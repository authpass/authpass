import 'package:authpass/bloc/kdbx/file_source.dart';
import 'package:authpass/utils/authpassicons.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

extension FileSourceIconUi on FileSourceIcon {
  IconData get iconData {
    switch (this) {
      case FileSourceIcon.dropbox:
        return FontAwesomeIcons.dropbox;
      case FileSourceIcon.googleDrive:
        return FontAwesomeIcons.googleDrive;
      case FileSourceIcon.webDav:
        return FontAwesomeIcons.cloudArrowUp;
      case FileSourceIcon.oneDrive:
        return FontAwesomeIcons.microsoft;
      case FileSourceIcon.hdd:
        return FontAwesomeIcons.hardDrive;
      case FileSourceIcon.externalLink:
        return FontAwesomeIcons.upRightFromSquare;
      case FileSourceIcon.authPass:
        return AuthPassIcons.AuthPassLogo;
      case FileSourceIcon.S3:
        return AuthPassIcons.AuthPassLogo;
    }
    // throw StateError('Invalid icon: $this');
  }
}
