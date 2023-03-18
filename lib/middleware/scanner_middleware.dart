import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';
import 'package:librarian_frontend/actions/actions.dart';
import 'package:librarian_frontend/state.dart';
import 'package:redux/redux.dart';

Middleware<GlobalAppState> handleScanISBNRequest() => (
      final Store<GlobalAppState> store,
      final dynamic action,
      final dynamic next,
    ) async {
      String _scannedISBN = '-1';

      try {
        _scannedISBN = await FlutterBarcodeScanner.scanBarcode(
          '#ff0000',
          'cancel'.tr,
          true,
          ScanMode.DEFAULT,
        );
      } on PlatformException {
        _scannedISBN = 'Failed to get platform version.';
      }

      if (_scannedISBN != '-1') {
        store.dispatch(SearchIsbnAction(_scannedISBN));
      }
    };
