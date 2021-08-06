import 'dart:async';
import 'dart:typed_data';

import 'package:authpass/ui/widgets/centered_icon.dart';
import 'package:authpass/utils/constants.dart';
import 'package:authpass/utils/dialog_utils.dart';
import 'package:authpass/utils/extension_methods.dart';
import 'package:authpass/utils/platform.dart';
import 'package:authpass/utils/predefined_icons.dart';
import 'package:file_picker_writable/file_picker_writable.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kdbx/kdbx.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart' as path;

part 'icon_selector.freezed.dart';

final _logger = Logger('authpass.icon_selector');

class IconSelectorDialog extends StatefulWidget {
  const IconSelectorDialog({Key? key, this.initialSelection, this.kdbxFile})
      : super(key: key);

  final SelectedIcon? initialSelection;
  final KdbxFile? kdbxFile;

  @override
  _IconSelectorDialogState createState() => _IconSelectorDialogState();

  static Future<SelectedIcon?> show(BuildContext context,
      {SelectedIcon? initialSelection, KdbxFile? kdbxFile}) {
    return showDialog<SelectedIcon>(
      context: context,
      builder: (context) => IconSelectorDialog(
        initialSelection: initialSelection,
        kdbxFile: kdbxFile,
      ),
    );
  }
}

class _IconSelectorDialogState extends State<IconSelectorDialog> {
  final _selectorKey = GlobalKey<_IconSelectorState>();

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final matLoc = MaterialLocalizations.of(context);
    return AlertDialog(
      content: IconSelector(
        key: _selectorKey,
        initialSelection: widget.initialSelection,
        kdbxFile: widget.kdbxFile,
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
            Navigator.of(context).pop(_selectorKey.currentState!._selection);
          },
          child: Text(loc.selectIconDialogAction),
        ),
      ],
    );
  }
}

class IconSelector extends StatefulWidget {
  const IconSelector(
      {Key? key, required this.initialSelection, required this.kdbxFile})
      : super(key: key);

  final SelectedIcon? initialSelection;
  final KdbxFile? kdbxFile;

  @override
  _IconSelectorState createState() => _IconSelectorState();
}

class _IconSelectorState extends State<IconSelector> {
  SelectedIcon? _selection;
  KdbxFile? _kdbxFile;

  @override
  void initState() {
    super.initState();
    _selection = widget.initialSelection;
    _kdbxFile = widget.kdbxFile;
  }

  @override
  Widget build(BuildContext context) {
//    return LayoutBuilder(builder: (context, constraints) {
    final mq = MediaQuery.of(context);
    final width = mq.size.width * 0.8;
    return SizedBox(
      width: width,
      height: mq.size.height * 0.8,
      child: GridView.count(
        crossAxisCount: width ~/ 80,
        children: <Widget>[
          InkWell(
            onTap: () {
              _readFile();
            },
            child: const Icon(FontAwesomeIcons.plus),
          ),
          ..._kdbxFile!.body.meta.customIcons.values
              .map((value) => IconSelectorCustomIcon(
                  iconData: value.data,
                  isSelected: _checkSelected(_selection!, value),
                  onTap: () {
                    _logger.fine('Selected custom icon.');
                    setState(() => _selection = SelectedIcon.custom(value));
                  })),
          ...KdbxIcon.values.map((icon) => IconSelectorIcon(
                iconData: PredefinedIcons.iconFor(icon),
                isSelected: _checkSelected(_selection!, icon),
                onTap: () {
                  _logger.fine('Selected icon $icon');
                  setState(() => _selection = SelectedIcon.predefined(icon));
                },
              )),
        ],
      ),
    );
//    });
  }

  bool _checkSelected(SelectedIcon selection, dynamic value) {
    final predefined = selection.map(
      predefined: (value) => value.icon,
      custom: (value) => null,
    );
    final custom = selection.map(
      predefined: (value) => null,
      custom: (value) => value.custom,
    );
    final selectedIconKdbx = custom ?? predefined;
    return value == selectedIconKdbx;
  }

