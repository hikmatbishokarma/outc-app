<!--
Copy this file to specs/000X-short-name.md (next number in sequence) and fill it in.
See docs/spec-driven-workflow.md for how specs fit into the overall process.
-->

# 0007 — Bus Results & Filters (eTravos design v1)

**Status:** Approved (2026-07-26)
**Module(s):** bus, core (reuses `lib/core/widgets/` built for flights)

## Overview

Build the Bus module's **results and filters screens** on top of the search call from
**spec 0006 — Bus Search**: render the trip list returned by search, and let the customer narrow it
with seven filter bottom sheets, matching the client-provided design ("Mobile APP - Hikmath.pdf",
eTravos branding) and the module contract in `docs/architecture.md`. Today's
`lib/dashboard/bus/screens/BusDashboard.dart` has mock result cards with hardcoded sample data and no
filter logic at all.

Unlike spec 0006 (where the request shape is still unconfirmed), **this spec's data contract is
grounded in a real sample search response** (Hyderabad → Bangalore corridor, `searchId:
16b16575-d6ce-4771-9863-138fc345d47b`) — see API contract below for the exact fields available.

## User story

As a guest or logged-in customer, I want to see real bus results with sort/filter options (seat type,
timing, AC, price, amenities, operator, boarding/dropping point), so that I can find and compare a
bus the same way I already can for flights.

## Acceptance criteria

- [ ] Bus module restructured to the standard shape: `bus/screens/`, `bus/models/`,
      `bus/providers/`, `bus/services/` — no business logic left in a widget file. (Shared with spec
      0006 — only do this once if both specs land close together.)
- [ ] Results screen: route + date + passenger-count header, "Sort & Filter" row with a live result
      count, operator cards (name (`displayName`), departure–arrival times, duration, seat/AC type
      (`busType`, `seatType`), price (`netFare`/`startingFare`), "Show Seats"), bottom quick-filter
      bar (Seat / Timing / AC / Sort / All Filters). **No rating badge** — the design mockup shows
      one, but the search response (confirmed on both the 3-trip sample and a full 290-trip live
      capture) has no rating field anywhere on a trip; omitted rather than fabricated until the
      backend actually returns one.
- [ ] Seven filter bottom sheets (reuse `core/widgets/bottom_sheet_shell`; the spec's own title/
      earlier drafts said "six" but the list below — matching the design PDF's numbered sections
      1–6 and 8 — has seven), each with Apply/Clear:
      Seat Type, Timing (Departure), AC/Non-AC, Sort By, Price Range (slider + preset chips),
      Amenities (multi-select), Bus Operators (searchable multi-select). Selected filters narrow the
      results list. **Seat Type and AC/Non-AC are both driven off the same `filters.busTypes` facet
      list** (confirmed two independent dimensions, not one category — see API contract notes):
      AC/Non-AC uses the `{AC, NON AC}` entries, Seat Type uses the `{Seater, Semi Sleeper, Sleeper}`
      entries. **Bus Operators is derived client-side** by deduplicating `trips[].displayName` (the
      `filters.busOperators` facet is confirmed to only ever contain a count, no operator list, even
      at full scale).
- [ ] Boarding-point and dropping-point facets (`data.filters.boardingPoints`/`.droppingPoints`) are
      **not** surfaced as a filter in this screen — decided out of scope. They're left unparsed here
      and remain available on each `BusTrip` for a later boarding-point *selection* step (once seat
      selection/booking is built) to consume.
- [ ] Filtering is **client-side** against the already-fetched `data.trips` array, using the
      `data.filters` facets purely to drive filter-UI options and counts — see Open Questions for why
      this is the assumption, not a confirmed backend behavior.
- [ ] Visual style matches the app's current navy/orange brand (`lib/widgets/colors/colors.dart`),
      not the generic Material `indigo` seed or the standalone `0xffec8333` orange literal used in
      today's file.
- [ ] Module remains deletable per `docs/architecture.md` §1: `bus/` imports only itself and
      `lib/core/` — no cross-imports from `flights/`, `hotels/`, etc.
- [ ] `flutter analyze` clean on all touched files.

