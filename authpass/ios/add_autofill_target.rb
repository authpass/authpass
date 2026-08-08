# Adds the AuthPassAutofill credential provider extension to Runner.xcodeproj.
#
#   cd authpass/ios && bundle exec ruby add_autofill_target.rb
#
# Idempotent: re-running replaces the target rather than duplicating it, so it
# doubles as the way to apply changes to the target's configuration.
#
# Scripted rather than hand edited because project.pbxproj merges badly and a
# credential provider needs a fair amount of wiring: its own deployment target
# (17.0, while the app is still on 13.0), the embed-appex build phase, and the
# frameworks from the headless Flutter module.
#
# Signing is left on automatic. Provisioning for the real bundle ids, the app
# group and the autofill capability is a phase 1 job — do not point this at the
# match profiles.

require 'xcodeproj'

PROJECT_PATH = 'Runner.xcodeproj'
TARGET_NAME = 'AuthPassAutofill'
SOURCE_DIR = 'AuthPassAutofill'
FIXTURES_DIR = File.join(SOURCE_DIR, 'Fixtures')
# Built by autofill_module/build_ios_framework.sh
MODULE_FRAMEWORKS = '../../autofill_module/build/framework/Release'
DEPLOYMENT_TARGET = '17.0'

project = Xcodeproj::Project.open(PROJECT_PATH)
app_target = project.targets.find { |t| t.name == 'Runner' }
raise 'Runner target not found' unless app_target

# --- start from scratch if we ran before -------------------------------------

existing = project.targets.select { |t| t.name == TARGET_NAME }
existing.each do |target|
  puts "removing existing target #{target.name}"
  app_target.dependencies.delete_if { |d| d.target == target }
  app_target.build_phases.grep(Xcodeproj::Project::Object::PBXCopyFilesBuildPhase)
            .select { |phase| phase.name == 'Embed App Extensions' }
            .each do |phase|
    phase.files.select { |f| f.display_name == "#{TARGET_NAME}.appex" }
         .each { |f| phase.remove_build_file(f) }
  end
  target.remove_from_project
end
project.main_group.children
       .select { |g| g.respond_to?(:name) && [TARGET_NAME, 'AutofillModuleFrameworks'].include?(g.name) }
       .each(&:remove_from_project)

# --- the target ---------------------------------------------------------------

target = project.new_target(
  :app_extension, TARGET_NAME, :ios, DEPLOYMENT_TARGET, nil, :swift
)

group = project.main_group.new_group(TARGET_NAME, SOURCE_DIR)

sources = Dir.glob("#{SOURCE_DIR}/*.swift").sort
raise "no swift sources in #{SOURCE_DIR}" if sources.empty?

sources.each do |path|
  file = group.new_reference(File.basename(path))
  target.add_file_references([file])
end

group.new_reference('Info.plist')
group.new_reference("#{TARGET_NAME}.entitlements")

# --- the spike fixture --------------------------------------------------------

fixtures = Dir.glob("#{FIXTURES_DIR}/*").sort
if fixtures.empty?
  warn "no fixtures in #{FIXTURES_DIR} — the spike will report a missing vault."
  warn 'generate one: cd ../../autofill_module && dart run tool/generate_test_vault.dart'
else
  fixture_group = group.new_group('Fixtures', 'Fixtures')
  resources = fixtures.map { |path| fixture_group.new_reference(File.basename(path)) }
  target.add_resources(resources)
end

# --- the flutter module -------------------------------------------------------

