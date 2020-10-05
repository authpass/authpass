import 'package:authpass/bloc/kdbx/file_source.dart';
import 'package:authpass/bloc/kdbx_bloc.dart';
import 'package:authpass/cloud_storage/cloud_storage_bloc.dart';
import 'package:authpass/l10n/app_localizations.dart';
import 'package:authpass/ui/widgets/savefile/save_file_menu_item.dart';
import 'package:authpass/utils/platform.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class SaveFileAsDialogButton extends StatelessWidget {
  const SaveFileAsDialogButton(
      {this.file,
      this.child,
      this.onFileSourceChanged,
      this.onSave,
      this.includeLocal = false});

  final KdbxOpenedFile file;
  final Widget child;
  final Function(FileSource) onFileSourceChanged;
  final Function(Future<void>) onSave;
  final bool includeLocal;

  void showBottomModal(BuildContext context) {
    showModalBottomSheet<KdbxOpenedFile>(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: getItems(context),
      ),
    );
  }

  List<SaveFileAsMenuItem> getItems(BuildContext context) {
    final cloudStorageBloc = context.read<CloudStorageBloc>();
    final loc = AppLocalizations.of(context);
    return [
      if (includeLocal)
        SaveFileAsMenuItem(
          title: loc.saveAs,
          file: file,
          onClose: () {
            Navigator.pop(context, file);
          },
          onSave: onSave,
          icon: const Icon(FontAwesomeIcons.hdd),
          onFileSourceChanged: onFileSourceChanged,
          subtitle: 'Local File',
        ),
      ...cloudStorageBloc.availableCloudStorage.map(
        (cs) => SaveFileAsMenuItem(
          title: loc.saveAs,
          file: file,
          onClose: () {
            Navigator.pop(context, file);
          },
          onSave: onSave,
          onFileSourceChanged: onFileSourceChanged,
          cs: cs,
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    if (AuthPassPlatform.isAndroid || AuthPassPlatform.isIOS) {
      if (child != null) {
        return InkWell(
          child: child,
          onTap: () => showBottomModal(context),
        );
      }
      return IconButton(
        icon: const Icon(Icons.more_vert),
        onPressed: () => showBottomModal(context),
      );
    } else {
      return PopupMenuButton<KdbxOpenedFile>(
        child: child,
        itemBuilder: (context) => getItems(context),
      );
    }
  }
}
