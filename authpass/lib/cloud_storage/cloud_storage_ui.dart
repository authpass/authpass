import 'package:authpass/bloc/app_data.dart';
import 'package:authpass/bloc/kdbx/file_source_cloud_storage.dart';
import 'package:authpass/cloud_storage/cloud_storage_provider.dart';
import 'package:authpass/ui/screens/select_file_screen.dart';
import 'package:authpass/ui/widgets/link_button.dart';
import 'package:authpass/ui/widgets/primary_button.dart';
import 'package:authpass/utils/dialog_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_async_utils/flutter_async_utils.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:logging/logging.dart';
import 'package:simple_form_field_validator/simple_form_field_validator.dart';

final _logger = Logger('authpass.google_drive_ui');

class CloudStorageSelector extends StatefulWidget {
  const CloudStorageSelector({Key key, this.provider, this.browserConfig})
      : super(key: key);

  final CloudStorageProvider provider;
  final CloudStorageSelectorConfig browserConfig;

  @override
  _CloudStorageSelectorState createState() => _CloudStorageSelectorState();

  static Route<T> route<T extends CloudStorageSelectorResult>(
          CloudStorageProvider provider,
          [CloudStorageSelectorConfig<T> browserConfig]) =>
      MaterialPageRoute<T>(
        settings: RouteSettings(name: '/cloudStorage/selector/${provider.id}'),
        builder: (context) => CloudStorageSelector(
          provider: provider,
          browserConfig: browserConfig,
        ),
      );
}

class _CloudStorageSelectorState extends State<CloudStorageSelector> {
  bool _isSearch;

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
                  icon: const Icon(FontAwesomeIcons.signOutAlt),
                ),
              ],
      ),
      body: widget.provider.isAuthenticated != true
          ? Center(
              child: CloudStorageAuthentication(
                  provider: widget.provider, onSuccess: () => setState(() {})))
          : Center(
              child: !_isSearch
                  ? CloudStorageBrowser(
                      provider: widget.provider,
                      config: config is CloudStorageBrowserConfig
                          ? config
                          : CloudStorageBrowserConfig(isSave: false))
                  : CloudStorageSearch(provider: widget.provider),
            ),
    );
  }
}

