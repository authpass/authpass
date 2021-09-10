import 'package:authpass/bloc/analytics.dart';
import 'package:authpass/bloc/app_data.dart';
import 'package:authpass/bloc/kdbx_bloc.dart';
import 'package:authpass/env/_base.dart';
import 'package:authpass/ui/common_fields.dart';
import 'package:authpass/ui/screens/locked_screen.dart';
import 'package:authpass/ui/screens/select_file_screen.dart';
import 'package:authpass/ui/widgets/keyboard_handler.dart';
import 'package:authpass/utils/authpassicons.dart';
import 'package:authpass/utils/constants.dart';
import 'package:authpass/utils/dialog_utils.dart';
import 'package:authpass/utils/extension_methods.dart';
import 'package:authpass/utils/platform.dart';
import 'package:autofill_service/autofill_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_async_utils/flutter_async_utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:string_literal_finder_annotations/string_literal_finder_annotations.dart';

final _logger = Logger('preferences');

class PreferencesScreen extends StatelessWidget {
  static Route<void> route() => MaterialPageRoute(
        settings: const RouteSettings(name: '/preferences'),
        builder: (context) => PreferencesScreen(),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).preferenceTitle),
        actions: [PreferencesOverflowMenuAction()],
      ),
      body: Scrollbar(
        child: SingleChildScrollView(child: PreferencesBody()),
      ),
    );
  }
}

class LocaleInfo {
  LocaleInfo(@NonNls this.locale, @NonNls this.nativeName, this.translatedName);
  final String? locale;
  final String nativeName;
  final String? translatedName;
}

class PreferencesBody extends StatefulWidget {
  @override
  _PreferencesBodyState createState() => _PreferencesBodyState();
}

