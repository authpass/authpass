import 'package:authpass/cloud_storage/authpasscloud/authpass_cloud_provider.dart';
import 'package:authpass/cloud_storage/cloud_storage_provider.dart';
import 'package:authpass/ui/widgets/async/retry_future_builder.dart';
import 'package:authpass/utils/dialog_utils.dart';
import 'package:authpass/utils/extension_methods.dart';
import 'package:authpass/utils/format_utils.dart';
import 'package:authpass_cloud_shared/authpass_cloud_shared.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_async_utils/flutter_async_utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:string_literal_finder_annotations/string_literal_finder_annotations.dart';

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
            await showDialog<void>(
              context: context,
              builder: (context) => ShareTokenPresent(tokenInfo: token),
            );
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
              : const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(),
                ),
        ),
      ],
    );
  }
}

class ShareTokenPresent extends StatelessWidget {
  const ShareTokenPresent({
    Key? key,
    required this.tokenInfo,
  }) : super(key: key);

  final FileTokenInfo tokenInfo;

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
              controller: TextEditingController(text: tokenInfo.fileToken),
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
    await Clipboard.setData(ClipboardData(text: tokenInfo.fileToken));
    context.showSnackBar(loc.sharePresentCopied);
  }
}