class CloudStorageAuthentication extends StatelessWidget {
  const CloudStorageAuthentication(
      {Key key, @required this.provider, this.onSuccess})
      : super(key: key);

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
            icon: const Icon(FontAwesomeIcons.signInAlt),
            child: Text('Login to ${provider.displayName}'),
            onPressed: () async {
              await _startLoginFlow(context);
            },
          ),
          const SizedBox(height: 16),
          Text(
            'You will be redirected to authenticate AuthPass to access your data.',
            style: Theme.of(context).textTheme.caption,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          LinkButton(
            child: const Text(
              'Enter code',
              textScaleFactor: 0.75,
            ),
            onPressed: () async {
              await _startLoginFlow(context, forceNoOpenUrl: true);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _startLoginFlow(BuildContext context,
      {bool forceNoOpenUrl = false}) async {
    try {
      final auth = await provider.startAuth((final prompt) async {
        if (prompt is UserAuthenticationPrompt<OAuthTokenResult,
            OAuthTokenFlowPromptData>) {
          final promptData = prompt.data;
          final uri = promptData.openUri;
          _logger.fine('Launching authentication url $uri');

          if (!forceNoOpenUrl) {
            if (!await DialogUtils.openUrl(uri)) {
              await DialogUtils.showSimpleAlertDialog(
                context,
                null,
                'Unable to launch url. Please visit $uri',
                routeAppend: 'cloudStorageAuthError',
              );
              prompt.result(null);
              return;
            }
          }
          final code = await SimpleAuthCodePromptDialog(
            title: '${provider.displayName} Authentication',
            labelText: 'Authentication Code',
          ).show(context);
          prompt.result(OAuthTokenResult(code));
        } else if (prompt is UserAuthenticationPrompt<UrlUsernamePasswordResult,
            UrlUsernamePasswordPromptData>) {
          final result = await UrlUsernamePasswordDialog().show(context);
          prompt.result(result);
        } else {
          throw StateError('Unsupported prompt: $prompt');
        }
      });
      _logger.fine('finished launching. $auth');
      onSuccess();
    } catch (e, stackTrace) {
      _logger.severe('Error while authenticating.', e, stackTrace);
      await DialogUtils.showErrorDialog(context, 'Error while authenticating',
          'Error while trying to authenticate to ${provider.displayName}. $e');
    }
  }
}

class CloudStorageSearch extends StatefulWidget {
  const CloudStorageSearch({Key key, this.provider}) : super(key: key);

  final CloudStorageProvider provider;

  @override
  _CloudStorageSearchState createState() => _CloudStorageSearchState();
}

class _CloudStorageSearchState extends State<CloudStorageSearch>
    with TaskStateMixin {
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
                  IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () => _search()),
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
    final length = response.results.length;
    return ListView.builder(
      itemBuilder: (context, itemId) {
        if (itemId >= length) {
          return ListTile(title: Text('$length Items in this folder.'));
        }
        final entity = response.results[itemId];
        return ListTile(
          leading: Icon(entity.type == CloudStorageEntityType.file
              ? FontAwesomeIcons.file
              : FontAwesomeIcons.folder),
          title: Text(entity.name),
          subtitle: entity.path == null ? null : Text(entity.path),
          onTap: () => onTap(entity),
        );
      },
      itemCount: length + 1,
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

class _CloudStorageBrowserState extends State<CloudStorageBrowser>
    with FutureTaskStateMixin {
  final List<CloudStorageEntity> _folderBreadcrumbs = [];
  final TextEditingController _fileNameController = TextEditingController();
  SearchResponse _response;
  CloudStorageEntity get _folder =>
      _folderBreadcrumbs.isEmpty ? null : _folderBreadcrumbs.last;

  @override
  void initState() {
    super.initState();
    _fileNameController.text = widget.config.defaultFileName;
    _listFolder();
  }

  Future<void> _listFolder() async {
    await asyncRunTask((progress) async {
      final response = await widget.provider.list(parent: _folder);
      setState(() {
        _response = response.rebuild((b) => b.results
          ..where((c) => c.type != CloudStorageEntityType.unknown)
          ..sort(_compare));
      });
    }, label: 'Loading');
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
                  _listFolder();
                },
                icon: const Icon(FontAwesomeIcons.folderOpen),
                label: const Text('/'),
              ),
              ..._folderBreadcrumbs.expand((f) => [
                    const Text('  >  '),
                    FlatButton.icon(
                      icon: const Icon(FontAwesomeIcons.folderOpen),
                      label: Text(f.name),
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
            child: task == null && _response != null
                ? SearchResultListView(
                    response: _response,
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
        ...?(!widget.config.isSave
            ? null
            : [
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
                          child: const Text('Save'),
                          onPressed: () {
                            Navigator.of(context).pop(
                                CloudStorageSelectorSaveResult(
                                    _folder, _fileNameController.text));
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ]),
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

class UrlUsernamePasswordDialog extends StatefulWidget {
  Future<UrlUsernamePasswordResult> show(BuildContext context) =>
      showDialog<UrlUsernamePasswordResult>(
          context: context, builder: (_) => this);

  @override
  _UrlUsernamePasswordDialogState createState() =>
      _UrlUsernamePasswordDialogState();
}

final _urlRegex = RegExp(r'^https?://');

class _UrlUsernamePasswordDialogState extends State<UrlUsernamePasswordDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _url = TextEditingController();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('WebDAV Settings'),
      scrollable: true,
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextFormField(
              controller: _url,
              keyboardType: TextInputType.url,
              decoration: const InputDecoration(
                labelText: 'Url',
                helperText: 'Base Url to your WebDAV service.',
                hintText: 'https://my.nextcloud.com/webdav',
              ),
              autocorrect: false,
              validator: SValidator.notEmpty(msg: 'Please enter a Url') +
                  SValidator.isTrue((str) => _urlRegex.hasMatch(str),
                      'Please enter a valid url with http:// or https://'),
            ),
            TextFormField(
              controller: _username,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Username',
              ),
            ),
            TextFormField(
              controller: _password,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        FlatButton(
          child: const Text('Ok'),
          onPressed: () {
            if (_formKey.currentState.validate()) {
              Navigator.of(context).pop(UrlUsernamePasswordResult(
                  _url.text, _username.text, _password.text));
            }
          },
        ),
      ],
    );
  }
}
