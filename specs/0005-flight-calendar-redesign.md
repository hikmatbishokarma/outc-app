# 0005 — Flight Calendar Redesign

**Status:** Approved (2026-07-22)
**Module(s):** flights

## Overview

Replace the stock `showDatePicker` calls used by the flight search form (specs/0003 deferred this) with a
dedicated `FlightCalendar` full-screen component: a unified Departure+Return date screen for One Way/Round
Trip (mirroring the FROM/TO unification in specs/0004), and a single-date screen per leg for Multi-City.
Presentation layer only.

## User story

As a customer picking flight dates, I want a premium full-screen calendar — matching modern travel apps —
where picking a return date on what started as a one-way search converts it to round trip automatically,
so date selection feels like one continuous flow instead of two disconnected pickers.

## Acceptance criteria

- [ ] Tapping either Departure or Return on the search card opens the same full-screen calendar, showing
      both selection cards together; the tapped one is active (highlighted border), the other visible.
- [ ] Selecting a departure date automatically activates the Return card next (does not close the screen).
- [ ] Trip type is derived on Done, not on entry: if a return date was selected, the search reverts/forwards
      to Round Trip; if only departure was ever set, it stays/becomes One Way. No explicit "downgrade"
      affordance is needed since the calendar never clears an existing return date.
- [ ] Multi-city legs open a single-date variant: route label (e.g. "HYD → BOM"), one selection card, one
      month grid, Done — updates only that leg.
- [ ] Month grid: Mon–Sun header, swipeable months, past dates disabled/dimmed, today subtly outlined,
      selected date(s) filled, in-between range dates softly shaded, all animated (no abrupt changes).
- [ ] No price, fare, holiday, or promotional content anywhere in the calendar (explicitly excluded this
      pass) — the day-cell widget accepts optional forward-compatible slots for such data so it can be
      wired up later without a redesign, but nothing populates them now.
- [ ] Sticky full-width Done button (56dp) at the bottom, always visible.
- [ ] No other module's date picker is touched — confirmed nothing is shared (every module calls
      `showDatePicker` independently); this is additive, flights-only.

## API contract

N/A — pure client-side date selection. No backend calls. The resulting `DateTime`s still feed the exact
same `ListModel` fields (`departureDateTime`, per-segment dates) as before, unchanged format
(`yyyy-MM-dd`).

## Out of scope

- Fare prices, lowest-fare calendar, holiday badges, fare prediction, flexible-date chips, promotional
  highlights — explicitly deferred; the widget architecture reserves optional slots for these but none
  are implemented or wired to any data source in this pass.
- Any change to `book_flight_formpage.dart`, `book_domestic_flight.dart`, or any other module's date
  picker — all independently call the stock `showDatePicker`, confirmed not shared, left untouched.
- Any backend/model/API change.

## Open questions

- Exact max bookable month range for the swipeable pager isn't specified. **Resolved with assumption**:
  24 months forward from today (a generous, sane default for a flight search UI) — trivially adjustable
  later, not a structural decision.
