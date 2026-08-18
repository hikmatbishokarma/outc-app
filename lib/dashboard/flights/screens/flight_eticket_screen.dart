import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:outc/core/theme/design_tokens.dart';
import 'package:outc/core/widgets/app_top_bar.dart';
import 'package:outc/dashboard/dashboard.dart';
import 'package:outc/dashboard/flights/models/flight_eticket_data.dart';
import 'package:outc/dashboard/flights/models/one_way_book_response.dart';
import 'package:outc/dashboard/flights/screens/flight_eticket_pdf.dart';

/// E-ticket screen (view/download/share) shown right after a booking is
/// confirmed — the flights counterpart of `BusETicketScreen`. Unlike bus,
/// there's no `ticketDetails`-equivalent GET endpoint for flights (spec
/// 0013), so this takes the already-fetched [FlightETicketData] directly
/// rather than re-fetching by reference number; reopening this ticket later
/// from "My Bookings" is a known gap, same one bus had before its own
/// ticketDetails endpoint existed. Visual style matches `BusETicketScreen`:
/// a two-part perforated stub (route header, then PNR/passenger/fare body).
class FlightETicketScreen extends StatefulWidget {
  const FlightETicketScreen({super.key, required this.data});

  final FlightETicketData data;

  @override
  State<FlightETicketScreen> createState() => _FlightETicketScreenState();
}

class _FlightETicketScreenState extends State<FlightETicketScreen> {
  bool _isCapturing = false;

  Future<void> _downloadTicket() async {
    if (_isCapturing) return;
    setState(() => _isCapturing = true);
    try {
      final bytes = await buildFlightTicketPdf(widget.data);
      final savedPath = await FileSaver.instance.saveAs(
        name: 'OutC_Ticket_${widget.data.bookingRefNo}',
        bytes: bytes,
        fileExtension: 'pdf',
        mimeType: MimeType.pdf,
      );
      if (savedPath != null) _showMessage('Ticket saved.');
    } catch (e) {
      _showMessage('Could not save the ticket. Please try again.');
    } finally {
      if (mounted) setState(() => _isCapturing = false);
    }
  }

  Future<void> _shareTicket() async {
    if (_isCapturing) return;
    setState(() => _isCapturing = true);
    try {
      final bytes = await buildFlightTicketPdf(widget.data);
      final segments = widget.data.segments;
      final route = segments.isEmpty
          ? ''
          : '${segments.first.originCity} to ${segments.last.destinationCity}';
      await Printing.sharePdf(
        bytes: bytes,
        filename: 'OutC_Ticket_${widget.data.bookingRefNo}.pdf',
        subject: 'My OutC flight ticket',
        body: 'My OutC flight ticket — PNR ${widget.data.pnr}, $route.',
      );
    } catch (e) {
      _showMessage('Could not share the ticket. Please try again.');
    } finally {
      if (mounted) setState(() => _isCapturing = false);
    }
  }

  void _showMessage(String text) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  void _goHome() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const Dashboard()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.panelBackground,
        appBar:
            const AppTopBar(title: 'E-Ticket', automaticallyImplyLeading: false),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: _ETicketCard(data: widget.data),
        ),
        bottomNavigationBar: _BottomActions(
          isBusy: _isCapturing,
          onDownload: _downloadTicket,
          onShare: _shareTicket,
          onGoHome: _goHome,
        ),
      ),
    );
  }
}

class _BottomActions extends StatelessWidget {
  const _BottomActions({
    required this.isBusy,
    required this.onDownload,
    required this.onShare,
    required this.onGoHome,
  });

  final bool isBusy;
  final VoidCallback onDownload;
  final VoidCallback onShare;
  final VoidCallback onGoHome;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 6,
                offset: const Offset(0, -2)),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: isBusy ? null : onDownload,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.primary,
                      side:
                          BorderSide(color: Theme.of(context).colorScheme.primary),
                      shape:
                          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(vertical: 13),
                    ),
                    icon: const Icon(Icons.download_outlined, size: 19),
                    label: const Text('Download'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: isBusy ? null : onShare,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      shape:
                          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(vertical: 13),
                    ),
                    icon: const Icon(Icons.share_outlined, size: 19, color: Colors.white),
                    label: const Text('Share', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
            TextButton(
              onPressed: onGoHome,
              child: const Text('Go to Home'),
            ),
          ],
        ),
      ),
    );
  }
}

/// The on-screen ticket card. `flight_eticket_pdf.dart` builds the
/// downloadable/shareable PDF independently from the same [FlightETicketData]
/// rather than screenshotting this widget, so its layout doesn't need to
/// mirror this one pixel-for-pixel — same relationship as bus's
/// `_ETicketCard`/`bus_eticket_pdf.dart`.
class _ETicketCard extends StatelessWidget {
  const _ETicketCard({required this.data});

