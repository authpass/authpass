import 'package:authpass/bloc/authpass_cloud_bloc.dart';
import 'package:authpass/bloc/kdbx_bloc.dart';
import 'package:authpass/ui/common_fields.dart';
import 'package:authpass/ui/screens/cloud/cloud_mail_read.dart';
import 'package:authpass/ui/widgets/async/retry_future_builder.dart';
import 'package:authpass/utils/dialog_utils.dart';
import 'package:authpass/utils/format_utils.dart';
import 'package:authpass/utils/predefined_icons.dart';
import 'package:authpass/utils/theme_utils.dart';
import 'package:authpass_cloud_shared/authpass_cloud_shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

final _logger = Logger('cloud_mailbox');

@Deprecated('no longer used, only the tabbed screen is used right now')
class CloudMailboxScreen extends StatelessWidget {
  static MaterialPageRoute<void> route() => MaterialPageRoute<void>(
        settings: const RouteSettings(name: '/cloud_mailbox/'),
        builder: (_) => CloudMailboxScreen(),
      );

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<AuthPassCloudBloc>();
    final loc = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(loc.mailMailboxesTitle),
      ),
      body: CloudMailboxList(bloc: bloc),
      floatingActionButton: Builder(
        builder: (context) => FloatingActionButton.extended(
          icon: const Icon(Icons.add),
          label: Text(loc.mailboxCreateButtonLabel),
          onPressed: () async {
            final result = await (SimplePromptDialog(
              labelText: loc.mailboxNameInputLabel,
            )).show(context);
            if (result != null) {
              await bloc.createMailbox(label: result);
            }
          },
        ),
      ),
    );
  }
}

class CloudMailboxTabScreen extends StatefulWidget {
  static MaterialPageRoute<void> route() => MaterialPageRoute<void>(
        settings: const RouteSettings(name: '/cloud_mailbox_tab/'),
        builder: (_) => CloudMailboxTabScreen(),
      );

  @override
  _CloudMailboxTabScreenState createState() => _CloudMailboxTabScreenState();
}

class _CloudMailboxTabScreenState extends State<CloudMailboxTabScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: 1,
    );
    _tabController!.addListener(_tabChanged);
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  void _tabChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<AuthPassCloudBloc>();
    final loc = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.mailScreenTitle),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              text: loc.mailTabBarTitleMailbox,
              icon: const Icon(FontAwesomeIcons.boxOpen),
            ),
            Tab(
              text: loc.mailTabBarTitleMail,
              icon: const Icon(FontAwesomeIcons.mailBulk),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          CloudMailboxList(bloc: bloc),
          CloudMailList(bloc: bloc),
        ],
      ),
      floatingActionButton: _tabController!.index == 0
          ? FloatingActionButton.extended(
              onPressed: () async {
                final result = await (SimplePromptDialog(
                  title: loc.mailboxNameInputDialogTitle,
                  labelText: loc.mailboxNameInputLabel,
                )).show(context);
                if (result != null) {
                  await bloc.createMailbox(label: result);
                }
              },
              icon: const Icon(Icons.add),
              label: Text(loc.mailboxCreateButtonLabel),
            )
          : null,
    );
  }
}

class CloudMailboxList extends StatelessWidget {
  const CloudMailboxList({Key? key, required this.bloc}) : super(key: key);

  final AuthPassCloudBloc bloc;

