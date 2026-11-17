pluginManagement {
    fun flutterSdkPath(): String {
        val properties = java.util.Properties()
        java.io.File("local.properties").inputStream().use { properties.load(it) }
        val flutterSdkPath = properties.getProperty("flutter.sdk")
        assert(flutterSdkPath != null) { "flutter.sdk not set in local.properties" }
        return flutterSdkPath
    }
    settings.extra.set("flutterSdkPath", flutterSdkPath())

    includeBuild("${settings.extra.get("flutterSdkPath")}/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    // The versions Flutter 3.50 templates, see
    // flutter_tools/lib/src/android/gradle_utils.dart. The Flutter Gradle
    // plugin is compiled against AGP 9, so 8.11 failed on a missing
    // ApplicationExtension.getDefaultConfig().
    id("com.android.application") version "9.3.1" apply false
    id("org.jetbrains.kotlin.android") version "2.4.20" apply false
}

include(":app")
