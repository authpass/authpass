//
//  Generated file. Do not edit.
//

#include "generated_plugin_registrant.h"

#include <argon2_ffi/argon2_ffi_plugin.h>
#include <biometric_storage/biometric_storage_plugin.h>
#include <file_chooser/file_chooser_plugin.h>
#include <url_launcher_linux/url_launcher_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) argon2_ffi_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "Argon2FfiPlugin");
  argon2_ffi_plugin_register_with_registrar(argon2_ffi_registrar);
  g_autoptr(FlPluginRegistrar) biometric_storage_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "BiometricStoragePlugin");
  biometric_storage_plugin_register_with_registrar(biometric_storage_registrar);
  g_autoptr(FlPluginRegistrar) file_chooser_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "FileChooserPlugin");
  file_chooser_plugin_register_with_registrar(file_chooser_registrar);
  g_autoptr(FlPluginRegistrar) url_launcher_linux_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "UrlLauncherPlugin");
  url_launcher_plugin_register_with_registrar(url_launcher_linux_registrar);
}
