import 'package:authpass/bloc/kdbx/file_source.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

extension CloudStorageIconUi on CloudStorageIcon {
  IconData get iconData {
    switch (this) {
      case CloudStorageIcon.dropbox:
        return FontAwesomeIcons.dropbox;
      case CloudStorageIcon.googleDrive:
        return FontAwesomeIcons.googleDrive;
      case CloudStorageIcon.webDav:
        return FontAwesomeIcons.cloudUploadAlt;
      case CloudStorageIcon.oneDrive:
        return FontAwesomeIcons.microsoft;
      case CloudStorageIcon.hdd:
        return FontAwesomeIcons.hdd;
      case CloudStorageIcon.externalLink:
        return FontAwesomeIcons.externalLinkAlt;
    }
    throw StateError('Invalid icon: $this');
  }
}