## API contract

**Confirmed via a real sample response** (not yet confirmed as the *final* production contract —
this is one live capture, not a spec doc from the backend team, so field presence/nullability across
other routes/dates is still an assumption). Request shape belongs to spec 0006; this spec only
consumes `data.trips` and `data.filters` from that response.

```jsonc
{
  "statusCode": 200,
  "message": "Request Successful!",
  "searchId": "16b16575-d6ce-4771-9863-138fc345d47b",
  "data": {
    "totalCount": 3,
    "trips": [
      {
        "id": "1#4494427172",              // composite id, format "<supplier>#<tripId>" — treat as opaque string
        "displayName": "GAJRAJ BUS SERVICE",
        "busType": "Bharat Benz AC Seater/Sleeper",
        "availableSeats": 40,
        "arrivalTime": "11:30",
        "departureTime": "00:30",
        "duration": "10:00 hr",             // string, not minutes — format as-is or parse "H:MM hr"
        "ArrivalDate": "2026-08-06T11:30:00",
        "isRtc": false,                      // state-run (RTC) operator flag
        "amenities": ["Water Bottle", "Charging Point", "Reading Light", "GPS Tracking"],
        "source": "Hyderabad",
        "destination": "Bangalore",
        "cancellationPolicy": "<pipe/asterisk-delimited tiered refund string — needs a parser, not free text>",
        "partialCancellationAllowed": false,
        "netFare": "3675",                   // string, not number — parse before arithmetic/sort
        "base": 3500,                        // number
        "nextDay": false,
        "startingFare": "3500",              // string
        "commission": 0,
        "markup": 0,
        "agentMarkup": 0,
        "boardingPoints": [
          { "PointId": "300704", "Name": "Medchal", "Time": "2026-08-06T00:30:00",
            "Address": "Medchal", "Landmark": "Medchal", "Location": "Medchal" }
          // ... many more per trip
        ],
        "droppingPoints": [ /* same shape as boardingPoints */ ],
        "seatType": 1,                       // enum, values TBD — needs backend confirmation of the mapping
        "apikey": "BCI"                      // supplier/aggregator identifier — this endpoint may aggregate multiple suppliers
      }
    ],
    "filters": {
      "price": { "min": 681.45, "max": 10500 },
      "arrivalTimes": { "12AM to 06AM": 9, "06AM to 12PM": 7, "12PM to 06PM": 88, "06PM to 12AM": 194 },
      "departureTimes": { "12AM to 06AM": 9, "06AM to 12PM": 7, "12PM to 06PM": 88, "06PM to 12AM": 194 },
      "busTypes": [ { "type": "AC", "count": 286 }, { "type": "NON AC", "count": 62 }, { "type": "Seater", "count": 43 } ],
      "busOperators": { "count": 287 },        // shape looks incomplete — see Open Questions, likely missing a per-operator list
      "boardingPoints": [ { "id": "300704", "name": "Medchal", "count": 2 } /* ~2,400 entries in sample */ ],
      "droppingPoints": [ { "id": "485734", "name": "By pass signal devanahalli", "count": 4 } /* ~1,450 entries in sample */ ]
    }
  }
}
```

Notes for implementation:
- `netFare`/`startingFare`/`base` are inconsistently typed (string vs number) in the sample — models
  must parse defensively, not assume one type.
