<!--
Copy this file to specs/000X-short-name.md (next number in sequence) and fill it in.
See docs/spec-driven-workflow.md for how specs fit into the overall process.
-->

# 0008 — Bus Seat Selection

**Status:** Approved (2026-07-26)
**Module(s):** bus, core

## Overview

Build the Bus module's **seat selection** screen: after picking a trip on the spec-0007 results
screen ("Show Seats" — currently a "coming soon" placeholder), show the real seat map for that trip
(fetched from a confirmed live endpoint) plus a boarding/dropping-point picker (using data already
fetched by search, spec 0006), and let the customer select exactly as many seats as the passenger
count they searched with. This replaces the legacy mock `SeatSelectionScreen` in
`lib/dashboard/bus/screens/legacy_seat_and_booking_mock.dart` with a real implementation.

This spec stops at seat + boarding/dropping-point selection. It does **not** cover passenger details,
add-ons, or payment/booking — those need their own endpoints (block/book equivalents), which haven't
been captured yet (see Out of scope).

## User story

As a guest or logged-in customer, having picked a trip from the results screen, I want to see the
actual seat layout with real-time availability and pricing, pick my boarding and dropping points, and
select the number of seats I searched for, so that I can proceed toward booking with a trip that's
actually configured the way I chose.

## Acceptance criteria

- [ ] Tapping "Show Seats" on a results-screen trip card (spec 0007) navigates to a new seat-selection
      screen instead of showing the "coming soon" snackbar, passing that trip's `id` (as `tripId`) and
      the `searchId` from the original search response.
- [ ] `BusSearchResponse.searchId` is threaded through the navigation chain (`BusSearchScreen` →
      `BusResultsScreen` → this new screen) — it isn't stored/passed anywhere today past the initial
      response, so this requires adding it to `BusResultsScreen`'s constructor params alongside the
      already-threaded `trips`/`filters`.
- [ ] On screen open, calls the confirmed `tripAvailability` endpoint (see API contract) and renders
      the returned seats as a real grid: grouped by deck (`zIndex`: 0 = lower, 1 = upper — confirmed
      via a live capture, not documented anywhere), positioned by `row`/`column`, sized by
      `length`/`width` (a sleeper berth's `length: 2` spans two grid units; a seater's `length: 1` is
      one unit).
- [ ] Each seat tile shows its `fare` and is styled by state: unavailable (`isAvailableSeat: false`),
      available, and selected (client-side selection state) — matching the color-coding style already
      established in the legacy mock (green/available, grey/sold) but driven by real data instead of
      the mock's hardcoded status strings.
- [ ] Selection is capped at exactly the passenger count from the original search
      (`BusSearchProvider.passengerCount`, threaded through the same chain as `searchId`) — the
      confirm action is disabled until exactly that many seats are selected.
