<!--
Copy this file to specs/000X-short-name.md (next number in sequence) and fill it in.
See docs/spec-driven-workflow.md for how specs fit into the overall process.
-->

# 0016 — Multi-City Flight Results

**Status:** Approved (2026-08-22)
**Module(s):** flights

## Overview

Gives multi-city (2+ city, non-returning) flight searches a real results screen. Today the search
*form* supports any number of city legs, but every screen it can land on is hard-coded to exactly 2
legs (one, `fetched_multicity_flights.dart`, literally copy-pastes its UI for index `[0]` and `[1]`
with nothing beyond), so nothing past leg 2 has ever been rendered. This spec adds a genuinely N-leg
results list, itinerary card, and trip/fares detail sheet — built against the response shape the
backend actually returns (confirmed live, see below), not a guess.

## User story

As a guest or logged-in customer searching a multi-city trip, I want to see and compare full priced
itineraries covering every city I searched for, so I can pick one and view its fare/baggage detail —
the same quality bar as the oneway and round-trip results screens.

## Acceptance criteria

- [ ] Results list: one card per priced itinerary, each card showing every leg it actually contains
      (airline, time, route, duration — reusing `FlightRouteDivider`'s stop-dot styling) stacked
      under one combined price and refundable/non-refundable tag. No hardcoded assumption of exactly
      2 legs — a card renders however many legs its data has.
- [ ] Tapping a card opens a trip/fares sheet: one route/time recap per leg (city + airport names via
      `AirportNameCache`, matching the oneway/round-trip fare sheet's precedent), then one fare block
      per entry in that itinerary's `fareFamilies.fareFamilies[]` (never hardcoded to `[0]`) — price,
      refundable tag, baggage, expandable fare rules.
- [ ] Trip summary bar (reusing `FlightTripSummaryBar`): route label chains every leg's origin through
      the final leg's destination (e.g. "BLR → DEL → BOM", not "⇄" — this is a one-way chain, not a
      round trip), subtitle lists each leg's date.
- [ ] Quick-filter bar (reusing `FlightQuickFilterBar`) + full Filters sheet (reusing, via
      generalization, `FlightFiltersSheet`) both work against the combo list: price range/sort use the
      itinerary's one shared fare, "direct" means every leg in the itinerary is direct, airline/
      connecting-location filters union across all legs.
- [ ] Selecting a fare in the trip/fares sheet shows an explicit, honest "Booking for multi-city trips
      is coming soon" state — not a crash, not a silent no-op, and not a fabricated booking request.
      See Out of scope.
- [ ] The existing oneway and round-trip results screens' filtering behaves identically to before this
      spec once `FlightFiltersSheet`/`applyFlightFilters` are generalized to serve this screen too —
      this is a refactor of shared code, not a behavior change for the screens already using it.

## API contract

No new endpoint. Multi-city search already goes through `POST /api/v1/flights/airSearch` (same URL as
oneway/round trip) with `airTravelType: "multidestination"`. Confirmed live against the real backend
(2026-08-21/22) with a 3-segment request:

- Response shape is the existing `flight_roundtrip_model.dart` "combo" shape: `Data.flightDetails` is
  a `List<DataFlightDetail>`, each `DataFlightDetail` holding its own `List<FlightDetailFlightDetail>`
  (the legs) plus **one shared** `FareFamilies`/`fareId` for the whole itinerary — not the flat,
  independently-priced-per-leg shape `flight_domestic_roundtrip_model.dart` uses for true round trip.
  `FlightDetailFlightDetail` is field-for-field identical to `flights_list_model.dart`'s `FlightDetail`.
- **Confirmed backend limitation, not a client bug:** a 3-segment request only ever returns itineraries
  covering the first 2 legs — the 3rd segment is silently dropped, and `multicityFlightDetails` (the
  field that sounds like it should hold N-leg data) is empty in every response tested, including with
  a different `itineraryViewType`. This spec's client code places no artificial cap on leg count —
  cards/sheets render however many legs a `DataFlightDetail` actually contains — so 3+ leg support
  requires no client change once/if the backend adds it.
- `getFlightsMulticityListmethod`'s existing domestic-vs-international branch (picking between the
  flat model and the combo model) is confirmed wrong for multicity specifically — a same-country
  (India→India) 3-segment test still returned the combo shape. Multicity always uses the combo path
  (`matchingFlightRoundtripList`), regardless of country.

## Out of scope

- **Booking a multi-city itinerary.** The existing price→block→book flow
  (`flightOnewayPrice`/`flightOnewayBlock`/`flightOnewayBook`) assumes either one flight (oneway) or
  two *independently priced* legs (`BookDomesticFlight`, this session's round-trip work — separate
  `fareFamilies` per leg). A multicity combo has one shared price across N legs; there's no existing
  request shape for "block/book N legs under one combined fare" anywhere in this codebase, and
  inventing one for real payment code without a confirmed backend contract isn't done here. This is a
  flagged follow-up, not an oversight.
- Fixing or deleting `fetched_multicity_flights.dart`. **Correction found during architecture review:**
  this screen is *not* dead code — `getFlightsMulticityListmethod()`'s non-domestic branch still pushes
  it for a true international round-trip search (`_onSearchOneWayRoundTrip`, untouched by this spec).
  Only the genuine multi-city path (`_onSearchMultiCity`) was redirected to `FetchedMulticityResults`
  here. This screen's own pre-existing bug (hardcoded to legs `[0]`/`[1]`) is real and still live for
  international round trip — already flagged as a separate, not-yet-done follow-up in spec 0015's Out
  of scope (international round trip / `FetchedRoundtripFlights`); fixing it is not this spec's job,
  but it must not be mistaken for unreachable code.
- Any UI change to the search form (`multi_city_form.dart`) — already correct, unbounded add/remove.
- A visible "your Nth city wasn't found" notice when the backend silently drops legs beyond 2 — real
  UX gap given the backend limitation above, but not required for this pass to ship something correct
  for what the backend does return today.

## Open questions

None outstanding — scope and the backend-shape questions above were resolved via a live API probe and
a scoping conversation before this spec was written (see conversation history / plan file).
