import 'package:string_literal_finder_annotations/string_literal_finder_annotations.dart';

class AppConstants {
  static const authPass = 'AuthPass'; // NON-NLS
  static const authPassCloud = 'AuthPass Cloud'; // NON-NLS

  static const routeOpenFile = '/openFile'; // NON-NLS
  static const routeOpenFileParamFile = 'file'; // NON-NLS
  static const routeOpen = '/open'; // NON-NLS

  static const kdbxExtension = '.kdbx'; // NON-NLS
  static const pngExtension = '.png'; // NON-NLS
  static const pngExtensionNoDot = 'png'; // NON-NLS

  static const contentTypeTextPlain = 'text/plain'; // NON-NLS
}

class CharConstants {
  static const empty = ''; // NON-NLS
  static const underScore = '_'; // NON-NLS
  static const plus = '+'; // NON-NLS

  static const space = ' '; // NON-NLS
  static const curlyOpen = '{'; // NON-NLS

  static const chevronRight = ' » '; // NON-NLS

  static const slash = '/'; // NON-NLS
  static const newLine = '\n'; // NON-NLS

  static const colon = ':'; // NON-NLS

  static const semiColon = ';'; // NON-NLS

  static const equalSign = '='; // NON-NLS
}

class AssetConstants {
  @NonNls
  static const imageOnboardingHeader = 'assets/images/onboarding-header.webp';
  @NonNls
  static const imageOnboardingButtonOpen = 'assets/images/safe-filled-v2.webp';

  @NonNls
  static String imageOnboardingButtonCreate =
      'assets/images/safe-empty-v2.webp';
}

class UrlConstants {
  static const forumUrl = 'https://forum.authpass.app/'; // NON-NLS
}
