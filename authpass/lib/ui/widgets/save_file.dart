import 'package:authpass/bloc/kdbx/file_source.dart';
import 'package:authpass/bloc/kdbx/file_source_local.dart';
import 'package:authpass/bloc/kdbx_bloc.dart';
import 'package:authpass/cloud_storage/cloud_storage_provider.dart';
import 'package:authpass/bloc/kdbx/file_source_ui.dart';
import 'package:authpass/utils/platform.dart';
import 'package:logging/logging.dart';
import 'package:macos_secure_bookmarks/macos_secure_bookmarks.dart';
import 'package:authpass/utils/platform.dart';
import 'package:file_chooser/file_chooser.dart';
import 'package:file_picker_writable/file_picker_writable.dart';
import 'dart:io';

import 'package:authpass/bloc/app_data.dart';
import 'package:authpass/bloc/kdbx/file_source_local.dart';
import 'package:authpass/cloud_storage/cloud_storage_provider.dart';
import 'package:authpass/cloud_storage/cloud_storage_ui.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_async_utils/flutter_async_utils.dart'
    hide FutureTaskStateMixin;
import 'package:flutter_async_utils/flutter_async_utils.dart';

final _logger = Logger('manage_file');

class SaveFileAs extends StatefulWidget {
  SaveFileAs(this.title, this.file,
      {this.onFileSourceChanged,
      this.onClose,
      this.icon,
      this.cs,
      this.onSave,
      this.subtitle})
      : assert((icon != null && subtitle != null) || cs != null) {
    local = cs == null;
  }

  Function onClose;
  Function(Future<void>) onSave;
  Function onFileSourceChanged;
  KdbxOpenedFile file;
  String title;
  String subtitle;
  Icon icon;
  bool local;
  CloudStorageProvider cs;

  @override
  _SaveFileAsState createState() => _SaveFileAsState();
}

class _SaveFileAsState extends State<SaveFileAs> with FutureTaskStateMixin {
  KdbxBloc kdbxBloc;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _init();
    super.didChangeDependencies();
  }

  void _init() {
    if (kdbxBloc == null) {
      kdbxBloc = Provider.of<KdbxBloc>(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: widget.icon ?? Icon(widget.cs.displayIcon.iconData),
      title: Text(widget.title),
      subtitle: Text(widget.subtitle ?? widget.cs.displayName),
      onTap: () {
        widget.onClose?.call();
        widget.onSave(widget.local ? _saveAsLocalFile() : _saveAsCloudStorage(widget.cs));
      },
    );
  }

  Future<void> _saveAsLocalFile() async {
    if (AuthPassPlatform.isIOS || AuthPassPlatform.isAndroid) {
      final fileInfo = await FileSourceLocal.createFileInNewTempDirectory(
          '${path.basenameWithoutExtension(widget.file.fileSource.displayPath)}.kdbx',
          (tempFile) async {
        return await FilePickerWritable().openFileForCreate(
          fileName:
              '${path.basenameWithoutExtension(widget.file.fileSource.displayPath)}.kdbx',
          writer: (file) async {
            _logger.fine('Writing placeholder into $file');
            await file.writeAsString('<placeholder>');
          },
        );
      });

      if (fileInfo == null) {
        _logger.info('User cancelled file picker.');
        return;
      }
      _logger.fine('writing to ${fileInfo.uri} / ${fileInfo.fileName}');
      final newFile = await kdbxBloc.saveAs(
          widget.file,
          FileSourceLocal(
            File(fileInfo.fileName),
            databaseName: widget.file.fileSource.displayName,
            uuid: AppDataBloc.createUuid(),
            filePickerIdentifier: fileInfo.toJsonString(),
          ));
      widget.onFileSourceChanged?.call(newFile.fileSource);
      if (!mounted) {
        _logger.severe(
            '$runtimeType We are no longer mounted after writing file.');
        return;
      }
//      setState(() {
//        _file = newFile;
//      });
      return;
    }
    final result = await showSavePanel(
      suggestedFileName: path.basename(widget.file.fileSource.displayPath),
      confirmButtonText: 'Save',
    );
    if (result.canceled) {
      return;
    }

    final pathFile = result.paths.first;
    final outputFile = File(pathFile);
    String macOsBookmark;
    if (AuthPassPlatform.isMacOS) {
      // create a dummy file, so we can create a secure bookmark.
      await outputFile.writeAsString('.');
      macOsBookmark = await SecureBookmarks().bookmark(outputFile);
    }
    final newFile = await kdbxBloc.saveAs(
      widget.file,
      FileSourceLocal(
        outputFile,
        uuid: AppDataBloc.createUuid(),
        macOsSecureBookmark: macOsBookmark,
      ),
    );
    widget.onFileSourceChanged?.call(newFile.fileSource);
  }

  Future<void> _saveAsCloudStorage(CloudStorageProvider cs) async {
    final createFileInfo =
        await Navigator.of(context).push(CloudStorageSelector.route(
      cs,
      CloudStorageBrowserConfig(
          defaultFileName: path.basename(widget.file.fileSource.displayPath),
          isSave: true),
    ));
    if (createFileInfo != null) {
      final newFile =
          await kdbxBloc.saveAsNewFile(widget.file, createFileInfo, cs);
      //onFileSourceChanged should have the same effect as this setState by getting relayed to ManageFileScreen where the state of it is set
      //setState(() {
      //  widget.file = newFile;
      //});
      widget.onFileSourceChanged?.call(newFile.fileSource);
//      cs.saveEntity(, bytes, previousMetadata)
    }
  }
}
