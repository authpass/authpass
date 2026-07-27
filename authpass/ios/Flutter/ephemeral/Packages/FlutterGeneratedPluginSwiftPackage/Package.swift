// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.
//
// Generated file. Do not edit.
//

import PackageDescription

let package = Package(
    name: "FlutterGeneratedPluginSwiftPackage",
    platforms: [
        .iOS("13.0")
    ],
    products: [
        .library(name: "FlutterGeneratedPluginSwiftPackage", type: .static, targets: ["FlutterGeneratedPluginSwiftPackage"])
    ],
    dependencies: [
        .package(name: "audio_session", path: "../.packages/audio_session-0.2.3"),
        .package(name: "device_info_plus", path: "../.packages/device_info_plus-12.4.0"),
        .package(name: "file_selector_ios", path: "../.packages/file_selector_ios-0.5.3+5"),
        .package(name: "flutter_email_sender", path: "../.packages/flutter_email_sender-8.0.0"),
        .package(name: "google_sign_in_ios", path: "../.packages/google_sign_in_ios-6.3.0"),
        .package(name: "integration_test", path: "../.packages/integration_test"),
        .package(name: "just_audio", path: "../.packages/just_audio-0.10.5"),
        .package(name: "mobile_scanner", path: "../.packages/mobile_scanner-7.2.0"),
        .package(name: "package_info_plus", path: "../.packages/package_info_plus-9.0.1"),
        .package(name: "share_plus", path: "../.packages/share_plus-12.0.2"),
        .package(name: "shared_preferences_foundation", path: "../.packages/shared_preferences_foundation-2.5.6"),
        .package(name: "sqflite_darwin", path: "../.packages/sqflite_darwin-2.4.3"),
        .package(name: "url_launcher_ios", path: "../.packages/url_launcher_ios-6.4.1"),
        .package(name: "video_player_avfoundation", path: "../.packages/video_player_avfoundation-2.9.7"),
        .package(name: "wakelock_plus", path: "../.packages/wakelock_plus-1.5.2"),
        .package(name: "webview_flutter_wkwebview", path: "../.packages/webview_flutter_wkwebview-3.26.0"),
        .package(name: "FlutterFramework", path: "../.packages/FlutterFramework")
    ],
    targets: [
        .target(
            name: "FlutterGeneratedPluginSwiftPackage",
            dependencies: [
                .product(name: "audio-session", package: "audio_session"),
                .product(name: "device-info-plus", package: "device_info_plus"),
                .product(name: "file-selector-ios", package: "file_selector_ios"),
                .product(name: "flutter-email-sender", package: "flutter_email_sender"),
                .product(name: "google-sign-in-ios", package: "google_sign_in_ios"),
                .product(name: "integration-test", package: "integration_test"),
                .product(name: "just-audio", package: "just_audio"),
                .product(name: "mobile-scanner", package: "mobile_scanner"),
                .product(name: "package-info-plus", package: "package_info_plus"),
                .product(name: "share-plus", package: "share_plus"),
                .product(name: "shared-preferences-foundation", package: "shared_preferences_foundation"),
                .product(name: "sqflite-darwin", package: "sqflite_darwin"),
                .product(name: "url-launcher-ios", package: "url_launcher_ios"),
                .product(name: "video-player-avfoundation", package: "video_player_avfoundation"),
                .product(name: "wakelock-plus", package: "wakelock_plus"),
                .product(name: "webview-flutter-wkwebview", package: "webview_flutter_wkwebview"),
                .product(name: "FlutterFramework", package: "FlutterFramework")
            ]
        )
    ]
)