class _PreferencesBodyState extends State<PreferencesBody>
    with StreamSubscriberMixin {
  KdbxBloc? _kdbxBloc;

  AutofillServiceStatus? _autofillStatus;
  AutofillPreferences? _autofillPrefs;

  late AppDataBloc _appDataBloc;
  AppData? _appData;
  Analytics get _analytics => context.read<Analytics>();

  @override
  void initState() {
    super.initState();
    _doInit();
  }

  Future<void> _doInit() async {
    if (AuthPassPlatform.isWeb) {
      return;
    }
    final autofill = AutofillService();
    _autofillStatus = await autofill.status();
    if (_autofillStatus != AutofillServiceStatus.unsupported) {
      _autofillPrefs = await autofill.getPreferences();
    }
    setState(() {});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_kdbxBloc == null) {
      _kdbxBloc = Provider.of<KdbxBloc>(context);
      _appDataBloc = Provider.of<AppDataBloc>(context);
      handleSubscription(
          _appDataBloc.store.onValueChangedAndLoad.listen((appData) {
        setState(() {
          _appData = appData;
        });
      }));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_appData == null) {
      return const Text('loading'); // NON-NLS
    }
    final loc = AppLocalizations.of(context);
    final env = Provider.of<Env>(context);
    final commonFields = context.watch<CommonFields>();
    final localeInfo = [
      LocaleInfo(null, loc.preferenceSystemDefault, null),
      LocaleInfo('de', 'Deutsch', loc.german),
      LocaleInfo('en', 'English', loc.english),
      LocaleInfo('lt', 'lietuviškai', loc.lithuanian),
      LocaleInfo('ru', 'русский', loc.russian),
      LocaleInfo('uk', 'українська', loc.ukrainian),
      LocaleInfo('fr', 'Français', loc.french),
      LocaleInfo('es', 'Español', loc.spanish),
      LocaleInfo('id', 'Bahasa Indonesia', loc.indonesian),
      LocaleInfo('tr', 'Türkçe', loc.turkish),
      LocaleInfo('he', 'עִבְרִית', loc.hebrew),
      LocaleInfo('it', 'Italiano', loc.italian),
      LocaleInfo('zh', 'Chinese Simplified', loc.chineseSimplified),
      LocaleInfo('zh_TW', 'Chinese Traditional', loc.chineseTraditional),
      LocaleInfo('pt_BR', 'Portuguese, Brazilian', loc.portugueseBrazilian),
      LocaleInfo('sk', 'Slovak', loc.slovak),
      LocaleInfo('nl', 'Nederlands', loc.dutch),
    ];
    final locales =
        Map.fromEntries(localeInfo.map((e) => MapEntry(e.locale, e)));
    return Column(
      children: <Widget>[
        ...?(_autofillStatus == AutofillServiceStatus.unsupported ||
                _autofillPrefs == null
            ? null
            : [
                SwitchListTile(
                  secondary: const Icon(FontAwesomeIcons.iCursor),
                  title: Text(loc.preferenceEnableAutoFill),
                  subtitle: _autofillStatus == AutofillServiceStatus.unsupported
                      ? Text(loc.preferenceAutoFillDescription)
                      : null,
                  value: _autofillStatus == AutofillServiceStatus.enabled,
                  onChanged: _autofillStatus ==
                          AutofillServiceStatus.unsupported
                      ? null
                      : (val) async {
                          if (val) {
                            await AutofillService().requestSetAutofillService();
                          } else {
                            await AutofillService().disableAutofillServices();
                          }
                          await _doInit();
                        },
                ),
                SwitchListTile(
                  secondary: const Icon(FontAwesomeIcons.bug),
                  title: Text(loc.enableAutofillDebug),
                  subtitle: Text(loc.enableAutofillDebugSubtitle),
                  value: _autofillPrefs!.enableDebug,
                  onChanged: (val) async {
                    _logger.fine('Setting debug to $val');
                    await AutofillService()
                        .setPreferences(AutofillPreferences(enableDebug: val));
                    await _doInit();
                  },
                ),
              ]),
        ...?!AuthPassPlatform.isAndroid
            ? null
            : [
                SwitchListTile(
                  secondary: const Icon(Icons.camera_alt),
                  title: Text(loc.preferenceAllowScreenshots),
                  value: !_appData!.secureWindowOrDefault,
                  onChanged: (value) {
                    _appDataBloc.update(
                        (builder, data) => builder.secureWindow = !value);
                    _analytics.events.trackPreferences(
                        setting: 'allowScreenshots', to: '$value');
                  },
                ),
              ],
        ListTile(
          leading: const Icon(
            FontAwesomeIcons.lightbulb,
          ),
          title: Text(loc.preferenceTheme),
          trailing: _appData?.theme == null
              ? Text(loc.preferenceSystemDefault)
              : _appData?.theme == AppDataTheme.light
                  ? Text(loc.preferenceThemeLight)
                  : Text(loc.preferenceThemeDark),
          onTap: () async {
            if (_appData == null) {
              return;
            }
            final newTheme = await _appDataBloc.updateNextTheme();
            _analytics.events
                .trackPreferences(setting: 'theme', to: '$newTheme');
          },
        ),
        ValueSelectorTile(
          icon: const FaIcon(FontAwesomeIcons.arrowsAltH),
          title: Text(loc.preferenceVisualDensity),
          onChanged: (value) {
            _appDataBloc
                .update((builder, data) => builder.themeVisualDensity = value);
            _analytics.events
                .trackPreferences(setting: 'themeVisualDensity', to: '$value');
          },
          value: _appData!.themeVisualDensity,
          minValue: -4,
          maxValue: 4,
          steps: 16,
        ),
        ValueSelectorTile(
          icon: const FaIcon(FontAwesomeIcons.textHeight),
          title: Text(loc.preferenceTextScaleFactor),
          onChanged: (value) {
            _appDataBloc
                .update((builder, data) => builder.themeFontSizeFactor = value);
            _analytics.events
                .trackPreferences(setting: 'themeFontSizeFactor', to: '$value');
          },
          value: _appData!.themeFontSizeFactor,
          minValue: 0.5,
          maxValue: 2,
          valueForNull: 1,
          steps: 15,
        ),
        ...?!env.diacDefaultDisabled
            ? null
            : [
                SwitchListTile(
                    title: Text(loc.diacOptIn),
                    subtitle: Text(loc.diacOptInSubtitle),
                    value: _appData!.diacOptIn == true,
                    onChanged: (value) {
                      _appDataBloc
                          .update((builder, data) => builder.diacOptIn = value);
                    }),
              ],
        ListTile(
          leading: const FaIcon(FontAwesomeIcons.language),
          title: Text(loc.preferenceLanguage),
          trailing: Text(locales[_appData!.localeOverride]!.nativeName),
          onTap: () async {
            final result = await showDialog<LocaleInfo>(
                context: context,
                builder: (_) => SelectLanguageDialog(
                      locales: localeInfo,
                      localeOverride: _appData!.localeOverride,
                    ));
            if (result != null) {
              await _appDataBloc.update(
                  (builder, data) => builder.localeOverride = result.locale);
            }
            _analytics.events.trackPreferences(
                setting: 'localeOverride', to: result?.locale ?? 'null');
          },
        ),
        CheckboxListTile(
          secondary: const FaIcon(FontAwesomeIcons.download),
          value: _appData!.fetchWebsiteIcons ??
              env.featureFetchWebsiteIconEnabledByDefault,
          title: Text(loc.preferenceDynamicLoadIcons),
          subtitle: Text(loc.preferenceDynamicLoadIconsSubtitle(
              commonFields.url.displayName)),
          isThreeLine: true,
          onChanged: (value) {
            _logger.fine('Changed to $value');
            _analytics.events
                .trackPreferences(setting: 'fetchWebsiteIcons', to: '$value');
            _appDataBloc
                .update((builder, data) => builder.fetchWebsiteIcons = value);
          },
          tristate: false,
        ),
        CheckboxListTile(
          secondary: const FaIcon(AuthPassIcons.AuthPassLogo),
          value: _appData!.authPassCloudAttachments ??
              _appData!.authPassCloudAttachmentsOrDefault,
          title: Text(loc.preferenceAuthPassCloudAttachmentTitle),
          subtitle: Text(loc.preferenceAuthPassCloudAttachmentSubtitle),
          // subtitle: Text(loc.preferenceDynamicLoadIconsSubtitle(
          //     commonFields.url.displayName)),
          isThreeLine: true,
          onChanged: (value) {
            _logger.fine('Changed to authPassCloudAttachments: $value');
            _analytics.events.trackPreferences(
                setting: 'authPassCloudAttachments', to: '$value');
            _appDataBloc.update(
                (builder, data) => builder.authPassCloudAttachments = value);
          },
          tristate: false,
        ),
        if (KeyboardHandler.supportsSystemWideShortcuts) ...[
          CheckboxListTile(
            secondary: const Icon(Icons.desktop_mac),
            value: _appData!.systemWideShortcuts,
            title: Text(loc.preferenceEnableSystemWideShortcuts),
            subtitle: Text(loc.preferenceEnableSystemWideShortcutsHelp),
            isThreeLine: true,
            onChanged: (value) {
              _logger.fine('Changed to $value');
              _analytics.events.trackPreferences(
                  setting: 'systemWideShortcuts', to: '$value');
              _appDataBloc.update(
                  (builder, data) => builder.systemWideShortcuts = value);
            },
            tristate: false,
          ),
        ],
        ListTile(
          leading: const Icon(Icons.search),
          title: Text(loc.preferencesSearchFields),
          subtitle: _appData?.searchFields?.let((it) => Text(it)) ??
              Text(CommonFields.defaultSearchFields
                  .map((e) => e.key)
                  .join(CharConstants.comma)),
          onTap: () async {
            final value = (await SimplePromptDialog(
              title: loc.preferencesSearchFieldPromptTitle,
              labelText: loc.preferencesSearchFieldPromptLabel,
              initialValue: _appData?.searchFields ?? CharConstants.empty,
              helperText: loc.preferencesSearchFieldPromptHelp(
                CharConstants.star,
                CommonFields.defaultSearchFields
                    .map((e) => e.key)
                    .join(CharConstants.comma),
              ),
            ).show(context))
                ?.trim();
            if (value != null) {
              await _appDataBloc.update((builder, data) =>
                  builder.searchFields = value.isEmpty ? null : value);
            }
          },
        ),
      ],
    );
  }
}