  final FlightETicketData data;

  static String _formatJourneyDate(DateTime date) =>
      DateFormat('EEE, dd MMM yyyy').format(date);

  static String _formatTime(DateTime date) => DateFormat('HH:mm').format(date);

  static String _formatDuration(Duration d) {
    final hours = d.inHours;
    final minutes = d.inMinutes.remainder(60);
    return '${hours}h ${minutes}m';
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final segments = data.segments;
    final firstSegment = segments.isNotEmpty ? segments.first : null;
    final lastSegment = segments.isNotEmpty ? segments.last : null;
    final stopsText = segments.length <= 1
        ? 'Direct'
        : '${segments.length - 1} stop${segments.length - 1 == 1 ? '' : 's'}';
    final duration = firstSegment != null && lastSegment != null
        ? lastSegment.arrivalDateTime.difference(firstSegment.departureDateTime)
        : null;
    final fare = data.fare;
    final taxesAndFees = (fare.tax + fare.otherCharges).toDouble();

    return Column(
      children: [
        // --- Top stub: airline + status ---
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.flight_rounded, color: primary, size: 22),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      firstSegment?.airlineName ?? data.operatorName,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  _StatusPill(status: data.bookingStatus, isConfirmed: data.isConfirmed),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  if (firstSegment != null)
                    Text('${firstSegment.flightNumber} · ',
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 12.5)),
                  Text(stopsText, style: TextStyle(color: Colors.grey.shade600, fontSize: 12.5)),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  _InfoChip(label: data.cabinClass, icon: Icons.event_seat_outlined),
                  const SizedBox(width: 8),
                  _InfoChip(
                    label: data.isRefundable ? 'Refundable' : 'Non Refundable',
                    icon: data.isRefundable ? Icons.check_circle_outline : Icons.block,
                    color: data.isRefundable ? AppColors.success : AppColors.error,
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (firstSegment != null) ...[
                          Text(_formatTime(firstSegment.departureDateTime),
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                          const SizedBox(height: 2),
                          Text(firstSegment.originCity,
                              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                          Text(firstSegment.originName,
                              style: TextStyle(color: Colors.grey.shade600, fontSize: 11.5),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis),
                        ],
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 76,
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(child: _DashedLine(color: Colors.grey.shade400)),
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: primary.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.flight, size: 12, color: primary),
                            ),
                            Expanded(child: _DashedLine(color: Colors.grey.shade400)),
                          ],
                        ),
                        if (duration != null) ...[
                          const SizedBox(height: 4),
                          Text(_formatDuration(duration),
                              style: TextStyle(color: Colors.grey.shade500, fontSize: 10)),
                        ],
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (lastSegment != null) ...[
                          Text(_formatTime(lastSegment.arrivalDateTime),
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                          const SizedBox(height: 2),
                          Text(lastSegment.destinationCity,
                              textAlign: TextAlign.right,
                              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                          Text(lastSegment.destinationName,
                              textAlign: TextAlign.right,
                              style: TextStyle(color: Colors.grey.shade600, fontSize: 11.5),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 13, color: Colors.grey.shade500),
                  const SizedBox(width: 6),
                  Text(_formatJourneyDate(data.journeyDate),
                      style: TextStyle(
                          color: Colors.grey.shade700, fontSize: 12.5, fontWeight: FontWeight.w600)),
                ],
              ),
            ],
          ),
        ),

        // --- Perforation ---
        SizedBox(
          height: 26,
          child: Row(
            children: [
              const _PunchHole(color: AppColors.panelBackground),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: _DashedLine(color: Colors.grey.shade300, height: 1.4),
                ),
              ),
              const _PunchHole(color: AppColors.panelBackground),
            ],
          ),
        ),

        // --- Bottom stub: PNR, passengers, fare, baggage ---
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _LabelValue(label: 'PNR', value: data.pnr, valueSize: 16),
                        const SizedBox(height: 10),
                        _LabelValue(label: 'Booking Ref', value: data.bookingRefNo),
                      ],
                    ),
                  ),
                  if (data.pnr.isNotEmpty || data.bookingRefNo.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: QrImageView(
                        data: data.pnr.isNotEmpty ? data.pnr : data.bookingRefNo,
                        version: QrVersions.auto,
                        size: 64,
                        gapless: false,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 18),
              const Text('Passengers', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5)),
              const SizedBox(height: 10),
              const _PassengerHeader(),
              const Divider(height: 16),
              for (var i = 0; i < data.passengers.length; i++) ...[
                _PassengerRow(passenger: data.passengers[i], primary: primary),
                if (i != data.passengers.length - 1) const SizedBox(height: 10),
              ],
              const SizedBox(height: 18),
              const Divider(height: 1),
              const SizedBox(height: 14),
              _FareRow(label: 'Base Fare', amount: fare.baseFare.toDouble()),
              const SizedBox(height: 6),
              _FareRow(label: 'Taxes & Fees', amount: taxesAndFees),
              const SizedBox(height: 10),
              _FareRow(
                label: 'Total Amount',
                amount: fare.totalFare.toDouble(),
                emphasize: true,
                primary: primary,
              ),
              if (data.baggageInfo.isNotEmpty) ...[
                const SizedBox(height: 18),
                const Divider(height: 1),
                const SizedBox(height: 14),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.luggage_outlined, size: 20, color: Colors.grey.shade600),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Baggage Allowance',
                              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                          for (final b in data.baggageInfo)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                '${b.cityPair}: ${b.cabinBaggageInfo} cabin, ${b.baggageInfo} check-in',
                                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 8),
              Center(
                child: Text(
                  'This is a computer-generated e-ticket and does not require a signature.',
                  textAlign: TextAlign.center,
                  style:
                      TextStyle(color: Colors.grey.shade500, fontSize: 10.5, fontStyle: FontStyle.italic),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.label, required this.icon, this.color});
  final String label;
  final IconData icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final chipColor = color ?? Colors.grey.shade700;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: chipColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: chipColor),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(color: chipColor, fontSize: 11, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.status, required this.isConfirmed});
  final String status;
  final bool isConfirmed;

  @override
  Widget build(BuildContext context) {
    final color = isConfirmed ? AppColors.success : AppColors.error;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.isEmpty ? 'PENDING' : status.toUpperCase(),
        style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _LabelValue extends StatelessWidget {
  const _LabelValue({required this.label, required this.value, this.valueSize = 14});
  final String label;
  final String value;
  final double valueSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(),
            style: TextStyle(color: Colors.grey.shade500, fontSize: 10.5, letterSpacing: 0.5)),
        const SizedBox(height: 3),
        Text(value,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: valueSize, letterSpacing: 0.5)),
      ],
    );
  }
}

