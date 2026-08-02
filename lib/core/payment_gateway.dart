import 'package:flutter/material.dart';

import 'widgets/payment_redirect_webview.dart';

class PgBlockPaymentData {
  final String paymentLink; // Cashfree session id (pgType 1) or a plain success URL (pgType 3)
  final int pgType; // 1 = Cashfree, 3 = wallet (already paid server-side)
  const PgBlockPaymentData({required this.paymentLink, required this.pgType});
}

enum PgResultStatus { success, failure }

class PgResult {
  final PgResultStatus status;
  final String? errorMessage;
  const PgResult({required this.status, this.errorMessage});
}

abstract class PaymentGateway {
  Future<void> open(
    BuildContext context,
    PgBlockPaymentData data, {
    required void Function(PgResult) onResult,
  });
}

/// Wallet (pgType 3) is already paid server-side by the time block returns (the backend hands back
/// its own success URL) — nothing to open, just report success immediately. This is real behavior,
/// not a mock, and is the correct permanent implementation for pgType 3.
class WalletAlreadyPaidGateway implements PaymentGateway {
  @override
  Future<void> open(
    BuildContext context,
    PgBlockPaymentData data, {
    required void Function(PgResult) onResult,
  }) async {
    onResult(const PgResult(status: PgResultStatus.success));
  }
}

/// Working adapter for pgType 1 in THIS spec — shows the real session id being handed off (proves
/// the pipeline wiring is correct) with explicit Simulate Success/Failure controls. The real Cashfree
/// SDK adapter implementing this same interface is spec 0002 — swapping it in requires zero changes
/// to the booking screens, which is the whole point of the interface.
class MockCashfreeGateway implements PaymentGateway {
  @override
  Future<void> open(
    BuildContext context,
    PgBlockPaymentData data, {
    required void Function(PgResult) onResult,
  }) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('Mock Cashfree Payment'),
        content: Text(
            'Session: ${data.paymentLink}\nReal Cashfree SDK not wired yet — see spec 0002.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              onResult(const PgResult(
                status: PgResultStatus.failure,
                errorMessage: 'Simulated failure',
              ));
            },
            child: const Text('Simulate Failure'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              onResult(const PgResult(status: PgResultStatus.success));
            },
            child: const Text('Simulate Success'),
          ),
        ],
      ),
    );
  }
}

/// Real pgType 1 adapter — replaces [MockCashfreeGateway] now that the
/// redirect contract is confirmed (`b2coutcbusblockbookrespo.txt`:
/// `payment_link` is actually a Cashfree `payment_session_id`, and the
/// gateway redirects to `outc.in/pg_success`/`pg_failure` on completion).
/// Booking confirmation doesn't need anything back from this — the caller
/// already holds the booking reference from `blockTicket`'s response, so
/// this only has to report success/failure.
class CashfreeGateway implements PaymentGateway {
  @override
  Future<void> open(
    BuildContext context,
    PgBlockPaymentData data, {
    required void Function(PgResult) onResult,
  }) async {
    final result = await Navigator.of(context).push<PaymentResult>(
      MaterialPageRoute(
        builder: (_) => PaymentRedirectWebView.cashfree(paymentSessionId: data.paymentLink),
      ),
    );
    onResult(
      result?.success == true
          ? const PgResult(status: PgResultStatus.success)
          : const PgResult(status: PgResultStatus.failure, errorMessage: 'Payment not completed'),
    );
  }
}

/// Picks the correct adapter for the pgType the backend returned on block.
PaymentGateway paymentGatewayFor(int pgType) =>
    pgType == 3 ? WalletAlreadyPaidGateway() : CashfreeGateway();
