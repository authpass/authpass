import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:authpass/bloc/analytics.dart';
import 'package:authpass/bloc/app_data.dart';
import 'package:authpass/bloc/authpass_cloud_bloc.dart';
import 'package:authpass/bloc/kdbx/storage_exception.dart';
import 'package:authpass/bloc/kdbx_bloc.dart';
import 'package:authpass/env/_base.dart';
import 'package:authpass/l10n/app_localizations.dart';
import 'package:authpass/ui/common_fields.dart';
import 'package:authpass/ui/screens/app_bar_menu.dart';
import 'package:authpass/ui/screens/cloud/cloud_auth.dart';
import 'package:authpass/ui/screens/entry_totp.dart';
import 'package:authpass/ui/screens/group_list.dart';
import 'package:authpass/ui/screens/hud.dart';
import 'package:authpass/ui/screens/password_generator.dart';
import 'package:authpass/ui/screens/password_list.dart';
import 'package:authpass/ui/widgets/icon_selector.dart';
import 'package:authpass/ui/widgets/keyboard_handler.dart';
import 'package:authpass/ui/widgets/link_button.dart';
import 'package:authpass/ui/widgets/primary_button.dart';
import 'package:authpass/utils/dialog_utils.dart';
import 'package:authpass/utils/extension_methods.dart';
import 'package:authpass/utils/format_utils.dart';
import 'package:authpass/utils/otpauth.dart';
import 'package:authpass/utils/password_generator.dart';
import 'package:authpass/utils/path_utils.dart';
import 'package:authpass/utils/platform.dart';
import 'package:barcode_scan/barcode_scan.dart' as barcode;
import 'package:base32/base32.dart';
import 'package:clock/clock.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:file_chooser/file_chooser.dart';
import 'package:file_picker_writable/file_picker_writable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_async_utils/flutter_async_utils.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kdbx/kdbx.dart';
import 'package:logging/logging.dart';
import 'package:mime/mime.dart';
import 'package:open_file/open_file.dart';
import 'package:otp/otp.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

final _logger = Logger('entry_details');

class EntryDetailsScreen extends StatefulWidget {
  const EntryDetailsScreen({Key key, @required this.entry}) : super(key: key);

  static Route<void> route({@required KdbxEntry entry}) => MaterialPageRoute(
      settings: const RouteSettings(name: '/entry'),
      builder: (context) => EntryDetailsScreen(
            entry: entry,
          ));

  final KdbxEntry entry;

  @override
  _EntryDetailsScreenState createState() => _EntryDetailsScreenState();
}

class _EntryDetailsScreenState extends State<EntryDetailsScreen>
    with
        TaskStateMixin<EntryDetailsScreen>,
        StreamSubscriberMixin<EntryDetailsScreen>,
        KdbxObjectSavableStateMixin<EntryDetailsScreen> {
  @override
  KdbxFile get file => widget.entry.file;
  @override
  Changeable get kdbxObject => widget.entry;
  @override
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final env = Provider.of<Env>(context);
    final vm = EntryViewModel(widget.entry, context.watch<KdbxBloc>());
    final entry = widget.entry;
    final loc = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(vm.label?.takeUnlessBlank() ?? loc.noTitle),
        actions: <Widget>[
          ...?!isDirty
              ? null
              : [
                  IconButton(
                    icon: const Icon(Icons.save),
                    onPressed: saveCallback,
                  ),
                ],
          AppBarMenu.createOverflowMenuButton(
            context,
            builder: (context) => [
              PopupMenuItem(
                child: const ListTile(
                  leading: Icon(Icons.delete),
                  title: Text('Delete'),
                ),
                value: () {
                  final oldGroup = entry.parent;
                  entry.file.deleteEntry(entry);
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: const Text('Deleted entry.'),
                    action: SnackBarAction(
                        label: 'Undo',
                        onPressed: () {
                          entry.file.move(entry, oldGroup);
                        }),
                  ));
                },
              ),
              ...?!env.isDebug
                  ? null
                  : [
                      PopupMenuItem(
                        child: const ListTile(
                          leading: Icon(Icons.bug_report),
                          title: Text('Debug: Copy XML'),
                        ),
                        value: () {
                          Clipboard.setData(ClipboardData(
                              text: entry.toXml().toXmlString(pretty: true)));
                        },
                      ),
                    ]
            ],
          )
        ],
      ),
//      floatingActionButton: FloatingActionButton(
//        child: Icon(Icons.add),
//        onPressed: () {},
//      ),
      body: WillPopScope(
        child: Form(
          key: formKey,
          child: EntryDetails(
            entry: vm,
            onSavedPressed: !isDirty && !entry.isDirty ? null : saveCallback,
          ),
          onChanged: () {
            if (!isFormDirty) {
              setState(() => isFormDirty = true);
            }
          },
        ),
        onWillPop: () async {
          if (!isDirty && !entry.isDirty) {
            return true;
          }
          return await DialogUtils.showConfirmDialog(
            context: context,
            params: ConfirmDialogParams(
                title: 'Unsaved Changes',
                content:
                    'There are still unsaved changes. Do you want to discard changes?',
                positiveButtonText: 'Discard Changes'),
          );
        },
      ),
    );
  }
}

