import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:outc/core/async_state.dart';
import 'package:outc/core/theme/design_tokens.dart';
import 'package:outc/core/widgets/app_top_bar.dart';
import 'package:outc/core/widgets/feedback_states.dart';
import 'package:outc/dashboard/bus/models/bus_ticket_details_model.dart';
import 'package:outc/dashboard/bus/providers/bus_eticket_provider.dart';
import 'package:outc/dashboard/bus/screens/bus_eticket_pdf.dart';
import 'package:outc/dashboard/dashboard.dart';

/// E-ticket screen (view/download/share) shown right after a booking is
/// confirmed, sourced from `GET /api/v1/buses/ticketDetails?refNo=` rather
/// than the local booking-flow state — this is the same data a customer
/// would see if they reopened this ticket later, so there's one ticket
/// rendering, not a "just booked" one plus a separate "view later" one.
/// Visual style takes a MakeMyTrip-style e-ticket/boarding-pass as its
/// reference: a two-part perforated stub (route header, then PNR/passenger/
/// fare body), matching how real bus operators' tickets read.
class BusETicketScreen extends StatelessWidget {
  const BusETicketScreen({super.key, required this.refNo});

  final String refNo;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BusETicketProvider(refNo: refNo)..load(),
      child: const _BusETicketView(),
    );
  }
}

class _BusETicketView extends StatefulWidget {
  const _BusETicketView();

  @override
  State<_BusETicketView> createState() => _BusETicketViewState();
}

class _BusETicketViewState extends State<_BusETicketView> {
  bool _isCapturing = false;