class SelectLanguageDialog extends StatelessWidget {
  const SelectLanguageDialog({Key? key, this.locales, this.localeOverride})
      : super(key: key);

  final List<LocaleInfo>? locales;
  final String? localeOverride;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return SimpleDialog(
      title: Text(loc.preferenceSelectLanguage),
      children: locales!
          .map((LocaleInfo e) => RadioListTile<String?>(
                title: Text(e.nativeName),
                subtitle: e.translatedName
                    ?.takeIf((n) => n != e.nativeName)
                    ?.let((name) => Text(e.translatedName!)),
                secondary: e.locale?.let((locale) => Text(locale)),
                value: e.locale,
                groupValue: localeOverride,
                onChanged: (value) {
                  Navigator.of(context).pop(e);
                },
              ))
          .toList(),
    );
  }
}

class ValueSelectorTile extends StatelessWidget {
  const ValueSelectorTile({
    Key? key,
    required this.value,
    required this.minValue,
    required this.maxValue,
    required this.steps,
    required this.onChanged,
    this.icon,
    this.title,
    this.valueForNull = 0,
  }) : super(key: key);

  final Widget? icon;
  final Widget? title;
  final double? value;
  final double valueForNull;
  final double minValue;
  final double maxValue;
  final int steps;
  final void Function(double? value) onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final density = theme.visualDensity;
    final loc = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              icon!,
              SizedBox(width: 32 + density.horizontal * 2),
              Expanded(
                child: DefaultTextStyle(
                  style: theme.textTheme.subtitle1!,
                  child: title!,
                ),
              ),
              Text(value == null
                  ? loc.preferenceDefault
                  : value!.toStringAsFixed(2)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                icon: FaIcon(
                  FontAwesomeIcons.minusSquare,
                  semanticLabel: loc.decreaseValue,
                ),
                onPressed: () => _updateValue(-1),
              ),
              IconButton(
                icon: FaIcon(
                  FontAwesomeIcons.plusSquare,
                  semanticLabel: loc.increaseValue,
                ),
                onPressed: () => _updateValue(1),
              ),
              IconButton(
                icon: FaIcon(
                  FontAwesomeIcons.times,
                  semanticLabel: loc.resetValue,
                ),
                onPressed: () => onChanged(null),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _updateValue(int stepDirection) {
    final v = value ?? valueForNull;
    final valueStep = (maxValue - minValue) / steps;
    final newValue =
        (v + valueStep * stepDirection).clamp(minValue, maxValue).toDouble();
    if (value != newValue) {
      onChanged(newValue);
    }
  }
}

class SliderSelector extends StatefulWidget {
  const SliderSelector({
    Key? key,
    required this.initialValue,
    required this.minValue,
    required this.maxValue,
    required this.steps,
    required this.onChanged,
  }) : super(key: key);