mixin KdbxObjectSavableStateMixin<T extends StatefulWidget>
    on State<T>, TaskStateMixin<T>, StreamSubscriberMixin<T> {
  GlobalKey<FormState> get formKey;
  KdbxFile get file;
  bool _isObjectDirty = false;
  bool get isDirty => _isObjectDirty || isFormDirty;
  bool isFormDirty = false;
  Changeable get kdbxObject;

  @override
  void initState() {
    super.initState();
    _registerListener();
  }

  @override
  void didUpdateWidget(T oldWidget) {
    super.didUpdateWidget(oldWidget);
    _registerListener();
  }

  void _registerListener() {
    subscriptions.cancelSubscriptions();
    handleSubscription(kdbxObject.changes.listen((change) {
      _logger.finer(
          '_isObjectDirty = ${change.isDirty} (before: $_isObjectDirty / formDirty: $isFormDirty');
      setState(() {
        _isObjectDirty = change.isDirty;
      });
    }));
  }

  @protected
  VoidCallback get saveCallback => asyncTaskCallback(() async {
        if (formKey.currentState.validate()) {
          formKey.currentState.save();
          final kdbxBloc = Provider.of<KdbxBloc>(context, listen: false);
          if (kdbxBloc.fileForKdbxFile(file).fileSource.supportsWrite) {
            try {
              await kdbxBloc.saveFile(file);
            } on StorageException catch (e, stackTrace) {
              _logger.warning('Error while saving database.', e, stackTrace);
              await DialogUtils.showErrorDialog(
                  context, 'Error while saving', 'Unable to save file: $e');
              return;
            } catch (e, stackTrace) {
              _logger.severe('Error while saving database.', e, stackTrace);
              if (mounted) {
                await DialogUtils.showErrorDialog(
                    context, 'Error while saving', 'Unable to save file: $e');
              }
              rethrow;
            }
            // if user navigated away from this entry, just ignore this.
            if (mounted) {
              setState(() => isFormDirty = false);
            }
          } else {
            await DialogUtils.showSimpleAlertDialog(
              context,
              null,
              'Sorry this database does not support saving. '
              'Please open a local database file.',
              routeAppend: 'databaseNoSupportSaving',
            );
          }
        }
      });
}

enum FieldType {
  string,
  otp,
}

class EntryDetails extends StatefulWidget {
  const EntryDetails(
      {Key key, @required this.entry, @required this.onSavedPressed})
      : super(key: key);

  final EntryViewModel entry;
  final VoidCallback onSavedPressed;

  @override
  _EntryDetailsState createState() => _EntryDetailsState();
}

