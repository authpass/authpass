//
//  Generated file. Do not edit.
//

import FlutterMacOS
import Foundation

import argon2_ffi
import biometric_storage
import file_picker_writable
import file_selector_macos
import macos_secure_bookmarks
import package_info
import path_provider_macos
import sqflite
import url_launcher_macos
import wakelock_macos

func RegisterGeneratedPlugins(registry: FlutterPluginRegistry) {
  Argon2FfiPlugin.register(with: registry.registrar(forPlugin: "Argon2FfiPlugin"))
  BiometricStorageMacOSPlugin.register(with: registry.registrar(forPlugin: "BiometricStorageMacOSPlugin"))
  FilePickerWritablePlugin.register(with: registry.registrar(forPlugin: "FilePickerWritablePlugin"))
  FileSelectorPlugin.register(with: registry.registrar(forPlugin: "FileSelectorPlugin"))
  SecureBookmarksPlugin.register(with: registry.registrar(forPlugin: "SecureBookmarksPlugin"))
  FLTPackageInfoPlugin.register(with: registry.registrar(forPlugin: "FLTPackageInfoPlugin"))
  PathProviderPlugin.register(with: registry.registrar(forPlugin: "PathProviderPlugin"))
  SqflitePlugin.register(with: registry.registrar(forPlugin: "SqflitePlugin"))
  UrlLauncherPlugin.register(with: registry.registrar(forPlugin: "UrlLauncherPlugin"))
  WakelockMacosPlugin.register(with: registry.registrar(forPlugin: "WakelockMacosPlugin"))
}
