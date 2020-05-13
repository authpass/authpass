import 'dart:collection';

import 'package:authpass/bloc/analytics.dart';
import 'package:authpass/bloc/kdbx_bloc.dart';
import 'package:authpass/ui/common_fields.dart';
import 'package:authpass/ui/screens/about.dart';
import 'package:authpass/ui/screens/entry_details.dart';
import 'package:authpass/ui/screens/group_list.dart';
import 'package:authpass/ui/screens/select_file_screen.dart';
import 'package:authpass/ui/widgets/keyboard_handler.dart';
import 'package:authpass/ui/widgets/primary_button.dart';
import 'package:authpass/utils/extension_methods.dart';
import 'package:authpass/utils/format_utils.dart';
import 'package:authpass/utils/predefined_icons.dart';
import 'package:authpass/utils/theme_utils.dart';
import 'package:autofill_service/autofill_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_async_utils/flutter_async_utils.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kdbx/kdbx.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

final _logger = Logger('password_list');

class EntryViewModel {
  EntryViewModel(this.entry, this.kdbxBloc)
      : label = EntryFormatUtils.getLabel(entry),
        groupNames = _createGroupNames(entry.parent),
        fileColor = kdbxBloc.fileForKdbxFile(entry.file).openedFile.color;

  final KdbxBloc kdbxBloc;
  final KdbxEntry entry;
  final String label;
  final List<String> groupNames;
  final Color fileColor;

  static List<String> _createGroupNames(KdbxGroup group) {
    final queue = Queue<String>();
    while (group != null) {
      queue.addFirst(group.name.get());
      group = group.parent;
    }
    return queue.toList();
  }
}

class PasswordList extends StatelessWidget {
  const PasswordList(
      {Key key, @required this.onEntrySelected, this.selectedEntry})
      : super(key: key);

  static const routeSettings = RouteSettings(name: '/passwordList');

  static Route<void> route() => MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => PasswordList(
          onEntrySelected: (entry, type) {
            if (type == EntrySelectionType.activeOpen) {
              Navigator.of(context)
                  .push(EntryDetailsScreen.route(entry: entry));
            }
          },
        ),
      );

  final KdbxEntry selectedEntry;
  final void Function(KdbxEntry entry, EntrySelectionType type) onEntrySelected;

  @override
  Widget build(BuildContext context) {
    final kdbxBloc = Provider.of<KdbxBloc>(context);

    final streams =
        kdbxBloc.openedFilesKdbx.map((file) => file.dirtyObjectsChanged);
    if (streams.isEmpty) {
      Provider.of<Analytics>(context).events.trackPasswordListEmpty();
      return Container(
        color: Colors.white,
        alignment: Alignment.center,
        child: PrimaryButton(
          child: const Text('Open File'),
          onPressed: () {
            Navigator.of(context, rootNavigator: true)
                .pushAndRemoveUntil(SelectFileScreen.route(), (_) => false);
          },
        ),
      );
    }
    return StreamBuilder<bool>(
        stream: Rx.merge(streams).map((x) => true),
        builder: (context, snapshot) {
          return PasswordListContent(
            kdbxBloc: kdbxBloc,
            openedKdbxFiles: kdbxBloc.openedFilesKdbx,
            selectedEntry: selectedEntry,
            onEntrySelected: onEntrySelected,
          );
        });
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
    @required this.kdbxBloc,
    @required this.openedKdbxFiles,
    @required
        void Function(KdbxEntry entry, EntrySelectionType type) onEntrySelected,
    this.selectedEntry,
  })  : _onEntrySelected = onEntrySelected,
        super(key: key);

  final KdbxBloc kdbxBloc;
  final List<KdbxFile> openedKdbxFiles;
  bool get isAutofillSelector =>
      WidgetsBinding.instance.window.defaultRouteName == '/autofill';
  final void Function(KdbxEntry entry, EntrySelectionType type)
      _onEntrySelected;
  final KdbxEntry selectedEntry;

  void onEntrySelected(
      BuildContext context, KdbxEntry entry, EntrySelectionType type) {
    if (isAutofillSelector) {
      if (type == EntrySelectionType.activeOpen) {
        final cf = Provider.of<CommonFields>(context, listen: false);
        final username = entry.getString(cf.userName.key)?.getText();
        final password = entry.getString(cf.password.key)?.getText();
        AutofillService().resultWithDataset(
            label: entry.label, username: username, password: password);
        return;
      }
    }
    _onEntrySelected(entry, type);
    Provider.of<Analytics>(context, listen: false)
        .events
        .trackSelectEntry(type: type);
  }

  @override
  _PasswordListContentState createState() => _PasswordListContentState();
}