class _EntryDetailsState extends State<EntryDetails>
    with StreamSubscriberMixin {
  List<Tuple3<GlobalKey<_EntryFieldState>, KdbxKey, CommonField>> _fieldKeys;

  void _initShortcutListener(
      KeyboardShortcutEvents events, CommonFields commonFields) {
    handleSubscription(events.shortcutEvents.listen((event) {
      _logger.fine('shortcut event: $event //// ${event.type}');
      if (event.type == KeyboardShortcutType.copyPassword) {
        final context = FocusManager.instance.primaryFocus?.context;
        if (context != null) {
          _logger.fine('context: $context');
          if (context?.widget is EditableText) {
            final ctrl = (context.widget as EditableText).controller;
            if (!ctrl.selection.isCollapsed && ctrl.selection.isNormalized) {
              final data = ctrl.selection.textInside(ctrl.text);
              if (data != null && data.isNotEmpty) {
                Clipboard.setData(ClipboardData(text: data));
                if (mounted) {
                  final loc = AppLocalizations.of(context);
                  Scaffold.of(context).showSnackBar(
                      SnackBar(content: Text(loc.copiedToClipboard)));
                }
                return;
              }
            }
          }

          final entryFieldState =
              context.findAncestorStateOfType<_EntryFieldState>();
          if (entryFieldState != null) {
            entryFieldState.copyValue();
            return;
          }
          if (widget is EditableText) {
            return;
          }
        }
        _copyField(commonFields.password);
      } else if (event.type == KeyboardShortcutType.copyUsername) {
        _copyField(commonFields.userName);
      } else if (event.type == KeyboardShortcutType.escape) {
        FocusManager.instance.primaryFocus?.unfocus();
      }
    }));
  }

  Future<void> _copyField(CommonField commonField) async {
    final field = _fieldKeys.firstWhere((f) => f.item2 == commonField.key,
        orElse: () => null);
    if (field != null) {
      if (await field.item1.currentState.copyValue()) {
        return;
      }
    }
    final entry = widget.entry.entry;
    final value = entry.getString(commonField.key);
    Scaffold.of(context).hideCurrentSnackBar();
    if (value != null && value.getText() != null) {
      await Clipboard.setData(ClipboardData(text: value.getText()));
//      await ClipboardManager.copyToClipBoard(value.getText());
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('${commonField.displayName} copied.'),
      ));
    } else {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('${commonField.displayName} is empty.'),
      ));
    }
  }

  void _initFields(CommonFields commonFields) {
    final entry = widget.entry.entry;
    final nonCommonKeys =
        entry.stringEntries.where((str) => !commonFields.isCommon(str.key));
    final oldKeys = _fieldKeys == null
        ? <KdbxKey, GlobalKey<_EntryFieldState>>{}
        : Map.fromEntries(_fieldKeys.map((e) => MapEntry(e.item2, e.item1)));
    _fieldKeys = commonFields.fields
        .where((f) => f.showByDefault || entry.getString(f.key) != null)
        .map((f) => Tuple3(
            oldKeys[f.key] ??
                GlobalKey<_EntryFieldState>(debugLabel: '${f.key}'),
            f.key,
            f))
        .followedBy(nonCommonKeys.map((f) => Tuple3(
            oldKeys[f.key] ??
                GlobalKey<_EntryFieldState>(debugLabel: '${f.key}'),
            f.key,
            null)))
        .toList();
    _logger.fine('Listing on changes for ${widget.entry.label}');
    handleSubscription(entry.changes.listen((event) {
      _logger.fine('Widget entry changed.');
      setState(() {});
    }));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _logger.info('_EntryDetailsState.didChangeDependencies');
    if (_fieldKeys == null) {
      subscriptions.cancelSubscriptions();
      _initFields(Provider.of<CommonFields>(context));
      _initShortcutListener(Provider.of<KeyboardShortcutEvents>(context),
          Provider.of<CommonFields>(context));
    }
  }

  @override
  void didUpdateWidget(EntryDetails oldWidget) {
    super.didUpdateWidget(oldWidget);
    _logger.fine('_EntryDetailsState.didUpdateWidget');
    if (oldWidget.entry != widget.entry) {
      _logger.info('_EntryDetailsState: widget.entry changed.');
      _initFields(Provider.of<CommonFields>(context));
    }
  }

  @override
  Widget build(BuildContext context) {
    final commonFields = Provider.of<CommonFields>(context);
    final vm = widget.entry;
    final entry = widget.entry.entry;
    final formatUtils = Provider.of<FormatUtils>(context);
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: SafeArea(
          top: false,
          left: false,
          child: Column(
            children: <Widget>[
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(width: 16),
                  EntryIcon(
                    vm: vm,
                    size: 64,
                    fallback: (context) => IconSelectorFormField(
                      initialValue: SelectedIcon.fromObject(entry),
                      onSaved: (icon) {
                        icon.when(predefined: (predefined) {
                          entry.customIcon = null;
                          entry.icon.set(predefined);
                        }, custom: (custom) {
                          // TODO support changing to a custom icon.
                          throw StateError('not yet supported.');
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const SizedBox(height: 16),
                        EntryMetaInfo(
                          label: loc.entryInfoFile,
                          value: entry.file.body.meta.databaseName.get(),
                        ),
                        EntryMetaInfo(
                          label: loc.entryInfoGroup,
                          value: vm.groupNames.join(' » '), // NON-NLS
                          onTap: () async {
                            // TODO
                            final file = vm.entry.file;
                            final newGroupSelection =
                                await Navigator.of(context)
//                                .push(GroupListFlat.route(file.body.rootGroup));
                                    .push(GroupListFlat.route(
                              {vm.entry.parent},
                              groupListMode: GroupListMode.singleSelect,
                              rootGroup: vm.entry.file.body.rootGroup,
                            ));
                            final newGroup = newGroupSelection?.first;
                            if (newGroup != null) {
                              final oldGroup = vm.entry.parent;
                              file.move(vm.entry, newGroup);
                              Scaffold.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(loc
                                      .movedEntryToGroup(newGroup.name.get())),
                                  action: SnackBarAction(
                                      label: loc.undoButtonLabel,
                                      onPressed: () {
                                        file.move(vm.entry, oldGroup);
                                      }),
                                ),
                              );
                            }
                          },
                        ),
                        EntryMetaInfo(
                          label: loc.entryInfoLastModified,
                          value: formatUtils.formatDateFull(
                              vm.entry.times.lastModificationTime.get()),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              ..._fieldKeys
                  .map(
                    (f) => EntryField(
                      fieldType: commonFields.isTotp(f.item2)
                          ? FieldType.otp
                          : FieldType.string,
                      key: f.item1,
                      entry: entry,
                      fieldKey: f.item2,
                      commonField: f.item3,
                      onChangedMetadata: () => setState(() {
                        _initFields(
                            Provider.of<CommonFields>(context, listen: false));
                      }),
                    ),
                  )
                  .expand((el) => [el, const SizedBox(height: 8)]),
              AddFieldButton(
                onAddField: (key) async {
                  final cf = commonFields[key];
                  if (cf == commonFields.otpAuth) {
                    final secret = await _askForTotpSecret(context);
                    if (secret == null) {
                      return;
                    }
                    _logger.finer('Got otp auth: $secret');
                    entry.setString(key,
                        ProtectedValue.fromString(secret.toUri().toString()));
                  } else {
                    entry.setString(
                        key,
                        cf?.protect == true
                            ? ProtectedValue.fromString('')
                            : PlainValue(''));
                  }
                  Provider.of<Analytics>(context, listen: false)
                      .events
                      .trackAddField(key: key.key);
                  _initFields(
                      Provider.of<CommonFields>(context, listen: false));
                  setState(() {});
                },
              ),
              const Divider(),
              ...?entry.binaryEntries.isEmpty
                  ? []
                  : entry.binaryEntries.map((e) {
                      return InkWell(
                        child: Container(
                          constraints: const BoxConstraints(minWidth: 500),
                          padding: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 8,
                          ),
                          child: Row(
                            children: <Widget>[
                              const Icon(Icons.attach_file),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(e.key.key,
                                        style: theme.textTheme.subtitle1),
                                    const SizedBox(height: 2),
                                    Text(loc.sizeBytes(e.value.value.length),
                                        style: theme.textTheme.caption),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        onTap: () async {
                          await showModalBottomSheet<void>(
                              context: context,
                              builder: (context) => AttachmentBottomSheet(
                                    entry: entry,
                                    attachment: e,
                                  ));
                        },
                      );
                    }),
              LinkButton(
                icon: const Icon(Icons.attach_file),
                child: Text(loc.entryAddAttachment),
                onPressed: _attachFile,
              ),
              const SizedBox(height: 16),
              PrimaryButton(
                icon: const Icon(Icons.save),
                child: Text(loc.saveButtonLabel),
                onPressed: widget.onSavedPressed,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _attachFile() async {
    if (AuthPassPlatform.isIOS || AuthPassPlatform.isAndroid) {
      await FilePickerWritable().openFile((fileInfo, file) async {
        final fileName = fileInfo.fileName ?? file.path;
        final bytes = await file.readAsBytes();
        await _attachFileContent(fileName, bytes);
        return fileInfo;
      });
    } else {
      final result = await showOpenPanel();
      if (!result.canceled) {
        final file = result.paths[0];
        final fileName = path.basename(file);
        final bytes = await File(file).readAsBytes();
        await _attachFileContent(fileName, bytes);
      }
    }
  }

  Future<void> _attachFileContent(String fileName, Uint8List bytes) async {
    final analytics = Provider.of<Analytics>(context, listen: false);
    final loc = AppLocalizations.of(context);
    if (bytes.lengthInBytes > 10 * 1024) {
      if (!await DialogUtils.showConfirmDialog(
        context: context,
        params: ConfirmDialogParams(
          content: loc.entryAttachmentSizeWarning,
        ),
      )) {
        analytics.events.trackAttachmentAdd(
          AttachmentAddType.canceled,
          path.extension(fileName),
          bytes.lengthInBytes,
        );
        return;
      }
    }
    analytics.events.trackAttachmentAdd(
      AttachmentAddType.success,
      path.extension(fileName),
      bytes.lengthInBytes,
    );
    widget.entry.entry.createBinary(
      isProtected: false,
      name: fileName,
      bytes: bytes,
    );
  }

  Future<OtpAuth> _askForTotpSecret(BuildContext context) async {
    final _cleanOtpCodeCode = (String totpCode) async {
      try {
        if (totpCode == null) {
          return null;
        }
        if (totpCode.startsWith('otpauth://')) {
          // NON-NLS
          return OtpAuth.fromUri(Uri.parse(totpCode));
        }
        final cleaned = totpCode?.replaceAll(' ', ''); //?.toUpperCase();
        final value = base32.decode(cleaned);
        _logger.fine('Got totp secret with ${value.lengthInBytes} bytes.');
        return OtpAuth(secret: value);
      } catch (e, stackTrace) {
        _logger.warning('Invalid base32 code?', e, stackTrace);
        await DialogUtils.showSimpleAlertDialog(
          context,
          'Invalid key',
          'Given input is not a valid base32 TOTP code. Please verify your input.',
          routeAppend: 'totpInvalidKey',
        );
        return await _askForTotpSecret(context);
      }
    };

    if (AuthPassPlatform.isIOS || AuthPassPlatform.isAndroid) {
      try {
        _logger.finer('Opening barcode scanner.');
//        final barcode = await FlutterBarcodeScanner.scanBarcode(
//            '#ff6666', 'Cancel', true, ScanMode.QR);

        final barcodeResult = await barcode.BarcodeScanner.scan();
        if (barcodeResult != null) {
          return _cleanOtpCodeCode(barcodeResult);
        }

//        final scanResult = await barcode.BarcodeScanner.scan();
//        _logger.fine('Got scan result of type ${scanResult.type} -'
//            ' ${scanResult.format} (${scanResult.formatNote})');
//        if (scanResult != null &&
//            scanResult.type == barcode.ResultType.Barcode) {
//          return _cleanOtpCodeCode(scanResult.rawContent);
//        }
      } catch (e, stackTrace) {
        _logger.warning('Error during barcode scanning.', e, stackTrace);
      }
    }
    final totpCode = await const SimplePromptDialog(
      title: 'Time Based Authentication',
      helperText: 'Please enter time based key.',
    ).show(context);
    return _cleanOtpCodeCode(totpCode);
  }
}

class AttachmentBottomSheet extends StatelessWidget {
  const AttachmentBottomSheet({
    Key key,
    @required this.entry,
    @required this.attachment,
  })  : assert(entry != null),
        assert(attachment != null),
        super(key: key);

  final KdbxEntry entry;
  final MapEntry<KdbxKey, KdbxBinary> attachment;

  @override
  Widget build(BuildContext context) {
    final analytics = Provider.of<Analytics>(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
          leading: const Icon(Icons.open_in_new),
          title: const Text('Open'),
          onTap: () async {
            analytics.events.trackAttachmentAction('open');
            Navigator.of(context).pop();
            final f = await PathUtils().saveToTempDirectory(
                attachment.value.value,
                dirPrefix: 'openbinary',
                fileName: attachment.key.key);
            _logger.fine('Opening ${f.path}');
            final result = await OpenFile.open(f.path);
            _logger.fine('finished opening $result');
          },
        ),
        if (AuthPassPlatform.isIOS || AuthPassPlatform.isAndroid)
          ListTile(
            leading: const Icon(Icons.share),
            title: const Text('Share'),
            onTap: () {
              analytics.events.trackAttachmentAction('share');
              final mimeType = lookupMimeType(
                attachment.key.key,
                headerBytes: attachment.value.value.length >
                        defaultMagicNumbersMaxLength
                    ? Uint8List.sublistView(
                        attachment.value.value, 0, defaultMagicNumbersMaxLength)
                    : null,
              );
              _logger.fine('Opening attachment with mimeType $mimeType');
              Share.file('Attachment', attachment.key.key,
                  attachment.value.value, mimeType);
              Navigator.of(context).pop();
            },
          ),
        if (AuthPassPlatform.isIOS || AuthPassPlatform.isAndroid)
          ListTile(
            leading: const Icon(Icons.save),
            title: const Text('Save to device'),
            onTap: () async {
              analytics.events.trackAttachmentAction('saveToDevice');
              Navigator.of(context).pop();
              await FilePickerWritable().openFileForCreate(
                  fileName: attachment.key.key,
                  writer: (file) async {
                    _logger.fine('Opening ${file.path}');
                    await file.writeAsBytes(attachment.value.value);
                  });
            },
          ),
        ListTile(
          leading: const Icon(Icons.delete),
          title: const Text('Remove'),
          onTap: () async {
            analytics.events.trackAttachmentAction('remove');
            Navigator.of(context).pop();
            final confirm = await DialogUtils.showConfirmDialog(
                context: context,
                params: ConfirmDialogParams(
                    content: 'Do you really want to delete'
                        ' ${attachment.key.key}?'));
            if (confirm) {
              entry.removeBinary(attachment.key);
            }
          },
        ),
      ],
    );
  }
}

class EntryMetaInfo extends StatelessWidget {
  const EntryMetaInfo({
    Key key,
    this.label,
    this.value,
    this.onTap,
  }) : super(key: key);

  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
//          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            ...?onTap == null
                ? null
                : [
                    const Icon(Icons.edit, size: 16, color: Colors.black45),
                    const SizedBox(width: 8),
                  ],
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(label, style: theme.textTheme.caption),
                  Text(
                    value,
                    style: theme.textTheme.bodyText1
                        .copyWith(color: theme.textTheme.caption.color),
                    maxLines: 2,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddFieldButton extends StatefulWidget {
  const AddFieldButton({Key key, @required this.onAddField}) : super(key: key);

  final void Function(KdbxKey key) onAddField;

  @override
  _AddFieldButtonState createState() => _AddFieldButtonState();
}

class _AddFieldButtonState extends State<AddFieldButton> {
  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return LinkButton(
      icon: const Icon(Icons.add_circle_outline),
      child: Text(loc.entryAddField),
      onPressed: () async {
        final rb = context.findRenderObject() as RenderBox;
        final overlay =
            Overlay.of(context).context.findRenderObject() as RenderBox;
        final position = RelativeRect.fromRect(
          Rect.fromPoints(
            rb.localToGlobal(Offset.zero, ancestor: overlay),
            rb.localToGlobal(rb.size.bottomRight(Offset.zero),
                ancestor: overlay),
          ),
          Offset.zero & overlay.size,
        );
        final commonFields = Provider.of<CommonFields>(context, listen: false);
        final custom = CommonField(
          displayName: loc.entryCustomField,
          key: KdbxKey('__custom'), // NON-NLS
        );
        final fields = commonFields.fields.followedBy([custom]).map(
          (f) => PopupMenuItem(
            value: f.key,
            child: ListTile(leading: Icon(f.icon), title: Text(f.displayName)),
          ),
        );
        final key = await showMenu<KdbxKey>(
          context: context,
          position: position,
          items: [
            ...fields,
          ],
          initialValue: custom.key,
        );
        if (key != null) {
          if (key == custom.key) {
            await _selectCustomKey();
          } else {
            widget.onAddField(key);
          }
        }
      },
    );
  }

  Future<void> _selectCustomKey() async {
    final loc = AppLocalizations.of(context);
    final key = await SimplePromptDialog(
      title: loc.entryCustomFieldTitle,
      labelText: loc.entryCustomFieldInputLabel,
    ).show(context);
    if (key != null && key.isNotEmpty) {
      widget.onAddField(KdbxKey(key));
    }
  }
}

class EntryField extends StatefulWidget {
  const EntryField({
    Key key,
    @required this.fieldType,
    @required this.entry,
    @required this.fieldKey,
    this.commonField,
    @required this.onChangedMetadata,
  })  : assert(entry != null),
        assert(fieldKey != null),
        assert(onChangedMetadata != null),
        super(key: key);

  final FieldType fieldType;
  final KdbxEntry entry;
  final KdbxKey fieldKey;
  final CommonField commonField;
  final VoidCallback onChangedMetadata;

  @override
  _EntryFieldState createState() =>
      fieldType == FieldType.otp ? _OtpEntryFieldState() : _EntryFieldState();
}

enum EntryAction {
  copy,
  copyRawData,
  rename,
  protect,
  delete,
  show,
  passwordGenerator,
  generateEmail,
}

class _EntryFieldState extends State<EntryField>
    with StreamSubscriberMixin, TaskStateMixin {
  final GlobalKey _formFieldKey = GlobalKey();
  TextEditingController _controller;
  bool _isValueObscured = false;
  final FocusNode _focusNode = FocusNode();
  CommonFields _commonFields;

  StringValue get _fieldValue => widget.entry.getString(widget.fieldKey);
  set _fieldValue(StringValue value) {
    widget.entry.setString(widget.fieldKey, value);
  }

  bool get _isProtected => _fieldValue == null
      ? widget.commonField?.protect == true
      : _fieldValue is ProtectedValue;
  String get _valueCurrent =>
      (_isValueObscured
          ? widget.entry.getString(widget.fieldKey)?.getText()
          : _controller.text) ??
      _fieldValue?.getText();

  final GlobalKey<HighlightWidgetState> _highlightWidgetKey =
      GlobalKey<HighlightWidgetState>();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_focusNodeChanged);
    if (_fieldValue is ProtectedValue || widget.commonField?.protect == true) {
      _isValueObscured = true;
      _controller = TextEditingController();
    } else {
      _controller = TextEditingController(text: _fieldValue?.getText() ?? '');
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _commonFields = Provider.of<CommonFields>(context);
    if (widget.fieldKey == _commonFields.password.key) {
      handleSubscription(Provider.of<KeyboardShortcutEvents>(context)
          .shortcutEvents
          .listen((event) {
        if (event.type == KeyboardShortcutType.generatePassword) {
          _generatePassword();
        }
      }));
    }
  }

  void _focusNodeChanged() {
    if (!_isProtected) {
      return;
    }
    _logger.info(
        'Focus changed to ${_focusNode.hasFocus} (primary: ${_focusNode.hasPrimaryFocus})');
    if (!_focusNode.hasFocus) {
      setState(() {
        _fieldValue = ProtectedValue.fromString(_controller.text);
        _isValueObscured = true;
        _logger.finer('${widget.fieldKey} _isProtected= $_isValueObscured');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _logger.finer('building ${widget.fieldKey} ($_isValueObscured)');
    final loc = AppLocalizations.of(context);
    return Dismissible(
      key: ValueKey(widget.fieldKey),
      background: Container(
        alignment: Alignment.centerLeft,
        color: Colors.lightBlueAccent,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(Icons.lock),
            const SizedBox(height: 4),
            Text(loc.swipeCopyField),
          ],
        ),
      ),
      confirmDismiss: (direction) async {
//        await ClipboardManager.copyToClipBoard(_value.getText());
        await copyValue();
        return false;
      },
      child: HighlightWidget(
        key: _highlightWidgetKey,
        childOnHighlight: Text(loc.doneCopiedField,
            style: Theme.of(context)
                .textTheme
                .bodyText2
                .copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: const [
                    Shadow(
                      color: Colors.black,
                      blurRadius: 1,
                    )
                  ],
                  letterSpacing: 1,
                )
                .apply(fontSizeFactor: 1.2)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: <Widget>[
              Expanded(
                child: _buildEntryFieldEditor(),
              ),
              Container(
                width: 48,
                height: 48,
                alignment: Alignment.center,
                child: AnimatedCrossFade(
                  duration: const Duration(milliseconds: 300),
                  firstChild: PopupMenuButton<EntryAction>(
                    icon: const Icon(Icons.more_vert),
                    offset: const Offset(0, 32),
                    onSelected: _handleMenuEntrySelected,
                    itemBuilder: _buildMenuEntries,
                  ),
                  secondChild: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  ),
                  crossFadeState: task == null
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                ),
              ),
//            IconButton(
//              icon: Icon(Icons.content_copy),
//              tooltip: 'Copy to clipboard',
//              onPressed: () {
//                ClipboardManager.copyToClipBoard(_value.getText());
//              },
//            ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleMenuEntrySelected(EntryAction entryAction) async {
    switch (entryAction) {
      case EntryAction.copy:
        await copyValue();
        break;
      case EntryAction.copyRawData:
        // only used by [_OtpEntryFieldState]
        throw UnsupportedError('Field does not support this action.');
        break;
      case EntryAction.rename:
        final key = await SimplePromptDialog(
          title: 'Renaming field',
          labelText: 'Enter the new name for the field',
          initialValue: widget.fieldKey.key,
        ).show(context);
        if (key != null) {
          widget.entry.renameKey(widget.fieldKey, KdbxKey(key));
          widget.onChangedMetadata();
        }
        break;
      case EntryAction.passwordGenerator:
        await _launchPasswordGenerator();
        break;
      case EntryAction.protect:
        setState(() {
          if (_isProtected) {
            _fieldValue = PlainValue(_valueCurrent ?? '');
            _isValueObscured = false;
          } else {
            _logger.fine(
                'protected: $_isProtected, obscured: $_isValueObscured, current: $_valueCurrent');
            _fieldValue = ProtectedValue.fromString(_valueCurrent ?? '');
            _isValueObscured = true;
          }
        });
        break;
      case EntryAction.delete:
        widget.entry.removeString(widget.fieldKey);
        widget.onChangedMetadata();
        break;
      case EntryAction.show:
        FullScreenHud.show(context, (context) {
          return FullScreenHud(
            value: _valueCurrent ?? '',
          );
        });
        break;
      case EntryAction.generateEmail:
        final bloc = context.read<AuthPassCloudBloc>();
        if (bloc.tokenStatus != TokenStatus.confirmed) {
          await Navigator.of(context).push(AuthPassCloudAuthScreen.route());
        } else {
          await asyncRunTask(() async {
            final address =
                await bloc.createMailbox(entryUuid: widget.entry.uuid.uuid);
            setState(() {
              _isValueObscured = false;
              _controller.text = address;
              _fieldValue = PlainValue(_controller.text);
              copyValue();
            });
          });
        }
        break;
    }
  }

  List<PopupMenuEntry<EntryAction>> _buildMenuEntries(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return <PopupMenuEntry<EntryAction>>[
      PopupMenuItem(
        value: EntryAction.copy,
        child: ListTile(
          leading: const Icon(Icons.content_copy),
          title: Text(loc.swipeCopyField),
        ),
      ),
      const PopupMenuDivider(),
      PopupMenuItem(
        value: EntryAction.rename,
        child: ListTile(
          leading: const Icon(Icons.edit),
          title: Text(loc.fieldRename),
        ),
      ),
      PopupMenuItem(
        value: EntryAction.passwordGenerator,
        child: ListTile(
          leading: const Icon(FontAwesomeIcons.random),
          title: Text(loc.generatePassword),
//            subtitle: null,
        ),
      ),
      ...?_buildMenuEntriesAuthPassCloud(context),
      PopupMenuItem(
        value: EntryAction.protect,
        child: ListTile(
          leading: Icon(
              _isProtected ? Icons.no_encryption : Icons.enhanced_encryption),
          title: Text(_isProtected ? loc.fieldUnprotect : loc.fieldProtect),
        ),
      ),
      PopupMenuItem(
        value: EntryAction.delete,
        child: ListTile(
          leading: const Icon(Icons.delete),
          title: Text(loc.deleteAction),
        ),
      ),
      PopupMenuItem(
        value: EntryAction.show,
        child: ListTile(
//                    leading: Icon(Icons.present_to_all),
          leading: const Icon(FontAwesomeIcons.qrcode),
          title: Text(loc.fieldPresent),
        ),
      ),
    ];
  }

  Future<void> _generatePassword() async {
    final appData =
        await Provider.of<AppDataBloc>(context, listen: false).store.load();
    final characterSets = CharacterSet.characterSetFromIds(
        appData.passwordGeneratorCharacterSets);
    if (characterSets.isEmpty) {
      characterSets.addAll([CharacterSet.alphaNumeric, CharacterSet.numeric]);
    }
    final length = appData.passwordGeneratorLength ?? 16;
    _generatedPassword(
      PasswordGenerator.singleton().generatePassword(
        CharacterSetCollection(characterSets.toList()),
        length,
      ),
    );
  }

  Future<void> _launchPasswordGenerator() async {
    final password = await Navigator.of(context).push(
        PasswordGeneratorScreen.route(finishButton: FinishButtonStyle.done));
    if (password != null) {
      setState(() {
        _generatedPassword(password);
      });
    }
  }

  void _generatedPassword(String password) {
    setState(() {
      _isValueObscured = false;
      _controller.text = password;
      _fieldValue = ProtectedValue.fromString(_controller.text);
      _controller.selection =
          TextSelection(baseOffset: 0, extentOffset: _controller.text.length);
      _focusNode.requestFocus();
    });
    copyValue();
  }

  Future<bool> copyValue() async {
    _highlightWidgetKey.currentState.triggerHighlight();
    Provider.of<Analytics>(context, listen: false)
        .events
        .trackCopyField(key: widget.fieldKey.key);
    await Clipboard.setData(ClipboardData(text: _valueCurrent ?? ''));
    return true;
  }

  Widget _buildEntryFieldEditor() =>
      _isValueObscured && _valueCurrent?.isEmpty == false
          ? _buildObscuredEntryFieldEditor()
          : _buildStringEntryFieldEditor();

  Widget _buildObscuredEntryFieldEditor() {
    return ObscuredEntryFieldEditor(
      onPressed: () {
        setState(() {
          _controller.text = _valueCurrent ?? '';
          _controller.selection = TextSelection(
              baseOffset: 0, extentOffset: _controller.text?.length ?? 0);
          _isValueObscured = false;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _focusNode.requestFocus();
            _logger.finer('requesting focus.');
          });
        });
      },
      fieldKey: widget.fieldKey,
      commonField: widget.commonField,
    );
  }

  Widget _buildStringEntryFieldEditor() {
    return StringEntryFieldEditor(
      onSaved: (value) {
        final newValue =
            _isProtected ? ProtectedValue.fromString(value) : PlainValue(value);
        _fieldValue = newValue;
      },
      fieldKey: widget.fieldKey,
      commonField: widget.commonField,
      controller: _controller,
      formFieldKey: _formFieldKey,
      focusNode: _focusNode,
      passwordGeneratorPressed: _generatePassword,
    );
  }

  @override
  void dispose() {
    _logger
        .fine('EntryFieldState.dispose() - ${widget.key} (${widget.fieldKey})');
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  List<PopupMenuEntry<EntryAction>> _buildMenuEntriesAuthPassCloud(
      BuildContext context) {
    final authPassCloud = context.read<AuthPassCloudBloc>();
    if (authPassCloud?.featureFlags?.authpassCloud != true) {
      return null;
    }
    if (authPassCloud.tokenStatus != TokenStatus.confirmed) {
      return null;
    }
    final loc = AppLocalizations.of(context);
    return [
      PopupMenuItem(
          value: EntryAction.generateEmail,
          child: ListTile(
            leading: const Icon(Icons.cloud),
            title: Text(loc.fieldGenerateEmail),
            subtitle: const Text(Env.AuthPassCLoud),
          )),
    ];
  }
}

class _OtpEntryFieldState extends _EntryFieldState {
  Timer _timer;

  String _currentOtp = '';

  String _errorMessage;

  /// elapsed seconds since the last period change.
  int _elapsed = 0;

  /// period in seconds how often the otp changes.
  int _period = 30;

  @override
  String get _valueCurrent =>
      widget.entry.getString(widget.fieldKey)?.getText() ?? '';

  String _addBase32Padding(String base32data) {
    if (base32data == null) {
      return null;
    }
    final padding = (8 - (base32data.length % 8)) % 8;
    if (padding == 0) {
      return base32data;
    }
    return base32data + ('=' * padding);
  }

  OtpAuth _getOtpAuth() {
    final value = widget.entry.getString(widget.fieldKey)?.getText();
    if (value == null || value.isEmpty) {
      return throw FormatException('OTP Field contains no data.', value);
    }
    if (value.startsWith('otpauth:')) {
      // Our own format :-) (And also used by KeeWeb)
      return OtpAuth.fromUri(Uri.parse(value));
    }
    if (value.contains('key\=')) {
      _logger.finer('value contains "key=": $value');
      // KeeOTP format:key={base32Key}&size=12&step=33&type=Totp&counter=3
      final data = Uri.splitQueryString(value);
      try {
        return OtpAuth(
          secret: base32.decode(_addBase32Padding(data['key'])),
          period: data['step']?.toInt() ?? OtpAuth.DEFAULT_PERIOD,
          digits: data['size']?.toInt() ?? OtpAuth.DEFAULT_DIGITS,
        );
      } on FormatException catch (e, stackTrace) {
        _logger.fine(
            'Error parsing $data for ${widget.fieldKey}', e, stackTrace);
        rethrow;
      }
    }
    // assume base32 encoded secret, with more settings stored in a second field.
    try {
      final binarySecret = base32.decode(value.replaceAll(' ', ''));
      final settings =
          _commonFields.otpAuthCompat1Settings.stringValue(widget.entry) ?? '';
      final settingsOptions =
          settings.isEmpty ? <String>[] : settings.split(';');
      _logger.finest('settings: $settings');
      return OtpAuth(
        secret: binarySecret,
        period: settingsOptions.optGet(0)?.toInt() ?? OtpAuth.DEFAULT_PERIOD,
        digits: settingsOptions.optGet(1)?.toInt() ?? OtpAuth.DEFAULT_DIGITS,
      );
    } on FormatException catch (e, stackTrace) {
      // ignore format exception from base32 decoding.
      _logger.fine('Error decoding base32 secret', e, stackTrace);
    } catch (e, stackTrace) {
      _logger.fine('Error while parsing OTP format', e, stackTrace);
      throw FormatException('Error parsing Tray OTP Format $e', value);
    }
    throw FormatException('Unknown format for OTP', value);
  }

  void _updateOtp() {
    try {
      final otpAuth = _getOtpAuth();
      final secretBase32 = base32.encode(otpAuth.secret);
      _logger.fine('uri: $otpAuth');
      final now = clock.now().millisecondsSinceEpoch;
      final totpCode = OTP.generateTOTPCodeString(
        secretBase32,
        now,
        algorithm: otpAuth.algorithm,
        length: otpAuth.digits,
        interval: otpAuth.period,
        // do not pad OTP secret if it is not of correct length.
        isGoogle: true,
      );
      setState(() {
        _elapsed = (now ~/ 1000) % otpAuth.period;
        _period = otpAuth.period;
        _currentOtp = totpCode;
        _errorMessage = null;
      });
    } on FormatException catch (e, stackTrace) {
      _logger.severe('Error while decoding otpauth url.', e, stackTrace);
      setState(() {
        _currentOtp = '';
        _errorMessage = 'Error generating token $e';
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_timer == null) {
      _updateOtp();
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        _updateOtp();
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
    _timer = null;
  }

  @override
  Future<bool> copyValue() async {
    _logger.finer('Copying OTP value.');
    _highlightWidgetKey.currentState.triggerHighlight();
    Provider.of<Analytics>(context, listen: false)
        .events
        .trackCopyField(key: widget.fieldKey.key);
    await Clipboard.setData(ClipboardData(text: _currentOtp ?? ''));
    return true;
  }

  @override
  Widget _buildEntryFieldEditor() => _errorMessage != null
      ? Text('$_errorMessage')
      : OtpFieldEntryEditor(
          period: _period,
          elapsed: _elapsed,
          otpCode: _currentOtp,
        );

  @override
  Future<void> _handleMenuEntrySelected(EntryAction entryAction) async {
    if (entryAction == EntryAction.copyRawData) {
      await Clipboard.setData(ClipboardData(text: _valueCurrent));
      return;
    }
    return super._handleMenuEntrySelected(entryAction);
  }

  @override
  List<PopupMenuEntry<EntryAction>> _buildMenuEntries(BuildContext context) =>
      super
          ._buildMenuEntries(context)
          .where((item) =>
              item is PopupMenuItem &&
              const [
                EntryAction.delete,
                EntryAction.copy,
              ].contains((item as PopupMenuItem).value))
          .followedBy([
        const PopupMenuItem(
          value: EntryAction.copyRawData,
          child: ListTile(
            leading: Icon(Icons.code),
            title: Text('Copy Secret'),
          ),
        )
      ]).toList();
}

class ObscuredEntryFieldEditor extends StatelessWidget {
  const ObscuredEntryFieldEditor({
    Key key,
    @required this.onPressed,
    @required this.commonField,
    @required this.fieldKey,
  }) : super(key: key);

  final CommonField commonField;
  final KdbxKey fieldKey;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InputDecorator(
          decoration: InputDecoration(
            prefixIcon:
                commonField?.icon == null ? null : Icon(commonField.icon),
            labelText: commonField?.displayName ?? fieldKey.key,
            filled: true,
          ),
          child: const Text(
            '*****************',
            style: TextStyle(color: Colors.white),
          ),
        ),
        Positioned.fill(
          child: ClipRect(
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(
                sigmaX: 0.5,
                sigmaY: 0.5,
              ),
              child: LinkButton(
                child: Container(
                  alignment: Alignment.bottomCenter,
                  padding: const EdgeInsets.only(left: 12.0 + 24.0, bottom: 16),
                  child: const Text(
                    'Protected field. Click to reveal.',
                    style: TextStyle(
                        shadows: [Shadow(color: Colors.white, blurRadius: 5)]),
                  ),
                ),
                onPressed: onPressed,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class StringEntryFieldEditor extends StatelessWidget {
  const StringEntryFieldEditor({
    Key key,
    @required this.onSaved,
    @required this.controller,
    @required this.formFieldKey,
    @required this.focusNode,
    @required this.commonField,
    @required this.fieldKey,
    @required this.passwordGeneratorPressed,
  }) : super(key: key);

  final Key formFieldKey;
  final FocusNode focusNode;
  final CommonField commonField;
  final KdbxKey fieldKey;
  final TextEditingController controller;
  final FormFieldSetter<String> onSaved;
  final VoidCallback passwordGeneratorPressed;

  @override
  Widget build(BuildContext context) {
    final commonFields = Provider.of<CommonFields>(context);
    return TextFormField(
      key: formFieldKey,
      maxLines: null,
      focusNode: focusNode,
      decoration: InputDecoration(
//        fillColor: const Color(0xfff0f0f0),
        filled: true,
        prefixIcon: commonField?.icon == null ? null : Icon(commonField.icon),
        suffixIcon: ValueListenableBuilder<TextEditingValue>(
          valueListenable: controller,
          builder: (context, value, child) =>
              fieldKey == commonFields.password.key && controller.text.isEmpty
                  ? IconButton(
//                            padding: EdgeInsets.zero,
                      tooltip: 'Generate Password (cmd+g)',
                      icon: const Icon(Icons.refresh),
                      onPressed: passwordGeneratorPressed,
                    )
                  : const SizedBox(),
        ),
//                        suffixIcon: _isProtected ? Icon(Icons.lock) : null,
        labelText: commonField?.displayName ?? fieldKey.key,
      ),
      keyboardType: commonField?.keyboardType,
      controller: controller,
      onSaved: onSaved,
    );
  }
}

class HighlightWidget extends StatefulWidget {
  const HighlightWidget({Key key, this.child, this.childOnHighlight})
      : super(key: key);

  final Widget child;
  final Widget childOnHighlight;

  @override
  HighlightWidgetState createState() => HighlightWidgetState();
}

class HighlightWidgetState extends State<HighlightWidget>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  Animation<Decoration> _decorationAnimation;
  Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _controller.addStatusListener(_animationStatusChanged);
  }

  void _animationStatusChanged(AnimationStatus status) {
    _logger.finer('Highlight animation status changed: $status');
    if (status == AnimationStatus.completed) {
      setState(() {
        _decorationAnimation = null;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _decorationAnimation == null
        ? widget.child
        /* Stack(children: [
            widget.child,
            Positioned.fill(
                child: Opacity(
              opacity: 0.9,
              child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.5),
                    backgroundBlendMode: BlendMode.color,
                    /*boxShadow: const [BoxShadow(blurRadius: 2)]*/
                  ),
                  child: Center(child: widget.childOnHighlight)),
            ))
          ])*/
        : Stack(
            overflow: Overflow.visible,
            children: [
              widget.child,
              Positioned.fill(
                top: -4,
                bottom: -4,
                child: FadeTransition(
                  opacity: _opacity,
                  child: DecoratedBoxTransition(
                      decoration: _decorationAnimation,
                      child: Center(child: widget.childOnHighlight)),
                ),
              ),
            ],
          );
  }

  void triggerHighlight() {
    final tween = DecorationTween(
      begin: BoxDecoration(
        color: Colors.green.withOpacity(0.8),
//        backgroundBlendMode: BlendMode.color,
      ),
      end: BoxDecoration(
        color: Colors.green.withOpacity(1),
//        backgroundBlendMode: BlendMode.color,
      ),
//      end: const BoxDecoration(color: Color(0xffffffff), backgroundBlendMode: BlendMode.overlay),
    );
    setState(() {
      _decorationAnimation =
          CurvedAnimation(parent: _controller, curve: Curves.easeOut)
              .drive(tween);
      _opacity = CurvedAnimation(parent: _controller, curve: Curves.easeIn)
          .drive(Tween(begin: 1, end: 0));
      _controller.forward(from: 0);
    });
  }
}
