import 'dart:typed_data';

import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:outc/dashboard/bus/models/bus_ticket_details_model.dart';

/// Mirrors `AppColors` (`lib/core/theme/design_tokens.dart`) — the `pdf`
/// package has its own `PdfColor` type, unrelated to Flutter's `Color`, so
/// the tokens can't be referenced directly here. Kept to the handful this
/// document actually uses rather than a parallel full token set.
class _PdfColors {
  _PdfColors._();
  static const primary = PdfColor.fromInt(0xFF1B2A6B);
  static const success = PdfColor.fromInt(0xFF008000);
  static const successBg = PdfColor.fromInt(0xFFE6F2E6);
  static const error = PdfColor.fromInt(0xFFBD0C21);
  static const errorBg = PdfColor.fromInt(0xFFFAE6E8);
  static const textPrimary = PdfColor.fromInt(0xFF222222);
  static const textSecondary = PdfColor.fromInt(0xFF666666);
  static const grey = PdfColor.fromInt(0xFFBDBDBD);
  static const amberBg = PdfColor.fromInt(0xFFFFF8E1);
  static const amberText = PdfColor.fromInt(0xFF8A6D00);
}

/// Builds the downloadable/shareable PDF e-ticket — a print-friendly
/// equivalent of the on-screen `_ETicketCard`, generated fresh rather than
/// captured as a screenshot so it stays crisp at any zoom/print size and
/// isn't recompressed the way a shared image is by chat apps.
Future<Uint8List> buildBusTicketPdf(BusTicketDetails data) async {
  final doc = pw.Document();

  final totalBase = data.passengers.fold(0.0, (sum, p) => sum + p.baseFare);
  final totalGst = data.passengers.fold(0.0, (sum, p) => sum + p.gst);
  final totalFare =
      data.totalPrice > 0 ? data.totalPrice : data.passengers.fold(0.0, (sum, p) => sum + p.fare);
  final currencySymbol = data.currency == 'INR' ? 'Rs. ' : '${data.currency} ';
  final statusColor = data.isConfirmed ? _PdfColors.success : _PdfColors.error;
  final statusBgColor = data.isConfirmed ? _PdfColors.successBg : _PdfColors.errorBg;

  String formatJourneyDate(String raw) {
    try {
      final parsed = DateFormat('dd-MM-yyyy').parseStrict(raw);
      return DateFormat('EEE, dd MMM yyyy').format(parsed);
    } catch (_) {
      return raw;
    }
  }

  doc.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(32),
      build: (context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('OutC E-Ticket',
                      style: const pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold, color: _PdfColors.primary)),
                  pw.SizedBox(height: 2),
                  pw.Text(data.operator, style: const pw.TextStyle(fontSize: 13)),
                  pw.Text('${data.busTypeName} - ${data.noOfSeats} seat(s)',
                      style: const pw.TextStyle(fontSize: 10, color: _PdfColors.textSecondary)),
                ],
              ),
              pw.Container(
                padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: pw.BoxDecoration(
                  color: statusBgColor,
                  borderRadius: pw.BorderRadius.circular(20),
                ),
                child: pw.Text(
                  data.bookingStatus.isEmpty ? 'PENDING' : data.bookingStatus.toUpperCase(),
                  style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: statusColor),
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 22),

          // Route
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(data.departureTime, style: const pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                    pw.Text(data.sourceName, style: const pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
                    pw.Text(data.boardingPoint, style: const pw.TextStyle(fontSize: 9, color: _PdfColors.textSecondary)),
                  ],
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.only(top: 6),
                child: pw.Text('>>>', style: const pw.TextStyle(color: _PdfColors.grey, fontSize: 12)),
              ),
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text(data.arrivalTime, style: const pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                    pw.Text(data.destinationName,
                        textAlign: pw.TextAlign.right,
                        style: const pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
                    pw.Text(data.droppingPoint,
                        textAlign: pw.TextAlign.right,
                        style: const pw.TextStyle(fontSize: 9, color: _PdfColors.textSecondary)),
                  ],
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 10),
          pw.Text('Journey date: ${formatJourneyDate(data.journeyDate)}',
              style: const pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: _PdfColors.textSecondary)),

          pw.SizedBox(height: 18),
          pw.Divider(color: _PdfColors.grey),
          pw.SizedBox(height: 14),

          // PNR / booking ref / QR
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('PNR', style: const pw.TextStyle(fontSize: 9, color: _PdfColors.textSecondary)),
                    pw.Text(data.pnr, style: const pw.TextStyle(fontSize: 15, fontWeight: pw.FontWeight.bold)),
                    pw.SizedBox(height: 8),
                    pw.Text('BOOKING REF', style: const pw.TextStyle(fontSize: 9, color: _PdfColors.textSecondary)),
                    pw.Text(data.bookingRefNo, style: const pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold)),
                  ],
                ),
              ),
              if (data.pnr.isNotEmpty || data.bookingRefNo.isNotEmpty)
                pw.BarcodeWidget(
                  data: data.pnr.isNotEmpty ? data.pnr : data.bookingRefNo,
                  barcode: pw.Barcode.qrCode(),
                  width: 64,
                  height: 64,
                  drawText: false,
                ),
            ],
          ),
          pw.SizedBox(height: 20),

          pw.Text('Passengers', style: const pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 6),
          pw.TableHelper.fromTextArray(
            headers: const ['Seat', 'Passenger', 'Age', 'Gender'],
            data: [
              for (final p in data.passengers) [p.seatNo, p.name, p.age, p.gender],
            ],
            headerStyle: const pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: _PdfColors.primary),
            cellStyle: const pw.TextStyle(fontSize: 10),
            // A solid pale fill, not an alpha-blended one — some PDF
            // renderers don't composite BoxDecoration alpha reliably inside
            // table headers, which previously rendered this as a solid navy
            // bar that made the (also-navy) header text invisible.
            headerDecoration: const pw.BoxDecoration(color: PdfColor.fromInt(0xFFEEF0F8)),
            cellAlignment: pw.Alignment.centerLeft,
            cellPadding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            border: pw.TableBorder.all(color: _PdfColors.grey, width: 0.5),
          ),
          pw.SizedBox(height: 18),

          pw.Divider(color: _PdfColors.grey),
          pw.SizedBox(height: 12),
          _fareRow('Base Fare', totalBase, currencySymbol),
          pw.SizedBox(height: 4),
          _fareRow('Taxes & Fees', totalGst, currencySymbol),
          pw.SizedBox(height: 8),
          _fareRow('Total Amount', totalFare, currencySymbol, emphasize: true),

          if (data.support != null) ...[
            pw.SizedBox(height: 18),
            pw.Divider(color: _PdfColors.grey),
            pw.SizedBox(height: 12),
            pw.Text(data.support!.companyName, style: const pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold)),
            pw.Text(
              [data.support!.phoneNumber, data.support!.email].where((s) => s.isNotEmpty).join(' | '),
              style: const pw.TextStyle(fontSize: 9, color: _PdfColors.textSecondary),
            ),
          ],

          if (data.cancellationPolicy.isNotEmpty) ...[
            pw.SizedBox(height: 18),
            pw.Text('Cancellation Policy', style: const pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 6),
            pw.Container(
              width: double.infinity,
              padding: const pw.EdgeInsets.all(10),
              decoration: pw.BoxDecoration(color: _PdfColors.amberBg, borderRadius: pw.BorderRadius.circular(6)),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: () {
                  final rules = parseCancellationPolicy(data.cancellationPolicy);
                  if (rules.isEmpty) {
                    return [pw.Text(data.cancellationPolicy, style: const pw.TextStyle(fontSize: 9, color: _PdfColors.amberText))];
                  }
                  return [
                    for (final rule in rules)
                      pw.Padding(
                        padding: const pw.EdgeInsets.only(bottom: 4),
                        child: pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Expanded(
                                child: pw.Text(rule.$1,
                                    style: const pw.TextStyle(fontSize: 9, color: _PdfColors.amberText))),
                            pw.Text(rule.$2,
                                style: const pw.TextStyle(
                                    fontSize: 9, fontWeight: pw.FontWeight.bold, color: _PdfColors.amberText)),
                          ],
                        ),
                      ),
                  ];
                }(),
              ),
            ),
          ],

          pw.SizedBox(height: 24),
          pw.Center(
            child: pw.Text(
              'This is a computer-generated e-ticket and does not require a signature.',
              style: const pw.TextStyle(fontSize: 8, color: _PdfColors.textSecondary, fontStyle: pw.FontStyle.italic),
            ),
          ),
        ],
      ),
    ),
  );

  return doc.save();
}

pw.Widget _fareRow(String label, double amount, String currencySymbol, {bool emphasize = false}) {
  final style = pw.TextStyle(
    fontSize: emphasize ? 13 : 10,
    fontWeight: emphasize ? pw.FontWeight.bold : pw.FontWeight.normal,
    color: emphasize ? _PdfColors.primary : _PdfColors.textPrimary,
  );
  return pw.Row(
    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
    children: [
      pw.Text(label, style: emphasize ? style : const pw.TextStyle(fontSize: 10, color: _PdfColors.textSecondary)),
      pw.Text('$currencySymbol${amount.toStringAsFixed(0)}', style: style),
    ],
  );
}