class PasswordListFilterIsolateRunner {
  static List<EntryViewModel> filterEntries(
      List<EntryViewModel> _allEntries, String query,
      {int maxResults = 30}) {
    _logger.info('We have to filter for $query');
    return _allEntries
        .where((entry) => matches(entry, query))
        // take no more than 30 for now.
        .take(maxResults)
        .toList(growable: false);
  }

  static final searchFields = [
    KdbxKey('Title'),
    KdbxKey('URL'),
    KdbxKey('UserName')
  ];

  static bool matches(EntryViewModel entry, String filterQuery) {
    final query = filterQuery.toLowerCase();
    return searchFields
            .where((field) =>
                entry.entry
                    .getString(field)
                    ?.getText()
                    ?.toLowerCase()
                    ?.contains(query) ==
                true)
            .isNotEmpty ||
        entry.groupNames
            .where((string) => string.toLowerCase().contains(query))
            .isNotEmpty;
  }
}

class GroupFilterEntry {
  const GroupFilterEntry({this.group, this.isRecursive});

  final KdbxGroup group;
  final bool isRecursive;
}

class GroupFilter {
  const GroupFilter({
    this.groups = const [],
    @required this.showRecycleBin,
    @required this.showActive,
    @required this.name,
  })  : assert(showRecycleBin != null),
        assert(showActive != null),
        assert(name != null);

  static const DEFAULT_GROUP_FILTER = GroupFilter(
      showRecycleBin: false, showActive: true, name: 'Hide Deleted Entries');
  static const RECYCLE_BIN = GroupFilter(
      showRecycleBin: true, showActive: false, name: 'Deleted Entries');

  final List<GroupFilterEntry> groups;

  /// show items which are in the recycle bins.
  final bool showRecycleBin;

  /// show items which are not in recycle bins.
  final bool showActive;

  /// Name to display.
  final String name;

  Iterable<KdbxEntry> getEntries(List<KdbxFile> files) {
    if (groups.isNotEmpty) {
      return groups.expand((g) {
        final groups = g.isRecursive ? g.group.getAllGroups() : [g.group];
        if (showRecycleBin && showActive) {
          return groups.expand((g) => g.entries);
        } else if (showActive) {
          return groups
              .where((g) => g.file.recycleBin != g)
              .expand((g) => g.entries);
        } else if (showRecycleBin) {
          return groups
              .where((g) => g.file.recycleBin == g)
              .expand((g) => g.entries);
        } else {
          throw StateError('Impossible. (showRecycleBin: $showRecycleBin,'
              'showActive: $showActive)');
        }
      });
    }
    return files.expand((f) {
      if (showRecycleBin && showActive) {
        return f.body.rootGroup.getAllEntries();
      } else {
        final recycleBin = f.recycleBin;
        if (showRecycleBin) {
          return recycleBin.entries;
        } else {
          return f.body.rootGroup
              .getAllGroups()
              .where((g) => g != recycleBin)
              .expand((e) => e.entries);
        }
      }
    });
  }
}