class _PassengerHeader extends StatelessWidget {
  const _PassengerHeader();

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(color: Colors.grey.shade500, fontSize: 11, fontWeight: FontWeight.w600);
    return Row(
      children: [
        Expanded(child: Text('PASSENGER', style: style)),
        Text('TYPE', style: style),
      ],
    );
  }
}

class _PassengerRow extends StatelessWidget {
  const _PassengerRow({required this.passenger, required this.primary});
  final Passenger passenger;
  final Color primary;

  static String _paxLabel(String paxType) => switch (paxType.toUpperCase()) {
        'ADT' => 'Adult',
        'CHD' => 'Child',
        'INF' => 'Infant',
        _ => paxType,
      };

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text('${passenger.title} ${passenger.firstName} ${passenger.lastName}',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              overflow: TextOverflow.ellipsis),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(_paxLabel(passenger.paxType),
              style: TextStyle(color: primary, fontWeight: FontWeight.bold, fontSize: 11.5)),
        ),
      ],
    );
  }
}

class _FareRow extends StatelessWidget {
  const _FareRow({
    required this.label,
    required this.amount,
    this.emphasize = false,
    this.primary,
  });

  final String label;
  final double amount;
  final bool emphasize;
  final Color? primary;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: emphasize ? 15 : 13,
                fontWeight: emphasize ? FontWeight.bold : FontWeight.w500,
                color: emphasize ? AppColors.textPrimary : Colors.grey.shade700)),
        Text(
          'INR ${amount.toStringAsFixed(2)}',
          style: TextStyle(
              fontSize: emphasize ? 16 : 13,
              fontWeight: emphasize ? FontWeight.bold : FontWeight.w600,
              color: emphasize ? primary : AppColors.textPrimary),
        ),
      ],
    );
  }
}

/// A single dashed horizontal rule — same approach as `BusETicketScreen`'s
/// private `_DashedLine` (built from boxes via `LayoutBuilder`, not a
/// `CustomPainter`, since it's one straight line reused in a couple of
/// places). Kept local rather than shared since it's a trivial one-off.
class _DashedLine extends StatelessWidget {
  const _DashedLine({required this.color, this.height = 1.6});
  final Color color;
  final double height;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const dashWidth = 4.0;
        const gap = 3.0;
        final count = (constraints.maxWidth / (dashWidth + gap)).floor().clamp(1, 1000);
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            count,
            (_) => Container(width: dashWidth, height: height, color: color),
          ),
        );
      },
    );
  }
}

/// The "punched hole" ticket-stub illusion — same approach as
/// `BusETicketScreen`'s private `_PunchHole`.
class _PunchHole extends StatelessWidget {
  const _PunchHole({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade300),
      ),
    );
  }
}
