<!--
Copy this file to specs/000X-short-name.md (next number in sequence) and fill it in.
See docs/spec-driven-workflow.md for how specs fit into the overall process.
-->

# 0015 — Flight Results Card, Fare Sheet & Round-Trip Dual Pane

**Status:** Approved (2026-08-19)
**Module(s):** flights

## Overview

Redesigns how a flight result is presented and booked, for the oneway and (domestic) round-trip
results screens: the card drops all buttons down to a single tap target, tapping it opens a
"Flight & Fares" bottom sheet that lists every bookable fare for that flight as its own block
(price, refund/change terms, baggage, fare rules, Book), and round trip becomes a two-pane
horizontally-draggable view (onward + a peeking return pane) instead of a sequential "pick onward,
then pick return" flow. Also fixes a live bug found in the course of this work: `airLineLogo` is
already in every API response and already parsed onto `FlightDetail`, but the widget that would
render it has been commented out — no airline logo has ever displayed in the app.

Agreed via an artifact mockup (two iterations) before implementation — see conversation history.

## User story

As a guest or logged-in customer browsing flight results, I want each result to show only what I
need to compare flights at a glance (airline + logo, times, duration, price) and get fare/baggage/
booking detail only when I ask for it, and for round trip I want to see and pick both legs without
losing my place, so that the results screen reads like a native, polished flight-search experience
instead of a page of stacked buttons.

## Acceptance criteria

- [ ] **Card** (oneway + round trip, both panes): airline logo (`Image.network(airLineLogo)` with a
      graceful fallback — initials badge — on load failure/empty URL, since this field was already
      being fetched and parsed but never rendered), airline name, flight number, direct/stop badge,
      departure/arrival time + city + duration, price, and a "Non-refundable"/"Refundable" hint on
      the same row as price. No Book/Baggage/Flight-details controls on the card. The entire card is
      one tap target.
  - [ ] Same card component used by oneway, and by both onward and return panes in round trip — one
        widget, not copies.
- [ ] **Flight & Fares sheet** (`BottomSheetShell`), opened by tapping a card: a compact route/time/
      duration recap at the top, then one **fare block** per entry in that flight's
      `fareFamilies.fareFamilies` (already an array in the model — today's UI hardcodes `[0]` and
      never shows the rest, even though the backend already returns multiple fare families for some
      results). Each fare block shows: fare identifier, price (`adultPublishFare`/`totalPublishFare`),
      refundable/non-refundable tag (that fare family's own `isRefundable`, not the flight-level one),
      baggage (`baggage[].cabinBaggageInfo`/`baggageInfo`), an expandable "Fare rules" section
      (`fareRules[].fareRuleDetail`/`fareRestriction`), and its own Book button that proceeds with
      *that* fare family's `fareId`/data — never the flight's first fare implicitly.
  - [ ] Today's data may still yield exactly one fare block for most results — that's expected, not
        a bug; the sheet doesn't need more than one to render correctly.
- [ ] **Filters**: the drill-down "Filters" menu added in spec 0014 (tap a row, navigate to a
      sub-sheet, come back) is replaced with **one sheet holding every group already open** — Sort
      By, Price Range, Stops, Departure Time, Arrival Time, Airlines, Connecting Locations,
      Refundable — each a multi-select chip group directly in the scrollable sheet body, with a
      sticky "Show N flights" bottom bar reflecting the live count and a single Clear All. Existing
      per-group logic (the AND-combining `updateFilterData()`, the `_hasStopFilter` crash guard, the
      derived price-range fallback) from spec 0014 is reused as-is — this changes the sheet's
      structure, not the filtering logic underneath it.
- [ ] **Round trip dual pane** (domestic round trip via `FetchedDomesticMulticityFlights` —
      international round trip via `FetchedRoundtripFlights`/`FetchedMulticityFlights` is a
      follow-up, see Out of scope): onward and return flight lists render as two horizontally
      adjacent panes in one screen — onward filling most of the width, return peeking in from the
      right edge as a column of compact time/price mini-cards, matching the reference screenshots.
      Dragging brings the peeking pane into focus (full width); the other pane becomes the peeking
      column on the opposite side. Both panes scroll vertically, independently, without fighting the
      horizontal drag gesture.
  - [ ] A flight picked in either pane stays visually marked (its peek-card gets a highlighted
        border) even while collapsed to the peek column.
  - [ ] A bottom bar shows the combined round-trip total (sum of whichever legs are picked so far)
        and one Book action once both legs are picked. No "Lock Price" — not a feature this app's
        data model or backend supports; not invented here.
  - [ ] Filters apply across both panes at once (one filter sheet, one set of active filters, same
        instance already built for spec 0014/this spec — not duplicated per pane).

## API contract

**None new.** `airLineLogo`, `fareFamilies.fareFamilies[]` (with nested `baggage[]`/`fareRules[]`),
and `ibFlightDetails` are all already present and already parsed in `flights_list_model.dart` /
`flight_domestic_roundtrip_model.dart` — this spec is a client-side redesign consuming data the
models already expose but the UI never rendered.

## Out of scope

- International round trip (`FetchedRoundtripFlights`/`FetchedMulticityFlights`) getting the dual-
  pane treatment — same fix, separate follow-up pass once the domestic version is validated, same
  precedent as spec 0013/0014 scoping to the reference flow first. Its filter panel also still has
  the old inline (not sheet-based) UI from before spec 0014, untouched here.
  - Note found during investigation: `matchingFlightRoundtripList`'s `ibFlightDetails` is currently
    typed `List<dynamic>` (not `List<FlightDetail>` like the domestic model already is) — the
    international dual-pane follow-up will need that typed first.
- Multi-city (3+ leg) results — `multicityFlightDetails` is still raw untyped JSON in both models;
  needs its own model + screen work, well beyond this spec, per the artifact's "Later" note.
- "Lock Price" — flagged above as a deliberate omission pending a business/backend decision, not an
  oversight.
- Selecting/booking flow after "Book" is tapped inside a fare block — unchanged; still hands off to
  `BookFlightFormpage` exactly as today, just now carrying the tapped fare family's own data instead
  of always `fareFamilies[0]`.

## Open questions

None outstanding — design was iterated and confirmed via two rounds of an artifact mockup before
this spec was written.
