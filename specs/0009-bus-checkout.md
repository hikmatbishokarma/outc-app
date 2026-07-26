<!--
Copy this file to specs/000X-short-name.md (next number in sequence) and fill it in.
See docs/spec-driven-workflow.md for how specs fit into the overall process.
-->

# 0009 — Bus Checkout (Trip Summary + Passenger Details)

**Status:** Approved (2026-07-26)
**Module(s):** bus

## Overview

Build the Bus module's **checkout screen**: the step after `BusPickupDropScreen`'s "Next" (spec 0008),
where the customer reviews the full trip summary (operator, boarding/dropping point, duration, seat
numbers, price breakup) and enters passenger details for each seat plus one shared contact, before
proceeding. Today, `BusPickupDropScreen`'s "Next" button shows a "Booking coming soon" `SnackBar` —
this spec builds the real review + passenger-details UI, but **still stops short of an actual booking
submission**, since no block/book endpoint has been captured yet (same gap flagged in specs 0006 and
0008 — an active gap, not an oversight to preserve, per `docs/architecture.md`).

## User story

As a guest or logged-in customer, having picked my seats and boarding/dropping points, I want to
review the full trip and fare details and enter passenger information in one place, so that I have
everything confirmed and ready before the app can actually submit a booking.

## Acceptance criteria

- [ ] **Navigation-chain threading**: `BusPickupDropScreen`'s "Next" button (currently ends in a
      `SnackBar` stub) instead pushes this new checkout screen, passing: the `BusTrip`, the *actual*
      selected `List<BusSeat>` (not just a count — `BusSeatSelectionScreen`'s "Continue" currently only
      passes `seatCount`/`totalFare` to `BusPickupDropScreen`, dropping the per-seat fare/code data
      this screen needs for its price breakup; this must be widened to pass the full seat list
      through both screens), the selected `BusBoardingPoint`, and the selected `BusBoardingPoint`
      (dropping).
- [ ] **Trip summary card**: operator (`displayName`), `busType`, boarding point name + time, dropping
      point name + time, `duration`, and the selected seat codes (e.g. "1A, 2A").
- [ ] **Price breakup**: each selected seat's own fare listed individually (seat code + ₹ amount),
      plus a total line summing them — reusing the same total already computed by
      `BusSeatSelectionProvider.totalFare` upstream, not recomputed differently here.
- [ ] **Passenger details** — one form block per selected seat, each with: **Title** (Mr/Mrs/Ms —
      see Open Questions on the exact value set), **Name**, **Age**, **Gender** (Male/Female). All
      four fields mandatory per passenger.
- [ ] **Contact details** — **Phone** and **Email**, entered **once for the whole booking**, not per
      passenger. Both mandatory.
- [ ] **Terms & Conditions and Privacy Policy** — a checkbox the customer must tick, with linked text
      for both documents (see Open Questions — actual copy/URLs not yet available).
- [ ] **Validation**: the proceed action stays disabled until every mandatory field (all passenger
      fields, contact phone/email, and the T&C/privacy checkbox) is filled/checked.
- [ ] Passenger gender input is **not** cross-validated against the seat's own `isMaleSeat`/
      `isLadiesSeat` reservation flag — consistent with spec 0008's existing decision not to enforce
      that client-side (the backend presumably enforces it once a real block/book step exists).
- [ ] The proceed button, once enabled, shows a "Booking coming soon" `SnackBar` (same stub pattern as
      specs 0006-0008) — this spec explicitly does not call any booking endpoint.
- [ ] Module remains deletable per `docs/architecture.md` §1: no cross-imports from other modules.
- [ ] `flutter analyze` clean on all touched files.

## API contract

**None.** This screen consumes only data already fetched by earlier screens (search, results,
seat-availability, and the customer's own picks) — no new network call is made. The actual booking
submission endpoint (block/book equivalents) is still **TBD — needs backend confirmation**, same gap
called out in specs 0006 and 0008's Out of scope.

## Out of scope

- Actual booking/payment submission — no block/book endpoint exists yet. A follow-up spec covers it
  once captured.
- Wiring Bus into the `BookingContext`/`PaymentGateway` abstractions from spec 0001 — same reason.
- Add-ons (free cancellation, ride assurance, donation) — present in the legacy `BookingScreen` mock
  but not requested for this spec; left untouched.
- Saved/recent-traveler profile reuse (auto-filling passenger details from a previous booking) — no
  such data source exists in this app yet.
- Government ID capture — some real bus operators require this for certain routes/states; not
  requested here.
- Deleting the legacy `BookingScreen` mock — stays as unwired legacy scaffolding until the booking
  spec above lands.

## Open questions

- **Terms & Conditions / Privacy Policy content** — do we have actual legal copy or URLs to link to,
  or is this a placeholder checkbox + generic text until legal/product provides real copy? Recommend
  treating as a placeholder (static short text + a non-functional "Terms & Conditions" / "Privacy
  Policy" link) until real copy is supplied, rather than inventing legal language.
- **Title field values** — assume the standard `Mr / Mrs / Ms` set; confirm whether the eventual
  booking API expects specific title codes, since that will drive the exact `enum`/string values used
  here.
- **Where does entered data go** once "Proceed" is tapped, given there's no booking endpoint to send
  it to? Recommend holding it only in this screen's own provider for the session (consistent with the
  rest of the module's ephemeral, non-persisted state) — not worth adding local persistence for data
  that has nowhere to go yet.