  Future<void> _downloadTicket(BusTicketDetails data) async {
    if (_isCapturing) return;
    setState(() => _isCapturing = true);
    try {
      final bytes = await buildBusTicketPdf(data);
      final savedPath = await FileSaver.instance.saveAs(
        name: 'OutC_Ticket_${data.bookingRefNo}',
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

  Future<void> _shareTicket(BusTicketDetails data) async {
    if (_isCapturing) return;
    setState(() => _isCapturing = true);
    try {
      final bytes = await buildBusTicketPdf(data);
      await Printing.sharePdf(
        bytes: bytes,
        filename: 'OutC_Ticket_${data.bookingRefNo}.pdf',
        subject: 'My OutC bus ticket',
        body: 'My OutC bus ticket — PNR ${data.pnr}, ${data.sourceName} to '
            '${data.destinationName} on ${data.journeyDate}.',
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
    final provider = context.watch<BusETicketProvider>();
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.panelBackground,
        appBar: const AppTopBar(title: 'E-Ticket', automaticallyImplyLeading: false),
        body: _buildBody(provider),
        bottomNavigationBar: switch (provider.state) {
          AsyncData(:final value) => _BottomActions(
              isBusy: _isCapturing,
              onDownload: () => _downloadTicket(value),
              onShare: () => _shareTicket(value),
              onGoHome: _goHome,
            ),
          _ => null,
        },
      ),
    );
  }

  Widget _buildBody(BusETicketProvider provider) {
    return switch (provider.state) {
      AsyncLoading() => const LoadingState(label: 'Fetching your ticket'),
      AsyncOffline() => NoInternetState(onRetry: provider.load),
      AsyncError(:final message) => ErrorState(message: message, onRetry: provider.load),
      AsyncEmpty() => EmptyState(
          title: 'Ticket not found',
          message: 'We could not find this booking. Please try again shortly.',
          actionLabel: 'Retry',
          onAction: provider.load,
        ),
      AsyncData(:final value) => SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: _ETicketCard(data: value),
        ),
    };
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
            BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 6, offset: const Offset(0, -2)),
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
                      side: BorderSide(color: Theme.of(context).colorScheme.primary),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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

/// The on-screen ticket card. `bus_eticket_pdf.dart` builds the downloadable/
/// shareable PDF independently (from the same `BusTicketDetails`) rather
/// than screenshotting this widget, so its layout doesn't need to mirror
/// this one pixel-for-pixel.
class _ETicketCard extends StatelessWidget {
  const _ETicketCard({required this.data});

  final BusTicketDetails data;

  static String _formatJourneyDate(String raw) {
    try {
      final parsed = DateFormat('dd-MM-yyyy').parseStrict(raw);
      return DateFormat('EEE, dd MMM yyyy').format(parsed);
    } catch (_) {
      return raw;
    }
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final totalBase = data.passengers.fold(0.0, (sum, p) => sum + p.baseFare);
    final totalGst = data.passengers.fold(0.0, (sum, p) => sum + p.gst);
    final totalFare = data.totalPrice > 0
        ? data.totalPrice
        : data.passengers.fold(0.0, (sum, p) => sum + p.fare);

    return Column(
      children: [
        // --- Top stub: route + status ---
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.directions_bus_rounded, color: primary, size: 22),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      data.operator,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  _StatusPill(status: data.bookingStatus, isConfirmed: data.isConfirmed),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '${data.busTypeName} · ${data.noOfSeats} seat${data.noOfSeats == 1 ? '' : 's'}',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12.5),
              ),
              const SizedBox(height: 18),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(data.departureTime,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                        const SizedBox(height: 2),
                        Text(data.sourceName,
                            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                        Text(data.boardingPoint,
                            style: TextStyle(color: Colors.grey.shade600, fontSize: 11.5),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 64,
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
                              child: Icon(Icons.directions_bus, size: 12, color: primary),
                            ),
                            Expanded(child: _DashedLine(color: Colors.grey.shade400)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(data.arrivalTime,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                        const SizedBox(height: 2),
                        Text(data.destinationName,
                            textAlign: TextAlign.right,
                            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                        Text(data.droppingPoint,
                            textAlign: TextAlign.right,
                            style: TextStyle(color: Colors.grey.shade600, fontSize: 11.5),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis),
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
                      style: TextStyle(color: Colors.grey.shade700, fontSize: 12.5, fontWeight: FontWeight.w600)),
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

        // --- Bottom stub: PNR, passengers, fare, policy ---
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16)),
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
              _FareRow(label: 'Base Fare', amount: totalBase, currency: data.currency),
              const SizedBox(height: 6),
              _FareRow(label: 'Taxes & Fees', amount: totalGst, currency: data.currency),
              const SizedBox(height: 10),
              _FareRow(
                label: 'Total Amount',
                amount: totalFare,
                currency: data.currency,
                emphasize: true,
                primary: primary,
              ),
              if (data.support != null) ...[
                const SizedBox(height: 18),
                const Divider(height: 1),
                const SizedBox(height: 14),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.support_agent, size: 20, color: Colors.grey.shade600),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(data.support!.companyName,
                              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                          const SizedBox(height: 2),
                          Text(
                            [data.support!.phoneNumber, data.support!.email]
                                .where((s) => s.isNotEmpty)
                                .join(' · '),
                            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
              if (data.cancellationPolicy.isNotEmpty) ...[
                const SizedBox(height: 8),
                Material(
                  type: MaterialType.transparency,
                  child: Theme(
                    data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      tilePadding: EdgeInsets.zero,
                      childrenPadding: const EdgeInsets.only(bottom: 10),
                      iconColor: primary,
                      collapsedIconColor: primary,
                      title: Row(
                        children: [
                          Icon(Icons.policy_outlined, size: 18, color: Colors.grey.shade700),
                          const SizedBox(width: 8),
                          const Text('Cancellation Policy',
                              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5)),
                        ],
                      ),
                      children: [_CancellationPolicyBody(data: data)],
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 8),
              Center(
                child: Text(
                  'This is a computer-generated e-ticket and does not require a signature.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 10.5, fontStyle: FontStyle.italic),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CancellationPolicyBody extends StatelessWidget {
  const _CancellationPolicyBody({required this.data});
  final BusTicketDetails data;

  @override
  Widget build(BuildContext context) {
    final rules = parseCancellationPolicy(data.cancellationPolicy);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(10),
      ),
      child: rules.isEmpty
          ? Text(data.cancellationPolicy,
              style: TextStyle(color: Colors.amber.shade900, fontSize: 12))
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final rule in rules)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(rule.$1,
                              style: TextStyle(color: Colors.amber.shade900, fontSize: 12)),
                        ),
                        const SizedBox(width: 8),
                        Text(rule.$2,
                            style: TextStyle(
                                color: Colors.amber.shade900,
                                fontSize: 12,
                                fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
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
        SizedBox(width: 56, child: Text('SEAT', style: style)),
        Expanded(child: Text('PASSENGER', style: style)),
        Text('AGE/GENDER', style: style),
      ],
    );
  }
}

class _PassengerRow extends StatelessWidget {
  const _PassengerRow({required this.passenger, required this.primary});
  final BusTicketPassenger passenger;
  final Color primary;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 56,
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              color: primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(passenger.seatNo,
                style: TextStyle(color: primary, fontWeight: FontWeight.bold, fontSize: 12.5)),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(passenger.name,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                overflow: TextOverflow.ellipsis),
          ),
        ),
        Text('${passenger.age} · ${passenger.gender}',
            style: TextStyle(color: Colors.grey.shade700, fontSize: 12.5)),
      ],
    );
  }
}

class _FareRow extends StatelessWidget {
  const _FareRow({
    required this.label,
    required this.amount,
    required this.currency,
    this.emphasize = false,
    this.primary,
  });

  final String label;
  final double amount;
  final String currency;
  final bool emphasize;
  final Color? primary;

  @override
  Widget build(BuildContext context) {
    final symbol = currency == 'INR' ? '₹' : '$currency ';
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: emphasize ? 15 : 13,
                fontWeight: emphasize ? FontWeight.bold : FontWeight.w500,
                color: emphasize ? AppColors.textPrimary : Colors.grey.shade700)),
        Text(
          '$symbol${amount.toStringAsFixed(0)}',
          style: TextStyle(
              fontSize: emphasize ? 16 : 13,
              fontWeight: emphasize ? FontWeight.bold : FontWeight.w600,
              color: emphasize ? primary : AppColors.textPrimary),
        ),
      ],
    );
  }
}

/// A single dashed horizontal rule, built from plain boxes rather than a
/// `CustomPainter` since it's one straight line reused in a couple of
/// places — not worth a painter for that.
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

/// The "punched hole" ticket-stub illusion: a background-colored circle
/// sitting on the panel background between the two card halves — reads as
/// a perforation without needing a per-height `CustomClipper` (the card's
/// content height is dynamic, so a fixed-position clip can't be pre-
/// computed reliably).
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
