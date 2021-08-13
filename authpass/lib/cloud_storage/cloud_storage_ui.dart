import 'package:authpass/bloc/analytics.dart';
import 'package:authpass/bloc/app_data.dart';
import 'package:authpass/bloc/kdbx/file_source_cloud_storage.dart';
import 'package:authpass/cloud_storage/authpasscloud/authpass_cloud_provider.dart';
import 'package:authpass/cloud_storage/cloud_storage_provider.dart';
import 'package:authpass/cloud_storage/cloud_storage_ui_auth.dart';
import 'package:authpass/cloud_storage/cloud_storage_ui_authpass_cloud.dart';
import 'package:authpass/env/_base.dart';
import 'package:authpass/ui/screens/create_file.dart';
import 'package:authpass/ui/screens/select_file_screen.dart';
import 'package:authpass/ui/widgets/link_button.dart';
import 'package:authpass/utils/constants.dart';
import 'package:authpass/utils/dialog_utils.dart';
import 'package:authpass/utils/extension_methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_async_utils/flutter_async_utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

final _logger = Logger('authpass.cloud_storage_ui');

class CloudStorageSelector extends StatefulWidget {
  const CloudStorageSelector(
      {Key? key, required this.provider, this.browserConfig})
      : super(key: key);

  final CloudStorageProvider provider;
  final CloudStorageSelectorConfig? browserConfig;

  @override
  _CloudStorageSelectorState createState() => _CloudStorageSelectorState();

  static Route<T> route<T extends CloudStorageSelectorResult>(
          CloudStorageProvider provider,
          [CloudStorageSelectorConfig<T>? browserConfig]) =>
      MaterialPageRoute<T>(
        settings: RouteSettings(name: '/cloudStorage/selector/${provider.id}'),
        builder: (context) => CloudStorageSelector(
          provider: provider,
          browserConfig: browserConfig,
        ),
      );
}

class _CloudStorageSelectorState extends State<CloudStorageSelector> {
  late bool _isSearch;
  CloudStorageEntity? _folder;

  @override
  void initState() {
    super.initState();
    widget.provider.loadSavedAuth().then((val) => setState(() {}));
    if (widget.browserConfig is CloudStorageBrowserConfig ||
        !(widget.provider.supportSearch)) {
      _isSearch = false;
    } else {
      _isSearch = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = widget.browserConfig;
    final analytics = context.watch<Analytics>();
    final loc = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(loc.cloudStorageAppBarTitle(widget.provider.displayName)),
        actions: widget.provider.isAuthenticated != true
            ? null
            : <Widget>[
                if (widget.provider is AuthPassCloudProvider) ...[
                  IconButton(
                    tooltip: loc.authPassCloudOpenWithShareCodeTooltip,
                    icon: const Icon(Icons.qr_code),
                    onPressed: () {
                      ShareCodeInputDialog.show(
                        context,
                        provider: widget.provider as AuthPassCloudProvider,
                      );
                    },
                  ),
                ],
                if (widget.browserConfig is CloudStorageOpenConfig) ...[
                  IconButton(
                    tooltip: loc.createNewFile,
                    onPressed: () async {
                      analytics.events.trackCreateFileAt(
                        cloudStorageId: widget.provider.id,
                        category: 'appbar',
                      );
                      await Navigator.of(context).push(CreateFile.route(
                        target: CloudStorageSaveTarget(
                          provider: widget.provider,
                          parent: _folder,
                        ),
                      ));
                    },
                    icon: const Icon(Icons.add),
                  ),
                ],
                IconButton(
                  tooltip: loc.logoutTooltip,
                  onPressed: () {
                    widget.provider.logout();
                    setState(() {});
                  },
                  icon: const Icon(FontAwesomeIcons.signOutAlt),
                ),
              ],
      ),
      floatingActionButton: widget.browserConfig is CloudStorageOpenConfig &&
              widget.provider.isAuthenticated
          ? FloatingActionButton(
              onPressed: () async {
                analytics.events.trackCreateFileAt(
                  cloudStorageId: widget.provider.id,
                  category: 'fab',
                );
                await Navigator.of(context).push(CreateFile.route(
                  target: CloudStorageSaveTarget(
                    provider: widget.provider,
                    parent: _folder,
                  ),
                ));
              },
              tooltip: loc.createNewFile,
              child: const Icon(Icons.add),
            )
          : null,
      body: widget.provider.isAuthenticated != true
          ? Center(
              child: CloudStorageAuthentication(
                  provider: widget.provider, onSuccess: () => setState(() {})),
            )
          : Center(
              child: !_isSearch
                  ? CloudStorageBrowser(
                      onFolderChanged: (folder) => _folder = folder,
                      provider: widget.provider,
                      config: config is CloudStorageBrowserConfig
                          ? config
                          : CloudStorageBrowserConfig(isSave: false))
                  : CloudStorageSearch(provider: widget.provider),
            ),
    );
  }
}

