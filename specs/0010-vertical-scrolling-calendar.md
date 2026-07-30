# 0010 — Vertical-Scrolling Calendar

**Status:** Approved (2026-07-30)
**Module(s):** core (shared calendar widget), flights, bus

## Overview

Replace `CalendarPager`'s (`lib/core/widgets/calendar/calendar_pager.dart`) current horizontal,
one-month-at-a-time `PageView` — navigated via prev/next chevron buttons — with a single continuous
vertically-scrolling list of months, matching the pattern used by MakeMyTrip/redBus and most native
mobile date pickers. Presentation layer only; no change to how a date gets selected or what gets
returned to the caller.

This is a **shared widget change**, not module-specific: `CalendarPager` currently has three call
sites, and all three inherit whatever this spec does —

- `FlightCalendarScreen` (`lib/dashboard/flights/widgets/calendar/flight_calendar_screen.dart`) — the
  One Way/Round Trip Departure+Return **range** picker (specs/0005). The most complex consumer: two
  date cards, auto-advance from Departure to Return on selection, in-between dates shaded as a range.
- `FlightSingleDateCalendarScreen` (`.../flight_single_date_calendar_screen.dart`) — single-date picker
  for one Multi-City leg (specs/0005).
- `BusDateCalendarScreen` (`lib/dashboard/bus/screens/bus_date_calendar_screen.dart`) — bus's one-way
  single-date picker (specs/0006).

**Supersedes part of specs/0005**: its acceptance criterion "Month grid: ... swipeable months ..." is
replaced by continuous vertical scrolling. Every other criterion in specs/0005 (auto-advance to Return,
trip-type derived on Done, range shading, disabled past dates, today outline, sticky Done button, no
fare/price content) carries forward unchanged — this spec only changes how the user moves between
months, not any selection behavior.

## User story

As a customer picking a date (flight departure/return, a multi-city leg, or a bus journey date), I want
to scroll straight down through upcoming months the way MakeMyTrip does, instead of tapping arrow
buttons or swiping one month at a time, so picking a date further out feels like a natural scroll
rather than repeated paging.

## Acceptance criteria

- [ ] `CalendarPager` shows all months (`monthCount`, currently 24 forward from `baseMonth`) as one
      continuously scrollable vertical list — no `PageView`, no prev/next chevron buttons, no swipe
      gesture required to change months. Implemented as a `CustomScrollView` with one
      `SliverPersistentHeader` (pinned) + grid body per month, rather than a plain `ListView` — this
      gets lazy building/laying-out of off-screen months for free from the sliver protocol, satisfying
      the lazy-rendering criterion below without extra bookkeeping.
- [ ] **Sticky month label, resolved (was an open question)**: each month's label (`CalendarMonth`'s
      existing `showMonthLabel: true` — already built for exactly this, currently suppressed by the
      pager in favor of a fixed header) is pinned to the top of the visible viewport while its grid is
      the one on screen, then is pushed off/replaced by the next month's label as the user scrolls past
      the boundary — matching MMT's behavior and saving the vertical space the old fixed
      header-plus-chevrons row used to take. No separate fixed "July 2026" title bar above the list.
- [ ] The list opens **scrolled to the relevant month** for the current selection/active field —
      replacing today's behavior where switching active field remounts `CalendarPager` via
      `ValueKey(_activeField)` to reset the `PageView` to a new `initialPage`. In the vertical-scroll
      version this must be a programmatic scroll-to-position (e.g. `ScrollController` +
      `Scrollable.ensureVisible` or a computed offset), not a widget remount, since a remount would
      lose scroll position/animate jarringly in a long continuous list.
- [ ] `FlightCalendarScreen`'s existing auto-advance behavior is preserved: picking a Departure date
      switches the active card to Return and the calendar scrolls to bring the Return-relevant month
      into view (today's equivalent of the pager jumping to a new page).
- [ ] Range shading (`isInRange`/`isSelectedStart`/`isSelectedEnd` in `CalendarMonth`/`CalendarDay`)
      is visually unchanged — still spans across month-section boundaries correctly in a continuous
      list (e.g. a range from July 28 to August 3 shades the tail of July's grid and the head of
      August's grid).
- [ ] Rendering is lazy (e.g. `ListView.builder`/`SliverList` equivalent) — 24 months of grids are not
      all built/laid out eagerly on first frame, matching a normal scrolling-list performance
      expectation.
- [ ] Past dates remain disabled/dimmed per `minDate`, today remains subtly outlined, exactly as today.
- [ ] The sticky full-width Done button at the bottom is unchanged.
- [ ] All three call sites (`FlightCalendarScreen`, `FlightSingleDateCalendarScreen`,
      `BusDateCalendarScreen`) get this behavior automatically since they all render through
      `CalendarPager` — no call site needs its own bespoke scroll logic.

## API contract

N/A — pure client-side presentation change. No backend calls, no change to the `DateTime`/
`FlightDateSelection` values returned to callers, no change to any request payload.

## Out of scope

- Any change to date-selection *logic* (range rules, min-date rules, trip-type derivation) — this spec
  only changes how months are browsed, not how a date is picked or what happens after Done.
- Any change to `CalendarDay`'s visual design (colors, shapes, today/selected/range styling) beyond
  what's needed to keep it correct across a month-section boundary in a continuous list.
- Fare/price/holiday content in the calendar — still explicitly out of scope per specs/0005.
- A "jump to today" or "jump to month" shortcut control — not requested; can be a follow-up if wanted.
- Any non-calendar UI on the three screens (date cards, route label, app bar, Done button placement).

## Open questions

- Confirm 24-month range (`monthCount`) is still the right forward limit for a continuous scroll list
  — a pager arguably tolerated a large `monthCount` better than a naive long scrolling list would if
  not properly lazy; assuming it stays 24 unless told otherwise, since the lazy-rendering criterion
  above should make this a non-issue either way.