class _PasswordListContentState extends State<PasswordListContent>
    with StreamSubscriberMixin, WidgetsBindingObserver {
  List<EntryViewModel> _filteredEntries;
  String _filterQuery;
  final _filterTextEditingController = TextEditingController();
  final FocusNode _filterFocusNode = FocusNode();
  bool _speedDialOpen = false;
  final ValueNotifier<GroupFilter> _groupFilterNotifier =
      ValueNotifier(GroupFilter.DEFAULT_GROUP_FILTER);
  GroupFilter get _groupFilter => _groupFilterNotifier.value;

//  List<EntryViewModel> get _allEntries => _groupFilter == null
//      ? widget.entries
//      : _groupFilter
//          .getAllEntries()
//          .map((e) => EntryViewModel(e, widget.kdbxBloc))
//          .toList();
  List<EntryViewModel> _allEntries;

//  final _isolateRunner = IsolateRunner.spawn();

  @override
  void initState() {
    super.initState();
    _logger.finer('Initializing password list content.');
//    _isolateRunner.then((runner) => runner.run(PasswordListFilterIsolateRunner.init, widget.entries)).then((result) {
//      _logger.finer('Initializd filter isolate $result');
//    });
    WidgetsBinding.instance.addObserver(this);
    _updateAllEntries();
    _groupFilterNotifier.addListener(_updateAllEntries);
  }

  void _updateAllEntries() {
    final watch = Stopwatch()..start();
    final allEntries = _groupFilter
        .getEntries(widget.openedKdbxFiles)
        .map((e) => EntryViewModel(e, widget.kdbxBloc))
        .toList(growable: false);
    allEntries
        .sort((a, b) => a.label.toLowerCase().compareTo(b.label.toLowerCase()));
    _allEntries = allEntries;
    watch.stop();
    _logger.finer('Rebuilding PasswordList. ${watch.elapsedMilliseconds}ms');
    setState(() {});
  }

  @override
  void didUpdateWidget(PasswordListContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.openedKdbxFiles != widget.openedKdbxFiles) {
      _updateAllEntries();
    }
  }

  void _selectAllFilter() =>
      _filterTextEditingController.selection = TextSelection(
          baseOffset: 0,
          extentOffset: _filterTextEditingController.text.length);

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
            _filteredEntries = _allEntries;
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
    final entries = _filteredEntries ?? _allEntries;
    if (entries.isEmpty) {
      return;
    }
    final idx = entries.indexWhere((a) => a.entry == widget.selectedEntry);
    // right now we ignore the fact that the user might select a list item which is not in view.
    // https://github.com/flutter/flutter/issues/12319
    if (idx < 0) {
      widget.onEntrySelected(
          context, entries.first.entry, EntrySelectionType.passiveHighlight);
    } else {
      // new Index, modulo entry length to make sure we wrap around the end..
      final newIndex = (idx + next) % entries.length;
      widget.onEntrySelected(context, entries[newIndex].entry,
          EntrySelectionType.passiveHighlight);
    }
  }

  @override
  void dispose() {
    _logger.info('Disposing isolate runner.');
//    _isolateRunner.then<void>((runner) => runner.close());
    _filterFocusNode.dispose();
    WidgetsBinding.instance.removeObserver(this);
    _groupFilterNotifier.removeListener(_updateAllEntries);
    _groupFilterNotifier.dispose();
    super.dispose();
  }

  AppBar _buildDefaultAppBar(BuildContext context) {
    final kdbxBloc = Provider.of<KdbxBloc>(context);
    final isDirty = kdbxBloc.openedFiles.entries.any((element) =>
        element.key.supportsWrite &&
        element.value.kdbxFile.dirtyObjects.isNotEmpty);
    return AppBar(
      title: const Text('AuthPass'),
      actions: <Widget>[
        ...?!isDirty
            ? null
            : [
                Builder(
                  builder: (context) => IconButton(
                    icon: Icon(Icons.save),
                    onPressed: () async {
                      final scaffold = Scaffold.of(context);
                      final savedFiles = <String>[];
                      for (final entry in kdbxBloc.openedFiles.entries) {
                        if (entry.key.supportsWrite &&
                            entry.value.kdbxFile.dirtyObjects.isNotEmpty) {
                          await kdbxBloc.saveFile(entry.value.kdbxFile);
                          savedFiles.add(entry.key.displayName);
                        }
                      }
                      scaffold.showSnackBar(
                        SnackBar(
                            content: Text(
                                'Saved files into: ${savedFiles.join(', ')}')),
                      );
                    },
                  ),
                ),
              ],
//        IconButton(
//          icon: Icon(FontAwesomeIcons.sitemap),
//          onPressed: () async {
//            final groupFilter =
//                await Navigator.of(context).push(GroupList.route(null));
//            setState(() {
//              _groupFilter = groupFilter;
//              _filteredEntries = null;
//              _filterTextEditingController.text = '';
//            });
//          },
//        ),
        PopupMenuButton<VoidCallback>(
          icon: Icon(FontAwesomeIcons.filter),
          onSelected: (value) async {
            value();
            _logger.fine('onchanged - $value');
          },
          itemBuilder: (context) {
            final availableFilter = [
              GroupFilter.DEFAULT_GROUP_FILTER,
              GroupFilter.RECYCLE_BIN,
            ];
            if (!availableFilter.contains(_groupFilter)) {
              availableFilter.add(_groupFilter);
            }
            return <PopupMenuEntry<VoidCallback>>[
              ...availableFilter.map(
                (e) => CheckedPopupMenuItem<VoidCallback>(
                  value: () => _groupFilterNotifier.value = e,
                  checked: e == _groupFilter,
                  child: Text(e.name),
                ),
              ),
//              const Divider(),
              PopupMenuItem(
                child: ListTile(
                  leading: Icon(Icons.folder),
                  title: const Text('Customize …'),
                ),
                value: () async {
                  final groupFilter = await Navigator.of(context).push(
                      GroupListFlat.route(
                          _groupFilter.groups.map((e) => e.group).toSet()));
                  if (groupFilter == null) {
                    return;
                  }
                  if (groupFilter.isEmpty) {
                    _groupFilterNotifier.value =
                        GroupFilter.DEFAULT_GROUP_FILTER;
                  }
                  _createGroupFilter(groupFilter);
                },
              ),
            ];
          },
        ),
        IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              setState(() {
                _filteredEntries = _allEntries;
              });
            }),
        PopupMenuButton<VoidCallback>(
          onSelected: (item) {
            item();
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              child: ListTile(
                leading: Icon(Icons.category),
                title: const Text('Manage Groups'),
              ),
              value: () async {
                final group =
                    await Navigator.of(context).push(GroupList.route(null));
                if (group != null) {
                  _createGroupFilter({group});
                }
              },
            ),
            ...AuthPassAboutDialog.createDefaultPopupMenuItems(
                context, kdbxBloc.openedFiles),
            PopupMenuItem(
              value: () {
                Provider.of<Analytics>(context, listen: false)
                    .events
                    .trackActionPressed(action: 'lockFiles');
                Provider.of<KdbxBloc>(context, listen: false).closeAllFiles();
                Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                  SelectFileScreen.route(skipQuickUnlock: true),
                  (_) => false,
                );
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

  ThemeData filterAppBarTheme(BuildContext context) {
    final theme = Theme.of(context);
    if (theme.brightness == Brightness.light) {
      return theme.copyWith(
        primaryColor: Colors.white,
        primaryIconTheme: theme.primaryIconTheme.copyWith(color: Colors.grey),
//      primaryColorBrightness: Brightness.light,
        primaryTextTheme: theme.textTheme,
      );
    } else {
      return theme.copyWith(
        textSelectionColor: theme.colorScheme.secondary,
        textSelectionHandleColor: theme.colorScheme.secondary,
        //primaryColor: Colors.blue,
//        cursorColor: Colors.red,
        cursorColor: Colors.white,
      );
    }
  }

  AppBar _buildFilterAppBar(BuildContext context) {
    final theme = filterAppBarTheme(context);
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
      title: Theme(
        data: theme,
        child: TextField(
          style: theme.textTheme.headline6,
          // we also want the same cursorColor for mac/ios
          cursorColor: theme.cursorColor,
          focusNode: _filterFocusNode,
          controller: _filterTextEditingController,
          onChanged: (newQuery) async {
            _logger.info('query changed to $newQuery');
            final entries = PasswordListFilterIsolateRunner.filterEntries(
                _allEntries, newQuery);
            setState(() {
              _filterQuery = newQuery;
              _filteredEntries = entries;
              if (_filteredEntries.isNotEmpty &&
                  (widget.selectedEntry == null ||
                      !_filteredEntries.contains(widget.selectedEntry))) {
                widget.onEntrySelected(context, _filteredEntries.first.entry,
                    EntrySelectionType.passiveHighlight);
//                  // TODO this looks a bit like a workaround. But on MacOS we lose focus when
//                  //      we show another password entry.
//                  WidgetsBinding.instance.addPostFrameCallback((_) {
//                    _filterFocusNode.requestFocus();
//                  });
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
      ),
    );
  }

  List<Widget> _buildGroupFilterPrefix() {
    if (_groupFilter == GroupFilter.DEFAULT_GROUP_FILTER) {
      return null;
    }
    return [
      MaterialBanner(
        backgroundColor: Colors.lightGreenAccent.withOpacity(0.2),
        content: Text('${_groupFilter.name}'),
        actions: <Widget>[
          FlatButton(
            child: const Text('Clear'),
            onPressed: () {
              _groupFilterNotifier.value = GroupFilter.DEFAULT_GROUP_FILTER;
            },
          )
        ],
      ),
    ];
  }

  List<Widget> _buildAutofillListPrefix() {
    if (!widget.isAutofillSelector) {
      return null;
    }
    return const [
      Padding(
        padding: EdgeInsets.all(8.0),
        child: Card(
          color: Colors.lightGreen,
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Select password entry for autofill.'),
          ),
        ),
      ),
    ];
  }

  List<Widget> _buildListPrefix() {
    final kdbxBloc = Provider.of<KdbxBloc>(context);
    final unsupportedWrite = kdbxBloc.openedFilesWithSources.firstWhere(
      (f) => f.value.dirtyObjects.isNotEmpty && !f.key.supportsWrite,
      orElse: () => null,
    );
    if (unsupportedWrite == null) {
      return null;
    }
    return [UnsupportedWrite(source: unsupportedWrite.key)];
  }

  @override
  Widget build(BuildContext context) {
    final commonFields = Provider.of<CommonFields>(context);
    final entries = _filteredEntries ?? _allEntries;
    final listPrefix = [
      ...?_buildGroupFilterPrefix(),
      ...?_buildAutofillListPrefix(),
      ...?_buildListPrefix(),
    ];
    final theme = Theme.of(context);
    final kdbxBloc = Provider.of<KdbxBloc>(context);
    return Scaffold(
      appBar: _filteredEntries == null
          ? _buildDefaultAppBar(context)
          : _buildFilterAppBar(context),
      body: _allEntries.isEmpty
          ? NoPasswordsEmptyView(
              listPrefix: listPrefix,
              onPrimaryButtonPressed: () {
                final kdbxBloc = Provider.of<KdbxBloc>(context, listen: false);
                final entry = kdbxBloc.createEntry();
//                Navigator.of(context).push(EntryDetailsScreen.route(entry: entry));
                widget.onEntrySelected(
                    context, entry, EntrySelectionType.activeOpen);
              },
            )
          : Scrollbar(
              child: ListView.builder(
                itemCount: entries.length + (listPrefix != null ? 1 : 0),
                itemBuilder: (context, index) {
                  if (listPrefix != null) {
                    if (index == 0) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: listPrefix,
                      );
                    }
                    index--;
                  }
                  final entry = entries[index];

                  final openedFile = kdbxBloc.fileForKdbxFile(entry.entry.file);
                  final fileColor = openedFile.openedFile.color;
//                _logger.finer('listview item. selectedEntry: ${widget.selectedEntry}');
                  return Dismissible(
                    key: ValueKey(entry.entry.uuid),
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
                        await Clipboard.setData(ClipboardData(
                            text: entry.entry
                                .getString(commonFields.userName.key)
                                .getText()));
                        Scaffold.of(context).showSnackBar(
                            const SnackBar(content: Text('Copied userame.')));
                      } else {
//                      await ClipboardManager.copyToClipBoard(entry.getString(commonFields.password.key).getText());
                        await Clipboard.setData(ClipboardData(
                            text: entry.entry
                                .getString(commonFields.password.key)
                                .getText()));
                        Scaffold.of(context).showSnackBar(
                            const SnackBar(content: Text('Copied password.')));
                      }
                      return false;
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Container(
                        decoration: widget.selectedEntry != entry.entry
                            ? (fileColor == null
                                ? null
                                : BoxDecoration(
                                    border: Border(
                                        left: BorderSide(
                                            color: fileColor, width: 4))))
                            : BoxDecoration(
                                color: Theme.of(context).selectedRowColor,
                                border: Border(
                                  right: BorderSide(
                                      color: Theme.of(context).primaryColor,
                                      width: 4),
                                  left: fileColor == null
                                      ? BorderSide.none
                                      : BorderSide(color: fileColor, width: 4),
                                ),
                              ),
                        child: PasswordEntryTile(
                          vm: entry,
                          isSelected: entry.entry == widget.selectedEntry,
                          filterQuery: _filterQuery,
                          onTap: () {
//                      Navigator.of(context).push(EntryDetailsScreen.route(entry: entry));
                            widget.onEntrySelected(context, entry.entry,
                                EntrySelectionType.activeOpen);
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: _allEntries.isEmpty || _filterQuery != null
          ? null
          : kdbxBloc.openedFiles.length == 1
              ? FloatingActionButton(
                  child: Icon(Icons.add),
                  onPressed: () {
                    final entry = kdbxBloc.createEntry();
                    widget.onEntrySelected(
                        context, entry, EntrySelectionType.activeOpen);
                  },
                )
              : SpeedDial(
                  child: Icon(_speedDialOpen ? Icons.close : Icons.add),
                  onOpen: () => setState(() => _speedDialOpen = true),
                  onClose: () => setState(() => _speedDialOpen = false),
                  overlayColor: theme.brightness == Brightness.dark
                      ? Colors.black
                      : Colors.white,
                  children: kdbxBloc.openedFiles.values
                      .map(
                        (file) => SpeedDialChild(
                            label: file.fileSource.displayName,
                            child: Icon(file.fileSource.displayIcon),
                            labelBackgroundColor: Theme.of(context).cardColor,
                            backgroundColor: file.openedFile.colorCode == null
                                ? null
                                : Color(file.openedFile.colorCode),
                            onTap: () {
                              final entry = kdbxBloc.createEntry(file.kdbxFile);
                              widget.onEntrySelected(context, entry,
                                  EntrySelectionType.activeOpen);
                            }),
                      )
                      .toList(),
                ),
    );
  }

  void _createGroupFilter(Set<KdbxGroup> groupFilter) {
    final name = groupFilter.length == 1
        ? 'Group: ${groupFilter.first.name.get()}'
        : 'Custom Filter (${groupFilter.length} Groups)';
    _groupFilterNotifier.value = GroupFilter(
      groups: groupFilter
          .map((g) => GroupFilterEntry(group: g, isRecursive: true))
          .toList(),
      showRecycleBin: true,
      showActive: true,
      name: name,
    );
    _filteredEntries = null;
    _filterTextEditingController.text = '';
  }
}

class NoPasswordsEmptyView extends StatelessWidget {
  const NoPasswordsEmptyView({
    Key key,
    this.onPrimaryButtonPressed,
    this.listPrefix,
  }) : super(key: key);

  final List<Widget> listPrefix;
  final VoidCallback onPrimaryButtonPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        ...?listPrefix,
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Align(
              alignment: const Alignment(0, -0.7),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Text('🤗️', style: TextStyle(fontSize: 64)),
                  const SizedBox(height: 16),
                  const Text(
                    'You do not have any password in your database yet.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  PrimaryButton(
                    child: const Text('Add Password'),
                    onPressed: onPrimaryButtonPressed,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
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

class PasswordEntryTile extends StatelessWidget {
  const PasswordEntryTile({
    Key key,
    @required this.vm,
    @required this.isSelected,
    @required this.filterQuery,
    this.onTap,
  }) : super(key: key);

  final EntryViewModel vm;
  final bool isSelected;
  final String filterQuery;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final commonFields = Provider.of<CommonFields>(context);
    final theme = Theme.of(context);
    final isDarkTheme = theme.brightness == Brightness.dark;
    final fgColor = isSelected
        ? isDarkTheme ? theme.primaryColorLight : theme.primaryColorDark
        : null;
    return InkWell(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
            child: Icon(
              PredefinedIcons.iconFor(vm.entry.icon.get()),
              color: fgColor ?? ThemeUtil.iconColor(theme, vm.fileColor),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  DefaultTextStyle(
                    style: theme.textTheme.subtitle1.copyWith(
                        fontWeight: FontWeight.normal, color: fgColor),
                    child: Text.rich(
                      _highlightFilterQuery(commonFields.title
                              .stringValue(vm.entry)
                              ?.nullIfBlank()) ??
                          const TextSpan(text: '(no title)'),
//                      style: theme.textTheme.subtitle1.copyWith(fontWeight: null),
                    ),
                  ),
                  const SizedBox(height: 2),
                  DefaultTextStyle(
                    style: theme.textTheme.bodyText1.copyWith(
                        fontSize: 13,
                        color: fgColor ?? theme.textTheme.caption.color),
                    child: Text.rich(
                      _highlightFilterQuery(
                            commonFields.userName
                                .stringValue(vm.entry)
                                ?.nullIfBlank(),
                          ) ??
                          const TextSpan(text: '(no username)'),
                      style: theme.textTheme.bodyText1.copyWith(
                          fontSize: 12, color: theme.textTheme.caption.color),
                    ),
                  ),
                  ...?vm.groupNames.length < 2
                      ? null
                      : [
                          Text(
                            '📁️  ' + vm.groupNames.sublist(1).join(' » '),
                            overflow: TextOverflow.fade,
                            maxLines: 1,
                            textAlign: TextAlign.right,
                            style:
                                theme.textTheme.caption.copyWith(fontSize: 10),
                          ),
                        ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  InlineSpan _highlightFilterQuery(String text) {
    if (text == null) {
      return null;
    }
    if (filterQuery == null || filterQuery.isEmpty) {
      return TextSpan(text: text);
    }
    final lcText = text.toLowerCase();
    final lcFilterQuery = filterQuery.toLowerCase();
    //RegExp.escape(text).allMatches(string)
    var previousMatchEnd = 0;
    final spans = <TextSpan>[];
    for (final match in lcFilterQuery.allMatches(lcText)) {
      spans.add(TextSpan(text: text.substring(previousMatchEnd, match.start)));
      spans.add(TextSpan(
          text: text.substring(match.start, match.end),
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)));
      previousMatchEnd = match.end;
    }
    if (previousMatchEnd < text.length) {
      spans.add(TextSpan(text: text.substring(previousMatchEnd)));
    }
    return TextSpan(children: spans);
  }
}
