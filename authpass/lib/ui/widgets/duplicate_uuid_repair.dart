import 'dart:async';

import 'package:authpass/bloc/kdbx/file_source.dart';
import 'package:authpass/bloc/kdbx_bloc.dart';
import 'package:authpass/l10n-generated/app_localizations.dart';
import 'package:authpass/utils/dialog_utils.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

final _logger = Logger('duplicate_uuid_repair');

/// Puts the duplicate entries in [fileSource] to the user and, if they agree,
/// repairs them - see [KdbxBloc.repairDuplicateUuidEntries].
///
/// Takes the [FileSource] rather than the `KdbxFile` and resolves the database
/// twice, because the open file can be swapped underneath this dialog: a cloud
/// file is opened from its cached content first and from the remote content
/// afterwards, and repairing the copy we started out with would mutate an
/// object which is no longer open - which cannot be saved and leaves the live
/// database just as broken as it was.
///
/// [context] has to outlive the dialog. A file which was just unlocked is the
/// awkward case, since the whole route stack is replaced right after the open,
/// so that path goes through [DuplicateUuidWatcher] instead of calling this.
Future<void> offerDuplicateUuidRepair(
  BuildContext context,
  FileSource fileSource,
) async {
  final loc = AppLocalizations.of(context);
  final kdbxBloc = Provider.of<KdbxBloc>(context, listen: false);
  final uuids = kdbxBloc
      .fileForFileSource(fileSource)
      ?.kdbxFile
      .findDuplicateUuidObjects()
      .keys
      .toSet();
  if (uuids == null || uuids.isEmpty) {
    // closed in the meantime, or an earlier repair already dealt with it.
    _logger.fine('Nothing to repair in $fileSource.');
    return;
  }
  final confirmed = await DialogUtils.showConfirmDialog(
    context: context,
    params: ConfirmDialogParams(
      title: loc.duplicateEntriesDialogTitle,
      content: loc.duplicateEntriesDialogMessage(
        fileSource.displayName,
        uuids.length,
      ),
      positiveButtonText: loc.duplicateEntriesRepairAction,
      negativeButtonText: loc.duplicateEntriesRepairLaterAction,
    ),
  );
  if (!confirmed || !context.mounted) {
    return;
  }
  final file = kdbxBloc.fileForFileSource(fileSource)?.kdbxFile;
  if (file == null) {
    _logger.warning('$fileSource was closed while we were asking.');
    return;
  }
  try {
    final repaired = await kdbxBloc.repairDuplicateUuidEntries(file);
    if (!context.mounted) {
      return;
    }
    if (repaired.isEmpty) {
      // nothing was repaired, so nothing was saved either - don't claim
      // success. kdbx leaves a uuid alone if it is not shared between
      // entries only, which it logs.
      _logger.warning('Nothing was repaired in $fileSource.');
      await DialogUtils.showErrorDialog(
        context,
        loc.duplicateEntriesDialogTitle,
        loc.duplicateEntriesRepairFailedMessage,
        routeAppend: 'duplicateUuidsNothingRepaired',
      );
      return;
    }
    await DialogUtils.showSimpleAlertDialog(
      context,
      loc.duplicateEntriesDialogTitle,
      loc.duplicateEntriesRepairedMessage(repaired.length),
      routeAppend: 'duplicateUuidsRepaired',
    );
  } on DuplicateUuidRepairNotSavedException catch (error, trace) {
    // the entries were folded together in memory and only the save failed,
    // so telling the user nothing was repaired would be wrong: the database
    // they are looking at is the repaired one.
    _logger.severe(
      'Repaired the duplicate entries in $fileSource, but saving failed.',
      error,
      trace,
    );
    if (!context.mounted) {
      return;
    }
    await DialogUtils.showErrorDialog(
      context,
      loc.duplicateEntriesDialogTitle,
      loc.duplicateEntriesRepairNotSavedMessage,
      routeAppend: 'duplicateUuidsRepairNotSaved',
    );
  } catch (error, trace) {
    _logger.severe(
      'Unable to repair the duplicate entries in $fileSource.',
      error,
      trace,
    );
    if (!context.mounted) {
      return;
    }
    await DialogUtils.showErrorDialog(
      context,
      loc.duplicateEntriesDialogTitle,
      loc.duplicateEntriesRepairFailedMessage,
      routeAppend: 'duplicateUuidsRepair',
    );
  }
}

/// Asks about the files which [KdbxBloc] found duplicate uuids in while it was
/// opening them.
///
/// The bloc notices them halfway through the open, which is too early to put
/// anything on screen: both unlock paths rebuild the whole route stack as soon
/// as the open returns - `pushAndRemoveUntil` after a manual unlock,
/// `pushReplacement` after quick unlock - and a dialog pushed before that goes
/// with it, unanswered and unseen. So the bloc only queues the file, and this
/// widget, which is mounted inside the scaffold that navigation lands on,
/// drains the queue once there is a route stack which stays.
class DuplicateUuidWatcher extends StatefulWidget {
  const DuplicateUuidWatcher({super.key, required this.child});

  final Widget child;

  @override
  State<DuplicateUuidWatcher> createState() => _DuplicateUuidWatcherState();
}

class _DuplicateUuidWatcherState extends State<DuplicateUuidWatcher> {
  StreamSubscription<void>? _subscription;

  /// Whether [_askAboutPendingFiles] is already working through the queue, so
  /// that two dialogs are never on screen at once.
  bool _asking = false;

  @override
  void initState() {
    super.initState();
    // a file which was open before this widget was mounted - the usual case,
    // since unlocking is what navigates here.
    _scheduleAsk();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // and a file which is opened while we are up, or whose remote content
    // turns out to have duplicates the cached content did not.
    _subscription ??= Provider.of<KdbxBloc>(
      context,
      listen: false,
    ).openedFilesChanged.listen((_) => _scheduleAsk());
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  /// Both triggers can fire while a frame is being built - mounting, and a
  /// stream which replays its current value on listen - and a dialog must not
  /// be pushed from inside a build.
  void _scheduleAsk() {
    final binding = WidgetsBinding.instance;
    binding.addPostFrameCallback((_) {
      if (mounted) {
        unawaited(_askAboutPendingFiles());
      }
    });
    // A post frame callback only runs once a frame is actually produced, and
    // nothing here guarantees one: a file which turns up while we are already
    // mounted arrives on a stream, which rebuilds nothing by itself.
    binding.scheduleFrame();
  }

  Future<void> _askAboutPendingFiles() async {
    if (_asking) {
      return;
    }
    _asking = true;
    try {
      final kdbxBloc = Provider.of<KdbxBloc>(context, listen: false);
      while (mounted) {
        final fileSource = kdbxBloc.takePendingDuplicateUuidReport();
        if (fileSource == null) {
          return;
        }
        await offerDuplicateUuidRepair(context, fileSource);
      }
    } finally {
      _asking = false;
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
