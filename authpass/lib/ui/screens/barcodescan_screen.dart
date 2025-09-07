import 'dart:async';

import 'package:authpass/utils/constants.dart';
import 'package:authpass/utils/extension_methods.dart';
// import 'package:barcode_scan2/barcode_scan2.dart' as barcode;
import 'package:flutter/material.dart';
// import 'package:flutter_zxing/flutter_zxing.dart';
import 'package:logging/logging.dart';
import 'package:mobile_scanner/mobile_scanner.dart' as scanner;
import 'package:string_literal_finder_annotations/string_literal_finder_annotations.dart';
// import 'package:zxing_scanner/zxing_scanner.dart' as zxing;

final _logger = Logger('barcodescan_screen');

class BarcodeScanHelper {
  static Future<ScanResult> scanBarcode(
    BuildContext context, {
    String? titleText,
    List<BarcodeFormat>? formats,
  }) async {
    final ret = await Navigator.of(context).push(
      BarcodeScanScreen.route(
        titleText: titleText ?? nonNls('Scan Barcode'),
        formats: formats ?? BarcodeFormat.any,
      ),
    );
    return ret ?? ScanResultInvalid();
    // final scanOptions = barcode.ScanOptions(
    //   restrictFormat:
    //       formats?.map((e) => _barcodeMapping[e]).whereNotNull().toList() ??
    //           const [],
    // );
    // _logger.finer('Scanning ${scanOptions.restrictFormat}');
    //
    // final barcodeResult =
    //     await barcode.BarcodeScanner.scan(options: scanOptions);
    // if (barcodeResult.type == barcode.ResultType.Barcode) {
    //   final format = _toBarcodeFormat(barcodeResult.format);
    //   return ScanResultValid(barcode: (
    //     text: barcodeResult.rawContent,
    //     format: format,
    //     isValid: true,
    //   ));
    // }
    // return ScanResultInvalid();
  }

  static final _barcodeMapping = Map.fromEntries(
    scanner.BarcodeFormat.values
        .map((e) => _toBarcodeFormat(e).let((f) => MapEntry(f, e)))
        .whereNotNull(),
  );

  static BarcodeFormat _toBarcodeFormat(scanner.BarcodeFormat format) =>
      switch (format) {
        scanner.BarcodeFormat.qrCode => BarcodeFormat.qrCode,
        scanner.BarcodeFormat.aztec => BarcodeFormat.aztec,
        scanner.BarcodeFormat.code39 => BarcodeFormat.code39,
        scanner.BarcodeFormat.code93 => BarcodeFormat.code93,
        scanner.BarcodeFormat.ean8 => BarcodeFormat.ean8,
        scanner.BarcodeFormat.ean13 => BarcodeFormat.ean13,
        scanner.BarcodeFormat.code128 => BarcodeFormat.code128,
        scanner.BarcodeFormat.dataMatrix => BarcodeFormat.dataMatrix,
        scanner.BarcodeFormat.itf => BarcodeFormat.itf,
        scanner.BarcodeFormat.upcE => BarcodeFormat.upce,
        scanner.BarcodeFormat.pdf417 => BarcodeFormat.pdf417,
        _ => BarcodeFormat.unknown,
      };

  // static final _barcodeMapping = Map.fromEntries(barcode.BarcodeFormat.values
  //     .map((e) => _toBarcodeFormat(e).let((f) => MapEntry(f, e)))
  //     .whereNotNull());
  //
  // static BarcodeFormat _toBarcodeFormat(barcode.BarcodeFormat format) =>
  //     switch (format) {
  //       barcode.BarcodeFormat.qr => BarcodeFormat.qrCode,
  //       barcode.BarcodeFormat.aztec => BarcodeFormat.aztec,
  //       barcode.BarcodeFormat.code39 => BarcodeFormat.code39,
  //       barcode.BarcodeFormat.code93 => BarcodeFormat.code93,
  //       barcode.BarcodeFormat.ean8 => BarcodeFormat.ean8,
  //       barcode.BarcodeFormat.ean13 => BarcodeFormat.ean13,
  //       barcode.BarcodeFormat.code128 => BarcodeFormat.code128,
  //       barcode.BarcodeFormat.dataMatrix => BarcodeFormat.dataMatrix,
  //       barcode.BarcodeFormat.interleaved2of5 => BarcodeFormat.itf,
  //       barcode.BarcodeFormat.upce => BarcodeFormat.upce,
  //       barcode.BarcodeFormat.pdf417 => BarcodeFormat.pdf417,
  //       _ => BarcodeFormat.unknown,
  //     };
}