class CloudStorageSearch extends StatefulWidget {
  const CloudStorageSearch({Key? key, required this.provider})
      : super(key: key);

  final CloudStorageProvider provider;

  @override
  _CloudStorageSearchState createState() => _CloudStorageSearchState();
}

class _CloudStorageSearchState extends State<CloudStorageSearch>
    with TaskStateMixin {
  final _searchController = TextEditingController(text: Env.KeePassExtension);
  SearchResponse? _searchResponse;

  @override
  void initState() {
    super.initState();
    _search();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final searchResponse = _searchResponse;
    return LayoutBuilder(
      builder: (context, constraints) => ConstrainedBox(
        constraints: constraints.copyWith(maxWidth: 320),
        child: Column(
//      mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: loc.cloudStorageSearchBoxLabel,
                      ),
                      controller: _searchController,
                      onEditingComplete: _search,
                    ),
                  ),
                  IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () => _search()),
                ],
              ),
            ),
            task != null
                ? const CircularProgressIndicator()
                : searchResponse == null
                    ? Container()
                    : Expanded(
                        child: SearchResultListView(
                          response: searchResponse,
                          onTap: (entity) {
                            final source = FileSourceCloudStorage(
                              provider: widget.provider,
                              fileInfo: entity.toSimpleFileInfo(),
                              uuid: AppDataBloc.createUuid(),
                            );
                            Navigator.of(context)
                                .pop(CloudStorageSelectorLoadResult(source));
                          },
                        ),
                      ),
          ],
        ),
      ),
    );
  }

  Future<void> _search() => asyncRunTask(
        () async {
          final results =
              await widget.provider.search(name: _searchController.text);
          _logger.fine('Got results:');
          for (final result in results.results) {
            _logger.fine('${result!.name} (${result.id}');
          }
          setState(() {
            _searchResponse = results;
          });
        },
      );
}

class SearchResultListView extends StatelessWidget {
  const SearchResultListView({
    Key? key,
    required this.response,
    required this.onTap,
    this.provider,
  }) : super(key: key);

  final SearchResponse response;
  final void Function(CloudStorageEntity entity) onTap;
  final AuthPassCloudProvider? provider;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final length = response.results.length;
    return ListView.builder(
      itemBuilder: (context, itemId) {
        if (itemId >= length) {
          return ListTile(title: Text(loc.cloudStorageItemsInFolder(length)));
        }
        final entity = response.results[itemId]!;
        return ListTile(
          leading: Icon(entity.type == CloudStorageEntityType.file
              ? FontAwesomeIcons.file
              : FontAwesomeIcons.folder),
          title: Text(entity.name!),
          trailing: _createMenu(loc, entity),
          subtitle: entity.path == null ? null : Text(entity.path!),
          onTap: () => onTap(entity),
        );
      },
      itemCount: length + 1,
    );
  }

  Widget? _createMenu(AppLocalizations loc, CloudStorageEntity entity) {
    if (entity.type != CloudStorageEntityType.file) {
      return null;
    }
    final provider = this.provider;
    if (provider == null) {
      return null;
    }
    return PopupMenuButton<VoidCallback>(
      onSelected: (val) => val(),
      itemBuilder: (context) {
        return [
          PopupMenuItem(
              value: () async {
                await Navigator.of(context).push(
                  ShareFileScreen.route(provider: provider, entity: entity),
                );
              },
              child: ListTile(
                leading: const Icon(Icons.share),
                title: Text(loc.authPassCloudShareFileActionLabel),
              )),
          PopupMenuItem(
            value: () async {
              await provider.delete(entity);
              context.showSnackBar(loc.successfullyDeletedFileCloudStorage);
            },
            child: ListTile(
              leading: const Icon(Icons.delete_forever),
              title: Text(loc.deleteAction),
            ),
          ),
        ];
      },
    );
  }
}