  Future<void> _readFile() async {
    if (AuthPassPlatform.isIOS || AuthPassPlatform.isAndroid) {
      await FilePickerWritable().openFile((fileInfo, file) async {
        final fileName = fileInfo.fileName ?? file.path;
        final bytes = await file.readAsBytes();
        await _savePngFile(fileName, bytes);
        return fileInfo;
      });
    } else {
      final loc = AppLocalizations.of(context);
      final typeGroup = XTypeGroup(
        label: loc.fileTypePngs,
        // extensions: ['jpg', 'png', 'jpeg', 'gif'],
        extensions: [AppConstants.pngExtensionNoDot],
      );
      final file = await openFile(acceptedTypeGroups: [typeGroup]);
      if (file != null) {
        final fileName = path.basename(file.path);
        final bytes = await file.readAsBytes();
        await _savePngFile(fileName, bytes);
      }
    }
  }

  Future<void> _savePngFile(String fileName, Uint8List bytes) async {
    final loc = AppLocalizations.of(context);
    if (!fileName.toLowerCase().endsWith(AppConstants.pngExtension)) {
      await DialogUtils.showSimpleAlertDialog(
        context,
        null,
        loc.notPngError,
        routeAppend: 'customIconPngError',
      );
      return;
    }
    if (bytes.lengthInBytes > 10 * 1024) {
      if (!await DialogUtils.showConfirmDialog(
        context: context,
        params: ConfirmDialogParams(
          content: loc.iconPngSizeWarning,
        ),
      )) {
        return;
      }
    }
    final newIcon = KdbxCustomIcon(uuid: KdbxUuid.random(), data: bytes);
    setState(() {
      _kdbxFile!.body.meta.addCustomIcon(newIcon);
      _selection = SelectedIcon.custom(newIcon);
    });
  }
}

class IconSelectorIcon extends StatelessWidget {
  const IconSelectorIcon({
    Key? key,
    this.iconData,
    this.isSelected,
    this.onTap,
  }) : super(key: key);

  final IconData? iconData;
  final bool? isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Ink(
      color: isSelected! ? theme.primaryColorLight : null,
      child: InkWell(
        onTap: onTap,
        child: Icon(iconData, color: isSelected! ? null : theme.primaryColor),
      ),
    );
  }
}

class IconSelectorCustomIcon extends StatelessWidget {
  const IconSelectorCustomIcon({
    Key? key,
    this.iconData,
    this.isSelected,
    this.onTap,
  }) : super(key: key);

  final Uint8List? iconData;
  final bool? isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconTheme = IconTheme.of(context);
    final iconSize = iconTheme.size;

    return Ink(
      color: isSelected! ? theme.primaryColorLight : null,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.memory(
            iconData!,
            width: iconSize,
            height: iconSize,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}

@freezed
class SelectedIcon with _$SelectedIcon {
  const factory SelectedIcon.predefined(KdbxIcon icon) =
      _SelectedIconPredefined;

  const factory SelectedIcon.custom(KdbxCustomIcon custom) =
      _SelectedIconCustom;

  factory SelectedIcon.fromObject(KdbxObject object) =>
      (object.customIcon?.let((custom) => SelectedIcon.custom(custom)) ??
          object.icon.get()?.let((icon) => SelectedIcon.predefined(icon)))!;
}

class IconSelectorFormField extends StatelessWidget {
  const IconSelectorFormField({
    Key? key,
    required this.initialValue,
    required this.onSaved,
    required this.kdbxFile,
    this.onChanged,
  }) : super(key: key);
  final SelectedIcon initialValue;
  final KdbxFile? kdbxFile;
  final void Function(SelectedIcon? icon) onSaved;
  final void Function(SelectedIcon icon)? onChanged;

  @override
  Widget build(BuildContext context) {
    return FormField<SelectedIcon>(
      builder: (formFieldState) {
        final theme = Theme.of(context);
        final value = formFieldState.value!;

        const iconSize = 48.0;
        return Card(
          elevation: 8,
          child: InkWell(
            onTap: () async {
              final newIcon = await IconSelectorDialog.show(context,
                  initialSelection: value, kdbxFile: kdbxFile);
              if (newIcon != null) {
                final change = newIcon;
                formFieldState.didChange(change);
                onChanged?.call(change);
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                height: 64,
                width: 64,
                child: Align(
                  alignment: Alignment.center,
                  child: value.map(
                    predefined: (predefined) => CenteredIcon(
                      icon: PredefinedIcons.iconFor(predefined.icon),
                      size: iconSize,
                      color: theme.primaryColor,
                    ),
                    custom: (custom) => Image.memory(
                      custom.custom.data,
                      width: iconSize,
                      height: iconSize,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
      initialValue: initialValue,
      onSaved: onSaved,
    );
  }
}
