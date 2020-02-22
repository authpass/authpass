//
//  Generated file. Do not edit.
//

import FlutterMacOS
import Foundation

import argon2_ffi
import biometric_storage
import file_chooser
import macos_secure_bookmarks
import package_info_macos
import path_provider_macos
import url_launcher_macos

func RegisterGeneratedPlugins(registry: FlutterPluginRegistry) {
  Argon2FfiPlugin.register(with: registry.registrar(forPlugin: "Argon2FfiPlugin"))
  BiometricStorageMacOSPlugin.register(with: registry.registrar(forPlugin: "BiometricStorageMacOSPlugin"))
  FileChooserPlugin.register(with: registry.registrar(forPlugin: "FileChooserPlugin"))
  SecureBookmarksPlugin.register(with: registry.registrar(forPlugin: "SecureBookmarksPlugin"))
  PackageInfoMacosPlugin.register(with: registry.registrar(forPlugin: "PackageInfoMacosPlugin"))
  PathProviderPlugin.register(with: registry.registrar(forPlugin: "PathProviderPlugin"))
  UrlLauncherPlugin.register(with: registry.registrar(forPlugin: "UrlLauncherPlugin"))
}
