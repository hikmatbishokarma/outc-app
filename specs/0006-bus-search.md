<!--
Copy this file to specs/000X-short-name.md (next number in sequence) and fill it in.
See docs/spec-driven-workflow.md for how specs fit into the overall process.
-->

# 0006 — Bus Search (eTravos design v1)

**Status:** Approved (2026-07-25)
**Module(s):** bus, core (reuses `lib/core/widgets/` built for flights)

## Overview

Rebuild the Bus module's **search screen only** — route/date/passenger entry and the call to the
real search endpoint — to match the client-provided design ("Mobile APP - Hikmath.pdf", eTravos
branding) and to actually follow the module contract in `docs/architecture.md`. Today's
`lib/dashboard/bus/screens/BusDashboard.dart` is a single 1120-line file with hardcoded sample data,
no `models/`/`providers/`/`services/` split, and no network calls at all — it is UI-only scaffolding,
not a working module.

This spec was split off a combined "search + results + filters" draft: **this half covers only the
search form and the search API call.** The results list, sort/filter UI, and the filter API contract
(`data.filters`) are spec **0007 — Bus Results & Filters**, which this spec's output feeds into.

## User story

As a guest or logged-in customer, I want to search one-way buses by route, date, and passenger
count, so that I get back a list of available trips to browse and filter (handled in spec 0007).

## Acceptance criteria

- [ ] Bus module restructured to the standard shape: `bus/screens/`, `bus/models/`,
      `bus/providers/`, `bus/services/` — no business logic or `http` calls left in a widget file.
      (Shared by spec 0007 — do this once, both specs build on it.)
- [ ] `Bus_Dashboard`'s nested `MaterialApp` is removed; the module is a plain widget tree that
      inherits the app's existing `MaterialApp`/theme/navigator (today it double-nests, which is a
      pre-existing bug — see Out of scope for why it hasn't broken visibly yet).
- [ ] Search screen: **one-way only** — no One Way / Round Trip toggle (see Out of scope). From/To
      city fields backed by a real city picker calling the confirmed `searchBusCities` endpoint (see
      API contract) as the user types — not free-text `TextField`s as today, and not the flights
      `airport_search_screen.dart`'s data source (bus uses its own city-search endpoint, returning
      `cityId` values, not IATA codes) — journey date picker, passenger count stepper (reuse
      `core/widgets/stepper_control`), "Search Buses" CTA.
- [ ] "Search Buses" calls the real search endpoint (see API contract) via a `BusService`, hands the
      parsed response to a `BusSearchProvider`, and navigates to the results screen (built in spec
      0007) with that provider's state — no more hardcoded sample trips.
- [ ] Visual style matches the app's current navy/orange brand (`lib/widgets/colors/colors.dart`),
      not the generic Material `indigo` seed or the standalone `0xffec8333` orange literal used in
      today's file.
- [ ] Module remains deletable per `docs/architecture.md` §1: `bus/` imports only itself and
      `lib/core/` — no cross-imports from `flights/`, `hotels/`, etc.
- [ ] `flutter analyze` clean on all touched files.

## API contract

### City search (confirmed, live)

`GET https://outc.in/api/v1/buses/searchBusCities/{query}` — e.g. `searchBusCities/hyd`. Powers the
From/To autocomplete field. Confirmed by hitting the live endpoint directly:

```jsonc
{
  "status": 200,
  "message": "SUCCESS",
  "data": [
    {
      "cityId": "2860",              // pass this as origin/destination in the search call below
      "name": "Hyderabad",
      "cityName": "Hyderabad,India",
      "fullName": "Hyderabad,Telangana,India",
      "countryCode": "IN",
      "country": "India",
      "state": "Telangana",
      "type": "city"
    }
    // ... more matches, e.g. "Hyderabad Airport RGIA", "Hyderabad By pass" as distinct cityIds
  ]
}
```

Note the query matches on more than just city names — airport and bypass/landmark variants of the
same city appear as separate `cityId`s (`"Hyderabad Airport RGIA"`, `"Hyderabad By pass"`), so the
picker must show `fullName` (or `name` + `state`) to disambiguate, not just group by city.

### Bus search (confirmed — both request and response)

`POST https://b2c.outc.in/api/v1/buses/availability`, `Authorization: Bearer <token>` (a guest
capture showed `Bearer null` — see Open Questions on whether guest search even needs a token),
`Content-Type: application/json`. Captured live from the app for the same
Hyderabad → Bangalore corridor as the response sample below (`searchId:
16b16575-d6ce-4771-9863-138fc345d47b`).

Path was previously documented as `.../availability/price` on `outc.in`; reconfirmed 2026-08-03
against the live web client's own network capture — the real path has no `/price` suffix, and
`b2c.outc.in` is the single host used end-to-end (search through block/book), matching
`AppConstant.baseUrl`.