abstract class CloudStorageSelectorConfig<
    T extends CloudStorageSelectorResult> {}

class CloudStorageOpenConfig
    extends CloudStorageSelectorConfig<CloudStorageSelectorLoadResult> {}

class CloudStorageBrowserConfig
    extends CloudStorageSelectorConfig<CloudStorageSelectorSaveResult> {
  CloudStorageBrowserConfig({this.defaultFileName, this.isSave = true});
  final String? defaultFileName;
  final bool isSave;
}

class CloudStorageBrowser extends StatefulWidget {
  const CloudStorageBrowser({
    Key? key,
    required this.provider,
    required this.config,
    required this.onFolderChanged,
  }) : super(key: key);
  final CloudStorageProvider provider;
  final CloudStorageBrowserConfig config;
  final void Function(CloudStorageEntity? folder) onFolderChanged;

  @override
  _CloudStorageBrowserState createState() => _CloudStorageBrowserState();
}

class _CloudStorageBrowserState extends State<CloudStorageBrowser>
    with FutureTaskStateMixin {
  final List<CloudStorageEntity> _folderBreadcrumbs = [];
  final TextEditingController _fileNameController = TextEditingController();
  SearchResponse? _response;
  CloudStorageEntity? get _folder =>
      _folderBreadcrumbs.isEmpty ? null : _folderBreadcrumbs.last;

  @override
  void initState() {
    super.initState();
    _fileNameController.text =
        widget.config.defaultFileName ?? CharConstants.empty;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (task == null && _response == null) {
      _listFolder();
    }
  }

  Future<void> _listFolder() async {
    final loc = AppLocalizations.of(context);
    widget.onFolderChanged(_folder);
    await asyncRunTask((progress) async {
      final response = await widget.provider.list(parent: _folder);
      setState(() {
        _response = response.rebuild((b) => b.results
          ..where((c) => c!.type != CloudStorageEntityType.unknown)
          ..sort(_compare));
      });
    }, label: loc.loading);
  }

  int _compare(CloudStorageEntity? a, CloudStorageEntity? b) {
    if (a!.type != b!.type) {
      return a.type!.index - b.type!.index;
    }
    return a.name!.toLowerCase().compareTo(b.name!.toLowerCase());
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final response = _response;
    return Column(
      children: <Widget>[
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          reverse: true,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextButton.icon(
                onPressed: () {
                  _folderBreadcrumbs.clear();
                  _listFolder();
                },
                icon: const Icon(FontAwesomeIcons.folderOpen),
                label: const Text(CharConstants.slash),
              ),
              ..._folderBreadcrumbs.expand((f) => [
                    const Text(CharConstants.chevronRight),
                    TextButton.icon(
                      icon: const Icon(FontAwesomeIcons.folderOpen),
                      label: Text(f.name!),
                      onPressed: () {
                        _folderBreadcrumbs.removeRange(
                            _folderBreadcrumbs.indexOf(f) + 1,
                            _folderBreadcrumbs.length);
                        _listFolder();
                      },
                    ),
                  ]),
            ],
          ),
        ),
        Expanded(
          child: ProgressOverlay(
            task: task,
            child: task == null && response != null
                ? SearchResultListView(
                    response: response,
                    provider: widget.provider.takeAs(),
                    onTap: (item) {
                      _logger.fine('Tapped on $item');
                      if (item.type == CloudStorageEntityType.directory) {
                        setState(() {
                          _folderBreadcrumbs.add(item);
                          _listFolder();
                        });
                      } else if (!widget.config.isSave) {
                        final source = FileSourceCloudStorage(
                          provider: widget.provider,
                          fileInfo: item.toSimpleFileInfo(),
                          uuid: AppDataBloc.createUuid(),
                        );
                        Navigator.of(context)
                            .pop(CloudStorageSelectorLoadResult(source));
                      }
                    },
                  )
                : const SizedBox.expand(),
          ),
        ),
        if (widget.config.isSave) ...[
          Material(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        filled: true,
                      ),
                      controller: _fileNameController,
                    ),
                  ),
                  const SizedBox(width: 8),
                  LinkButton(
                    icon: const Icon(FontAwesomeIcons.save),
                    onPressed: () {
                      Navigator.of(context).pop(CloudStorageSelectorSaveResult(
                          _folder, _fileNameController.text));
                    },
                    child: Text(loc.saveButtonLabel),
                  )
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}