  final double initialValue;
  final double minValue;
  final double maxValue;
  final int steps;
  final void Function(double value) onChanged;

  @override
  _SliderSelectorState createState() => _SliderSelectorState();
}

class _SliderSelectorState extends State<SliderSelector> {
  late double _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Slider(
      value: _value,
      min: widget.minValue,
      max: widget.maxValue,
      divisions: widget.steps,
      onChanged: (value) {
        setState(() {
          _value = value;
          widget.onChanged(value);
        });
      },
    );
  }
}

class PreferencesOverflowMenuAction extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final kdbxBloc = context.read<KdbxBloc>();
    final supportsBiometricKeystore = useFuture(
        kdbxBloc.quickUnlockStorage.supportsBiometricKeyStore(),
        initialData:
            kdbxBloc.quickUnlockStorage.supportsBiometricKeystoreAlready);
    return PopupMenuButton<VoidCallback>(
      itemBuilder: (context) {
        return [
          if (supportsBiometricKeystore.data == true) ...[
            PopupMenuItem(
              value: () async {
                await kdbxBloc.closeAllFiles(clearQuickUnlock: true);
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(loc.clearQuickUnlockSuccess)));
                await SelectFileScreen.navigate(context);
              },
              child: ListTile(
                leading: const Icon(FontAwesomeIcons.bug),
                title: Text(loc.clearQuickUnlock),
                subtitle: Text(loc.clearQuickUnlockSubtitle),
              ),
            ),
          ],
          if (kdbxBloc.openedFilesWithSources.isNotEmpty) ...[
            PopupMenuItem(
              value: () async {
                await kdbxBloc.closeAllFiles(clearQuickUnlock: false);
                await Navigator.of(context, rootNavigator: true)
                    .pushAndRemoveUntil(LockedScreen.route(), (_) => false);
              },
              child: ListTile(
                leading: const Icon(FontAwesomeIcons.signOutAlt),
                title: Text(loc.lockAllFiles),
              ),
            ),
          ],
        ];
      },
      onSelected: (value) => value(),
    );
  }
}