class BarcodeScanScreen extends StatefulWidget {
  const BarcodeScanScreen({
    super.key,
    required this.titleText,
    required this.formats,
  });

  final String titleText;
  final List<BarcodeFormat> formats;

  static Route<ScanResult> route({
    required String titleText,
    List<BarcodeFormat> formats = BarcodeFormat.any,
  }) => MaterialPageRoute(
    builder: (context) => BarcodeScanScreen(
      titleText: titleText,
      formats: formats,
    ),
  );

  @override
  State<BarcodeScanScreen> createState() => _BarcodeScanScreenState();
}

class _BarcodeScanScreenState extends State<BarcodeScanScreen>
    with WidgetsBindingObserver {
  late final scanner.MobileScannerController controller =
      scanner.MobileScannerController(
        // cameraResolution: size,
        // detectionSpeed: detectionSpeed,
        // detectionTimeoutMs: detectionTimeout,
        formats: widget.formats
            .map((e) => BarcodeScanHelper._barcodeMapping[e])
            .nonNulls
            .toList(),
        // returnImage: returnImage,
        torchEnabled: true,
        // invertImage: invertImage,
        // autoZoom: autoZoom,
      );

  @override
  void initState() {
    super.initState();
    // Start listening to lifecycle changes.
    WidgetsBinding.instance.addObserver(this);

    // Finally, start the scanner itself.
    unawaited(controller.start());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // If the controller is not ready, do not try to start or stop it.
    // Permission dialogs can trigger lifecycle changes before the controller is ready.
    if (!controller.value.hasCameraPermission) {
      return;
    }

    switch (state) {
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
        return;
      case AppLifecycleState.resumed:
        unawaited(controller.start());
        break;
      case AppLifecycleState.inactive:
        // Stop the scanner when the app is paused.
        // Also stop the barcode events subscription.
        unawaited(controller.stop());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.titleText),
      ),
      body: scanner.MobileScanner(
        controller: controller,
        onDetect: (barcodes) {
          _logger.fine('detected bar code. ${barcodes.barcodes.length}');
          if (barcodes.barcodes.isNotEmpty) {
            unawaited(controller.stop());
            final barcode = barcodes.barcodes.first;
            final scanResult = ScanResultValid(
              barcode: (
                isValid: true,
                format: BarcodeScanHelper._toBarcodeFormat(barcode.format),
                text: barcode.displayValue ?? CharConstants.empty,
              ),
            );
            Navigator.of(context).pop(scanResult);
          }
        },
        onDetectError: (error, stackTrace) {
          _logger.severe('Error while detrecting barcodes.', error, stackTrace);
        },
      ),
    );
  }

  @override
  void dispose() {
    // Stop listening to lifecycle changes.
    WidgetsBinding.instance.removeObserver(this);
    // Dispose the widget itself.
    super.dispose();
    // Finally, dispose of the controller.
    controller.dispose();
  }
}

// class BarcodeScanScreen extends StatelessWidget {
//   const BarcodeScanScreen({
//     super.key,
//     required this.titleText,
//     required this.formats,
//   });
//
//   final String titleText;
//   final List<BarcodeFormat> formats;
//
//   static Route<ScanResult> route({
//     required String titleText,
//     List<BarcodeFormat> formats = BarcodeFormat.any,
//   }) =>
//       MaterialPageRoute(
//         builder: (context) => BarcodeScanScreen(
//           titleText: titleText,
//           formats: formats,
//         ),
//       );
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(titleText),
//       ),
//       // body: zxing.ScanView(
//       //   onResult: (result) {
//       //     _logger.fine('got result: $result');
//       //     for (final r in result) {
//       //       if (r.text.isNotEmpty) {
//       //         final scanResult = ScanResultValid(
//       //           barcode: (
//       //             isValid: true,
//       //             text: r.text,
//       //             format: r.barcodeFormat.toMyFormat(),
//       //           ),
//       //         );
//       //         Navigator.of(context).pop(scanResult);
//       //       }
//       //     }
//       //   },
//       // ),
//       body: ReaderWidget(
//         codeFormat: formats.toIntValue(),
//         scannerOverlay: const DynamicScannerOverlay(
//           cutOutSize: 0.8,
//         ),
//         onScan: (result) {
//           _logger.fine('scanned: $result');
//           if (result.isValid) {
//             final scanResult = ScanResultValid(
//               barcode: (
//                 isValid: true,
//                 text: result.text ?? CharConstants.empty,
//                 format: BarcodeFormat.mapping[result.format ?? 0] ??
//                     BarcodeFormat.unknown,
//               ),
//             );
//             Navigator.of(context).pop(scanResult);
//           }
//         },
//       ),
//     );
//   }
// }

