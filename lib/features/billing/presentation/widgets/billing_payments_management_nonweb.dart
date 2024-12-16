import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';

Future<void> downloadPDF(String billId, Uint8List bytes) async {
  final directory = await getApplicationDocumentsDirectory();
  final filePath = '${directory.path}/bill_$billId.pdf';
  final file = File(filePath);
  await file.writeAsBytes(bytes);

  // Optionally show the file path to the user
  print('PDF saved at $filePath');
}
