import 'package:authpass/cloud_storage/authpasscloud/authpass_cloud_provider.dart';
import 'package:authpass/cloud_storage/cloud_storage_bloc.dart';
import 'package:authpass/cloud_storage/cloud_storage_provider.dart';
import 'package:authpass/ui/screens/hud.dart';
import 'package:authpass/ui/screens/select_file_screen.dart';
import 'package:authpass/ui/widgets/async/retry_future_builder.dart';
import 'package:authpass/ui/widgets/authpass_progress_indicator.dart';
import 'package:authpass/utils/authpassicons.dart';
import 'package:authpass/utils/constants.dart';
import 'package:authpass/utils/dialog_utils.dart';
import 'package:authpass/utils/extension_methods.dart';
import 'package:authpass/utils/format_utils.dart';
import 'package:authpass/utils/platform.dart';
import 'package:authpass_cloud_shared/authpass_cloud_shared.dart';
import 'package:barcode_scan2/barcode_scan2.dart' as barcode;
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_async_utils/flutter_async_utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:string_literal_finder_annotations/string_literal_finder_annotations.dart';
import 'package:url_launcher/link.dart';

final _logger = Logger('cloud_storage_ui_authpass_cloud');

class ShareFileScreen extends StatefulWidget {
  const ShareFileScreen({
    Key? key,
    required this.provider,
    required this.entity,
  }) : super(key: key);

  static Route<void> route({
    required AuthPassCloudProvider provider,
    required CloudStorageEntity entity,
  }) =>
      MaterialPageRoute(
        settings: const RouteSettings(name: 'shareFile'),
        builder: (context) => ShareFileScreen(
          provider: provider,
          entity: entity,
        ),
        fullscreenDialog: true,
      );

  final AuthPassCloudProvider provider;
  final CloudStorageEntity entity;

  @override
  State<ShareFileScreen> createState() => _ShareFileScreenState();
}

class _ShareFileScreenState extends State<ShareFileScreen> {
  final _retryBuilder = GlobalKey<RetryFutureBuilderState>();

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(loc.shareDialogTitle(
            widget.entity.name ?? loc.unnamedFilePlaceholder)),
        actions: [
          IconButton(
              onPressed: () async {
                _retryBuilder.currentState?.reload();
              },
              icon: const Icon(Icons.refresh)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            await showDialog<void>(
                context: context,
                builder: (context) => ShareCreateDialog(
                      provider: widget.provider,
                      entity: widget.entity,
                    ));
            _retryBuilder.currentState?.reload();
          },
          label: Text(loc.shareFileActionLabel),
          icon: const Icon(Icons.share)),
      body: RetryFutureBuilder<List<FileTokenInfo>>(
        key: _retryBuilder,
        produceFuture: (context) =>
            widget.provider.listShareTokens(widget.entity),
        builder: (context, data) {
          final sorted =
              data.sorted((a, b) => a.createdAt.compareTo(b.createdAt));
          return ShareFileBody(tokens: sorted);
        },
      ),
    );
  }
}

class ShareFileBody extends StatelessWidget {
  const ShareFileBody({
    Key? key,
    required this.tokens,
  }) : super(key: key);

  final List<FileTokenInfo> tokens;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    if (tokens.isEmpty) {
      return Center(child: Text(loc.shareTokenListEmptyScreenPlaceholder));
    }
    final formatUtils = context.watch<FormatUtils>();
    return ListView.builder(
      itemCount: tokens.length,
      itemBuilder: (context, index) {
        final token = tokens[index];
        return ListTile(
          leading: const Icon(Icons.group),
          title: Text(
            token.label.takeUnlessBlank() ?? loc.shareTokenNoLabel,
          ),
          subtitle: Text([
            token.readOnly ? loc.shareTokenReadOnly : loc.shareTokenReadWrite,
            formatUtils.formatDateFull(token.createdAt)
          ].join(nonNls(' — '))),
          onTap: () async {
            await ShareTokenPresent.show(context,
                token: ShareTokenPresentArgs(token: token.fileToken));
          },
        );
      },
    );
  }
}

class ShareCreateDialog extends StatefulWidget {
  const ShareCreateDialog({
    Key? key,
    required this.provider,
    required this.entity,
  }) : super(key: key);

  final AuthPassCloudProvider provider;
  final CloudStorageEntity entity;

  @override
  State<ShareCreateDialog> createState() => _ShareCreateDialogState();
}

