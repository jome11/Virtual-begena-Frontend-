import 'dart:js_interop';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:web/web.dart' as web;

class CertificateService {
  static Future<void> download({
    required String name,
    required String qenetLabel,
    required int accuracy,
    required int sessions,
  }) async {
    final gold = PdfColor.fromHex('#B8892F');
    final dark = PdfColor.fromHex('#1A1408');
    final d = DateTime.now();
    final date =
        '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

    final doc = pw.Document();
    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4.landscape,
        margin: const pw.EdgeInsets.all(28),
        build: (_) => pw.Container(
          decoration: pw.BoxDecoration(border: pw.Border.all(color: gold, width: 4)),
          padding: const pw.EdgeInsets.all(32),
          child: pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
              pw.Text('VIRTUAL BEGENA',
                  style: pw.TextStyle(
                      fontSize: 16,
                      letterSpacing: 4,
                      color: gold,
                      fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 18),
              pw.Text('Certificate of Achievement',
                  style: pw.TextStyle(
                      fontSize: 36, fontWeight: pw.FontWeight.bold, color: dark)),
              pw.SizedBox(height: 24),
              pw.Text('This certifies that', style: const pw.TextStyle(fontSize: 14)),
              pw.SizedBox(height: 10),
              pw.Text(name,
                  style: pw.TextStyle(
                      fontSize: 32, fontWeight: pw.FontWeight.bold, color: gold)),
              pw.SizedBox(height: 14),
              pw.Text('has completed the $qenetLabel qenet',
                  style: const pw.TextStyle(fontSize: 16)),
              pw.SizedBox(height: 6),
              pw.Text('$sessions sessions · $accuracy% average accuracy',
                  style: const pw.TextStyle(fontSize: 14)),
              pw.SizedBox(height: 28),
              pw.Text(date, style: const pw.TextStyle(fontSize: 12)),
            ],
          ),
        ),
      ),
    );

    final bytes = await doc.save();
    final blob = web.Blob([bytes.toJS].toJS, web.BlobPropertyBag(type: 'application/pdf'));
    final url = web.URL.createObjectURL(blob);
    final a = web.HTMLAnchorElement()
      ..href = url
      ..download = 'virtual-begena-$qenetLabel.pdf';
    a.click();
    web.URL.revokeObjectURL(url);
  }
}
