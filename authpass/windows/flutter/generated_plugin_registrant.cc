//
//  Generated file. Do not edit.
//

#include "generated_plugin_registrant.h"

#include <argon2_ffi/argon2_ffi_plugin.h>
#include <url_launcher_fde/url_launcher_plugin.h>
#include <file_chooser/file_chooser_plugin.h>
#include <path_provider_fde/path_provider_plugin.h>
#include <winsparkle_flutter/winsparkle_flutter_plugin.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  Argon2FfiPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("Argon2FfiPlugin"));
  UrlLauncherPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("UrlLauncherPlugin"));
  FileChooserPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FileChooserPlugin"));
  PathProviderPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("PathProviderPlugin"));
  WinsparkleFlutterPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("WinsparkleFlutterPlugin"));
}
