import 'package:authpass/cloud_storage/cloud_storage.dart';
import 'package:authpass/ui/widgets/link_button.dart';
import 'package:authpass/utils/dialog_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
  CloudStorageProvider _drive;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Drive'),
      ),
      body: Center(
        child: _drive == null
            ? CloudStorageAuthentication(drive: widget.provider, onSuccess: () => setState(() {}))
            : GoogleDriveSearch(provider: _drive),
      ),
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
            if (await canLaunch(uri)) {
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

class _GoogleDriveSearchState extends State<GoogleDriveSearch> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        LinkButton(
          child: const Text('Search'),
          onPressed: () {
            widget.provider.searchKdbx();
          },
        ),
      ],
    );
  }
}
