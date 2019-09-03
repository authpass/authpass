import 'package:authpass/bloc/analytics.dart';
import 'package:authpass/bloc/kdbx_bloc.dart';
import 'package:authpass/main.dart';
import 'package:authpass/ui/common_fields.dart';
import 'package:authpass/ui/screens/about.dart';
import 'package:authpass/ui/screens/entry_details.dart';
import 'package:authpass/ui/screens/select_file_screen.dart';
import 'package:authpass/ui/widgets/keyboard_handler.dart';
import 'package:authpass/ui/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_async_utils/flutter_async_utils.dart';
import 'package:kdbx/kdbx.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

final _logger = Logger('password_list');

class PasswordList extends StatelessWidget {
  const PasswordList({Key key, @required this.onEntrySelected, this.selectedEntry}) : super(key: key);

  static const routeSettings = RouteSettings(name: '/passwordList');

  static Route<void> route() => MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => PasswordList(
          onEntrySelected: (entry, type) {
            if (type == EntrySelectionType.activeOpen) {
              Navigator.of(context).push(EntryDetailsScreen.route(entry: entry));
            }
          },
        ),
      );

  final KdbxEntry selectedEntry;
  final void Function(KdbxEntry entry, EntrySelectionType type) onEntrySelected;

  @override
  Widget build(BuildContext context) {
    final kdbxBloc = Provider.of<KdbxBloc>(context);
    final allEntries = kdbxBloc.openedFiles.expand((f) => f.body.rootGroup.getAllEntries()).toList(growable: false);
    return PasswordListContent(
      entries: allEntries,
      selectedEntry: selectedEntry,
      onEntrySelected: onEntrySelected,
    );
  }
}

enum EntrySelectionType {
  /// entry was highlighted (e.g. via search or up/down arrows) must not switch context.
  passiveHighlight,

  /// entry was actively selected by the user (e.g. via tap).
  activeOpen,
}

class PasswordListContent extends StatefulWidget {
  const PasswordListContent({
    Key key,
    @required this.entries,
    @required void Function(KdbxEntry entry, EntrySelectionType type) onEntrySelected,
    this.selectedEntry,
  })  : _onEntrySelected = onEntrySelected,
        super(key: key);

  final List<KdbxEntry> entries;
  final void Function(KdbxEntry entry, EntrySelectionType type) _onEntrySelected;
  final KdbxEntry selectedEntry;

  void onEntrySelected(BuildContext context, KdbxEntry entry, EntrySelectionType type) {
    _onEntrySelected(entry, type);
    Provider.of<Analytics>(context).events.trackSelectEntry(type: type);
  }

  @override
  _PasswordListContentState createState() => _PasswordListContentState();
}

class PasswordListFilterIsolateRunner {
  static final _instance = PasswordListFilterIsolateRunner();

  List<KdbxEntry> _allEntries;

  static bool init(List<KdbxEntry> entries) {
    initIsolate();
    PasswordListFilterIsolateRunner._instance._allEntries = entries;
    return true;
  }

  static List<KdbxEntry> filter(String query) {
    return filterEntries(PasswordListFilterIsolateRunner._instance._allEntries, query);
  }

  static List<KdbxEntry> filterEntries(List<KdbxEntry> _allEntries, String query, {int maxResults = 30}) {
    _logger.info('We have to filter for $query');
    return _allEntries
        .where((entry) => matches(entry, query))
        // take no more than 30 for now.
        .take(maxResults)
        .toList(growable: false);
  }

  static final searchFields = [KdbxKey('Title'), KdbxKey('URL'), KdbxKey('UserName')];

  static bool matches(KdbxEntry entry, String filterQuery) {
    final query = filterQuery.toLowerCase();
    return searchFields
        .where((field) => entry.getString(field)?.getText()?.toLowerCase()?.contains(query) == true)
        .isNotEmpty;
  }
}

