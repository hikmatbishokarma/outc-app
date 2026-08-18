<!--
Copy this file to specs/000X-short-name.md (next number in sequence) and fill it in.
See docs/spec-driven-workflow.md for how specs fit into the overall process.
-->

# 0013 — Flight Checkout & E-Ticket Redesign (Oneway Flow)

**Status:** Approved (2026-08-14)
**Module(s):** flights, core

## Overview

Bring the flight module's passenger-details → block → payment → book → confirmation journey up to
the same standard the bus module just reached: `design_tokens.dart` styling throughout, a
step-checklist progress overlay during block/payment/book instead of a bare opacity spinner, and a
downloadable/shareable PDF e-ticket (with QR) instead of the current static confirmation screen. The
underlying network calls already work end-to-end (`flightOnewayPrice` → `flightOnewayBlock` →
`paymentGatewayFor` → `flightOnewayBook`) — this spec is a UX/consistency pass on top of that, the
same relationship spec 0012 has to the feedback-states work: behavior already exists, this makes it
match the app's current visual/interaction standard.

**Scope is the oneway/roundtrip/multicity entry point only** — `book_flight_formpage.dart` →
`ticketView.dart`, reached from `oneway_flight_list.dart`, `fetched_roundtrip_flights.dart`, and
`fetched_multicity_flights.dart`. CLAUDE.md calls this "the most complete journey, and the reference
for how other modules should eventually work." The domestic round-trip combined form
(`book_domestic_flight.dart`, reached from `fetched_domestic_multicity_flights.dart`) is explicitly
**out of scope** — it's flagged as the legacy inline-`http`-call pattern and is a bigger, separate
lift once this pattern is proven out here.

## User story

As a guest or logged-in customer booking a flight, I want the passenger-details, payment-in-progress,
and confirmation screens to look and feel consistent with the rest of the app (matching what bus just
shipped), and to be able to download or share a real PDF of my e-ticket, so that the flight booking
experience doesn't feel like a different, older app bolted onto this one.

## Acceptance criteria

- [ ] **Passenger/contact form** (`BookFlightFormpage`): rebuilt on `design_tokens.dart` — no
      `Color(0xFF...)` literals, no import of the module's legacy `colors.dart`. Same fields/
      validation as today (per-passenger title/first/last/DOB/nationality by pax type, shared phone/
      email/address, T&C checkbox) — this is a visual/structural pass, not a fields change.
- [ ] **Fare summary card**: same data as today (base fare, taxes, convenience fee, grand total,
      promo field) restyled onto tokens — matches the visual weight bus's checkout screen gives its
      price breakup.
- [ ] **`BookingStepOverlay` becomes a shared `lib/core/widgets/` component** (moved from
      `lib/dashboard/bus/widgets/booking_step_overlay.dart`), since a module folder may only import
      from itself and `lib/core/` (`docs/architecture.md` §1) — flights cannot reach into
      `lib/dashboard/bus/widgets/` to reuse it as-is. Bus's usage is updated to import from the new
      location; no behavior change for bus.
- [ ] **Block step**: replaces `Flight_ProgressBar`'s opacity-dimmed screen with a step-checklist
      overlay ("Checking fare", "Holding your seat", "Redirecting to payment" or equivalent),
      paced the same way `BusCheckoutProvider._runStepTimer` does — `flightOnewayPrice` and
      `flightOnewayBlock` are each a single atomic call with no real intermediate progress to report.
- [ ] **Book step**: after a successful payment redirect, a second step-checklist overlay ("Payment
      received", "Confirming with airline", "Issuing ticket", etc.) covers the `flightOnewayBook`
      call, same pacing approach.
- [ ] **This state lives in a new `providers/flight_checkout_provider.dart`**, not inline in the
      widget's `setState` calls — `BookFlightFormpage` currently drives `isApiCallProcess` and every
      status-code branch by hand inside the widget; this moves that into a `ChangeNotifier` the
      widget reads, matching `BusCheckoutProvider`'s split of `blockSeats()`/`confirmBooking()`.
      Existing request-building logic (passenger list assembly, `FlightFormRequestModel`,
      `FLightPriceRequestModel`) moves into this provider largely as-is — this is a relocation, not a
      request-shape change.
- [ ] **New `FlightETicketScreen`** (`lib/dashboard/flights/screens/`) replaces `TicketView` as the
      post-`flightOnewayBook` destination for this flow: airline/flight number, route with times and
      duration, cabin class, PNR + QR code, passenger list, fare paid, refundability — styled as an
      e-ticket/boarding-pass, matching `BusETicketScreen`'s visual pattern (perforated-stub layout).
      Built entirely from the `flightOnewayBook` response already in hand — no new endpoint (see Open
      Questions in spec 0009's counterpart concern, resolved here as: **not reopenable later**, same
      limitation bus had before its `ticketDetails` endpoint existed).
- [ ] **Download** (native Save As via `file_saver`) and **Share** (native share sheet via
      `printing`) generate a real PDF from the same data, reusing the `pdf`/`printing`/`file_saver`
      packages already added for bus — no new dependencies.
- [ ] `TicketView`/`ticketview` old screen is left in place but no longer reachable from this flow
      (becomes dead code, same treatment as `BusTicketScreen` after `BusETicketScreen` replaced it) —
      not deleted in this spec.
- [ ] `book_domestic_flight.dart` and its navigation chain are untouched.
- [ ] Module boundary preserved: no flights → bus (or reverse) cross-imports other than the relocated
      `BookingStepOverlay` now living in `lib/core/widgets/`.
- [ ] `flutter analyze` clean on all touched files.

## API contract

**None new.** Reuses `flightOnewayPrice`, `flightOnewayBlock`, `flightOnewayBook`, and
`paymentGatewayFor` exactly as currently implemented in `api_services_list.dart` /
`lib/core/payment_gateway.dart`. No backend confirmation needed.

## Out of scope

- `book_domestic_flight.dart` (domestic round-trip combined form) — follow-up spec once this pattern
  is validated on the reference flow.
- A `ticketDetails`-equivalent GET endpoint for flights (would make the e-ticket reopenable from "My
  Bookings" later, like bus's) — no such endpoint exists yet; flagged as a future gap, not built here.
- Splitting `api_services_list.dart`'s god-class or moving flight endpoints into a module-owned
  `services/` folder — acknowledged tech debt per `docs/architecture.md` §2, not a blocker for this
  spec since no endpoints are added or changed.
- Wiring flights into the `BookingContext`/`PaymentGateway` abstractions further than they already
  are — this spec is styling/state-organization only, not a booking-logic change.
- Any change to fare calculation, validation rules, or passenger data collected.

## Open questions

None outstanding — scope and the e-ticket data-source gap were confirmed directly with the product
owner before drafting.
