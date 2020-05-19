//
//  Generated file. Do not edit.
//

import FlutterMacOS
import Foundation

import argon2_ffi
import file_chooser
import package_info
import biometric_storage
import path_provider_macos
import url_launcher_macos
import macos_secure_bookmarks

func RegisterGeneratedPlugins(registry: FlutterPluginRegistry) {
  Argon2FfiPlugin.register(with: registry.registrar(forPlugin: "Argon2FfiPlugin"))
  FileChooserPlugin.register(with: registry.registrar(forPlugin: "FileChooserPlugin"))
  FLTPackageInfoPlugin.register(with: registry.registrar(forPlugin: "FLTPackageInfoPlugin"))
  BiometricStorageMacOSPlugin.register(with: registry.registrar(forPlugin: "BiometricStorageMacOSPlugin"))
  PathProviderPlugin.register(with: registry.registrar(forPlugin: "PathProviderPlugin"))
  UrlLauncherPlugin.register(with: registry.registrar(forPlugin: "UrlLauncherPlugin"))
  SecureBookmarksPlugin.register(with: registry.registrar(forPlugin: "SecureBookmarksPlugin"))
}
