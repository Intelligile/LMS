import 'dart:html' as html;
import 'dart:typed_data';

void downloadPDF(String billId, Uint8List bytes) {
  final blob = html.Blob([bytes]);
  final url = html.Url.createObjectUrlFromBlob(blob);
  final anchor = html.AnchorElement(href: url)
    ..target = 'blank'
    ..download = 'bill_$billId.pdf'
    ..click();
  html.Url.revokeObjectUrl(url);
}