Request body:

```jsonc
{
  "tripType": 1,              // always 1 (one-way) — this spec doesn't build a round-trip path
  "sourceId": "2860",         // cityId from searchBusCities, as string
  "destinationId": "702",
  "journeyDate": "06-08-2026", // DD-MM-YYYY
  "returnDate": "",            // always empty string — one-way only
  "src": "Hyderabad",          // display name, sent alongside the id — presumably for logging/display, not lookup
  "dst": "Bangalore",
  "userId": 1,                 // captured on an unauthenticated (guest) request — see Open Questions
  "roleType": 4,                // bus module's own roleType value — NOT the same 4/5 used by flights, see Open Questions
  "membership": 1
}
```

No `passengerCount` field — availability/price appears to return seat-level `availableSeats` per
trip rather than filtering by requested passenger count server-side. Confirm whether the passenger
stepper's value is used at all by this call, or only downstream at seat-selection (out of scope here).

Response (`200`):

```jsonc
{
  "statusCode": 200,
  "message": "Request Successful!",
  "searchId": "<uuid>",       // used to correlate this search with later results/filter calls
  "data": {
    "totalCount": 3,
    "trips": [ /* see spec 0007 for the full per-trip shape — results/sorting/filtering owns this */ ],
    "filters": { /* see spec 0007 — this spec only needs to know the field exists on the response */ }
  }
}
```

This spec's search screen only needs to: build the request, call the endpoint, and hand the whole
`data` object off to the results/filters flow (spec 0007) unchanged. It does not parse `trips` or
`filters` itself.

- `searchId` — appears to identify this search server-side; confirm whether later calls (e.g.
  paginating or re-fetching results) need to pass it back, or whether `data` is the complete result
  set in one shot.

## Out of scope

- **Round-trip search.** This spec covers one-way only — no trip-type toggle, no return-date field,
  no return-leg search call. `tripType`/`returnDate` are always sent as one-way values (see API
  contract). Round trip is a future spec if/when the client asks for it.
- Results list, sort/filter UI, and the `data.filters` contract — spec 0007.
- Seat selection, boarding/dropping-point selection, passenger details form, add-ons, and payment —
  the design doc does not include these screens yet; today's mock implementations of them
  (`SeatSelectionScreen`, `BookingScreen` in the current `BusDashboard.dart`) are left as-is and
  untouched by this spec. A follow-up spec covers them once the client shares those designs.
- Wiring Bus into the `BookingContext` / `PaymentGateway` abstractions from spec 0001 — no purchase
  flow exists yet for this module, so there's nothing to wire.
- Fixing the double-`MaterialApp` nesting bug's *downstream* effects beyond removing the nesting
  itself (e.g. any state loss it may currently mask) — flag anything found, don't chase it.

## Open questions

- **`roleType`/`membership`/`userId` semantics** — the live capture (unauthenticated/guest session,
  `Bearer null`) still sent `"userId": 1, "roleType": 4, "membership": 1`. Spec 0001 established
  `BookingContext { payerType, userId, walletId? }` as the seam that's supposed to replace hardcoded
  `roleType` literals (flights uses `roleType: 5`); bus's `roleType: 4` looks like the same
  legacy-style hardcoding, just a different literal for this module. Confirm with backend: (a) is
  `roleType: 4` bus's fixed "customer" value the same way flights hardcodes `5`, with a different
  value for agent search, and (b) are `userId`/`membership` meaningful for a guest at all, or is
  `userId: 1`/`membership: 1` just a placeholder the frontend always sends pre-login. This spec can
  proceed by mirroring whatever the live capture shows (hardcoded per-module constants, same pattern
  as flights today) but should flag rather than silently deepen the anti-pattern spec 0001 is trying
  to phase out.
- **`src`/`dst` display-name fields** — sent alongside `sourceId`/`destinationId` in the request;
  confirm whether the backend actually uses them (e.g. for logging) or whether they're vestigial and
  only the ids matter.
- **Splash screen (design page 1)** — the design shows a bus-specific "Welcome to eTravos Bus" splash
  with its own Login/Continue-as-Guest buttons. The app already has a single shared splash/login
  entry point (`Splashscreen` → guest-first dashboard, per spec 0002). Is this bus-specific splash
  meant to replace the shared one when entering via the Bus tile, or is it just how the designer
  mocked up the flow in isolation and the existing shared entry point stays as-is? **Recommendation:**
  treat it as the latter (no new splash screen) unless the client says otherwise — building a
  second, module-specific auth entry point would contradict the guest-first architecture just
  established in spec 0002.
