import 'dart:typed_data';

import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:outc/dashboard/flights/models/flight_eticket_data.dart';

/// Mirrors `AppColors` (`lib/core/theme/design_tokens.dart`) — the `pdf`
/// package has its own `PdfColor` type, unrelated to Flutter's `Color`, so
/// the tokens can't be referenced directly here. Same approach as bus's
/// `bus_eticket_pdf.dart`, kept to the handful of colors this document
/// actually uses rather than a parallel full token set.
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
}

String _paxLabel(String paxType) => switch (paxType.toUpperCase()) {
      'ADT' => 'Adult',
      'CHD' => 'Child',
      'INF' => 'Infant',
      _ => paxType,
    };

/// Builds the downloadable/shareable PDF e-ticket — a print-friendly
/// equivalent of the on-screen `_ETicketCard`, generated fresh rather than
/// captured as a screenshot so it stays crisp at any zoom/print size.
/// Directly modeled on `bus_eticket_pdf.dart`'s `buildBusTicketPdf`.
Future<Uint8List> buildFlightTicketPdf(FlightETicketData data) async {
  final doc = pw.Document();

  final segments = data.segments;
  final firstSegment = segments.isNotEmpty ? segments.first : null;
  final lastSegment = segments.isNotEmpty ? segments.last : null;
  final stopsText = segments.length <= 1
      ? 'Direct'
      : '${segments.length - 1} stop${segments.length - 1 == 1 ? '' : 's'}';
  final fare = data.fare;
  final taxesAndFees = (fare.tax + fare.otherCharges).toDouble();
  final statusColor = data.isConfirmed ? _PdfColors.success : _PdfColors.error;
  final statusBgColor = data.isConfirmed ? _PdfColors.successBg : _PdfColors.errorBg;

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
                      style: const pw.TextStyle(
                          fontSize: 20, fontWeight: pw.FontWeight.bold, color: _PdfColors.primary)),
                  pw.SizedBox(height: 2),
                  pw.Text(firstSegment?.airlineName ?? data.operatorName,
                      style: const pw.TextStyle(fontSize: 13)),
                  pw.Text(
                    '${firstSegment?.flightNumber ?? ''} - $stopsText - ${data.cabinClass}',
                    style: const pw.TextStyle(fontSize: 10, color: _PdfColors.textSecondary),
                  ),
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
                    if (firstSegment != null) ...[
                      pw.Text(DateFormat('HH:mm').format(firstSegment.departureDateTime),
                          style: const pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                      pw.Text(firstSegment.originCity,
                          style: const pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
                      pw.Text(firstSegment.originName,
                          style: const pw.TextStyle(fontSize: 9, color: _PdfColors.textSecondary)),
                    ],
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
                    if (lastSegment != null) ...[
                      pw.Text(DateFormat('HH:mm').format(lastSegment.arrivalDateTime),
                          style: const pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                      pw.Text(lastSegment.destinationCity,
                          textAlign: pw.TextAlign.right,
                          style: const pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
                      pw.Text(lastSegment.destinationName,
                          textAlign: pw.TextAlign.right,
                          style: const pw.TextStyle(fontSize: 9, color: _PdfColors.textSecondary)),
                    ],
                  ],
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 10),
          pw.Text('Journey date: ${DateFormat('EEE, dd MMM yyyy').format(data.journeyDate)}',
              style: const pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: _PdfColors.textSecondary)),
          pw.Text('Refund policy: ${data.isRefundable ? 'Refundable' : 'Non Refundable'}',
              style: const pw.TextStyle(fontSize: 10, color: _PdfColors.textSecondary)),

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
            headers: const ['Title', 'Name', 'Type'],
            data: [
              for (final p in data.passengers)
                [p.title, '${p.firstName} ${p.lastName}', _paxLabel(p.paxType)],
            ],
            headerStyle: const pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: _PdfColors.primary),
            cellStyle: const pw.TextStyle(fontSize: 10),
            // A solid pale fill, not an alpha-blended one — same reasoning as
            // bus_eticket_pdf.dart's headerDecoration.
            headerDecoration: const pw.BoxDecoration(color: PdfColor.fromInt(0xFFEEF0F8)),
            cellAlignment: pw.Alignment.centerLeft,
            cellPadding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            border: pw.TableBorder.all(color: _PdfColors.grey, width: 0.5),
          ),
          pw.SizedBox(height: 18),

          pw.Divider(color: _PdfColors.grey),
          pw.SizedBox(height: 12),
          _fareRow('Base Fare', fare.baseFare.toDouble()),
          pw.SizedBox(height: 4),
          _fareRow('Taxes & Fees', taxesAndFees),
          pw.SizedBox(height: 8),
          _fareRow('Total Amount', fare.totalFare.toDouble(), emphasize: true),

          if (data.baggageInfo.isNotEmpty) ...[
            pw.SizedBox(height: 18),
            pw.Divider(color: _PdfColors.grey),
            pw.SizedBox(height: 12),
            pw.Text('Baggage Allowance', style: const pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold)),
            for (final b in data.baggageInfo)
              pw.Text(
                '${b.cityPair}: ${b.cabinBaggageInfo} cabin, ${b.baggageInfo} check-in',
                style: const pw.TextStyle(fontSize: 9, color: _PdfColors.textSecondary),
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

pw.Widget _fareRow(String label, double amount, {bool emphasize = false}) {
  final style = pw.TextStyle(
    fontSize: emphasize ? 13 : 10,
    fontWeight: emphasize ? pw.FontWeight.bold : pw.FontWeight.normal,
    color: emphasize ? _PdfColors.primary : _PdfColors.textPrimary,
  );
  return pw.Row(
    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
    children: [
      pw.Text(label, style: emphasize ? style : const pw.TextStyle(fontSize: 10, color: _PdfColors.textSecondary)),
      pw.Text('INR ${amount.toStringAsFixed(2)}', style: style),
    ],
  );
}