- **Re-verified against a full live capture** (same corridor, 290 real trips, not the earlier
  abbreviated 3-trip sample) — this resolved several items below from "assumption" to "confirmed":
  - `busTypes` counts (`AC: 289, Sleeper: 288, NON AC: 62, Seater: 42, Semi Sleeper: 9` against
    `totalCount: 290`) don't sum to `totalCount` because **the 5 entries are two independent
    dimensions, not one mutually-exclusive category**: AC/NON-AC is one axis, Seater/Semi
    Sleeper/Sleeper is another — a single "AC Sleeper" trip counts toward both. This is good news:
    the **AC/Non-AC sheet** and the **Seat Type sheet** (acceptance criteria) can both be driven off
    this one `busTypes` facet list, just filtered to the two entries vs the three entries
    respectively. See the resolved "Bus Type" open question below.
  - Each trip's numeric `seatType` field was `1` for **all 290 trips** — confirmed useless for
    filtering, not just absent a mapping. The Seat Type sheet must key off the `busType` free-text
    string (via the `busTypes` facet above), not the numeric `seatType` field. This closes that open
    question without needing backend confirmation of an enum mapping that turned out not to matter.
  - `busOperators: { "count": 290 }` — still only a count, no per-operator list, **confirmed at full
    scale** (this isn't a truncation artifact of the smaller sample). The Bus Operators filter must
    be derived client-side by deduplicating `trips[].displayName` (132 distinct operators in this
    capture), not read from `filters.busOperators`.
  - `arrivalTimes`/`departureTimes` bucket counts each sum to `302` against `totalCount: 290` — still
    off by 12, still unexplained, but confirmed small/stable rather than wildly inconsistent. Treat as
    a minor backend facet quirk; use for chip labels only, not a correctness check (unchanged
    guidance, now with more confidence it's not a sampling artifact).
  - All 290 trips were returned in one response with full facet data alongside them — reinforces
    (does not yet fully confirm) the client-side-filtering assumption below.

## Out of scope

- The search screen and search API call — spec 0006.
- Seat selection, boarding/dropping-point *selection* (as a booking step), passenger details form,
  add-ons, and payment — the design doc does not include these screens yet; today's mock
  implementations (`SeatSelectionScreen`, `BookingScreen` in the current `BusDashboard.dart`) are left
  as-is and untouched by this spec. A follow-up spec covers them once the client shares those designs.
- Wiring Bus into the `BookingContext` / `PaymentGateway` abstractions from spec 0001 — no purchase
  flow exists yet for this module.
- A "Bus Type" filter as a *distinct* numbered screen — the source design PDF's filter sections are
  numbered 1–6 and 8 (Seat Type, Timing, AC/Non-AC, Sort By, Price Range, Amenities, Bus Operators);
  section "7" is referenced by the numbering but its screen was not included in the handoff. See Open
  Questions. (Note the sample response's `busTypes` facet already includes an "AC"/"NON AC"/"Seater"
  breakdown under acceptance criterion 3's AC/Non-AC sheet — a separate "Bus Type" screen may be
  redundant with it; see Open Questions.)

## Open questions

- **Resolved — "7. Bus Type" filter screen**: not a missing screen. Re-verified against a full
  290-trip live capture: `filters.busTypes` is two independent dimensions (AC/NON-AC and
  Seater/Semi-Sleeper/Sleeper) packed into one 5-entry list. The design's numbered sections 6→8
  (skipping 7) lines up exactly with AC/Non-AC and Seat Type already being two separate sheets in
  this spec's acceptance criteria, both sourced from that one facet — there's no missing screen to
  chase down with the client.
- **Resolved — `busOperators` facet shape**: confirmed at full scale (290 trips, 132 distinct
  operators) to only ever be `{ count }`, never a per-operator list. Bus Operators filter is
  client-derived from `trips[].displayName`, not from `filters.busOperators`. No backend follow-up
  needed.
- **Resolved — `seatType` enum mapping**: moot. The numeric `seatType` field was `1` on all 290 trips
  in the live capture — not useful for filtering regardless of what the mapping turns out to be. Seat
  Type filtering uses the `busType` string / `busTypes` facet instead (see above).
- **Still open — Server-side vs client-side filtering**: this spec still assumes client-side. The
  290-trip capture strengthens the assumption (the full candidate set + facets arrive in one response
  regardless of size) but doesn't fully confirm it — a corridor with, say, 2,000 results might behave
  differently. Treat as a reasonable working assumption, not a confirmed contract; revisit if a huge
  corridor is found to paginate or behave differently.
- **Resolved — Boarding/dropping-point filter**: decided not in scope for this screen. Only the seven
  design-doc filter sheets are built here; `filters.boardingPoints`/`.droppingPoints` are left for a
  later boarding-point *selection* step (out of scope, post-trip-pick), not a results-screen filter.
