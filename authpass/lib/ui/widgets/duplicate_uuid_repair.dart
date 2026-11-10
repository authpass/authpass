import 'dart:async';

import 'package:authpass/bloc/kdbx/file_source.dart';
import 'package:authpass/bloc/kdbx_bloc.dart';
import 'package:authpass/l10n-generated/app_localizations.dart';
import 'package:authpass/utils/dialog_utils.dart';
import 'package:flutter/material.dart';
import 'package:kdbx/kdbx.dart';
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
/// [context] only has to be alive while the question is on screen: a repair
/// the user has confirmed goes ahead even when the route it was asked from has
/// gone by then, and only the message afterwards is dropped. A file which was
/// just unlocked still goes through [DuplicateUuidWatcher] rather than calling
/// this directly, so that it is asked about from the route stack which stays.
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
  final confirmed = await DialogUtils.showConfirmDialogOrNull(
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
  if (confirmed == null) {
    // The dialog was taken off the navigator before the user got to answer
    // it, so this file has not actually been asked about and goes back on the
    // queue. Reading that as a "no" is the mistake this whole mechanism exists
    // to avoid, and no amount of picking the right moment to ask rules it out.
    _logger.fine('The question about $fileSource never reached the user.');
    kdbxBloc.returnPendingDuplicateUuidReport(fileSource);
    return;
  }
  if (!confirmed) {
    return;
  }
  // Deliberately not also gated on `context.mounted`: repairing needs the
  // bloc and nothing else, while the route this dialog was pushed from can be
  // on its way out while the dialog is still up - which is how a confirmed
  // repair used to be dropped without a word. The user said yes, so the
  // database gets repaired; only the messages further down need a live
  // context.
  final file = kdbxBloc.fileForFileSource(fileSource)?.kdbxFile;
  if (file == null) {
    _logger.warning('$fileSource was closed while we were asking.');
    return;
  }
  if (file.findDuplicateUuidObjects().isEmpty) {
    // The open file was swapped underneath the dialog for one which has
    // nothing wrong with it - a cloud database is opened from its cached
    // content first and from the remote content afterwards, and another device
    // may have repaired it in between. Repairing would report that it did
    // nothing, which would read as a failure.
    _logger.info('$fileSource no longer contains any duplicate uuids.');
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

/// Offers the repair for whichever database [file] belongs to, as far as that
/// is still possible.
///
/// For the callers which can run long after the action they belong to - the
/// snackbar undo actions in the entry details screen, which outlive the screen
/// that put them up. By the time the user taps Undo the element can be defunct
/// and the database can have been closed, and both of those used to throw:
/// `AppLocalizations.of` on a dead context, and [KdbxBloc.fileForKdbxFile],
/// which raises a `StateError` rather than answering null. Inside a snackbar
/// callback that surfaces as a framework error and an undo which does nothing.
void offerDuplicateUuidRepairForFile(BuildContext context, KdbxFile file) {
  if (!context.mounted) {
    _logger.warning('Not offering to repair $file: the screen is gone.');
    return;
  }
  final fileSource = Provider.of<KdbxBloc>(
    context,
    listen: false,
  ).fileSourceForKdbxFile(file);
  if (fileSource == null) {
    _logger.warning('Not offering to repair $file: it is no longer open.');
    return;
  }
  unawaited(offerDuplicateUuidRepair(context, fileSource));
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
    // and a file queued while we are up: one opened later, one whose remote
    // content turns out to have duplicates the cached content did not, or one
    // handed back because the dialog about it was destroyed unanswered.
    _subscription ??= Provider.of<KdbxBloc>(
      context,
      listen: false,
    ).duplicateUuidsPendingChanged.listen((_) => _scheduleAsk());
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

  /// Whether this watcher's route is still part of the navigator's history,
  /// and so whether it is the one which should be asking.
  ///
  /// Unlocking a second database over an open one does not replace the
  /// scaffold it starts from: the select file screen is *pushed* over it
  /// (`app_bar_menu.dart`), so this watcher is still mounted - and still first
  /// in line - when `pushAndRemoveUntil` installs the watcher that is going to
  /// stay. Taking the file here would mean asking from a route which is
  /// disposed as soon as the new one has finished animating in, and an answer
  /// into a dead element.
  ///
  /// `isActive` turns false as soon as the route leaves the history, which is
  /// well before it is disposed. Deliberately not `isCurrent`: a watcher with
  /// the entry details screen pushed over it is still the right one to ask.
  bool get _routeIsStaying => ModalRoute.of(context)?.isActive ?? true;

  Future<void> _askAboutPendingFiles() async {
    if (_asking) {
      return;
    }
    _asking = true;
    try {
      final kdbxBloc = Provider.of<KdbxBloc>(context, listen: false);
      // Both conditions are checked again on every pass, which is also what
      // stops a file handed back by `offerDuplicateUuidRepair` from being
      // picked straight back up here: whatever took that dialog off the
      // navigator took this route with it, so the loop ends and the watcher
      // which replaces us gets the file instead.
      while (mounted && _routeIsStaying) {
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
