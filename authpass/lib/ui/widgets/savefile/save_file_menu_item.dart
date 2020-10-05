import 'package:authpass/cloud_storage/cloud_storage_provider.dart';
import 'package:authpass/ui/widgets/savefile/save_file.dart';
import 'package:authpass/bloc/kdbx_bloc.dart';
import 'package:flutter/material.dart';

class SaveFileAsMenuItem extends PopupMenuEntry<KdbxOpenedFile> {
  const SaveFileAsMenuItem(
      {this.title,
      this.file,
      this.onFileSourceChanged,
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
    return SaveFileAs(
      title: widget.title,
      file: widget.file,
      onFileSourceChanged: widget.onFileSourceChanged,
      onClose: widget.onClose,
      icon: widget.icon,
      cs: widget.cs,
      onSave: widget.onSave,
      subtitle: widget.subtitle,
    );
  }
}
