import 'package:authpass/bloc/app_data.dart';
import 'package:authpass/bloc/kdbx_bloc.dart';
import 'package:authpass/cloud_storage/cloud_storage_provider.dart';
import 'package:authpass/ui/widgets/primary_button.dart';
import 'package:authpass/utils/async_utils.dart';
import 'package:authpass/utils/dialog_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:logging/logging.dart';
import 'package:url_launcher/url_launcher.dart';

final _logger = Logger('authpass.google_drive_ui');

class CloudStorageSelector extends StatefulWidget {
  const CloudStorageSelector({Key key, this.provider}) : super(key: key);

  final CloudStorageProvider provider;

  @override
  _CloudStorageSelectorState createState() => _CloudStorageSelectorState();

  static Route<FileSourceCloudStorage> route(CloudStorageProvider provider) =>
      MaterialPageRoute<FileSourceCloudStorage>(
        settings: const RouteSettings(name: '/cloudStorage/selector'),
        builder: (context) => CloudStorageSelector(
          provider: provider,
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
    return Scaffold(
      appBar: AppBar(
        title: Text('CloudStorage - ${widget.provider.displayName}'),
      ),
      body: widget.provider.isAuthenticated != true
          ? Center(child: CloudStorageAuthentication(provider: widget.provider, onSuccess: () => setState(() {})))
          : Center(child: CloudStorageSearch(provider: widget.provider)),
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
                      decoration: InputDecoration(
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
                    : SearchResultListView(
                        response: _searchResponse,
                        onTap: (entity) {
                          final source = FileSourceCloudStorage(
                            provider: widget.provider,
                            fileInfo: entity.toSimpleFileInfo(),
                            uuid: AppDataBloc.createUuid(),
                          );
                          Navigator.of(context).pop(source);
                        },
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
  const SearchResultListView({Key key, @required this.response, this.onTap}) : super(key: key);

  final SearchResponse response;
  final void Function(CloudStorageEntity entity) onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemBuilder: (context, itemId) {
          final entity = response.results[itemId];
          return ListTile(
            leading: Icon(FontAwesomeIcons.file),
            title: Text(entity.name),
            subtitle: entity.path == null ? null : Text(entity.path),
            onTap: () => onTap(entity),
          );
        },
        itemCount: response.results.length,
      ),
    );
  }
}
