# 0003 — Flight Search Screen Redesign (Presentation & Interaction Layer)

**Status:** Approved (2026-07-20)
**Module(s):** flights, core (new `lib/core/widgets/`)

## Overview

Redesign the Flight Search screen's visual design and internal state management — replacing the
hand-duplicated One Way / Round Trip / Multi-City form markup in `search_flights.dart` with a
shared, reusable widget set (navy-branded, animated trip-type segmented control, a travellers/
cabin-class bottom sheet, dynamic multi-city route cards) — and fix the underlying navigation bug
that resets passenger count/cabin class selections whenever a city is picked. This is a
presentation/interaction-layer change only: no backend, API, model, or business-logic changes.

## User story

As a customer searching flights, I want a fast, visually polished search form — similar in
interaction quality to MakeMyTrip — where switching trip type or picking a city never loses my
passenger count or cabin class selection, so I don't have to re-enter my search criteria
repeatedly.

## Acceptance criteria

- [ ] Trip type (One Way / Round Trip / Multi-City) switches via an animated segmented control
      with a sliding indicator — no full-screen flash or rebuild delay.
- [ ] Picking a FROM or TO city returns to the *same* search screen instance with all other fields
      (dates, passenger counts, cabin class) unchanged — city pickers no longer push a new screen.
- [ ] Travellers/cabin-class selection opens as a bottom sheet (adults/children/infants steppers +
      cabin-class cards); the search card's summary line reflects the new selection immediately
      after the sheet closes, with no extra tap needed.
- [ ] The children-count stepper can be decremented all the way to 0 (fixes existing lockout at 1).
- [ ] Multi-City supports adding a 3rd (and further) route via "+ Add City" and removing any leg
      beyond the first two, with card add/remove animated; the form can never drop below 2 legs.
- [ ] Round Trip shows a "+ Add Return Date" affordance when no return date is set yet, matching
      the One Way → Round Trip flow in the reference screenshots.
- [ ] SEARCH still produces correct results for One Way, Round Trip (domestic and international),
      and Multi-City (2-segment, matching today's exact behavior) — same `ListModel` payload shape,
      same three results screens reached with the same constructor parameters.
- [ ] Visual style uses the current navy palette (`Flights_Colours`), with 16-18px card corner
      radii, 14px segmented-control radius, 12px button radius, 20px horizontal / 16px vertical
      spacing, and no clipped text or overflow at narrow phone widths.

## API contract

N/A — no backend/API/model changes. The outgoing `ListModel` payload (`originDestinations`,
`adultCount`, `childCount`, `infantCount`, `cabinClass`, `airTravelType`, etc.) and the navigation
contract into `OneWayFlightlistPage` / `FetchedMulticityFlights` / `FetchedDomesticMulticityFlights`
stay byte-for-byte identical to today.

## Out of scope

- A custom calendar/date-range picker — `showDatePicker` (Flutter's stock date picker) stays for
  this pass; a custom calendar is a separate, future spec.
- Any change to `models/`, `services/`, `lib/services/api_services_list.dart`, or the three flight
  results screens.
- Fixing the pre-existing bug where cabin-class selection has no effect on the search payload
  (both SEARCH handlers hardcode `cabinClass: "Economy"` today, regardless of the picked cabin
  card) — left exactly as-is; see Open Questions.
- Hotels/cars/visa/bus modules — this spec only makes the new shared primitives
  (`lib/core/widgets/`) available for those modules to adopt later; it does not adopt them there.
- Backend confirmation that multi-city search actually returns correct results for 3+ segments —
  this spec only guarantees the client can *send* an N-segment request in the same shape the
  backend already accepts for 2; end-to-end correctness for 3+ segments is unverified and not a
  blocker for this spec's completion.

## Open questions

- Should cabin-class selection actually flow into the `cabinClass` payload field (fixing the
  existing "always Economy" behavior), or is that intentionally deferred? — **Resolved with
  assumption**: left as-is (still sends `"Economy"` literally) since changing payload behavior is
  outside a presentation-layer redesign; flagged here so it isn't mistaken for an oversight.
- Is there a hard maximum on multi-city legs (backend limit or UX preference), or is "+ Add City"
  effectively unbounded? — **Resolved with assumption**: no hard cap enforced in this pass; can be
  added trivially later if the backend/product owner specifies one.