// extension on zxing.BarcodeFormat {
//   BarcodeFormat toMyFormat() => switch (this) {
//         zxing.BarcodeFormat.aztec => BarcodeFormat.aztec,
//         zxing.BarcodeFormat.codabar => BarcodeFormat.codabar,
//         zxing.BarcodeFormat.code39 => BarcodeFormat.code39,
//         zxing.BarcodeFormat.code93 => BarcodeFormat.code93,
//         zxing.BarcodeFormat.code128 => BarcodeFormat.code128,
//         zxing.BarcodeFormat.dataMatrix => BarcodeFormat.dataMatrix,
//         zxing.BarcodeFormat.ean8 => BarcodeFormat.ean8,
//         zxing.BarcodeFormat.ean13 => BarcodeFormat.ean13,
//         zxing.BarcodeFormat.itf => BarcodeFormat.itf,
//         zxing.BarcodeFormat.maxicode => BarcodeFormat.maxiCode,
//         zxing.BarcodeFormat.pdf417 => BarcodeFormat.pdf417,
//         zxing.BarcodeFormat.qrCode => BarcodeFormat.qrCode,
//         zxing.BarcodeFormat.rss14 =>
//           throw UnimplementedError('Not implemented: $this'),
//         zxing.BarcodeFormat.rssExpanded =>
//           throw UnimplementedError('Not implemented: $this'),
//         zxing.BarcodeFormat.upcA => BarcodeFormat.upca,
//         zxing.BarcodeFormat.upcE => BarcodeFormat.upce,
//         zxing.BarcodeFormat.upcEanExtension => BarcodeFormat.upce,
//       };
// }

// enum BarcodeFormat {
//   unknown(0),
//   aztec(Format.aztec),
//   codabar(Format.codabar),
//   code39(Format.code39),
//   code93(Format.code93),
//   code128(Format.code128),
//   dataBar(Format.dataBar),
//   dataBarExpanded(Format.dataBarExpanded),
//   dataMatrix(Format.dataMatrix),
//   ean8(Format.ean8),
//   ean13(Format.ean13),
//   itf(Format.itf),
//   maxiCode(Format.maxiCode),
//   pdf417(Format.pdf417),
//   qrCode(Format.qrCode),
//   upca(Format.upca),
//   upce(Format.upce),
//   microQRCode(Format.microQRCode),
//   ;
//
//   const BarcodeFormat(this._formatId);
//   final int _formatId;
//   static final mapping = Map.fromIterable(
//     BarcodeFormat.values,
//     key: (e) => e._formatId,
//   );
//   static const any = BarcodeFormat.values;
// }
//
// extension on List<BarcodeFormat> {
//   int toIntValue() =>
//       fold(0, (previousValue, element) => previousValue | element._formatId);
// }
//
// sealed class ScanResult {}
//
// class ScanResultInvalid extends ScanResult {}
//
// class ScanResultValid extends ScanResult {
//   ScanResultValid({required this.barcode});
//
//   final ScanResultBarcode barcode;
// }
//
// typedef ScanResultBarcode = ({
//   bool isValid,
//   String text,
//   BarcodeFormat format,
// });
//
enum BarcodeFormat {
  unknown(),
  aztec(),
  codabar(),
  code39(),
  code93(),
  code128(),
  dataBar(),
  dataBarExpanded(),
  dataMatrix(),
  ean8(),
  ean13(),
  itf(),
  maxiCode(),
  pdf417(),
  qrCode(),
  upca(),
  upce(),
  microQRCode();

  const BarcodeFormat();

  static const any = BarcodeFormat.values;
}

sealed class ScanResult {}

class ScanResultInvalid extends ScanResult {}

class ScanResultValid extends ScanResult {
  ScanResultValid({required this.barcode});

  final ScanResultBarcode barcode;
}

typedef ScanResultBarcode = ({bool isValid, String text, BarcodeFormat format});
