import '../widgets/sharedprefservices.dart';

enum PayerType { customer, agent }

class BookingContext {
  final PayerType payerType;
  final int userId;
  final String? walletId;

  const BookingContext({
    required this.payerType,
    required this.userId,
    this.walletId,
  });

  factory BookingContext.current() {
    final id = int.tryParse(SharedPrefServices.getcustomerId().toString()) ?? 0;
    final isAgent = SharedPrefServices.getroleType().toString() == "agent";
    return BookingContext(
      payerType: isAgent ? PayerType.agent : PayerType.customer,
      userId: id,
      walletId: isAgent ? SharedPrefServices.getwalletId() : null,
    );
  }

  /// Preserves today's exact wire value (roleType: 5, unconditional) — do not invent a
  /// different value for agent; that would be an undocumented behavior change on a field
  /// whose backend semantics aren't fully understood. Only centralizes where it comes from.
  int get roleTypeValue => 5; // TODO(spec-0002+): confirm true agent semantics with backend

  /// Confirmed by the client: pgType 1 = Cashfree (customers have no wallet), pgType 3 = wallet
  /// (agents only). Unlike roleTypeValue, this one IS a real, confirmed behavior change from
  /// today's hardcoded `pgType: 3` — customers booking today would incorrectly request a wallet
  /// transaction, which cannot succeed for them.
  int get pgTypeValue => payerType == PayerType.agent ? 3 : 1;
}