class _PasswordListContentState extends State<PasswordListContent> with StreamSubscriberMixin, WidgetsBindingObserver {
  List<KdbxEntry> _filteredEntries;
  String _filterQuery;
  final _filterTextEditingController = TextEditingController();
  final FocusNode _filterFocusNode = FocusNode();

//  final _isolateRunner = IsolateRunner.spawn();

  @override
  void initState() {
    super.initState();
    _logger.finer('Initializing password list content.');
//    _isolateRunner.then((runner) => runner.run(PasswordListFilterIsolateRunner.init, widget.entries)).then((result) {
//      _logger.finer('Initializd filter isolate $result');
//    });
    WidgetsBinding.instance.addObserver(this);
  }

  void _selectAllFilter() => _filterTextEditingController.selection =
      TextSelection(baseOffset: 0, extentOffset: _filterTextEditingController.text.length);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    _logger.finer('didChangeAppLifecycleState($state)');
    if (state == AppLifecycleState.resumed) {
      setState(() {
        _selectAllFilter();
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    subscriptions.cancelSubscriptions();
    final shortcuts = Provider.of<KeyboardShortcutEvents>(context);
    handleSubscription(shortcuts.shortcutEvents.listen((event) {
      if (event.type == KeyboardShortcutType.search) {
        setState(() {
          if (_filterQuery == null || _filteredEntries == null) {
            _filterQuery ??= '';
            _filteredEntries = widget.entries;
          }
          _selectAllFilter();
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _filterFocusNode.requestFocus();
          });
        });
      } else if (event.type == KeyboardShortcutType.moveUp) {
        _selectNextEntry(-1);
      } else if (event.type == KeyboardShortcutType.moveDown) {
        _selectNextEntry(1);
      }
    }));
  }

  void _selectNextEntry(int next) {
    final entries = _filteredEntries ?? widget.entries;
    if (entries.isEmpty) {
      return;
    }
    final idx = entries.indexOf(widget.selectedEntry);
    // right now we ignore the fact that the user might select a list item which is not in view.
    // https://github.com/flutter/flutter/issues/12319
    if (idx < 0) {
      widget.onEntrySelected(context, entries.first, EntrySelectionType.passiveHighlight);
    } else {
      // new Index, modulo entry length to make sure we wrap around the end..
      final newIndex = (idx + next) % entries.length;
      widget.onEntrySelected(context, entries[newIndex], EntrySelectionType.passiveHighlight);
    }
  }

