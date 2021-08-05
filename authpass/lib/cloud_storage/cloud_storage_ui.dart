import 'package:authpass/bloc/analytics.dart';
import 'package:authpass/bloc/app_data.dart';
import 'package:authpass/bloc/kdbx/file_source_cloud_storage.dart';
import 'package:authpass/cloud_storage/authpasscloud/authpass_cloud_provider.dart';
import 'package:authpass/cloud_storage/cloud_storage_provider.dart';
import 'package:authpass/env/_base.dart';
import 'package:authpass/ui/screens/cloud/cloud_auth.dart';
import 'package:authpass/ui/screens/create_file.dart';
import 'package:authpass/ui/screens/select_file_screen.dart';
import 'package:authpass/ui/widgets/link_button.dart';
import 'package:authpass/ui/widgets/primary_button.dart';
import 'package:authpass/utils/constants.dart';
import 'package:authpass/utils/dialog_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_async_utils/flutter_async_utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:simple_form_field_validator/simple_form_field_validator.dart';
import 'package:string_literal_finder_annotations/string_literal_finder_annotations.dart';

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
                if (widget.browserConfig is CloudStorageOpenConfig) ...[
                  IconButton(
                    onPressed: () async {
                      analytics.events.trackCreateFileAt(
                          cloudStorageId: widget.provider.id);
                      await Navigator.of(context).push(CreateFile.route(
                        target: CloudStorageSaveTarget(
                          provider: widget.provider,
                          parent: _folder,
                        ),
                      ));
                    },
                    icon: const Icon(Icons.create_new_folder),
                  ),
                ],
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

class CloudStorageAuthentication extends StatelessWidget {
  const CloudStorageAuthentication(
      {Key? key, required this.provider, this.onSuccess})
      : super(key: key);

  final CloudStorageProvider? provider;
  final void Function()? onSuccess;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          PrimaryButton(
            icon: const Icon(FontAwesomeIcons.signInAlt),
            onPressed: () async {
              await _startLoginFlow(context);
            },
            child:
                Text(loc.cloudStorageLogInActionLabel(provider!.displayName)),
          ),
          const SizedBox(height: 16),
          Text(
            loc.cloudStorageLogInCaption,
            style: Theme.of(context).textTheme.caption,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          LinkButton(
            onPressed: () async {
              await _startLoginFlow(context, forceNoOpenUrl: true);
            },
            child: Text(
              loc.cloudStorageLogInCode,
              textScaleFactor: 0.75,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _startLoginFlow(BuildContext context,
      {bool forceNoOpenUrl = false}) async {
    final loc = AppLocalizations.of(context);
    try {
      final auth = await provider!.startAuth((final prompt) async {
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
                loc.launchUrlError(uri),
                routeAppend: 'cloudStorageAuthError',
              );
              prompt.result(null);
              return;
            }
          }
          final code = await SimpleAuthCodePromptDialog(
            title: loc.cloudStorageAuthCodeDialogTitle(provider!.displayName),
            labelText: loc.cloudStorageAuthCodeLabel,
          ).show(context);
          prompt.result(OAuthTokenResult(code));
        } else if (prompt is UserAuthenticationPrompt<UrlUsernamePasswordResult,
            UrlUsernamePasswordPromptData>) {
          final result = await UrlUsernamePasswordDialog().show(context);
          prompt.result(result);
        } else if (prompt is UserAuthenticationPrompt<
            DummyUserAuthenticationPromptResult, AuthPassCloudAuthPromptData>) {
          final result = await Navigator.of(context, rootNavigator: true)
              .push(AuthPassCloudAuthScreen.route());
          prompt.result(DummyUserAuthenticationPromptResult(result ?? false));
        } else {
          throw StateError('Unsupported prompt: $prompt');
        }
      });
      _logger.fine('finished launching. $auth');
      onSuccess!();
    } catch (e, stackTrace) {
      _logger.severe('Error while authenticating.', e, stackTrace);
      await DialogUtils.showErrorDialog(context, loc.cloudStorageAuthErrorTitle,
          loc.cloudStorageAuthErrorMessage(provider!.displayName, e));
    }
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
  }) : super(key: key);

  final SearchResponse response;
  final void Function(CloudStorageEntity entity) onTap;

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
          subtitle: entity.path == null ? null : Text(entity.path!),
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
                          onPressed: () {
                            Navigator.of(context).pop(
                                CloudStorageSelectorSaveResult(
                                    _folder, _fileNameController.text));
                          },
                          child: Text(loc.saveButtonLabel),
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
  Future<UrlUsernamePasswordResult?> show(BuildContext context) =>
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
    final loc = AppLocalizations.of(context);
    final matLoc = MaterialLocalizations.of(context);
    return AlertDialog(
      title: Text(loc.webDavSettings),
      scrollable: true,
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextFormField(
              controller: _url,
              keyboardType: TextInputType.url,
              decoration: InputDecoration(
                labelText: loc.webDavUrlLabel,
                helperText: loc.webDavUrlHelperText,
                hintText: nonNls('https://my.nextcloud.com/webdav'),
              ),
              autocorrect: false,
              validator: SValidator.notEmpty(msg: loc.webDavUrlValidatorError) +
                  SValidator.isTrue((str) => _urlRegex.hasMatch(str!),
                      loc.webDavUrlValidatorInvalidUrlError),
            ),
            TextFormField(
              controller: _username,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: loc.webDavAuthUser,
              ),
            ),
            TextFormField(
              controller: _password,
              obscureText: true,
              decoration: InputDecoration(
                labelText: loc.webDavAuthPassword,
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(matLoc.cancelButtonLabel),
        ),
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.of(context).pop(UrlUsernamePasswordResult(
                  _url.text, _username.text, _password.text));
            }
          },
          child: Text(matLoc.okButtonLabel),
        ),
      ],
    );
  }
}
