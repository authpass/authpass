import 'package:authpass/bloc/kdbx_bloc.dart';
import 'package:authpass/cloud_storage/cloud_storage_bloc.dart';
import 'package:authpass/ui/widgets/savefile/save_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class SaveFileAsDialogButton extends StatelessWidget {
  const SaveFileAsDialogButton({
    required this.file,
    this.child,
    this.onSave,
    this.includeLocal = false,
  });

  final KdbxOpenedFile file;
  final Widget? child;
  final OnSave? onSave;
  final bool includeLocal;

  void _showBottomModal(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.3,
        maxChildSize: 0.6,
        expand: false,
        builder: (context, scrollController) {
          return Scrollbar(
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: _getItems(context),
              ),
            ),
          );
        },
      ),
    );
  }

  List<Widget> _getItems(BuildContext context) {
    final cloudStorageBloc = context.watch<CloudStorageBloc>();
    final loc = AppLocalizations.of(context);
    return [
      if (includeLocal)
        SaveFileAs(
          title: loc.saveAs,
          file: file,
          onSave: (fileFuture) {
            Navigator.of(context).pop();
            onSave?.call(fileFuture);
          },
          icon: const Icon(FontAwesomeIcons.hdd),
          subtitle: loc.saveAsEntryLocalFile,
        ),
      ...cloudStorageBloc.availableCloudStorage.map(
        (cs) => SaveFileAs(
          title: loc.saveAs,
          file: file,
          onSave: (saveFuture) {
            Navigator.of(context).pop();
            onSave?.call(saveFuture);
          },
          cs: cs,
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    if (child != null) {
      return TextButton(
        onPressed: () => _showBottomModal(context),
        child: child!,
      );
    }
    return IconButton(
      icon: const Icon(Icons.more_vert),
      onPressed: () => _showBottomModal(context),
    );
  }
}