class _ShareCreateDialogState extends State<ShareCreateDialog>
    with FutureTaskStateMixin {
  final _controller = TextEditingController();
  bool readOnly = false;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final matLoc = MaterialLocalizations.of(context);
    return AlertDialog(
      title: Text(loc.shareCreateTokenDialogTitle),
      content: Container(
        constraints: const BoxConstraints(minWidth: 400.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: loc.shareCreateTokenLabelText,
                hintText: loc.shareCreateTokenLabelHint,
                helperText: loc.shareCreateTokenLabelHelp,
                helperMaxLines: 2,
              ),
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: readOnly,
              title: Text(loc.shareCreateTokenReadOnly),
              subtitle: Text(loc.shareCreateTokenReadOnlyHelpText),
              onChanged: (value) => setState(() => readOnly = value),
            )
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
          onPressed: asyncTaskCallback((task) async {
            await Future<void>.delayed(const Duration(seconds: 2));
            final response = await widget.provider.createShareToken(
              widget.entity,
              label: _controller.text,
              readOnly: readOnly,
            );
            // TODO show a 'present' dialog.
            _logger.fine('Created share token. ${response.fileToken.length}');

            if (mounted) {
              context.showSnackBar(loc.shareCreateTokenSuccess);
              Navigator.of(context).pop();
            }
          }),
          child: task == null
              ? Text(matLoc.okButtonLabel)
              : const ProgressIndicatorForButtonBar(),
        ),
      ],
    );
  }
}

class ShareTokenPresentArgs {
  ShareTokenPresentArgs({required this.token});
  final String token;
}

class ShareTokenPresent extends StatelessWidget {
  ShareTokenPresent({
    Key? key,
    required this.tokenInfo,
  }) : super(key: key);

  final ShareTokenPresentArgs tokenInfo;

  late final tokenUrl = AppConstants.authPassWebAppUri
      .replace(
        fragment: Uri(
            path: AppConstants.routeOpenFile,
            queryParameters: <String, String>{
              AppConstants.routeOpenFileParamToken: tokenInfo.token
            }).toString(),
      )
      .toString();

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final matLoc = MaterialLocalizations.of(context);
    return AlertDialog(
      title: Text(loc.sharePresentDialogTitle),
      content: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              loc.sharePresentDialogHelp,
              maxLines: null,
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 100,
                  height: 100,
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Ink(
                      color: Colors.white,
                      child: InkWell(
                        onTap: () {
                          FullScreenHud.show(context,
                              (context) => FullScreenHud(value: tokenUrl));
                        },
                        child: QrImage(
                          data: tokenUrl,
                          // backgroundColor: Colors.white,
                          // foregroundColor: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        onTap: () {
                          _copy(context);
                        },
                        enableInteractiveSelection: false,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: loc.sharePresentToken,
                          // suffix: IconButton(
                          //   padding: EdgeInsets.zero,
                          //   onPressed: () {
                          //     _copy(context);
                          //   },
                          //   icon: const Icon(Icons.copy),
                          //   constraints: BoxConstraints(),
                          // ),
                        ),
                        controller:
                            TextEditingController(text: tokenUrl.toString()),
                        readOnly: true,
                      ),
                      const SizedBox(height: 8),
                      TextButton.icon(
                        onPressed: () => _copy(context),
                        icon: const Icon(Icons.copy),
                        label: Text(matLoc.copyButtonLabel),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(matLoc.okButtonLabel),
        ),
      ],
    );
  }

  Future<void> _copy(BuildContext context) async {
    final loc = AppLocalizations.of(context);
    await Clipboard.setData(ClipboardData(text: tokenUrl));
    context.showSnackBar(loc.sharePresentCopied);
  }

  static Future<void> show(BuildContext context,
      {required ShareTokenPresentArgs token}) async {
    await showDialog<void>(
      context: context,
      builder: (context) => ShareTokenPresent(tokenInfo: token),
      routeSettings: const RouteSettings(name: 'shareTokenPresent'),
    );
  }
}

class ShareCodeInputDialog extends StatefulWidget {
  const ShareCodeInputDialog({
    Key? key,
    required this.provider,
  }) : super(key: key);

  final AuthPassCloudProvider provider;

  static Future<void> show(
    BuildContext context, {
    required AuthPassCloudProvider provider,
  }) async {
    await showDialog<void>(
      context: context,
      builder: (context) => ShareCodeInputDialog(
        provider: provider,
      ),
      routeSettings: const RouteSettings(name: 'shareCodeInput'),
    );
  }

  @override
  _ShareCodeInputDialogState createState() => _ShareCodeInputDialogState();
}

