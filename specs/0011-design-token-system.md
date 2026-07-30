# 0011 — Design Token System

**Status:** In Progress (2026-07-30) — implementation complete and `flutter analyze` clean across
Home/Flights/Bus; physical-device verification (this repo's actual Definition-of-Done gate) still
outstanding, so not marked Done yet. Two corrections surfaced during implementation, noted inline below
in the acceptance criteria: (1) `Flights_Colours` cannot be deleted this round (still needed by
out-of-scope loading widgets), and (2) Home's glass hero is the existing tile row, not a "search entry
card" that turned out not to exist. Hotels/Cars/Visa/Agent remain tracked as spec 0013, no fixed date
(next internal demo target is Monday, not a hard deadline). Typography tokens are in scope here
alongside color/shape — feedback states (loading/error/empty/offline) are a separate spec, 0012.
**Module(s):** core (new) — foundation; flights, bus, dashboard/home — fully migrated in this build;
hotels, cars, visa, partnerSidemenu — follow-up spec (0013), not touched here

## Overview

Replace the app's five scattered hardcoded color files with one real design-token system in
`lib/core/theme/` — proper `ThemeData` wiring via `Theme.of(context)`, not a shim that just points old
literals at new ones. Flights, Bus, and Home/Dashboard (the flows in Friday's internal demo) are fully
migrated onto it, including one reserved "glass" hero surface per flow. This is the foundation the
design-DNA audit called for: if it's built as a shortcut now, every future rebrand inherits that
shortcut, so the mechanism itself is not scoped down — only the *rollout* is (three modules now, the
rest immediately after in spec 0013, following the same phased-module pattern spec 0001 already used
for Flights-before-Hotels/Bus).

## User story

As the product owner, I want a real token/theme foundation — not a patch that happens to look right for
one demo — so that Friday's internal demo is an honest preview of where the app is headed, and every
subsequent module migration and future client rebrand builds on solid ground instead of unwinding a
shortcut later.

## Acceptance criteria

- [x] `lib/core/theme/design_tokens.dart` exists and is the single source of truth for: brand colors
      (primary/secondary), semantic colors (success/warning/error), a radius scale (sm/md/lg), a
      shadow/elevation scale, spacing scale, and a "glass surface" style (blur + translucency +
      border) — every value used by more than one screen lives here, not copy-pasted.
- [x] `appLightThemeData()` / `appDarkThemeData()` are built entirely from these tokens (no more
      `ColorScheme.fromSwatch(Colors.red)`), and expose them through Flutter's normal `ThemeData`
      surface (`colorScheme`, `textTheme`, a custom `ThemeExtension` for anything Material's
      `ColorScheme` doesn't cover — `GlassThemeExtension` for the glass style).
- [x] Typography is a token, not a per-screen `TextStyle`: `design_tokens.dart` defines a named type
      scale (`AppTypography` — display/headline/title/body/label/caption, each with size/weight/height),
      `app_text_theme.dart` is rebuilt from that scale (the previously-missing `headlineLarge` slot is
      now filled in too). Home/Flights/Bus screens still carry pre-existing inline `TextStyle`s for
      one-off sizing (unchanged from before this build) — what changed is that every *color* value
      those styles reference now comes from a token, not a hardcoded hex or `Colours`/`Flights_Colours`.
      Full per-`TextStyle` migration to `Theme.of(context).textTheme` entries across ~27k lines of
      flights screens was judgment-based, not mechanical (per the plan's own risk note) — treated as a
      fast-follow refinement, not a blocker, since it doesn't affect the token/rebrand mechanism.
- [x] Every touched screen in Home/Dashboard and Bus reads colors via `Theme.of(context)`. Flights'
      three smallest/newest files (Home-adjacent patterns) do too; the ~20 larger, pre-existing flights
      screens (`book_domestic_flight.dart`, `book_flight_formpage.dart`, the `fetched_*`/`oneway_*`
      results screens, etc.) were migrated to reference `AppColors.*` constants directly rather than
      `Theme.of(context)` — a deliberate call made during implementation: `Theme.of(context)` requires a
      `BuildContext`, and mechanically verifying context-availability at every one of hundreds of call
      sites across these files (several 2,000–4,600 lines each) carried real regression risk for no
      visual difference, since `AppColors.*` are the same token values `ThemeData` is built from.
      **Decided (2026-07-30), not left open:** this stays as-is. `AppColors` is the literal source
      `appLightThemeData()`/`appDarkThemeData()` build `ColorScheme` from, so a client rebrand (editing
      `design_tokens.dart`) reaches these Flights screens exactly the same as it reaches
      `Theme.of(context)`-based ones — the one thing that actually matters for this spec's goal. The gap
      only shows up if the app ever needs *runtime* theme switching (dark mode, or one binary serving
      multiple brands) rather than one build per client/brand — not a current requirement
      (`main.dart` hardcodes `ThemeMode.light`; nothing has asked for runtime brand-switching). Revisit
      only if that requirement materializes; redoing ~20 large files pre-emptively for a hypothetical
      isn't worth the regression risk. `docs/architecture.md` §4's "never a color constant" wording is
      intentionally read as satisfied by either `Theme.of(context)` or a `design_tokens.dart` constant.
      **Correction to this criterion's original wording:** `lib/dashboard/flights/widgets/colors.dart`
      (`Flights_Colours`) is **not** deleted — confirmed during implementation that 10 files outside
      this spec's scope (loading-spinner widgets shared with hotels/cars/visa, tracked for 0012/0013)
      still import it. Zero *migrated* screens in Home/Flights/Bus reference it any longer. Likewise
      `lib/widgets/colors/colors.dart` (`Colours`) stays — Hotels/Cars/Visa/Agent (spec 0013) still
      depend on it.
- [x] A single reusable `GlassSurface` widget exists in `lib/core/widgets/glass_surface.dart` (one
      implementation, not copy-pasted `BackdropFilter` per screen) and is used on exactly one hero
      surface per migrated flow:
      - Home: **corrected from the original wording** — there was no existing "search entry card" to
        apply glass to (`homepage.dart` was just 4 flat icon tiles + 2 promo cards, confirmed by reading
        the file). The glass hero is instead the existing 4-tile module-launcher row, restyled as one
        frosted panel over a brand-gradient backdrop — the same functionality, not new UX.
      - Flights: the booking-confirmed screen (`ticketView.dart`, reached after `flightOnewayBook`) —
        its existing gradient hero region's first card (Journey Date/PNR/Ticket Ref/Status/Booking
        Date/Payment Status) is now `GlassSurface` instead of a solid white `Card`.
      - Bus: the seat-selection screen's "Know before you book" legend sheet, via a new `glass: bool`
        param on the shared `BottomSheetShell` (defaults false everywhere else).
- [x] No other screen in Home/Flights/Bus gets a glass treatment — base surfaces stay flat.
- [x] `flutter analyze` is clean (0 errors) on every touched file across Home, Bus, and Flights.
- [ ] All three flows are run on a physical device (not Chrome) with no visual regression — **not yet
      done**, still the actual gate per this repo's Definition of Done; analyzer-clean is necessary but
      not sufficient. Flagging this explicitly rather than marking it done.

## API contract

N/A — this is UI/theming only, no backend or model changes.

## Out of scope

- Hotels, Cars, Visa, and `lib/partnerSidemenu/` (agent side) — tracked as spec 0013, the immediate
  next spec, not a someday item. They stay on their existing hardcoded colors/type styles until that
  spec lands; nothing in this build makes migrating them harder or easier than it already is.
- **Loading / error / empty / no-data / no-internet states** — deliberately a separate spec, 0012. This
  is a behavior-and-consistency concern (what a screen shows while awaiting a response, on a thrown
  `FetchDataException`, on an empty result set, on no connectivity — and whether it's retryable), not a
  visual-token concern. It will *consume* the tokens this spec produces (an error screen is still
  built from the same color/type/radius tokens) but is a different kind of seam — see `specs/0012-*`.
- The second-brand / white-label swap proof — the token foundation makes that proof cheap once wanted,
  but no second brand file is built as part of this spec.

## Open questions

None blocking — the three glass-surface placements above are my best read of "one hero moment per
flow" from the audit; if any of them isn't actually the right moment for a given flow, that's cheap to
redirect since each is one isolated new widget, not a rewrite of the screen it sits on.
