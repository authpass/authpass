//
// Generated file. Do not edit.
//

// ignore: unused_import
import 'dart:ui';

import 'package:biometric_storage/biometric_storage_web.dart';
import 'package:url_launcher_web/url_launcher_web.dart';
import 'package:video_player_web/video_player_web.dart';

import 'package:flutter_web_plugins/flutter_web_plugins.dart';

// ignore: public_member_api_docs
void registerPlugins(PluginRegistry registry) {
  BiometricStoragePluginWeb.registerWith(registry.registrarFor(BiometricStoragePluginWeb));
  UrlLauncherPlugin.registerWith(registry.registrarFor(UrlLauncherPlugin));
  VideoPlayerPlugin.registerWith(registry.registrarFor(VideoPlayerPlugin));
  registry.registerMessageHandler();
}