class _ShareCodeInputDialogState extends State<ShareCodeInputDialog>
    with FutureTaskStateMixin {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final matLoc = MaterialLocalizations.of(context);
    return AlertDialog(
      title: Text(loc.shareCodeInputDialogTitle),
      content: Container(
        constraints: const BoxConstraints(minWidth: 400.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton.icon(
              onPressed: () async {
                final result = await barcode.BarcodeScanner.scan(
                    options: const barcode.ScanOptions(
                        restrictFormat: [barcode.BarcodeFormat.qr]));
                if (result.type == barcode.ResultType.Barcode) {
                  _controller.text = result.rawContent;
                  await _load();
                }
              },
              icon: const Icon(Icons.qr_code_scanner),
              label: Text(loc.shareCodeInputDialogScan),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                IconButton(
                  tooltip: loc.promptDialogPasteActionTooltip,
                  icon: const Icon(FontAwesomeIcons.paste),
                  onPressed: () async {
                    final text = await getClipboardText();
                    if (text != null) {
                      _controller.text = text;
                    }
                  },
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      labelText: loc.shareCodeInputLabel,
                      helperText: loc.shareCodeInputHelperText,
                      helperMaxLines: 2,
                    ),
                    autofocus: true,
                    onEditingComplete: () {
                      Navigator.of(context).pop(_controller.text);
                    },
                  ),
                ),
              ],
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
        task == null
            ? TextButton(
                onPressed: () {
                  _load();
                },
                child: Text(matLoc.okButtonLabel),
              )
            : const ProgressIndicatorForButtonBar(),
      ],
    );
  }

  Future<void> _load() async {
    await asyncRunTask((progress) async {
      final token = _tokenFromString(_controller.text);
      final loadedToken =
          await widget.provider.loadFromShareToken(token: token);
      await Navigator.of(context)
          .pushReplacement(CredentialsScreen.route(loadedToken.fileSource));
    });
  }

  String _tokenFromString(final String tokenString) {
    final token = tokenString.trim();
    if (token.startsWith(nonNls('https://'))) {
      final parsed = Uri.tryParse(token)?.let((uri) {
        final fragment = Uri.tryParse(uri.fragment);
        return fragment?.queryParameters[nonNls('token')];
      });
      if (parsed != null) {
        return parsed;
      }
    }
    return token;
  }
}

/// Launch screen when deep linking to token.
class AuthPassCloudLoadFileLaunch extends StatefulWidget {
  const AuthPassCloudLoadFileLaunch({
    Key? key,
    required this.token,
  }) : super(key: key);

  static Route<void> route({required String token}) => MaterialPageRoute(
        builder: (context) => AuthPassCloudLoadFileLaunch(token: token),
        settings: RouteSettings(
            name:
                Uri(path: '/openFile/token', queryParameters: <String, String>{
          AppConstants.routeOpenFileParamToken: token,
        }).toString()),
      );

  final String token;

  @override
  State<AuthPassCloudLoadFileLaunch> createState() =>
      _AuthPassCloudLoadFileLaunchState();
}

class _AuthPassCloudLoadFileLaunchState
    extends State<AuthPassCloudLoadFileLaunch> with FutureTaskStateMixin {
  AuthPassCloudProvider? _provider;
  LoadedShareToken? _loadedToken;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_provider == null) {
      final bloc = context.watch<CloudStorageBloc>();
      final provider = _provider =
          bloc.availableCloudStorage.whereType<AuthPassCloudProvider>().single;
      asyncRunTask((progress) async {
        final response = await provider.loadFromShareToken(token: widget.token);
        setState(() {
          _loadedToken = response;
        });
        _logger.fine('done.');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final loadedToken = _loadedToken;
    final loc = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(loc.shareCodeOpenScreenTitle)),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (loadedToken == null) ...[
              Text(loc.shareCodeLoadingProgress),
              const SizedBox(height: 16),
              if (task != null) ...[
                const CircularProgressIndicator(),
              ] else ...[
                TextButton(
                  onPressed: () {},
                  child: Text(loc.retryDialogActionLabel),
                ),
              ],
            ] else ...[
              Icon(AuthPassIcons.AuthPassLogo,
                  color: Theme.of(context).primaryColor, size: 64),
              const SizedBox(height: 16),
              Text(loadedToken.fileInfo.name),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(CredentialsScreen.route(loadedToken.fileSource));
                },
                child: Text(loc.shareCodeOpenFileButtonLabel),
              ),
              const SizedBox(height: 32),
              Text(AuthPassPlatform.isWeb
                  ? loc.shareCodeOpenInstallAppCaption
                  : loc.shareCodeOpenAnotherAppCaption),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Link(
                    uri: AppConstants.authPassInstall
                        .utmCampaign('shareCodeLaunch'),
                    target: LinkTarget.blank,
                    builder: (context, followLink) => TextButton(
                      onPressed: followLink,
                      child: Text(loc.shareCodeOpenInstallAppButtonLabel),
                    ),
                  ),
                  const SizedBox(width: 16),
                  TextButton(
                    onPressed: () async {
                      await ShareTokenPresent.show(
                        context,
                        token: ShareTokenPresentArgs(
                            token: loadedToken.fileInfo.fileToken),
                      );
                    },
                    child: Text(loc.shareCodeOpenShowCodeButtonLabel),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
