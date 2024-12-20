import 'package:barcode_scan2/barcode_scan2.dart';

class BarcodeService {
  Future<String> scanBarcode() async {
    try {
      // Trigger barcode scan
      var result = await BarcodeScanner.scan();

      // Return the scanned barcode or -1 if the scan is cancelled
      if (result.rawContent.isNotEmpty) {
        return result.rawContent;
      } else {
        return '-1'; // Indicate failure or cancellation
      }
    } catch (e) {
      // Handle exceptions
      return '-1'; // Indicate failure or cancellation
    }
  }
}
