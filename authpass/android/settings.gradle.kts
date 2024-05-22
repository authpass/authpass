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
    id("com.android.application") version "8.4.0" apply false
    id("org.jetbrains.kotlin.android") version "1.8.10" apply false
}

include(":app")
