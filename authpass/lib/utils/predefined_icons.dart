import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kdbx/kdbx.dart';

class PredefinedIcons {
  static const icons = <IconData>[
    FontAwesomeIcons.key,
    FontAwesomeIcons.globeEurope,
    FontAwesomeIcons.exclamationCircle,
    FontAwesomeIcons.server,
    FontAwesomeIcons.thumbtack,
    FontAwesomeIcons.comments,
    FontAwesomeIcons.puzzlePiece,
    FontAwesomeIcons.pencilAlt,
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
    FontAwesomeIcons.cog,
    FontAwesomeIcons.clipboard,
    FontAwesomeIcons.paperPlane,
    FontAwesomeIcons.tv,
    FontAwesomeIcons.bolt,
    FontAwesomeIcons.inbox,
    FontAwesomeIcons.save,
    FontAwesomeIcons.hdd,
    FontAwesomeIcons.dotCircle,
    FontAwesomeIcons.expeditedssl,
    FontAwesomeIcons.terminal,
    FontAwesomeIcons.print,
    FontAwesomeIcons.mapSigns,
    FontAwesomeIcons.flagCheckered,
    FontAwesomeIcons.wrench,
    FontAwesomeIcons.laptop,
    FontAwesomeIcons.archive,
    FontAwesomeIcons.creditCard,
    FontAwesomeIcons.windowClose,
    FontAwesomeIcons.clock,
    FontAwesomeIcons.search,
    FontAwesomeIcons.flask,
    FontAwesomeIcons.gamepad,
    FontAwesomeIcons.trash,
    FontAwesomeIcons.stickyNote,
    FontAwesomeIcons.ban,
    FontAwesomeIcons.questionCircle,
    FontAwesomeIcons.cube,
    FontAwesomeIcons.folder,
    FontAwesomeIcons.folderOpen,
    FontAwesomeIcons.database,
    FontAwesomeIcons.unlockAlt,
    FontAwesomeIcons.lock,
    FontAwesomeIcons.check,
    FontAwesomeIcons.pencilAlt,
    FontAwesomeIcons.portrait,
    FontAwesomeIcons.book,
    FontAwesomeIcons.listAlt,
    FontAwesomeIcons.userSecret,
    FontAwesomeIcons.utensils,
    FontAwesomeIcons.home,
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
