import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kdbx/kdbx.dart';

class PredefinedIcons {
  static const icons = <IconData>[
    FontAwesomeIcons.key,
    FontAwesomeIcons.earthEurope,
    FontAwesomeIcons.circleExclamation,
    FontAwesomeIcons.server,
    FontAwesomeIcons.thumbtack,
    FontAwesomeIcons.comments,
    FontAwesomeIcons.puzzlePiece,
    FontAwesomeIcons.pencil,
    FontAwesomeIcons.plug,
    FontAwesomeIcons.newspaper,
    FontAwesomeIcons.paperclip,
    FontAwesomeIcons.camera,
    FontAwesomeIcons.wifi,
    FontAwesomeIcons.link,
    FontAwesomeIcons.batteryThreeQuarters,
    FontAwesomeIcons.barcode,
    FontAwesomeIcons.certificate,
    FontAwesomeIcons.bullseye,
    FontAwesomeIcons.desktop,
    FontAwesomeIcons.envelopeOpen,
    FontAwesomeIcons.gear,
    FontAwesomeIcons.clipboard,
    FontAwesomeIcons.paperPlane,
    FontAwesomeIcons.tv,
    FontAwesomeIcons.bolt,
    FontAwesomeIcons.inbox,
    FontAwesomeIcons.floppyDisk,
    FontAwesomeIcons.hardDrive,
    FontAwesomeIcons.circleDot,
    FontAwesomeIcons.expeditedssl,
    FontAwesomeIcons.terminal,
    FontAwesomeIcons.print,
    FontAwesomeIcons.signsPost,
    FontAwesomeIcons.flagCheckered,
    FontAwesomeIcons.wrench,
    FontAwesomeIcons.laptop,
    FontAwesomeIcons.boxArchive,
    FontAwesomeIcons.creditCard,
    FontAwesomeIcons.rectangleXmark,
    FontAwesomeIcons.clock,
    FontAwesomeIcons.magnifyingGlass,
    FontAwesomeIcons.flask,
    FontAwesomeIcons.gamepad,
    FontAwesomeIcons.trash,
    FontAwesomeIcons.noteSticky,
    FontAwesomeIcons.ban,
    FontAwesomeIcons.circleQuestion,
    FontAwesomeIcons.cube,
    FontAwesomeIcons.folder,
    FontAwesomeIcons.folderOpen,
    FontAwesomeIcons.database,
    FontAwesomeIcons.unlockKeyhole,
    FontAwesomeIcons.lock,
    FontAwesomeIcons.check,
    FontAwesomeIcons.pencil,
    FontAwesomeIcons.imagePortrait,
    FontAwesomeIcons.book,
    FontAwesomeIcons.rectangleList,
    FontAwesomeIcons.userSecret,
    FontAwesomeIcons.utensils,
    FontAwesomeIcons.house,
    FontAwesomeIcons.star,
    FontAwesomeIcons.linux,
    FontAwesomeIcons.mapPin,
    FontAwesomeIcons.apple,
    FontAwesomeIcons.wikipediaW,
    FontAwesomeIcons.dollarSign,
    FontAwesomeIcons.calendar,
    FontAwesomeIcons.mobile,
  ];

  static IconData iconFor(KdbxIcon icon) {
    return icons[icon.index]; // ?? FontAwesomeIcons.users;
  }

  static IconData iconForGroup(KdbxIcon icon) {
    return icons[icon.index]; // ?? FontAwesomeIcons.folder;
  }
}
