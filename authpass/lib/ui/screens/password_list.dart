import 'dart:async';
import 'dart:collection';

import 'package:authpass/bloc/analytics.dart';
import 'package:authpass/bloc/app_data.dart';
import 'package:authpass/bloc/authpass_cloud_bloc.dart';
import 'package:authpass/bloc/kdbx/file_source.dart';
import 'package:authpass/bloc/kdbx/file_source_local.dart';
import 'package:authpass/bloc/kdbx/file_source_ui.dart';
import 'package:authpass/bloc/kdbx_bloc.dart';
import 'package:authpass/env/_base.dart';
import 'package:authpass/l10n/app_localizations.dart';
import 'package:authpass/ui/common_fields.dart';
import 'package:authpass/ui/screens/app_bar_menu.dart';
import 'package:authpass/ui/screens/cloud/cloud_auth.dart';
import 'package:authpass/ui/screens/cloud/cloud_mailbox.dart';
import 'package:authpass/ui/screens/entry_details.dart';
import 'package:authpass/ui/screens/group_list.dart';
import 'package:authpass/ui/screens/locked_screen.dart';
import 'package:authpass/ui/screens/password_list_drawer.dart';
import 'package:authpass/ui/screens/select_file_screen.dart';
import 'package:authpass/ui/widgets/backup_warning_banner.dart';
import 'package:authpass/ui/widgets/keyboard_handler.dart';
import 'package:authpass/ui/widgets/primary_button.dart';
import 'package:authpass/ui/widgets/savefile/save_file_diag_button.dart';
import 'package:authpass/utils/cache_manager.dart';
import 'package:authpass/utils/extension_methods.dart';
import 'package:authpass/utils/format_utils.dart';
import 'package:authpass/utils/predefined_icons.dart';
import 'package:authpass/utils/theme_utils.dart';
import 'package:autofill_service/autofill_service.dart';
import 'package:badges/badges.dart';
import 'package:built_collection/built_collection.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:diac_client/diac_client.dart';
import 'package:flinq/flinq.dart';
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

class EntryViewModel implements Comparable<EntryViewModel> {
  EntryViewModel(this.entry, this.kdbxBloc)
      : label = entry.label,
        _labelComparable = entry.label?.toLowerCase() ?? '',
        groupNames = _createGroupNames(entry.parent),
        fileColor = kdbxBloc.fileForKdbxFile(entry.file).openedFile.color;

  static const websiteKey = KdbxKeyCommon.URL;

  final KdbxBloc kdbxBloc;
  final KdbxEntry entry;
  String _website;

  String get website => _website ??= _normalizeUrl();
  final String label;
  final String _labelComparable;
  final List<String> groupNames;
  final Color fileColor;

  static List<String> _createGroupNames(KdbxGroup group) =>
      group.breadcrumbs.map((e) => e.name.get()).toList();

  String _normalizeUrl() {
    final url = entry.getString(websiteKey)?.getText()?.trim();
    if (url == null || url.isEmpty) {
      return null;
    }
    try {
      var urlToParse = url;
      if (!url.contains('//')) {
        urlToParse = 'http://$url'; // NON-NLS
      }
      final parsed = Uri.parse(urlToParse);
      var ret = parsed;
      if (!parsed.hasScheme) {
        ret = parsed.replace(scheme: 'https'); // NON-NLS
      }
      final resolved = ret.resolve('/'); // NON-NLS
//      _logger
//          .finer('url $url ($parsed) with scheme $ret resolved to $resolved');
      return resolved.toString();
    } catch (e) {
      return null;
    }
  }

  @override
  int compareTo(EntryViewModel other) {
    if (entry == other.entry) {
      return 0;
    }
    return _labelComparable
        .compareTo(other._labelComparable)
        .unlessZero(() => entry.uuid.uuid.compareTo(other.entry.uuid.uuid));
  }
}

extension on int {
  int unlessZero(int Function() cb) => this == 0 ? cb() : this;
}

