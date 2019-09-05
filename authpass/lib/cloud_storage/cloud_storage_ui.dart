import 'package:authpass/cloud_storage/cloud_storage.dart';
import 'package:authpass/ui/widgets/link_button.dart';
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

  static Route<String> route(CloudStorageProvider provider) => MaterialPageRoute(
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CloudStorage - ${widget.provider.displayName}'),
      ),
      body: widget.provider.isAuthenticated != true
          ? Center(child: CloudStorageAuthentication(drive: widget.provider, onSuccess: () => setState(() {})))
          : Center(child: GoogleDriveSearch(provider: widget.provider)),
    );
  }
}

class CloudStorageAuthentication extends StatelessWidget {
  const CloudStorageAuthentication({Key key, @required this.drive, this.onSuccess}) : super(key: key);

  final CloudStorageProvider drive;
  final void Function() onSuccess;

  @override
  Widget build(BuildContext context) {
    return LinkButton(
      child: const Text('Auth'),
      onPressed: () async {
        try {
          final auth = await drive.startAuth((uri) async {
            _logger.fine('Launching authentication url $uri');
            if (await DialogUtils.openUrl(uri)) {
              await launch(uri);
//              await DialogUtils.showConfirmDialog(context: null, params: null)
              return await SimplePromptDialog.showPrompt(
                  context,
                  const SimplePromptDialog(
                    title: 'Google Drive Authentication',
                    labelText: 'Authentication Code',
                  ));
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
    );
  }
}

class GoogleDriveSearch extends StatefulWidget {
  const GoogleDriveSearch({Key key, this.provider}) : super(key: key);

  final CloudStorageProvider provider;

  @override
  _GoogleDriveSearchState createState() => _GoogleDriveSearchState();
}

class _GoogleDriveSearchState extends State<GoogleDriveSearch> with TaskStateMixin {
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
                    ),
                  ),
                  IconButton(icon: Icon(Icons.search), onPressed: () => _search()),
                ],
              ),
            ),
            task != null
                ? const CircularProgressIndicator()
                : _searchResponse == null ? Container() : SearchResultListView(response: _searchResponse),
          ],
        ),
      ),
    );
  }

  Future<void> _search() => asyncRunTask(
        () async {
          final results = await widget.provider.searchKdbx();
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
  const SearchResultListView({Key key, @required this.response}) : super(key: key);

  final SearchResponse response;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemBuilder: (context, itemId) {
          final entity = response.results[itemId];
          return ListTile(
            leading: Icon(FontAwesomeIcons.file),
            title: Text(entity.name),
          );
        },
        itemCount: response.results.length,
      ),
    );
  }
}