# directly under main_group: a nested group would prepend its parent's path.
frameworks_group = project.main_group.new_group(
  'AutofillModuleFrameworks', MODULE_FRAMEWORKS
)
%w[Flutter.xcframework App.xcframework].each do |name|
  unless File.exist?(File.join(File.dirname(PROJECT_PATH), MODULE_FRAMEWORKS, name))
    warn "missing #{name} — run autofill_module/build_ios_framework.sh"
  end
  reference = frameworks_group.new_reference(name)
  build_file = target.frameworks_build_phase.add_file_reference(reference)
  # embed, and let the linker find it
  embed = target.build_phases.find do |phase|
    phase.is_a?(Xcodeproj::Project::Object::PBXCopyFilesBuildPhase) &&
      phase.name == 'Embed Frameworks'
  end
  embed ||= begin
    phase = target.new_copy_files_build_phase('Embed Frameworks')
    phase.symbol_dst_subfolder_spec = :frameworks
    phase
  end
  embedded = embed.add_file_reference(reference)
  embedded.settings = { 'ATTRIBUTES' => ['CodeSignOnCopy', 'RemoveHeadersOnCopy'] }
  build_file.settings = { 'ATTRIBUTES' => ['Required'] }
end

# --- build settings -----------------------------------------------------------

target.build_configurations.each do |config|
  settings = config.build_settings
  settings['PRODUCT_BUNDLE_IDENTIFIER'] =
    "$(PRODUCT_BUNDLE_IDENTIFIER_BASE).#{TARGET_NAME}"
  settings['PRODUCT_NAME'] = TARGET_NAME
  settings['INFOPLIST_FILE'] = "#{SOURCE_DIR}/Info.plist"
  settings['CODE_SIGN_ENTITLEMENTS'] = "#{SOURCE_DIR}/#{TARGET_NAME}.entitlements"
  settings['IPHONEOS_DEPLOYMENT_TARGET'] = DEPLOYMENT_TARGET
  settings['SWIFT_VERSION'] = '5.0'
  settings['CODE_SIGN_STYLE'] = 'Automatic'
  settings['DEVELOPMENT_TEAM'] = '64ZPC769JY'
  settings['TARGETED_DEVICE_FAMILY'] = '1,2'
  settings['SKIP_INSTALL'] = 'YES'
  settings['FRAMEWORK_SEARCH_PATHS'] = ['$(inherited)', "$(PROJECT_DIR)/#{MODULE_FRAMEWORKS}"]
  # the whole point of the extension safe engine
  settings['APPLICATION_EXTENSION_API_ONLY'] = 'YES'
  settings['ENABLE_BITCODE'] = 'NO'
end

# the app targets already vary the bundle id per configuration; mirror it so
# debug builds of the app get the debug extension.
app_target.build_configurations.each do |app_config|
  base = app_config.build_settings['PRODUCT_BUNDLE_IDENTIFIER']
  next if base.nil?

  app_config.build_settings['PRODUCT_BUNDLE_IDENTIFIER_BASE'] = base
  config = target.build_configurations.find { |c| c.name == app_config.name }
  next if config.nil?

  config.build_settings['PRODUCT_BUNDLE_IDENTIFIER'] = "#{base}.#{TARGET_NAME}"
end

# --- embed into the app -------------------------------------------------------

app_target.add_dependency(target)

embed_phase = app_target.build_phases.find do |phase|
  phase.is_a?(Xcodeproj::Project::Object::PBXCopyFilesBuildPhase) &&
    phase.name == 'Embed App Extensions'
end
embed_phase ||= begin
  phase = app_target.new_copy_files_build_phase('Embed App Extensions')
  phase.symbol_dst_subfolder_spec = :plug_ins
  phase
end

# new_copy_files_build_phase appends, which lands after flutter's "Thin Binary"
# script. That script declares Runner.app as an output while this phase writes
# into it, and xcode calls the result a dependency cycle. Move it ahead of the
# scripts — which is where xcode puts this phase for a plain app with an
# extension anyway.
app_target.build_phases.delete(embed_phase)
app_target.build_phases.insert(
  app_target.build_phases.index(app_target.resources_build_phase) + 1,
  embed_phase
)
appex = embed_phase.add_file_reference(target.product_reference)
appex.settings = { 'ATTRIBUTES' => ['RemoveHeadersOnCopy'] }

project.save

puts "added #{TARGET_NAME} (deployment target #{DEPLOYMENT_TARGET})"
puts 'bundle ids:'
target.build_configurations.each do |config|
  puts "  #{config.name}: #{config.build_settings['PRODUCT_BUNDLE_IDENTIFIER']}"
end
