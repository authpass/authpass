import 'package:authpass/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zxing/flutter_zxing.dart';

import 'package:logging/logging.dart';

final _logger = Logger('barcodescan_screen');

class BarcodeScanScreen extends StatelessWidget {
  const BarcodeScanScreen({
    super.key,
    required this.formats,
  });

  final List<BarcodeFormat> formats;

  static Route<ScanResult> route({
    List<BarcodeFormat> formats = BarcodeFormat.any,
  }) =>
      MaterialPageRoute(
        builder: (context) => BarcodeScanScreen(formats: formats),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan QR Code.'),
      ),
      body: ReaderWidget(
        codeFormat: formats.toIntValue(),
        onScan: (result) {
          _logger.fine('scanned: $result');
          if (result.isValid) {
            final scanResult = ScanResultValid(
              barcode: (
                isValid: true,
                text: result.text ?? CharConstants.empty,
                format: BarcodeFormat.mapping[result.format ?? 0] ??
                    BarcodeFormat.unknown,
              ),
            );
            Navigator.of(context).pop(scanResult);
          }
        },
      ),
    );
  }
}

enum BarcodeFormat {
  unknown(0),
  aztec(Format.aztec),
  codabar(Format.codabar),
  code39(Format.code39),
  code93(Format.code93),
  code128(Format.code128),
  dataBar(Format.dataBar),
  dataBarExpanded(Format.dataBarExpanded),
  dataMatrix(Format.dataMatrix),
  ean8(Format.ean8),
  ean13(Format.ean13),
  itf(Format.itf),
  maxiCode(Format.maxiCode),
  pdf417(Format.pdf417),
  qrCode(Format.qrCode),
  upca(Format.upca),
  upce(Format.upce),
  microQRCode(Format.microQRCode),
  ;

  const BarcodeFormat(this._formatId);
  final int _formatId;
  static final mapping = Map.fromIterable(
    BarcodeFormat.values,
    key: (e) => e._formatId,
  );
  static const any = BarcodeFormat.values;
}

extension on List<BarcodeFormat> {
  int toIntValue() =>
      fold(0, (previousValue, element) => previousValue | element._formatId);
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
