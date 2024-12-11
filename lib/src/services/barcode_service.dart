// lib/src/services/barcode_service.dart
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class BarcodeService {
  Future<String> scanBarcode() async {
    try {
      String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666", // Line color
        "Cancel", // Cancel button text
        true,      // Show flash icon
        ScanMode.BARCODE, // Scan mode
      );
      return barcodeScanRes;
    } catch (e) {
      // Handle exceptions
      return '-1'; // Indicate failure or cancellation
    }
  }
}
