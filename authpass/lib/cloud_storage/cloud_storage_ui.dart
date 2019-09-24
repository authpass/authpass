import 'package:authpass/bloc/app_data.dart';
import 'package:authpass/bloc/kdbx_bloc.dart';
import 'package:authpass/cloud_storage/cloud_storage_provider.dart';
import 'package:authpass/ui/screens/select_file_screen.dart';
import 'package:authpass/ui/widgets/link_button.dart';
import 'package:authpass/ui/widgets/primary_button.dart';
import 'package:authpass/utils/async_utils.dart';
import 'package:authpass/utils/dialog_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:logging/logging.dart';

final _logger = Logger('authpass.google_drive_ui');

abstract class CloudStorageSelectorResult {}

class CloudStorageSelectorSaveResult implements CloudStorageSelectorResult {
  CloudStorageSelectorSaveResult(this.parentId, this.fileName);
  final String parentId;
  final String fileName;
}

class CloudStorageSelectorLoadResult implements CloudStorageSelectorResult {
  CloudStorageSelectorLoadResult(this.fileSource);
  final FileSource fileSource;
}

class CloudStorageSelector extends StatefulWidget {
  const CloudStorageSelector({Key key, this.provider, this.browserConfig}) : super(key: key);

  final CloudStorageProvider provider;
  final CloudStorageSelectorConfig browserConfig;

  @override
  _CloudStorageSelectorState createState() => _CloudStorageSelectorState();

  static Route<T> route<T extends CloudStorageSelectorResult>(CloudStorageProvider provider,
          [CloudStorageSelectorConfig<T> browserConfig]) =>
      MaterialPageRoute<T>(
        settings: const RouteSettings(name: '/cloudStorage/selector'),
        builder: (context) => CloudStorageSelector(
          provider: provider,
          browserConfig: browserConfig,
        ),
      );
}

class _CloudStorageSelectorState extends State<CloudStorageSelector> {
  @override
  void initState() {
    super.initState();
    widget.provider.loadSavedAuth().then((val) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final config = widget.browserConfig;
    return Scaffold(
      appBar: AppBar(
        title: Text('CloudStorage - ${widget.provider.displayName}'),
        actions: widget.provider.isAuthenticated != true
            ? null
            : <Widget>[
                IconButton(
                  onPressed: () {
                    widget.provider.logout();
                    setState(() {});
                  },
                  icon: Icon(FontAwesomeIcons.signOutAlt),
                ),
              ],
      ),
      body: widget.provider.isAuthenticated != true
          ? Center(child: CloudStorageAuthentication(provider: widget.provider, onSuccess: () => setState(() {})))
          : Center(
              child: config is CloudStorageBrowserConfig
                  ? CloudStorageBrowser(provider: widget.provider, config: config)
                  : CloudStorageSearch(provider: widget.provider),
            ),
    );
  }
}

class CloudStorageAuthentication extends StatelessWidget {
  const CloudStorageAuthentication({Key key, @required this.provider, this.onSuccess}) : super(key: key);

  final CloudStorageProvider provider;
  final void Function() onSuccess;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          PrimaryButton(
            icon: Icon(FontAwesomeIcons.signInAlt),
            child: Text('Login to ${provider.displayName}'),
            onPressed: () async {
              try {
                final auth = await provider.startAuth((uri) async {
                  _logger.fine('Launching authentication url $uri');
                  if (await DialogUtils.openUrl(uri)) {
//                  await launch(uri);
//              await DialogUtils.showConfirmDialog(context: null, params: null)
                    return await SimplePromptDialog.showPrompt(
                      context,
                      const SimplePromptDialog(
                        title: 'Google Drive Authentication',
                        labelText: 'Authentication Code',
                      ),
                    );
                  } else {
                    await DialogUtils.showSimpleAlertDialog(context, null, 'Unable to launch url. Please visit $uri');
                    return null;
                  }
                });
                _logger.fine('finished launching. $auth');
                onSuccess();
              } catch (e, stackTrace) {
                _logger.severe('Error while authenticating.', e, stackTrace);
                await DialogUtils.showSimpleAlertDialog(
                    context, 'Error while authenticating', 'Error while trying to authenticate fo google drive. $e');
              }
            },
          ),
          const SizedBox(height: 16),
          Text(
            'You will be redirected to authenticate AuthPass to access your data.',
            style: Theme.of(context).textTheme.caption,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class CloudStorageSearch extends StatefulWidget {
  const CloudStorageSearch({Key key, this.provider}) : super(key: key);

  final CloudStorageProvider provider;

  @override
  _CloudStorageSearchState createState() => _CloudStorageSearchState();
}

class _CloudStorageSearchState extends State<CloudStorageSearch> with TaskStateMixin {
  final _searchController = TextEditingController(text: 'kdbx');
  SearchResponse _searchResponse;

  @override
  void initState() {
    super.initState();
    _search();
  }

  @override
  Widget build(BuildContext context) {
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
                      decoration: const InputDecoration(
                        labelText: 'Search Query',
                      ),
                      controller: _searchController,
                      onEditingComplete: _search,
                    ),
                  ),
                  IconButton(icon: Icon(Icons.search), onPressed: () => _search()),
                ],
              ),
            ),
            task != null
                ? const CircularProgressIndicator()
                : _searchResponse == null
                    ? Container()
                    : Expanded(
                        child: SearchResultListView(
                          response: _searchResponse,
                          onTap: (entity) {
                            final source = FileSourceCloudStorage(
                              provider: widget.provider,
                              fileInfo: entity.toSimpleFileInfo(),
                              uuid: AppDataBloc.createUuid(),
                            );
                            Navigator.of(context).pop(CloudStorageSelectorLoadResult(source));
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
          final results = await widget.provider.search(name: _searchController.text);
          _logger.fine('Got results:');
          for (final result in results.results) {
            _logger.fine('${result.name} (${result.id}');
          }
          setState(() {
            _searchResponse = results;
          });
        },
      );
}

