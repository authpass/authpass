import 'package:authpass/bloc/kdbx/file_source.dart';
import 'package:authpass/bloc/kdbx_bloc.dart';
import 'package:authpass/cloud_storage/cloud_storage_bloc.dart';
import 'package:authpass/cloud_storage/cloud_storage_provider.dart';
import 'package:authpass/l10n/app_localizations.dart';
import 'package:authpass/ui/screens/select_file_screen.dart';
import 'package:authpass/ui/widgets/save_file.dart';
import 'package:authpass/utils/platform.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class SaveFileAsDialogButton extends StatefulWidget {
  const SaveFileAsDialogButton(this.file,
      {this.child,
      this.onFileSourceChanged,
      this.onSave,
      this.local = false,
      this.cloud = true});

  final KdbxOpenedFile file;
  final Widget child;
  final Function(FileSource) onFileSourceChanged;
  final Function(Future<void>) onSave;
  final bool local;
  final bool cloud;
  @override
  _SaveFileAsDialogButtonState createState() => _SaveFileAsDialogButtonState();
}

class _SaveFileAsDialogButtonState extends State<SaveFileAsDialogButton> {
  void showBottomModal() {
    showModalBottomSheet<KdbxOpenedFile>(
        context: context,
        builder: (context) => Column(
              mainAxisSize: MainAxisSize.min,
              children: getItems(),
            ));
  }

  List<SaveFileAsMenuItem> getItems() {
    final cloudStorageBloc =
        Provider.of<CloudStorageBloc>(context, listen: false);
    final loc = AppLocalizations.of(context);
    return [
      if (widget.local)
        SaveFileAsMenuItem(
          loc.saveAs,
          widget.file,
          onClose: () {
            Navigator.pop(context, widget.file);
          },
          onSave: widget.onSave,
          icon: const Icon(FontAwesomeIcons.hdd),
          onFileSourceChanged: widget.onFileSourceChanged,
          subtitle: 'Local File',
        ),
      if (widget.cloud)
        ...cloudStorageBloc.availableCloudStorage.map(
          (cs) => SaveFileAsMenuItem(
            loc.saveAs,
            widget.file,
            onClose: () {
              Navigator.pop(context, widget.file);
            },
            onSave: widget.onSave,
            onFileSourceChanged: widget.onFileSourceChanged,
            cs: cs,
          ),
        )
    ];
  }

  @override
  Widget build(BuildContext context) {
    if (AuthPassPlatform.isAndroid || AuthPassPlatform.isIOS) {
      if (widget.child != null) {
        return InkWell(
          child: widget.child,
          onTap: showBottomModal,
        );
      }
      return IconButton(
        icon: const Icon(Icons.more_vert),
        onPressed: showBottomModal,
      );
    } else {
      return PopupMenuButton<KdbxOpenedFile>(
        child: widget.child ?? widget.child,
        onSelected: (_) => _,
        itemBuilder: (context) => getItems(),
      );
    }
  }
}

class SaveFileAsMenuItem extends PopupMenuEntry<KdbxOpenedFile> {
  const SaveFileAsMenuItem(this.title, this.file,
      {this.onFileSourceChanged,
      this.onClose,
      this.icon,
      this.cs,
      this.onSave,
      this.subtitle})
      : assert((icon != null && subtitle != null) || cs != null);

  final Function onClose;
  final Function(Future<void>) onSave;
  final Function onFileSourceChanged;
  final KdbxOpenedFile file;
  final String title;
  final String subtitle;
  final Icon icon;
  final CloudStorageProvider cs;
  bool get local => cs == null;

  @override
  State<SaveFileAsMenuItem> createState() => _SaveFileAsMenuItemState();

  @override
  double get height => kMinInteractiveDimension;

  @override
  bool represents(value) => value == file;
}

class _SaveFileAsMenuItemState extends State<SaveFileAsMenuItem> {
  @override
  Widget build(BuildContext context) {
    return SaveFileAs(widget.title, widget.file,
        onFileSourceChanged: widget.onFileSourceChanged,
        onClose: widget.onClose,
        icon: widget.icon,
        cs: widget.cs,
        onSave: widget.onSave,
        subtitle: widget.subtitle);
  }
}
