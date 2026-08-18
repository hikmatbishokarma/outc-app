<!--
Copy this file to specs/000X-short-name.md (next number in sequence) and fill it in.
See docs/spec-driven-workflow.md for how specs fit into the overall process.
-->

# 0014 — Flight Results Filters (Oneway)

**Status:** Approved (2026-08-18)
**Module(s):** flights

## Overview

Port the bus module's filter bottom-sheet pattern (`BusFilterSheets`, spec 0007) onto the flight
oneway-results screen (`oneway_flight_list.dart`), replacing its always-inline, unstyled green filter
panel — the same panel that was crashing with a `RangeError` (see below) and displaying a broken
"0.00 INR – 0.00 INR" price range. Also adds Sort By, which didn't exist for flights at all.

Found and fixed in the course of live device testing, in this order:

1. **Crash on opening the filter panel**: `widget.filterData!.stops![0]`/`[1]` assumed the API always
   returns exactly a "Direct" and a "1 Stop (s)" entry, in that order. For an all-direct route the
   backend returns an empty `stops` array, so indexing `[0]` threw a `RangeError`. Fixed by looking up
   stop-type presence by label instead of position — same fix applied to the same copy-pasted pattern
   in `fetched_roundtrip_flights.dart`, `fetched_multicity_flights.dart`, and
   `fetched_domestic_multicity_flights.dart` (2 occurrences), since none of those screens had opened
   their filter panel yet to surface the same bug.
2. **Filters didn't combine**: `updateFilterData()` re-derived `flightsdata` from `widget.originalData`
   independently per filter category, each overwriting the last — so only the *last*-applied filter
   category ever actually narrowed the list, not all active filters together. Rewritten as one combined
   (AND'd) predicate.
3. **This spec**: the filter UI itself looked inconsistent with the rest of the app (raw green
   `Container`, hardcoded `Colors.blue`/`Colors.white` toggle chips, no `design_tokens.dart`) and asked
   to match the polish already shipped for bus.

## User story

As a guest or logged-in customer viewing oneway flight results, I want to filter and sort them through
the same kind of clean, tappable filter sheets the bus results screen already has, so that narrowing
down flights doesn't feel like a broken, unstyled leftover next to the rest of the app.

## Acceptance criteria

- [x] Funnel icon in the Flight Results app bar opens a "Filters" `BottomSheetShell` listing rows —
      Sort By, Price Range, Stops, Departure Time, Arrival Time, Airlines, Connecting Locations
      (only shown when the API returned any), Refundable — each drilling into its own sub-sheet,
      mirroring `BusFilterSheets`' `showAllFilters` structure.
- [x] Sort By: Price Low-to-High, Price High-to-Low, Duration Shortest, Departure Earliest (new —
      flights had no sort before this).
- [x] Price Range: `RangeSlider` bounded by the backend's `filterData.price.minPrice`/`maxPrice` when
      usable (`max > min`), falling back to the actual min/max fare across this search's results when
      the backend range is missing/collapsed (the "0.00 INR" bug).
- [x] Stops, Departure/Arrival Time, Refundable, Connecting Locations, Airlines: multi-select toggle
      sheets (Refundable is single-select, since "Refundable" and "Non-Refundable" are mutually
      exclusive) with per-sheet Apply/Clear, sharing one generic `_ToggleFilterSheet`.
- [x] All active filters combine (AND) against the full result set, plus the chosen sort, in one pass.
- [x] Funnel icon tints to the app's primary color while any filter is active, so it's visible from the
      results list without opening the sheet.
- [x] `flutter analyze` clean on all touched files; `flutter build apk --debug` succeeds.

## API contract

**None new.** Consumes the same `FiltersObj` (`price`, `stops`, `connect`, `airlines`) already returned
by the flight search endpoint — no backend change.

## Out of scope

- The other three flight-results screens (`fetched_roundtrip_flights.dart`,
  `fetched_multicity_flights.dart`, `fetched_domestic_multicity_flights.dart`) keep their original inline
  filter panel (crash fixed per above, but not restyled) — same bottom-sheet treatment as a follow-up
  once this pattern is validated here, matching how spec 0013 scoped the checkout redesign to the
  reference (oneway) flow first.
- Faceted counts per filter option (e.g., bus's "23 buses" subtitle) — flights' `FiltersObj` doesn't
  carry per-option result counts the way bus's provider-backed facets do; not invented here.
- A `FlightResultsProvider` matching `BusResultsProvider`'s architecture — this screen's filter/sort
  state stays on the existing `_OneWayFlightlistPageState`, consistent with how the rest of this
  (pre-token-system, pre-provider) screen is already built. A provider-based rewrite is a larger,
  separate effort than a filter-UI restyle.

## Open questions

None outstanding — scope was confirmed directly with the product owner (oneway-only) before
implementation.
