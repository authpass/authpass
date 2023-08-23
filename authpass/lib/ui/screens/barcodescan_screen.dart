import 'package:authpass/utils/extension_methods.dart';
import 'package:barcode_scan2/barcode_scan2.dart' as barcode;
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

final _logger = Logger('barcodescan_screen');

class BarcodeScanHelper {
  static Future<ScanResult> scanBarcode(
    BuildContext context, {
    String? titleText,
    List<BarcodeFormat>? formats,
  }) async {
    final scanOptions = barcode.ScanOptions(
      restrictFormat:
          formats?.map((e) => _barcodeMapping[e]).whereNotNull().toList() ??
              const [],
    );
    _logger.finer('Scanning ${scanOptions.restrictFormat}');

    final barcodeResult =
        await barcode.BarcodeScanner.scan(options: scanOptions);
    if (barcodeResult.type == barcode.ResultType.Barcode) {
      final format = _toBarcodeFormat(barcodeResult.format);
      return ScanResultValid(barcode: (
        text: barcodeResult.rawContent,
        format: format,
        isValid: true,
      ));
    }
    return ScanResultInvalid();
  }

  static final _barcodeMapping = Map.fromEntries(barcode.BarcodeFormat.values
      .map((e) => _toBarcodeFormat(e).let((f) => MapEntry(f, e)))
      .whereNotNull());

  static BarcodeFormat _toBarcodeFormat(barcode.BarcodeFormat format) =>
      switch (format) {
        barcode.BarcodeFormat.qr => BarcodeFormat.qrCode,
        barcode.BarcodeFormat.aztec => BarcodeFormat.aztec,
        barcode.BarcodeFormat.code39 => BarcodeFormat.code39,
        barcode.BarcodeFormat.code93 => BarcodeFormat.code93,
        barcode.BarcodeFormat.ean8 => BarcodeFormat.ean8,
        barcode.BarcodeFormat.ean13 => BarcodeFormat.ean13,
        barcode.BarcodeFormat.code128 => BarcodeFormat.code128,
        barcode.BarcodeFormat.dataMatrix => BarcodeFormat.dataMatrix,
        barcode.BarcodeFormat.interleaved2of5 => BarcodeFormat.itf,
        barcode.BarcodeFormat.upce => BarcodeFormat.upce,
        barcode.BarcodeFormat.pdf417 => BarcodeFormat.pdf417,
        _ => BarcodeFormat.unknown,
      };
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
//
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
  microQRCode(),
  ;

  const BarcodeFormat();

  static const any = BarcodeFormat.values;
}

sealed class ScanResult {}

class ScanResultInvalid extends ScanResult {}

class ScanResultValid extends ScanResult {
  ScanResultValid({required this.barcode});

  final ScanResultBarcode barcode;
}

typedef ScanResultBarcode = ({
  bool isValid,
  String text,
  BarcodeFormat format,
});