- [ ] A running total fare updates live as seats are selected (sum of each selected seat's `fare`).
- [ ] Boarding-point and dropping-point pickers use the already-fetched `BusTrip.boardingPoints` /
      `.droppingPoints` (parsed in spec 0007, not yet surfaced in any UI) — no new API call needed for
      this part.
- [ ] Module stays deletable per `docs/architecture.md` §1: no new cross-imports from other modules.
- [ ] `flutter analyze` clean on all touched files.

## API contract

**Confirmed live** — captured the same way as specs 0006/0007 (a real browser request/response, not
a design doc).

`POST https://outc.in/api/v1/buses/tripAvailability`, same header convention as the search endpoint
(`Authorization: Bearer <token>`, `Content-Type: application/json`).

Request body:

```jsonc
{
  "searchId": "b3a6fef1-0ee6-4a82-b17d-7024017d9235",  // from the original search response
  "tripId": "1#4405748871",                              // the trip's `id` field from search results
  "userId": 1,
  "roleType": 4,
  "membership": 1
}
```

Response (`200`):

```jsonc
{
  "statusCode": 200,
  "message": "Request Successful!",
  "data": [
    {
      "seatCode": "1C",       // human-visible label — same as `number`
      "number": "1C",
      "row": 1,
      "column": 1,
      "length": 1,             // 1 = single seat/seater; 2 = sleeper berth (spans 2 grid units)
      "width": 1,
      "zIndex": 0,             // 0 = lower deck, 1 = upper deck (inferred from the capture, not documented)
      "fare": 456,             // per-seat price — varies seat-to-seat on the same trip
      "base": 456,
      "gst": 0,
      "markup": 0,
      "commission": 0,
      "agentMarkup": 0,
      "adminCommission": 0,
      "serviceTax": 0,
      "operatorServiceCharge": 0,
      "isAvailableSeat": true,
      "isMaleSeat": false,
      "isLadiesSeat": false,        // seat reserved for female passengers
      "isLadiesSeatReserv": false   // seat reserved AND currently held for a female booking in progress
    }
    // ... one entry per seat on the bus (~48 in the capture: 2 lower seater rows + 1 lower sleeper
    // row + 3 upper sleeper rows on this particular operator's layout — layout shape is not fixed
    // across operators, must be derived from row/column/zIndex, not hardcoded)
  ]
}
```

Notes for implementation:
- `fare`/`base` etc. are numbers here (unlike the search response's `netFare`/`startingFare`, which
  are inconsistently strings) — still worth parsing defensively rather than assuming.
- No boarding/dropping points in this response at all — confirmed by inspection. That data comes
  entirely from the search response's per-trip `boardingPoints`/`droppingPoints` (already parsed,
  spec 0007).
- The seat grid shape (how many rows/columns, which rows are sleeper vs seater, upper vs lower deck
  split) is **not a fixed layout** — it must be derived per-trip from each seat's own
  `row`/`column`/`length`/`zIndex`, since different operators/bus types will have different physical
  layouts. Don't hardcode "2 seater rows + 1 sleeper row" as if every bus looks like the one capture.

## Out of scope

- Passenger details form, add-ons, payment, and the actual booking/block/confirm step — no endpoint
  for any of this has been captured yet. A follow-up spec covers it once those are available.
- Wiring Bus into the `BookingContext`/`PaymentGateway` abstractions from spec 0001 — same reason.
- Enforcing gender-based seat rules (`isMaleSeat`/`isLadiesSeat`/`isLadiesSeatReserv`) beyond
  displaying them — there's no passenger-gender input anywhere yet (that's part of the out-of-scope
  passenger details form), so this spec can't actually enforce "only a female passenger may select
  this seat." See Open Questions.
- Deleting the legacy `BookingScreen` mock (passenger details/add-ons/payment) — it stays as
  unwired legacy scaffolding until the follow-up spec above; only `SeatSelectionScreen` is being
  replaced here.

## Open questions

- **Gender-reserved seats** — should a ladies-reserved seat (`isLadiesSeat: true`) be shown as
  selectable-but-flagged (e.g. a pink badge, still tappable) or fully blocked from selection in this
  spec, given there's no passenger-gender data collected yet to actually validate the rule? **Recommendation:**
  show it as visually distinct (matches the legacy mock's existing male/female icon treatment) but
  still selectable — the backend presumably enforces the real rule at block/book time once that step
  exists; don't invent a client-side enforcement rule not confirmed with the backend.
- **Seat layout variability** — the one live capture is a single operator's Volvo-style 2+1
  seater/sleeper layout. Confirm whether other operators' layouts (different row/column/zIndex
  patterns) have been checked, or whether the rendering approach (derive purely from each seat's own
  grid fields, no assumptions) is trusted to generalize. Recommend testing against at least one more
  operator's `tripAvailability` capture before calling the layout algorithm done.
- **`searchId` lifetime** — how long is a `searchId` valid for a `tripAvailability` call after the
  original search? Not confirmed; matters if a customer lingers on the results screen before tapping
  "Show Seats."
