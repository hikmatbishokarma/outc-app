import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:outc/services/app_constants.dart';

/// Outcome of a hosted-checkout payment attempt, parsed off the gateway's
/// redirect URL rather than a callback API — the gateway only ever tells us
/// the result by redirecting to `pg_success`/`pg_failure`.
class PaymentResult {
  const PaymentResult({required this.success, this.ref, this.isDeposite});

  final bool success;
  final String? ref;
  final bool? isDeposite;
}

/// Opens a hosted payment-gateway checkout URL in an in-app WebView and pops
/// with a [PaymentResult] once the gateway redirects to `pg_success`/
/// `pg_failure` — mobile's equivalent of the browser redirect the web app
/// relies on (see `docs/architecture.md` §3's
/// `PaymentGateway` seam). This is that seam's concrete redirect-handling
/// piece for a hosted-checkout-URL gateway; it isn't the full interface from
/// spec 0001 since Bus is still the only caller — promote it once a second
/// module (Flight/Hotel) needs the same handling.
class PaymentRedirectWebView extends StatefulWidget {
  const PaymentRedirectWebView({super.key, required this.paymentUrl});

  /// Cashfree issues a `payment_session_id` (confirmed — that's what
  /// `blockTicket`'s `payment_link` field actually is, despite the name)
  /// rather than a ready URL. This builds the hosted-checkout URL their
  /// sessions are opened at, same page the web app redirects to.
  ///
  /// `sandbox` must match whichever Cashfree app/keys the backend used to
  /// create the session — confirmed `true` for the current staging
  /// `b2c.outc.in` environment. **Flip to `false` when cutting over to
  /// production** (or make it follow whatever env switch the app ends up
  /// using) — don't ship this default unchanged at launch.
  factory PaymentRedirectWebView.cashfree({
    Key? key,
    required String paymentSessionId,
    bool sandbox = true,
  }) {
    final host = sandbox ? 'payments-test.cashfree.com' : 'payments.cashfree.com';
    return PaymentRedirectWebView(key: key, paymentUrl: 'https://$host/order/#$paymentSessionId');
  }

  final String paymentUrl;

  @override
  State<PaymentRedirectWebView> createState() => _PaymentRedirectWebViewState();
}

class _PaymentRedirectWebViewState extends State<PaymentRedirectWebView> {
  // Cashfree redirects back to whichever host actually created the session —
  // i.e. wherever BusService.blockTicket() called (AppConstant.baseUrl, not
  // busBaseUrl). These two must always match each other; if blockTicket's
  // host ever changes, this has to change with it — confirmed by the
  // client, not an independent config.
  static final _successPrefix = '${AppConstant.baseUrl}pg_success';
  static final _failurePrefix = '${AppConstant.baseUrl}pg_failure';

  late final WebViewController _controller;
  bool _resolved = false;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(onNavigationRequest: _onNavigationRequest))
      ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  NavigationDecision _onNavigationRequest(NavigationRequest request) {
    final url = request.url;
    if (url.startsWith(_successPrefix) || url.startsWith(_failurePrefix)) {
      final uri = Uri.parse(url);
      final result = PaymentResult(
        success: url.startsWith(_successPrefix),
        ref: uri.queryParameters['ref'],
        isDeposite: uri.queryParameters['isDeposite'] == 'true',
      );
      _resolve(result);
      return NavigationDecision.prevent;
    }
    return NavigationDecision.navigate;
  }

  void _resolve(PaymentResult result) {
    if (_resolved) return;
    _resolved = true;
    Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _resolve(const PaymentResult(success: false));
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Complete Payment')),
        body: WebViewWidget(controller: _controller),
      ),
    );
  }
}
