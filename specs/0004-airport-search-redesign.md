# 0004 — Airport Search Screen Redesign

**Status:** Approved (2026-07-22)
**Module(s):** flights

## Overview

Redesign the airport (city) search screen used when picking FROM/TO on the flight search form, replacing
the current two separate near-identical full-screen pickers (`SelectCity`, `ToSelectCity`) with a single
combined screen that shows both FROM and TO together — one editable, one visible-but-disabled — matching
premium travel-app UX (MakeMyTrip-style). Presentation/interaction layer only.

## User story

As a customer picking flight airports, I want to see both my origin and destination on one screen while
searching, and have picking the origin automatically advance me to picking the destination when it's
still empty, so airport selection feels like one fast, continuous flow instead of two disconnected screens.

## Acceptance criteria

- [ ] A single new screen shows FROM and TO together: the active field is an editable rounded search
      card (56dp height, 14dp radius) with a back-arrow leading icon on the FROM slot; the inactive field
      is visible but disabled, showing its selected airport (code/city/airport name) or a placeholder, and
      tapping it switches which field is active.
- [ ] The active field autofocuses with the keyboard open on screen entry.
- [ ] "Recent Searches" (locally stored, most-recent-first, capped at a small number) shown only when the
      active field's query is empty and at least one recent entry exists; selecting one fills the active
      field immediately. Hidden as soon as the user types.
- [ ] Typing shows live results from the existing airport search endpoint (unchanged), each row ≥64dp,
      divided, showing code/city/airport name; selecting a row fills the active field.
- [ ] Selecting FROM: if TO is already filled, return to the flight search screen; if TO is empty,
      automatically switch to TO active (no separate navigation) instead of returning.
- [ ] Selecting TO: always return to the flight search screen afterward.
- [ ] No promotional/destination-suggestion content (popular searches, visa-free destinations, offers) —
      explicitly deferred, not part of this pass.
- [ ] Only `lib/dashboard/flights/screens/search_flights.dart`'s FROM/TO pick calls are rewired to the new
      screen. The existing `SelectCity`/`ToSelectCity` screens and the airport search HTTP call are left
      completely unchanged and untouched, since `lib/dashboard/cars/screens/search_cars.dart` also depends
      on them (a pre-existing cross-module reference, out of scope to fix here).

## API contract

Unchanged. Same endpoint/call used by the existing `SelectCity`/`ToSelectCity` (`GET
.../flights/updatedAirPort/search/:query`, parsed via the existing `Datum`/`CitiesbySearch` models) is
reused verbatim inside the new screen. "Recent searches" is new *local-only* storage (SharedPreferences,
same mechanism already used throughout this app for local state) — not a backend feature, no new endpoint.

## Out of scope

- Any change to the airport search API, `Datum`/`CitiesbySearch` models, or `SelectCity`/`ToSelectCity`
  (kept as-is for `search_cars.dart`'s continued use).
- Popular/visa-free/e-visa destination suggestion content — explicitly deferred per the brief.
- Applying this new combined screen to hotels/cars/visa/bus's own city pickers — flights only, for now.

## Open questions

- The redesigned inactive field's "airport name" subtitle needs data (`airportDesc`) that today's
  `SharedPrefServices` doesn't persist (only city/airport-code/country are stored for the already-selected
  leg). **Resolved with assumption**: fall back to showing city/country only when re-entering with a
  pre-existing selection sourced from `SharedPrefServices` (no new persisted field added, to avoid
  widening `SharedPrefServices`' schema for a cosmetic subtitle) — full code/city/airport-name shows
  correctly whenever the airport was just picked in the current session.