class PasswordList extends StatelessWidget {
  const PasswordList(
      {Key key, @required this.onEntrySelected, this.selectedEntry})
      : super(key: key);

  static const routeSettings = RouteSettings(name: '/passwordList');

  static Widget phonePasswordList(BuildContext context) {
    return PasswordList(
      onEntrySelected: (entry, type) {
        if (type == EntrySelectionType.activeOpen) {
          Navigator.of(context).push(EntryDetailsScreen.route(entry: entry));
        }
      },
    );
  }

  static Route<void> route() => MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => phonePasswordList(context),
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
      final loc = AppLocalizations.of(context);
      return Container(
        color: Colors.white,
        alignment: Alignment.center,
        child: PrimaryButton(
          child: Text(loc.openFile),
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
        // not sure if this actually works.
        context?.read<Analytics>()?.events?.trackAutofillSelect();
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
    final terms = query.toLowerCase().split(' ');
    return _allEntries
        .where((entry) => matches(entry, terms))
        // take no more than 30 for now.
        .take(maxResults)
        .toList(growable: false);
  }

  static final searchFields = [
    KdbxKeyCommon.TITLE,
    KdbxKeyCommon.URL,
    KdbxKeyCommon.USER_NAME,
  ];

  static bool matches(EntryViewModel entry, List<String> filterTerms) {
    for (final term in filterTerms) {
      if (searchFields
              .where((field) =>
                  entry.entry
                      .getString(field)
                      ?.getText()
                      ?.toLowerCase()
                      ?.contains(term) ==
                  true)
              .isEmpty &&
          entry.groupNames
              .where((string) => string.toLowerCase().contains(term))
              .isEmpty) {
        return false;
      }
    }
    return true;
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
        assert(name != null),
        assert(groups != null);

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
      return groups.expand((groupSelected) {
        final groups = groupSelected.isRecursive
            ? groupSelected.group.getAllGroups()
            : [groupSelected.group];
        if (showRecycleBin && showActive) {
          return groups.expand((g) => g.entries);
        } else if (showActive) {
          return groups
              .where((g) => g == groupSelected.group || g.file.recycleBin != g)
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
          return recycleBin?.entries ?? [];
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
    with StreamSubscriberMixin, WidgetsBindingObserver, FutureTaskStateMixin {
  List<EntryViewModel> _filteredEntries;
  String _filterQuery;
  final _filterTextEditingController = TextEditingController();
  final FocusNode _filterFocusNode = FocusNode();
  bool _speedDialOpen = false;
  final ValueNotifier<GroupFilter> _groupFilterNotifier =
      ValueNotifier(GroupFilter.DEFAULT_GROUP_FILTER);

  GroupFilter get _groupFilter => _groupFilterNotifier.value;

  StreamSubscription<AppData> _appDataStream;

//  List<EntryViewModel> get _allEntries => _groupFilter == null
//      ? widget.entries
//      : _groupFilter
//          .getAllEntries()
//          .map((e) => EntryViewModel(e, widget.kdbxBloc))
//          .toList();
  List<EntryViewModel> _allEntries;

  /// on android while requesting autofill.
  AutofillMetadata _autofillMetadata;

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
    _updateAutofillMetadata();
    _subscribetoAppData();
  }

  void _subscribetoAppData() {
    _appDataStream = Provider.of<AppDataBloc>(context, listen: false)
        .store
        .onValueChangedAndLoad
        .listen(_updateDismissedFiles);
  }

  void _updateDismissedFiles(AppData data) {
    _dismissedLocalFilesReady = true;
    setState(() {
      _dismissedLocalFiles = data.dismissedBackupLocalFiles;
    });
  }

  void _updateAutofillMetadata() {
    if (widget.isAutofillSelector) {
      AutofillService().getAutofillMetadata().then((value) {
        if (_autofillMetadata == value || !mounted) {
          return;
        }
        setState(() {
          _autofillMetadata = value;
        });
        final val = value?.searchTerm?.let((term) {
              _filterTextEditingController.text = term;
              _filterTextEditingController.selection =
                  TextSelection(baseOffset: 0, extentOffset: term.length);
              return _updateFilterQuery(term);
            }) ??
            0;
        context?.read<Analytics>()?.events?.trackAutofillFilter(
              filter: '${value?.searchTerm?.isNotEmpty}',
              value: val,
            );
      });
    }
  }

  void _updateAllEntries() {
    final watch = Stopwatch()..start();
    final allEntries = SplayTreeSet<EntryViewModel>.from(
        _groupFilter
            .getEntries(widget.openedKdbxFiles)
            .map<EntryViewModel>((e) => EntryViewModel(e, widget.kdbxBloc)),
        (EntryViewModel a, EntryViewModel b) => a.compareTo(b));
//    final allEntries = _groupFilter
//        .getEntries(widget.openedKdbxFiles)
//        .map((e) => EntryViewModel(e, widget.kdbxBloc))
//        .toSet()
//        .toList(growable: false);
//    allEntries
//        .sort((a, b) => a.label.toLowerCase().compareTo(b.label.toLowerCase()));
    _allEntries = allEntries.toList(growable: false);
    watch.stop();
    _logger.finer('Rebuilding PasswordList. (${_allEntries.length} entries)'
        ' ${watch.elapsedMilliseconds}ms');
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
        if (!_isFocusInForeignTextField()) {
          _selectNextEntry(-1);
        }
      } else if (event.type == KeyboardShortcutType.moveDown) {
        if (!_isFocusInForeignTextField()) {
          _selectNextEntry(1);
        }
      } else if (event.type == KeyboardShortcutType.escape) {
        if (!_isFocusInForeignTextField()) {
          _cancelFilter();
        }
      }
    }));
  }

  bool _isFocusInForeignTextField() {
    final widget =
        WidgetsBinding.instance.focusManager.primaryFocus?.context?.widget;
    if (widget == null) {
      return false;
    }
    if (widget is EditableText) {
      if (widget.controller == _filterTextEditingController) {
        return false;
      }
      return true;
    }
    return false;
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
    _appDataStream.cancel();
    super.dispose();
  }

  AppBar _buildDefaultAppBar(BuildContext context) {
    final kdbxBloc = Provider.of<KdbxBloc>(context);
    final isDirty = kdbxBloc.openedFiles.entries.any((element) =>
        element.key.supportsWrite &&
        element.value.kdbxFile.dirtyObjects.isNotEmpty);
    final loc = AppLocalizations.of(context);
    return AppBar(
      title: const Text('AuthPass'), // NON-NLS
      actions: <Widget>[
        ...?!isDirty
            ? null
            : [
                Builder(
                  builder: (context) => IconButton(
                    icon: const Icon(Icons.save),
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
                          content: Text(loc.savedFiles(savedFiles.length,
                              savedFiles.join(Nls.COMMA_SPACE))),
                        ),
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
          icon: const Icon(FontAwesomeIcons.filter),
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
                  leading: const Icon(Icons.folder),
                  title: Text(loc.filterCustomize),
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
                    return;
                  }
                  _createGroupFilter(groupFilter);
                },
              ),
            ];
          },
        ),
        IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              setState(() {
                _filteredEntries = _allEntries;
              });
            }),
        StreamBuilder<CloudStatus>(
          stream: context.watch<AuthPassCloudBloc>().cloudStatus,
          initialData: null,
          builder: (context, cloudStatusSnapshot) => Badge(
            badgeContent: cloudStatusSnapshot.hasData &&
                    cloudStatusSnapshot.data.messagesUnread > 0
                ? Text('x${cloudStatusSnapshot.data.messagesUnread}',
                    style: const TextStyle(color: Colors.white))
                : null,
            showBadge: cloudStatusSnapshot.hasData &&
                cloudStatusSnapshot.data.messagesUnread > 0,
            badgeColor: Theme.of(context).primaryColorDark,
            position: BadgePosition.topEnd(top: 0, end: 3),
            child: PopupMenuButton<VoidCallback>(
              key: const ValueKey('appBarOverflowMenu'),
              onSelected: (item) {
                item();
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: ListTile(
                    leading: const Icon(Icons.category),
                    title: Text(loc.manageGroups),
                  ),
                  value: () async {
                    await Navigator.of(context).push(GroupListFlat.route(
                      {},
                      groupListMode: GroupListMode.manage,
                    ));
//                if (group != null) {
//                  _createGroupFilter({group});
//                }
                  },
                ),
                ...?_buildAuthPassCloudMenuItems(
                    context, cloudStatusSnapshot.data),
                ...AppBarMenu.createDefaultPopupMenuItems(
                    context, kdbxBloc.openedFiles),
                PopupMenuItem(
                  value: () {
                    Provider.of<Analytics>(context, listen: false)
                        .events
                        .trackActionPressed(action: 'lockFiles');
                    Provider.of<KdbxBloc>(context, listen: false)
                        .closeAllFiles(clearQuickUnlock: false);
                    Navigator.of(context, rootNavigator: true)
                        .pushAndRemoveUntil(
                      LockedScreen.route(),
                      (_) => false,
                    );
                  },
                  child: ListTile(
                    leading: const Icon(Icons.exit_to_app),
                    title: Text(loc.lockFiles),
                  ),
                ),
              ],
            ),
          ),
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

  void _cancelFilter() {
    setState(() {
      _filterQuery = null;
      _filteredEntries = null;
    });
  }

  AppBar _buildFilterAppBar(BuildContext context) {
    final theme = filterAppBarTheme(context);
    final loc = AppLocalizations.of(context);
    return AppBar(
      backgroundColor: theme.primaryColor,
      iconTheme: theme.primaryIconTheme,
      textTheme: theme.primaryTextTheme,
      brightness: theme.primaryColorBrightness,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          _cancelFilter();
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
            _updateFilterQuery(newQuery);
          },
          autofocus: true,
          decoration: InputDecoration(
            hintText: loc.searchHint,
            border: InputBorder.none,
            hintStyle: theme.inputDecorationTheme.hintStyle,
          ),
        ),
      ),
    );
  }

  int _updateFilterQuery(String newQuery) {
    final entries =
        PasswordListFilterIsolateRunner.filterEntries(_allEntries, newQuery);
    if (!mounted) {
      _logger.severe('No longer mounted after updating filter query.', null,
          StackTrace.current);
      return 0;
    }
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
    return entries.length;
  }

  List<Widget> _buildGroupFilterPrefix() {
    if (_groupFilter == GroupFilter.DEFAULT_GROUP_FILTER) {
      return null;
    }
    final loc = AppLocalizations.of(context);
    return [
      MaterialBanner(
        backgroundColor: Colors.lightGreenAccent.withOpacity(0.2),
        content: Text('${_groupFilter.name}'),
        actions: <Widget>[
          FlatButton(
            child: Text(loc.clear),
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
      _logger.info(
          'not autofill: ${WidgetsBinding.instance.window.defaultRouteName}');
      return null;
    }
    final loc = AppLocalizations.of(context);

    final info = _autofillMetadata?.let((metadata) {
      final searchTerm = metadata.searchTerm;
      if (searchTerm != null && searchTerm == _filterQuery) {
        return [
          TextSpan(text: Nls.NL + loc.autofillFilterPrefix + Nls.SP),
          TextSpan(
              text: searchTerm,
              style: const TextStyle(fontWeight: FontWeight.bold)),
        ];
      }
    });
    return [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          color: Colors.lightGreen,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text.rich(
              TextSpan(
                text: loc.autofillPrompt,
                children: info,
              ),
              textAlign: TextAlign.center,
            ),
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

  BuiltList<String> _dismissedLocalFiles;
  bool _dismissedLocalFilesReady = false;

  List<Widget> _buildBackupWarningBanners() {
    final kdbxBloc = context.watch<KdbxBloc>();
    final loc = AppLocalizations.of(context);
    final localFiles =
        kdbxBloc.openedFilesWithSources.where((e) => e.key is FileSourceLocal);
    final localFiles3 = localFiles
        .where((file) =>
            file.value.body.rootGroup
                .getAllGroups()
                .where((element) => element != file.value.recycleBin)
                .expand((element) => element.getAllEntries())
                .length >=
            3)
        .where((element) =>
            !(_dismissedLocalFiles?.contains(element.key.uuid) ?? false));
    if (localFiles3.isNotEmpty && _dismissedLocalFilesReady) {
      final file = localFiles3.first;
      final analytics = context.watch<Analytics>();
      analytics.events.trackBackupBanner(BackupBannerAction.shown);
      return [
        BackupBanner(
          loc.backupWarningMessage(file.key.displayName),
          backupWidget: SaveFileAsDialogButton(
            file: kdbxBloc.fileForFileSource(file.key),
            child: Text(loc.backupButton),
            onSave: (saveFuture) {
              asyncRunTask((progress) async {
                analytics.events.trackBackupBanner(BackupBannerAction.saved);
                await saveFuture;
              }, label: loc.saving);
            },
          ),
          dismissText: loc.dismissBackupButton,
          onDismiss: () {
            analytics.events.trackBackupBanner(BackupBannerAction.dismissed);
            context.read<AppDataBloc>().update((builder, data) =>
                builder.dismissedBackupLocalFiles =
                    data.dismissedBackupLocalFiles?.toBuilder() ??
                        BuiltList<String>().toBuilder()
                      ..add(file.key.uuid));
          },
        ),
      ];
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final commonFields = Provider.of<CommonFields>(context);
    final entries = _filteredEntries ?? _allEntries;
    final listPrefix = [
      ...?_buildBackupWarningBanners(),
      ...?_buildGroupFilterPrefix(),
      ...?_buildAutofillListPrefix(),
      ...?_buildListPrefix(),
    ];
    if (listPrefix.isEmpty) {
      listPrefix.add(DiacMaterialBanner(
        diac: Provider.of<DiacBloc>(context),
      ));
    }

    final theme = Theme.of(context);
    final kdbxBloc = Provider.of<KdbxBloc>(context);
    final loc = AppLocalizations.of(context);
    return Scaffold(
      appBar: _filteredEntries == null
          ? _buildDefaultAppBar(context)
          : _buildFilterAppBar(context),
      drawer: Drawer(
        child: PasswordListDrawer(
          initialSelection: _groupFilter.groups.map((e) => e.group).toSet(),
          selectionChanged: (Set<KdbxGroup> selection) {
            _createGroupFilter(selection);
          },
        ),
      ),
      body: ProgressOverlay(
        task: task,
        child: _allEntries.isEmpty
            ? NoPasswordsEmptyView(
                listPrefix: listPrefix,
                onPrimaryButtonPressed: () {
                  final kdbxBloc =
                      Provider.of<KdbxBloc>(context, listen: false);
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

                    final openedFile =
                        kdbxBloc.fileForKdbxFile(entry.entry.file);
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
                            const Icon(Icons.lock),
                            const SizedBox(height: 4),
                            Text(loc.swipeCopyPassword),
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
                            const Icon(Icons.account_circle),
                            const SizedBox(height: 4),
                            Text(loc.swipeCopyUsername),
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
                              SnackBar(content: Text(loc.doneCopiedUsername)));
                          context
                              .read<Analytics>()
                              .events
                              .trackSwipeCopyUsername();
                        } else {
//                      await ClipboardManager.copyToClipBoard(entry.getString(commonFields.password.key).getText());
                          await Clipboard.setData(ClipboardData(
                              text: entry.entry
                                  .getString(commonFields.password.key)
                                  .getText()));
                          Scaffold.of(context).showSnackBar(
                              SnackBar(content: Text(loc.doneCopiedPassword)));
                          context
                              .read<Analytics>()
                              .events
                              .trackSwipeCopyPassword();
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
                                        : BorderSide(
                                            color: fileColor, width: 4),
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
      ),
      floatingActionButton: _allEntries.isEmpty ||
              _filterQuery != null ||
              _autofillMetadata != null
          ? null
          : kdbxBloc.openedFiles.length == 1 || _groupFilter.groups.length == 1
              ? FloatingActionButton(
                  child: const Icon(Icons.add),
                  onPressed: () {
                    final group = _groupFilter.groups.isEmpty
                        ? null
                        : _groupFilter.groups.first.group;
                    final entry = kdbxBloc.createEntry(
                      file: group?.file,
                      group: group,
                    );
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
                            child: Icon(file.fileSource.displayIcon.iconData),
                            labelBackgroundColor: Theme.of(context).cardColor,
                            backgroundColor: file.openedFile.colorCode == null
                                ? null
                                : Color(file.openedFile.colorCode),
                            onTap: () {
                              final entry =
                                  kdbxBloc.createEntry(file: file.kdbxFile);
                              widget.onEntrySelected(context, entry,
                                  EntrySelectionType.activeOpen);
                            }),
                      )
                      .toList(),
                ),
    );
  }

  void _createGroupFilter(Set<KdbxGroup> groupFilter) {
    if (groupFilter.isEmpty) {
      _groupFilterNotifier.value = GroupFilter.DEFAULT_GROUP_FILTER;
      return;
    }
    final name = groupFilter.length == 1
        ? 'Group: ${groupFilter.first.name.get()}'
        : 'Custom Filter (${groupFilter.length} Groups)';
    _groupFilterNotifier.value = GroupFilter(
      groups: groupFilter
          .map((g) => GroupFilterEntry(group: g, isRecursive: true))
          .toList(),
      showRecycleBin: false,
      showActive: true,
      name: name,
    );
    _filteredEntries = null;
    _filterTextEditingController.text = '';
  }

  List<PopupMenuItem<VoidCallback>> _buildAuthPassCloudMenuItems(
      BuildContext context, CloudStatus cloudStatus) {
    final bloc = context.read<AuthPassCloudBloc>();
    if (bloc?.featureFlags?.authpassCloud != true) {
      return null;
    }
    if (bloc.tokenStatus == TokenStatus.confirmed) {
      return [
        PopupMenuItem(
          child: ListTile(
            leading: Badge(
              badgeContent:
                  cloudStatus != null && cloudStatus.messagesUnread > 0
                      ? Text(
                          cloudStatus.messagesUnread.toString(),
                          style: TextStyle(
                              color: Theme.of(context)
                                  .primaryTextTheme
                                  .bodyText1
                                  .color),
                        )
                      : null,
              showBadge: cloudStatus != null && cloudStatus.messagesUnread > 0,
              badgeColor: Theme.of(context).primaryColor,
              child: const Icon(Icons.cloud),
            ),
            title: const Text('AuthPass Mailboxes'),
          ),
          value: () {
            Navigator.of(context, rootNavigator: true)
                .push(CloudMailboxTabScreen.route());
          },
        )
      ];
    } else {
      return [
        PopupMenuItem(
          child: const ListTile(
            leading: Icon(Icons.cloud),
            title: Text('Authenticate with AuthPass Cloud'),
          ),
          value: () {
            Navigator.of(context, rootNavigator: true)
                .push(AuthPassCloudAuthScreen.route());
          },
        )
      ];
    }
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
    final loc = AppLocalizations.of(context);
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
                  const Text(
                    '🤗️', // NON-NLS
                    style: TextStyle(fontSize: 64),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    loc.emptyPasswordVaultPlaceholder,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  PrimaryButton(
                    child: Text(loc.emptyPasswordVaultButtonLabel),
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
        color: theme.errorColor.withOpacity(0.2),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: <Widget>[
              Icon(Icons.warning, color: theme.errorColor),
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
                            final bloc =
                                Provider.of<KdbxBloc>(context, listen: false);
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

  Widget _defaultIcon(Color fgColor, ThemeData theme, double size) =>
      EntryIcon.defaultIcon(vm, fgColor, theme, size);

  @override
  Widget build(BuildContext context) {
    final commonFields = Provider.of<CommonFields>(context);
    final theme = Theme.of(context);
    final isDarkTheme = theme.brightness == Brightness.dark;
    final fgColor = isSelected
        ? isDarkTheme
            ? theme.primaryColorLight
            : theme.primaryColorDark
        : null;
    final iconTheme = IconTheme.of(context);
    final size = iconTheme.size * 1.5;
    final loc = AppLocalizations.of(context);
    _logger
        .info('devicePixelRatio: ${MediaQuery.of(context).devicePixelRatio}');

    final icon = EntryIcon(
      vm: vm,
      size: size,
      fallback: (context) => _defaultIcon(fgColor, theme, size),
    );

    return InkWell(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
            child: icon,
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
                      _highlightFilterQuery(vm.label?.nullIfBlank()) ??
                          TextSpan(text: loc.noTitle),
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
                          TextSpan(text: loc.noUsername),
                      style: theme.textTheme.bodyText1.copyWith(
                          fontSize: 12, color: theme.textTheme.caption.color),
                    ),
                  ),
                  ...?vm.groupNames.length < 2
                      ? null
                      : [
                          Text(
                            '📁️  ' +
                                vm.groupNames.sublist(1).join(' » '), // NON-NLS
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
    final lcFilterTerms = filterQuery.toLowerCase().split(' ');
    final filterRegexp =
        RegExp(lcFilterTerms.map((e) => RegExp.escape(e)).join('|'));
    var previousMatchEnd = 0;
    final spans = <TextSpan>[];
    for (final match in filterRegexp.allMatches(lcText)) {
      spans.add(TextSpan(text: text.substring(previousMatchEnd, match.start)));
      spans.add(TextSpan(
          text: text.substring(match.start, match.end),
          style: const TextStyle(
              fontWeight: FontWeight.bold, color: Colors.green)));
      previousMatchEnd = match.end;
    }
    if (previousMatchEnd < text.length) {
      spans.add(TextSpan(text: text.substring(previousMatchEnd)));
    }
    return TextSpan(children: spans);
  }
}

class EntryIcon extends StatelessWidget {
  const EntryIcon({
    Key key,
    @required this.vm,
    @required this.fallback,
    @required this.size,
  })  : assert(vm != null),
        assert(fallback != null),
        assert(size != null),
        super(key: key);

  final EntryViewModel vm;
  final double size;
  final Widget Function(BuildContext context) fallback;

  @override
  Widget build(BuildContext context) {
    final env = context.watch<Env>();
    final appData = context.watch<AppData>();
    if (!env.featureFetchWebsiteIconEnabledByDefault &&
        !appData.fetchWebsiteIconsOrDefault) {
      return fallback(context);
    }

    final url = vm.website;

    if (url == null) {
      return fallback(context);
    }

    return CachedNetworkImage(
      cacheManager: context.watch<AuthPassCacheManager>(),
      width: size,
      height: size,
      imageUrl: Uri.parse('https://cloud.authpass.app/website/image')
          .replace(queryParameters: <String, String>{'url': url}).toString(),
      errorWidget: (context, _, dynamic __) {
        return fallback(context);
      },
    );
  }

  static Widget defaultIcon(
    EntryViewModel vm,
    Color fgColor,
    ThemeData theme,
    double size,
  ) {
    return vm.entry.customIcon?.let((customIcon) => Image.memory(
              customIcon.data,
              width: size,
              height: size,
              fit: BoxFit.contain,
            )) ??
        Icon(
          PredefinedIcons.iconFor(vm.entry.icon.get()),
          color: fgColor ?? ThemeUtil.iconColor(theme, vm.fileColor),
          size: size,
        );
  }
}

extension on AutofillMetadata {
  String get searchTerm =>
      webDomains
          ?.where((element) => element.domain.isNotEmpty)
          ?.firstOrNull
          ?.domain ??
      packageNames
          .where((element) => element != 'android' // NON-NLS
              )
          .firstOrNull;
}
