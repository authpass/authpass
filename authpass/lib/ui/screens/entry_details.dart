import 'package:authpass/ui/common_fields.dart';
import 'package:authpass/ui/widgets/primary_button.dart';
import 'package:clipboard_manager/clipboard_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kdbx/kdbx.dart';
import 'package:provider/provider.dart';

class EntryDetailsScreen extends StatelessWidget {
  const EntryDetailsScreen({Key key, @required this.entry}) : super(key: key);

  static Route<void> route({@required KdbxEntry entry}) => MaterialPageRoute(
      settings: const RouteSettings(name: '/entry'),
      builder: (context) => EntryDetailsScreen(
            entry: entry,
          ));

  final KdbxEntry entry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(entry.label ?? ''),
      ),
      body: EntryDetails(entry: entry),
      bottomNavigationBar: Material(
        elevation: 8,
//        color: Colors.green,
        child: Container(
//          decoration: BoxDecoration(border: Border(top: BorderSide())),
          padding: const EdgeInsets.all(16) + EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
          child: PrimaryButton(
            onPressed: () {},
            icon: Icon(Icons.save),
            child: const Text('Save'),
          ),
        ),
      ),
    );
  }
}

class EntryDetails extends StatefulWidget {
  const EntryDetails({Key key, @required this.entry}) : super(key: key);

  final KdbxEntry entry;

  @override
  _EntryDetailsState createState() => _EntryDetailsState();
}

class _EntryDetailsState extends State<EntryDetails> {
  final List<EntryField> fields = [];

  void _initTextControllers() {}

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initTextControllers();
  }

  @override
  Widget build(BuildContext context) {
    final commonFields = Provider.of<CommonFields>(context);

    final nonCommonKeys = widget.entry.stringEntries.where((str) => !commonFields.isCommon(str.key));

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: SafeArea(
          top: false,
          left: false,
          right: false,
          child: Column(
            children: <Widget>[
              ...commonFields.fields
                  .map(
                    (f) => EntryField(
                      entry: widget.entry,
                      fieldKey: f.key,
                      commonField: f,
                    ),
                  )
                  .followedBy(
                    nonCommonKeys.map((key) => EntryField(entry: widget.entry, fieldKey: key.key)),
                  )
                  .expand((el) => [el, const SizedBox(height: 8)]),
            ],
          ),
        ),
      ),
    );
  }
}

class EntryField extends StatefulWidget {
  const EntryField({Key key, @required this.entry, @required this.fieldKey, this.commonField}) : super(key: key);

  final KdbxEntry entry;
  final KdbxKey fieldKey;
  final CommonField commonField;

  @override
  _EntryFieldState createState() => _EntryFieldState();
}

class _EntryFieldState extends State<EntryField> {
  TextEditingController _controller;
  bool _isProtected = false;

  StringValue _value;

  @override
  void initState() {
    super.initState();
    _value = widget.entry.getString(widget.fieldKey);
    if (_value is ProtectedValue) {
      _isProtected = true;
      _controller = TextEditingController(text: 'Protected');
    } else {
      _controller = TextEditingController(text: _value.getText());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(widget.key),
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
        await ClipboardManager.copyToClipBoard(_value.getText());
        return false;
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                maxLines: null,
                decoration: InputDecoration(
                  fillColor: const Color(0xfff0f0f0),
                  filled: true,
                  suffixIcon: _isProtected ? Icon(Icons.lock) : null,
                  labelText: widget.commonField?.displayName ?? widget.fieldKey.key,
                ),
                keyboardType: widget.commonField?.keyboardType,
                controller: _controller,
                obscureText: _isProtected,
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
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
