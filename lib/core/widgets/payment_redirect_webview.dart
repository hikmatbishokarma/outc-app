import 'dart:convert';

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
  const PaymentRedirectWebView({super.key, this.paymentUrl, this.paymentHtml, this.paymentHtmlBaseUrl})
      : assert(paymentUrl != null || paymentHtml != null);

  /// Cashfree issues a `payment_session_id` (confirmed — that's what
  /// `blockTicket`'s `payment_link` field actually is, despite the name),
  /// not a ready URL. Loading `https://payments(-test).cashfree.com/order/#
  /// sessionId` directly — Cashfree's older hosted-checkout link format —
  /// came back "client session is invalid" on a real session. The web app's
  /// own checkout (confirmed via its network capture) actually lands on
  /// `sandbox.cashfree.com/checkout/`, which is only reachable through
  /// Cashfree's current JS SDK (`cashfree.checkout(...)`), not a bare URL.
  /// So this loads a minimal page that runs that SDK call instead — same
  /// integration the web app uses, just embedded in the WebView.
  ///
  /// `sandbox` must match whichever Cashfree app/keys the backend used to
  /// create the session — confirmed `true` (test mode) from the web
  /// checkout's own `sandbox.cashfree.com` host.
  factory PaymentRedirectWebView.cashfree({
    Key? key,
    required String paymentSessionId,
    bool sandbox = true,
  }) {
    final mode = sandbox ? 'sandbox' : 'production';
    final html = '''
<!DOCTYPE html>
<html>
<head><meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1"></head>
<body>
<script src="https://sdk.cashfree.com/js/v3/cashfree.js"></script>
<script>
  const cashfree = Cashfree({ mode: ${jsonEncode(mode)} });
  cashfree.checkout({
    paymentSessionId: ${jsonEncode(paymentSessionId)},
    redirectTarget: "_self",
  });
</script>
</body>
</html>
''';
    return PaymentRedirectWebView(key: key, paymentHtml: html, paymentHtmlBaseUrl: AppConstant.baseUrl);
  }

  final String? paymentUrl;
  final String? paymentHtml;
  final String? paymentHtmlBaseUrl;

  @override
  State<PaymentRedirectWebView> createState() => _PaymentRedirectWebViewState();
}

class _PaymentRedirectWebViewState extends State<PaymentRedirectWebView> {
  // Cashfree redirects back to whichever host actually created the session —
  // i.e. AppConstant.baseUrl, the same host BusService.blockTicket() calls.
  // These two must always match; if that host ever changes, this changes
  // with it — confirmed by the client, not an independent config.
  static final _successPrefix = '${AppConstant.baseUrl}pg_success';
  static final _failurePrefix = '${AppConstant.baseUrl}pg_failure';

  late final WebViewController _controller;
  bool _resolved = false;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(onNavigationRequest: _onNavigationRequest));
    final html = widget.paymentHtml;
    if (html != null) {
      _controller.loadHtmlString(html, baseUrl: widget.paymentHtmlBaseUrl);
    } else {
      _controller.loadRequest(Uri.parse(widget.paymentUrl!));
    }
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