  @override
  Widget build(BuildContext context) {
    final formatUtil = context.watch<FormatUtils>();
    final kdbxBloc = context.watch<KdbxBloc>();
    final commonFields = context.watch<CommonFields>();
    final loc = AppLocalizations.of(context);
    // TODO only clear on demand (ie. when something changes in the kdbx file).
    _logger.fine('clearing entry lookup.');
    kdbxBloc.clearEntryByUuidLookup();
    return RefreshIndicator(
      onRefresh: () async => await bloc.mailboxList.reload(),
      child: RetryStreamBuilder<MailboxList>(
          stream: (context) => bloc.mailboxList,
          retry: () async => await bloc.mailboxList.reload(),
          builder: (context, mailboxList) {
            final data = mailboxList.mailboxes!;
            if (data.isEmpty) {
              return Center(
                child: Text(loc.mailMailboxListEmpty),
              );
            }
            return ListView.builder(
              itemBuilder: (context, idx) {
                final mailbox = data[idx];
                final vm =
                    _labelFor(loc, kdbxBloc, commonFields, formatUtil, mailbox);
                return ListTile(
                  leading: Icon(vm.icon,
                      color: mailbox.isDisabled ? Colors.black12 : null),
                  title: Text(vm.label),
                  subtitle: Text(
                    mailbox.address,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () async {
                    await Clipboard.setData(
                        ClipboardData(text: mailbox.address));
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar(reason: SnackBarClosedReason.hide)
                      ..showSnackBar(
                        SnackBar(
                          content: Text(
                              loc.mailMailboxAddressCopied(mailbox.address)),
                        ),
                      );
                  },
                  onLongPress: () async {
                    final action = await showModalBottomSheet<VoidCallback>(
                      context: context,
                      builder: (context) => Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            leading: const Icon(Icons.delete),
                            title: Text(loc.deleteAction),
                            onTap: () async {
                              Navigator.of(context).pop();
                              await bloc.deleteMailbox(mailbox);
                            },
                          ),
                          mailbox.isDisabled
                              ? ListTile(
                                  leading:
                                      const Icon(FontAwesomeIcons.volumeUp),
                                  title: Text(loc.mailboxEnableLabel),
                                  subtitle: Text(loc.mailboxEnableHint),
                                  onTap: () async {
                                    Navigator.of(context).pop();
                                    await bloc.updateMailbox(
                                      mailbox,
                                      isDisabled: false,
                                    );
                                  },
                                )
                              : ListTile(
                                  leading:
                                      const Icon(FontAwesomeIcons.volumeMute),
                                  title: Text(loc.mailboxDisableLabel),
                                  subtitle: Text(loc.mailboxDisableHint),
                                  onTap: () async {
                                    Navigator.of(context).pop();
                                    await bloc.updateMailbox(mailbox,
                                        isDisabled: true);
                                  },
                                ),
                        ],
                      ),
                    );
                    if (action != null) {
                      action();
                    }
                  },
                );
              },
              itemCount: data.length,
            );
          }),
    );
  }

  MailboxViewModel _labelFor(AppLocalizations loc, KdbxBloc kdbxBloc,
      CommonFields commonFields, FormatUtils formatUtils, Mailbox mailbox) {
    if (mailbox.entryUuid.isNotEmpty) {
      final entry = kdbxBloc.findEntryByUuid(mailbox.entryUuid);

      if (entry != null) {
        final label = entry.label;
        if (label != null) {
          return MailboxViewModel(
            PredefinedIcons.iconFor(entry.icon.get()!),
            loc.mailboxLabelPrefixForEntry(label),
          );
        }
        return MailboxViewModel(
          PredefinedIcons.iconFor(entry.icon.get()!),
          loc.mailboxLabelPrefixUnknownEntry(mailbox.entryUuid),
        );
      }
    } else if (mailbox.label.isNotEmpty == true) {
      return MailboxViewModel(FontAwesomeIcons.boxOpen, mailbox.label);
    }
    return MailboxViewModel(
      FontAwesomeIcons.boxOpen,
      loc.mailboxLabelPrefixCreatedAt(
          formatUtils.formatDateFull(mailbox.createdAt)),
    );
  }
}

class MailboxViewModel {
  MailboxViewModel(this.icon, this.label);

  final IconData icon;
  final String label;
}

class CloudMailList extends StatelessWidget {
  const CloudMailList({Key? key, required this.bloc}) : super(key: key);

  final AuthPassCloudBloc bloc;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return RefreshIndicator(
      onRefresh: () async {
        await bloc.loadMessageListMore(reload: true);
      },
      child: RetryStreamBuilder<EmailMessageList>(
          stream: (context) => bloc.messageList,
          retry: () => bloc.loadMessageListMore(),
          builder: (context, data) {
            if (data.messages.isEmpty) {
              if (data.hasMore) {
                bloc.loadMessageListMore();
                return const Center(child: CircularProgressIndicator());
              }
              return Center(
                child: Text(loc.mailListNoMail),
              );
            }
            return ListView.builder(
              itemCount: data.messages.length,
              itemBuilder: (context, idx) {
                if (idx + 1 == data.messages.length) {
                  bloc.loadMessageListMore();
                }
                final message = data.messages[idx];
                return MailListTile(
                  message: message,
                  onTap: () async {
                    await Navigator.of(context)
                        .push(EmailReadScreen.route(bloc, message));
                  },
                );
              },
            );
          }),
    );
  }
}

class MailListTile extends StatelessWidget {
  const MailListTile({Key? key, required this.message, this.onTap})
      : super(key: key);

  final EmailMessage message;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final formatUtil = context.watch<FormatUtils>();
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Container(
//        height: 72,
        constraints: const BoxConstraints(minHeight: 72),
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: <Widget>[
            const SizedBox(width: 16),
            Container(
              width: 40,
              height: 40,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: message.isRead
                  ? Icon(
                      FontAwesomeIcons.envelopeOpen,
                      color: ThemeUtil.iconColor(theme, null),
                    )
                  : Icon(
                      FontAwesomeIcons.envelope,
                      color: theme.primaryColor,
                    ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(message.subject, style: theme.textTheme.subtitle1),
                  const SizedBox(height: 4),
                  Text(
                    message.sender,
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                    softWrap: false,
                    style: theme.textTheme.caption,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formatUtil.formatDateFull(message.createdAt),
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                    softWrap: false,
                    style: theme.textTheme.caption!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
          ],
        ),
      ),
    );
  }
}
