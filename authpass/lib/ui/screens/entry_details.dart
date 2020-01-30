import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:authpass/bloc/analytics.dart';
import 'package:authpass/bloc/app_data.dart';
import 'package:authpass/bloc/kdbx_bloc.dart';
import 'package:authpass/cloud_storage/cloud_storage_provider.dart';
import 'package:authpass/env/_base.dart';
import 'package:authpass/ui/common_fields.dart';
import 'package:authpass/ui/screens/about.dart';
import 'package:authpass/ui/screens/entry_totp.dart';
import 'package:authpass/ui/screens/hud.dart';
import 'package:authpass/ui/screens/password_generator.dart';
import 'package:authpass/ui/widgets/icon_selector.dart';
import 'package:authpass/ui/widgets/keyboard_handler.dart';
import 'package:authpass/ui/widgets/link_button.dart';
import 'package:authpass/ui/widgets/primary_button.dart';
import 'package:authpass/utils/async_utils.dart';
import 'package:authpass/utils/dialog_utils.dart';
import 'package:authpass/utils/format_utils.dart';
import 'package:authpass/utils/otpauth.dart';
import 'package:authpass/utils/password_generator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_async_utils/flutter_async_utils.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kdbx/kdbx.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
import 'package:base32/base32.dart';

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
    with TaskStateMixin, StreamSubscriberMixin {
  final _formKey = GlobalKey<FormState>();
  bool _isDirty = false;

  @override
  void initState() {
    super.initState();
    _registerListener();
  }

  @override
  void didUpdateWidget(EntryDetailsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    _registerListener();
  }

  void _registerListener() {
    subscriptions.cancelSubscriptions();
    widget.entry.changes.listen((change) {
      setState(() {
        _isDirty = change.isDirty || _isDirty;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final env = Provider.of<Env>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(EntryFormatUtils.getLabel(widget.entry)),
        actions: <Widget>[
          AuthPassAboutDialog.createAboutPopupAction(context,
              builder: !env.isDebug
                  ? null
                  : (context) => [
                        PopupMenuItem(
                          child: const ListTile(
                            leading: Icon(Icons.bug_report),
                            title: Text('Debug: Copy XML'),
                          ),
                          value: () {
                            Clipboard.setData(ClipboardData(
                                text: widget.entry
                                    .toXml()
                                    .toXmlString(pretty: true)));
                          },
                        ),
                      ]),
        ],
      ),
//      floatingActionButton: FloatingActionButton(
//        child: Icon(Icons.add),
//        onPressed: () {},
//      ),
      body: WillPopScope(
        child: Form(
          key: _formKey,
          child: EntryDetails(
            entry: widget.entry,
            onSavedPressed: !_isDirty && !widget.entry.isDirty
                ? null
                : asyncTaskCallback(() async {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      final kdbxBloc = Provider.of<KdbxBloc>(context);
                      if (kdbxBloc
                          .fileForKdbxFile(widget.entry.file)
                          .fileSource
                          .supportsWrite) {
                        try {
                          await kdbxBloc.saveFile(widget.entry.file);
                        } on StorageException catch (e, stackTrace) {
                          _logger.warning(
                              'Error while saving database.', e, stackTrace);
                          await DialogUtils.showErrorDialog(context,
                              'Error while saving', 'Unable to save file: $e');
                          return;
                        }
                        setState(() => _isDirty = false);
                      } else {
                        await DialogUtils.showSimpleAlertDialog(
                          context,
                          null,
                          'Sorry this database does not support saving. '
                          'Please open a local database file.',
                        );
                      }
                    }
                  }),
          ),
          onChanged: () {
            if (!_isDirty) {
              setState(() => _isDirty = true);
            }
          },
        ),
        onWillPop: () async {
          if (!_isDirty && !widget.entry.isDirty) {
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

class EntryDetails extends StatefulWidget {
  const EntryDetails(
      {Key key, @required this.entry, @required this.onSavedPressed})
      : super(key: key);

  final KdbxEntry entry;
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
      if (event.type == KeyboardShortcutType.copyPassword) {
        _copyField(commonFields.password);
      } else if (event.type == KeyboardShortcutType.copyUsername) {
        _copyField(commonFields.userName);
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
    final value = widget.entry.getString(commonField.key);
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

  void _initFields() {
    final commonFields = Provider.of<CommonFields>(context);
    final nonCommonKeys = widget.entry.stringEntries
        .where((str) => !commonFields.isCommon(str.key));
    _fieldKeys = commonFields.fields
        .where((f) => f.showByDefault || widget.entry.getString(f.key) != null)
        .map((f) => Tuple3(
            GlobalKey<_EntryFieldState>(debugLabel: '${f.key}'), f.key, f))
        .followedBy(nonCommonKeys.map((f) =>
            Tuple3(GlobalObjectKey<_EntryFieldState>(f.key), f.key, null)))
        .toList();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _logger.info('_EntryDetailsState.didChangeDependencies');
    if (_fieldKeys == null) {
      subscriptions.cancelSubscriptions();
      _initFields();
      _initShortcutListener(Provider.of<KeyboardShortcutEvents>(context),
          Provider.of<CommonFields>(context));
    }
  }

  @override
  void didUpdateWidget(EntryDetails oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.entry != widget.entry) {
      _logger.info('_EntryDetailsState: widget.entry changed.');
      _initFields();
    }
  }

  @override
  Widget build(BuildContext context) {
    final commonFields = Provider.of<CommonFields>(context);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: SafeArea(
          top: false,
          left: false,
          child: Column(
            children: <Widget>[
              const SizedBox(height: 16),
              IconSelectorFormField(
                initialValue: widget.entry.icon.get(),
                onSaved: (icon) {
                  widget.entry.icon.set(icon);
                },
              ),
              const SizedBox(height: 32),
              ..._fieldKeys
                  .map(
                    (f) => EntryField(
                      key: f.item1,
                      entry: widget.entry,
                      fieldKey: f.item2,
                      commonField: f.item3,
                      onChangedMetadata: () => setState(() {
                        _initFields();
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
                    widget.entry.setString(key,
                        ProtectedValue.fromString(secret.toUri().toString()));
                  } else {
                    widget.entry.setString(
                        key,
                        cf?.protect == true
                            ? ProtectedValue.fromString('')
                            : PlainValue(''));
                  }
                  Provider.of<Analytics>(context, listen: false)
                      .events
                      .trackAddField(key: key.key);
                  _initFields();
                  setState(() {});
                },
              ),
              const SizedBox(height: 16),
              PrimaryButton(
                icon: Icon(Icons.save),
                child: const Text('Save'),
                onPressed: widget.onSavedPressed,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<OtpAuth> _askForTotpSecret(BuildContext context) async {
    final totpCode = await SimplePromptDialog.showPrompt(
        context,
        const SimplePromptDialog(
          title: 'Time Based Authentication',
          labelText: 'Please enter time based key.',
        ));
    if (totpCode == null) {
      return null;
    }
    try {
      final cleaned = totpCode?.replaceAll(' ', ''); //?.toUpperCase();
      final value = base32.decode(cleaned);
      _logger.fine('Got totp secret with ${value.lengthInBytes} bytes.');
      return OtpAuth(secret: value);
    } catch (e, stackTrace) {
      _logger.warning('Invalid base32 code?', e, stackTrace);
      await DialogUtils.showSimpleAlertDialog(context, 'Invalid key',
          'Given input is not a valid base32 TOTP code. Please verify your input.');
      return await _askForTotpSecret(context);
    }
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
    return LinkButton(
      icon: Icon(Icons.add_circle_outline),
      child: const Text('Add Field'),
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
        final commonFields = Provider.of<CommonFields>(context);
        final custom = CommonField(
          displayName: 'Custom Field',
          key: '__custom',
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
    final key = await SimplePromptDialog.showPrompt(
      context,
      const SimplePromptDialog(
        title: 'Adding new Field',
        labelText: 'Enter a name for the field',
      ),
    );
    if (key != null && key.isNotEmpty) {
      widget.onAddField(KdbxKey(key));
    }
  }
}

class EntryField extends StatefulWidget {
  const EntryField({
    Key key,
    @required this.entry,
    @required this.fieldKey,
    this.commonField,
    @required this.onChangedMetadata,
  })  : assert(entry != null),
        assert(fieldKey != null),
        assert(onChangedMetadata != null),
        super(key: key);

  final KdbxEntry entry;
  final KdbxKey fieldKey;
  final CommonField commonField;
  final VoidCallback onChangedMetadata;

  @override
  _EntryFieldState createState() => _EntryFieldState();
}

enum EntryAction {
  copy,
  rename,
  protect,
  delete,
  show,
  passwordGenerator,
}

class _EntryFieldState extends State<EntryField> with StreamSubscriberMixin {
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

  bool get _isOtpAuth => widget.commonField == _commonFields.otpAuth;

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
    return Dismissible(
      key: ValueKey(widget.fieldKey),
      background: Container(
        alignment: Alignment.centerLeft,
        color: Colors.lightBlueAccent,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(Icons.lock),
            const SizedBox(height: 4),
            const Text('Copy Field'),
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
        childOnHighlight: Text('Copied!',
            style: Theme.of(context)
                .textTheme
                .body1
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
                child: _isOtpAuth
                    ? TotpFieldEntry(
                        entry: widget.entry,
                        fieldKey: widget.fieldKey,
                        commonField: widget.commonField,
                      )
                    : _isValueObscured
                        ? ObscuredEntryField(
                            onPressed: () {
                              setState(() {
                                _controller.text = _valueCurrent ?? '';
                                _controller.selection = TextSelection(
                                    baseOffset: 0,
                                    extentOffset:
                                        _controller.text?.length ?? 0);
                                _isValueObscured = false;
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  _focusNode.requestFocus();
                                  _logger.finer('requesting focus.');
                                });
                              });
                            },
                            fieldKey: widget.fieldKey,
                            commonField: widget.commonField,
                          )
                        : StringEntryField(
                            onSaved: (value) {
                              final newValue = _isProtected
                                  ? ProtectedValue.fromString(value)
                                  : PlainValue(value);
                              _fieldValue = newValue;
                            },
                            fieldKey: widget.fieldKey,
                            commonField: widget.commonField,
                            controller: _controller,
                            formFieldKey: _formFieldKey,
                            focusNode: _focusNode,
                            passwordGeneratorPressed: _generatePassword,
                          ),
              ),
              PopupMenuButton<EntryAction>(
                icon: Icon(Icons.more_vert),
                offset: const Offset(0, 32),
                onSelected: (val) async {
                  switch (val) {
                    case EntryAction.copy:
                      await copyValue();
                      break;
                    case EntryAction.rename:
                      final key = await SimplePromptDialog.showPrompt(
                        context,
                        SimplePromptDialog(
                          title: 'Renaming field',
                          labelText: 'Enter the new name for the field',
                          initialValue: widget.fieldKey.key,
                        ),
                      );
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
                          _fieldValue =
                              ProtectedValue.fromString(_valueCurrent ?? '');
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
                  }
                },
                itemBuilder: (context) => <PopupMenuEntry<EntryAction>>[
                  const PopupMenuItem(
                    value: EntryAction.copy,
                    child: ListTile(
                      leading: Icon(Icons.content_copy),
                      title: Text('Copy'),
                    ),
                  ),
                  const PopupMenuDivider(),
                  const PopupMenuItem(
                    value: EntryAction.rename,
                    child: ListTile(
                      leading: Icon(Icons.edit),
                      title: Text('Rename'),
                    ),
                  ),
                  const PopupMenuItem(
                    value: EntryAction.passwordGenerator,
                    child: ListTile(
                      leading: Icon(FontAwesomeIcons.random),
                      title: Text('Password Generator …'),
                    ),
                  ),
                  PopupMenuItem(
                    value: EntryAction.protect,
                    child: ListTile(
                      leading: Icon(_isProtected
                          ? Icons.no_encryption
                          : Icons.enhanced_encryption),
                      title: Text(
                          _isProtected ? 'Unprotect value' : 'Protect Value'),
                    ),
                  ),
                  const PopupMenuItem(
                    value: EntryAction.delete,
                    child: ListTile(
                      leading: Icon(Icons.delete),
                      title: Text('Delete'),
                    ),
                  ),
                  const PopupMenuItem(
                    value: EntryAction.show,
                    child: ListTile(
//                    leading: Icon(Icons.present_to_all),
                      leading: Icon(FontAwesomeIcons.qrcode),
                      title: Text('Present'),
                    ),
                  ),
                ]
                    .where((item) =>
                        !_isOtpAuth ||
                        item is PopupMenuItem &&
                            (item as PopupMenuItem).value == EntryAction.delete)
                    .toList(),
              )
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

  Future<void> _generatePassword() async {
    final appData = await Provider.of<AppDataBloc>(context).store.load();
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
    final password =
        await Navigator.of(context).push(PasswordGeneratorScreen.route());
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
  }

  Future<bool> copyValue() async {
    _highlightWidgetKey.currentState.triggerHighlight();
    Provider.of<Analytics>(context)
        .events
        .trackCopyField(key: widget.fieldKey.key);
    await Clipboard.setData(ClipboardData(text: _valueCurrent ?? ''));
    return true;
  }

  @override
  void dispose() {
    _logger
        .fine('EntryFieldState.dispose() - ${widget.key} (${widget.fieldKey})');
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}

class ObscuredEntryField extends StatelessWidget {
  const ObscuredEntryField({
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

class StringEntryField extends StatelessWidget {
  const StringEntryField({
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
        fillColor: const Color(0xfff0f0f0),
        filled: true,
        prefixIcon: commonField?.icon == null ? null : Icon(commonField.icon),
        suffixIcon: fieldKey == commonFields.password.key
            ? IconButton(
//                            padding: EdgeInsets.zero,
                tooltip: 'Generate Password (cmd+g)',
                icon: Icon(Icons.refresh),
                onPressed: passwordGeneratorPressed,
              )
            : null,
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