class SearchResultListView extends StatelessWidget {
  const SearchResultListView({
    Key key,
    @required this.response,
    @required this.onTap,
  }) : super(key: key);

  final SearchResponse response;
  final void Function(CloudStorageEntity entity) onTap;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, itemId) {
        final entity = response.results[itemId];
        return ListTile(
          leading: Icon(entity.type == CloudStorageEntityType.file ? FontAwesomeIcons.file : FontAwesomeIcons.folder),
          title: Text(entity.name),
          subtitle: entity.path == null ? null : Text(entity.path),
          onTap: () => onTap(entity),
        );
      },
      itemCount: response.results.length,
    );
  }
}

abstract class CloudStorageSelectorConfig<T extends CloudStorageSelectorResult> {}

class CloudStorageLoadConfig extends CloudStorageSelectorConfig<CloudStorageSelectorLoadResult> {}

class CloudStorageBrowserConfig extends CloudStorageSelectorConfig<CloudStorageSelectorSaveResult> {
  CloudStorageBrowserConfig({this.defaultFileName, this.isSave = true});
  final String defaultFileName;
  final bool isSave;
}

class CloudStorageBrowser extends StatefulWidget {
  const CloudStorageBrowser({
    Key key,
    @required this.provider,
    @required this.config,
  }) : super(key: key);
  final CloudStorageProvider provider;
  final CloudStorageBrowserConfig config;

  @override
  _CloudStorageBrowserState createState() => _CloudStorageBrowserState();
}

class _CloudStorageBrowserState extends State<CloudStorageBrowser> with FutureTaskStateMixin {
  final List<CloudStorageEntity> _folderBreadcrumbs = [];
  final TextEditingController _fileNameController = TextEditingController();
  SearchResponse _response;

  @override
  void initState() {
    super.initState();
    _fileNameController.text = widget.config.defaultFileName;
    _runSearch();
  }

  CloudStorageEntity get _folder => _folderBreadcrumbs.isEmpty ? null : _folderBreadcrumbs.last;

  Future<void> _runSearch() async {
    await asyncRunTask((progress) async {
      final response = await widget.provider.list(parent: _folder);
      setState(() {
        _response = response.rebuild((b) => b.results.sort(_compare));
      });
    });
  }

  int _compare(CloudStorageEntity a, CloudStorageEntity b) {
    if (a.type != b.type) {
      return a.type.index - b.type.index;
    }
    return a.name.toLowerCase().compareTo(b.name.toLowerCase());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          reverse: true,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              FlatButton.icon(
                onPressed: () {
                  _folderBreadcrumbs.clear();
                  _runSearch();
                },
                icon: Icon(FontAwesomeIcons.folderOpen),
                label: const Text('/'),
              ),
              ..._folderBreadcrumbs.expand((f) => [
                    const Text('  >  '),
                    FlatButton.icon(
                      icon: Icon(FontAwesomeIcons.folderOpen),
                      label: Text(f.name),
                      onPressed: () {
                        _folderBreadcrumbs.removeRange(_folderBreadcrumbs.indexOf(f) + 1, _folderBreadcrumbs.length);
                        _runSearch();
                      },
                    ),
                  ]),
            ],
          ),
        ),
        Expanded(
          child: ProgressOverlay(
            task: task,
            child: task == null && _response != null
                ? SearchResultListView(
                    response: _response,
                    onTap: (item) {
                      _logger.fine('Tapped on $item');
                      if (item.type == CloudStorageEntityType.directory) {
                        setState(() {
                          _folderBreadcrumbs.add(item);
                          _runSearch();
                        });
                      }
                    },
                  )
                : const SizedBox.shrink(),
          ),
        ),
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
                  icon: Icon(FontAwesomeIcons.save),
                  child: const Text('Save'),
                  onPressed: () {
                    Navigator.of(context).pop(CloudStorageSelectorSaveResult(_folder?.id, _fileNameController.text));
                  },
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class CloudStorageBrowserItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