  @override
  void dispose() {
    _logger.info('Disposing isolate runner.');
//    _isolateRunner.then<void>((runner) => runner.close());
    _filterFocusNode.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  AppBar _buildDefaultAppBar(BuildContext context) {
    return AppBar(
      title: const Text('AuthPass'),
      actions: <Widget>[
        IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              setState(() {
                _filteredEntries = widget.entries;
              });
            }),
        PopupMenuButton<VoidCallback>(
          onSelected: (item) {
            item();
          },
          itemBuilder: (context) => [
            AuthPassAboutDialog.createAboutMenuItem(context),
            PopupMenuItem(
              value: () {
                Provider.of<KdbxBloc>(context).closeAllFiles();
                Navigator.of(context).pushAndRemoveUntil(SelectFileScreen.route, (_) => false);
              },
              child: ListTile(
                leading: Icon(Icons.exit_to_app),
                title: const Text('Lock Files'),
              ),
            ),
          ],
        )
      ],
    );
  }

  ThemeData appBarTheme(BuildContext context) {
    final theme = Theme.of(context);
    return theme.copyWith(
      primaryColor: Colors.white,
      primaryIconTheme: theme.primaryIconTheme.copyWith(color: Colors.grey),
      primaryColorBrightness: Brightness.light,
      primaryTextTheme: theme.textTheme,
    );
  }

  AppBar _buildFilterAppBar(BuildContext context) {
    final theme = appBarTheme(context);
    return AppBar(
      backgroundColor: theme.primaryColor,
      iconTheme: theme.primaryIconTheme,
      textTheme: theme.primaryTextTheme,
      brightness: theme.primaryColorBrightness,
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          setState(() {
            _filterQuery = null;
            _filteredEntries = null;
          });
        },
      ),
      title: TextField(
        style: theme.textTheme.title,
        focusNode: _filterFocusNode,
        controller: _filterTextEditingController,
        onChanged: (newQuery) async {
          _logger.info('query changed to $newQuery');
          final entries = PasswordListFilterIsolateRunner.filterEntries(widget.entries, newQuery);
          setState(() {
            _filterQuery = newQuery;
            _filteredEntries = entries;
            if (_filteredEntries.isNotEmpty &&
                (widget.selectedEntry == null || !_filteredEntries.contains(widget.selectedEntry))) {
              widget.onEntrySelected(context, _filteredEntries.first, EntrySelectionType.passiveHighlight);
            }
          });
        },
        autofocus: true,
        decoration: InputDecoration(
          hintText: 'Search',
          border: InputBorder.none,
          hintStyle: theme.inputDecorationTheme.hintStyle,
        ),
      ),
    );
  }

  Widget _buildListPrefix() {
    final kdbxBloc = Provider.of<KdbxBloc>(context);
    final unsupportedWrite = kdbxBloc.openedFilesWithSources.firstWhere(
      (f) => f.value.dirtyObjects.isNotEmpty && !f.key.supportsWrite,
      orElse: () => null,
    );
    if (unsupportedWrite == null) {
      return null;
    }
    return UnsupportedWrite(source: unsupportedWrite.key);
  }

  @override
  Widget build(BuildContext context) {
    final commonFields = Provider.of<CommonFields>(context);
    final entries = _filteredEntries ?? widget.entries;
    final listPrefix = _buildListPrefix();
    return Scaffold(
      appBar: _filteredEntries == null ? _buildDefaultAppBar(context) : _buildFilterAppBar(context),
      body: widget.entries.isEmpty
          ? NoPasswordsEmptyView(
              onPrimaryButtonPressed: () {
                final kdbxBloc = Provider.of<KdbxBloc>(context);
                final entry = kdbxBloc.createEntry();
//                Navigator.of(context).push(EntryDetailsScreen.route(entry: entry));
                widget.onEntrySelected(context, entry, EntrySelectionType.activeOpen);
              },
            )
          : ListView.builder(
              itemCount: entries.length + (listPrefix != null ? 1 : 0),
              itemBuilder: (context, index) {
                if (listPrefix != null) {
                  if (index == 0) {
                    return listPrefix;
                  }
                  index--;
                }
                final entry = entries[index];
//                _logger.finer('listview item. selectedEntry: ${widget.selectedEntry}');
                return Dismissible(
                  key: ValueKey(entry.uuid),
                  resizeDuration: null,
                  background: Container(
                    alignment: Alignment.centerLeft,
                    color: Colors.lightBlueAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(Icons.lock),
                        const SizedBox(height: 4),
                        const Text('Copy Password'),
                      ],
                    ),
                  ),
                  secondaryBackground: Container(
                    alignment: Alignment.centerRight,
                    color: Colors.limeAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(Icons.account_circle),
                        const SizedBox(height: 4),
                        const Text('Copy User Name'),
                      ],
                    ),
                  ),
                  confirmDismiss: (direction) async {
                    if (direction == DismissDirection.endToStart) {
//                      await ClipboardManager.copyToClipBoard(entry.getString(commonFields.userName.key).getText());
                      await Clipboard.setData(
                          ClipboardData(text: entry.getString(commonFields.userName.key).getText()));
                      Scaffold.of(context).showSnackBar(SnackBar(content: const Text('Copied userame.')));
                    } else {
//                      await ClipboardManager.copyToClipBoard(entry.getString(commonFields.password.key).getText());
                      await Clipboard.setData(
                          ClipboardData(text: entry.getString(commonFields.password.key).getText()));
                      Scaffold.of(context).showSnackBar(SnackBar(content: const Text('Copied password.')));
                    }
                    return false;
                  },
                  child: Container(
                    decoration: widget.selectedEntry != entry
                        ? null
                        : BoxDecoration(
                            color: Colors.white,
                            border: Border(right: BorderSide(color: Theme.of(context).primaryColor, width: 4)),
                          ),
                    child: ListTile(
                      leading: Icon(Icons.supervisor_account),
                      selected: widget.selectedEntry == entry,
                      title: Text.rich(_highlightFilterQuery(commonFields.title.stringValue(entry)) ??
                          const TextSpan(text: '(no title)')),
                      subtitle: Text.rich(_highlightFilterQuery(commonFields.userName.stringValue(entry)) ??
                          const TextSpan(text: '(no website)')),
                      onTap: () {
//                      Navigator.of(context).push(EntryDetailsScreen.route(entry: entry));
                        widget.onEntrySelected(context, entry, EntrySelectionType.activeOpen);
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }

  InlineSpan _highlightFilterQuery(String text) {
    if (text == null) {
      return null;
    }
    if (_filterQuery == null || _filterQuery.isEmpty) {
      return TextSpan(text: text);
    }
    //RegExp.escape(text).allMatches(string)
    int previousMatchEnd = 0;
    final List<TextSpan> spans = [];
    for (final match in _filterQuery.allMatches(text)) {
      spans.add(TextSpan(text: text.substring(previousMatchEnd, match.start)));
      spans.add(TextSpan(text: text.substring(match.start, match.end), style: TextStyle(fontWeight: FontWeight.bold)));
      previousMatchEnd = match.end;
    }
    if (previousMatchEnd < text.length) {
      spans.add(TextSpan(text: text.substring(previousMatchEnd)));
    }
    return TextSpan(children: spans);

//    The functional approach was a bit too clever...
//    int previousMatchEnd = 0;
//    return TextSpan(
//        children: _filterQuery.allMatches(text).expand((match) {
//      final spans = [
//        TextSpan(text: text.substring(previousMatchEnd, match.start)),
//        TextSpan(text: text.substring(match.start, match.end), style: TextStyle(fontWeight: FontWeight.bold)),
//      ];
//      previousMatchEnd = match.end;
//      return spans;
//    }).toList(growable: false));
  }
}

class NoPasswordsEmptyView extends StatelessWidget {
  const NoPasswordsEmptyView({Key key, this.onPrimaryButtonPressed}) : super(key: key);

  final VoidCallback onPrimaryButtonPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text('🤗️', style: TextStyle(fontSize: 64)),
          const SizedBox(height: 16),
          const Text('You do not have any password in your database yet.'),
          const SizedBox(height: 16),
          PrimaryButton(
            child: const Text('Add Password'),
            onPressed: onPrimaryButtonPressed,
          ),
        ],
      ),
    );
  }
}

class UnsupportedWrite extends StatelessWidget {
  const UnsupportedWrite({Key key, this.source}) : super(key: key);

  final FileSource source;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: const Color(0xffffe9e9),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: <Widget>[
              Icon(Icons.warning, color: const Color(0xffff0000)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  children: [
                    Text('You have changes in "${source.displayName}", which '
                        'does not support writing of changes.'),
                    const SizedBox(height: 4),
                    Text(source.displayPath, style: theme.textTheme.caption),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
//                        FlatButton(
//                          child: const Text('Dismiss'),
//                          onPressed: () {},
//                        ),
                        FlatButton(
                          child: const Text('Save locally'),
                          onPressed: () {
                            final bloc = Provider.of<KdbxBloc>(context);
                            bloc.saveLocally(source);
                          },
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
