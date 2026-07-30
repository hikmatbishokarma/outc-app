# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
flutter pub get              # install/update dependencies (run after any pubspec.yaml change)
flutter analyze              # static analysis — must be clean before any PR
flutter run -d chrome         # fast hot-reload loop for compiling/wiring logic only — NOT a design/UX reference; this app targets touch-first mobile, not web
flutter run -d <device-id>    # verify on a physical phone before calling a UI change done — see `flutter devices`
flutter devices               # list available targets (emulators/physical devices/chrome)
flutter test                  # run all tests
flutter test test/widget_test.dart   # run a single test file
```

There is no CI configured yet. `flutter analyze` + a manual run is currently the only quality gate — see "Definition of Done" below for what should gate a PR until CI exists.

The default `test/widget_test.dart` is the unmodified Flutter counter-app template test — it does not test this app and should be replaced/removed rather than "fixed."

## Architecture

**Stack**: Flutter/Dart, `provider` for state management (`ChangeNotifier`), `http` for networking, `shared_preferences` for local/session storage. No backend code lives in this repo — it's a client for a REST API (see `lib/services/app_constants.dart` for the base URL).

**App shell**: `lib/main.dart` wires up all `ChangeNotifierProvider`s and launches `Splashscreen` (`lib/Splash/splashpage.dart`), which reads `SharedPrefServices.getislogged()` to route to either `Dashboard` (`lib/dashboard/dashboard.dart`) or the login flow (`lib/loginflow/multiloginpage.dart`). `Dashboard` is a 3-tab bottom nav: Home, My Bookings, Account.

**Two audiences, one codebase**: this is simultaneously a B2C traveller app (search/book flights, hotels, cars, visa, bus as a guest or logged-in customer) and a B2B agent portal (`lib/partnerSidemenu/`) — reports, deposits, statements, wallet — reached from the side menu (`lib/sidemenu/sidemenu.dart`) and gated by `roleType` at login.

**Per-service module layout**: each travel service lives under `lib/dashboard/<service>/` (`flights/`, `hotels/`, `cars/`, `visa/`, `bus/`) with its own `screens/`, `models/`, `providers/`, and sometimes `widgets/` subfolders. This mirrors `lib/partnerSidemenu/` (agent side), which has parallel `models/`, `providers/`, `reportlistpages/`, `reportfilterpages/` per report type (flight/hotel/car/visa/deposit/statement). **Modules currently do not share a common base or contract — see `docs/architecture.md` for the module-boundary standard now being introduced.**

**Networking**: `lib/load_data/http_client.dart` is a singleton wrapping `http` with a JWT `Authorization` header read from `SharedPrefServices`. In practice, most screens instead call `lib/services/api_services_list.dart` directly (a single `APIService` class holding every endpoint across all modules) or, in some older screens, build `http` calls inline in the widget file itself (e.g. `lib/dashboard/flights/screens/book_domestic_flight.dart`). **This inline/monolith pattern is legacy and should not be extended — see `docs/architecture.md`.**

**Flight booking flow** (the most complete journey, and the reference for how other modules should eventually work): search (`search_flights.dart`) → results (`oneway_flight_list.dart` / `fetched_*_flights.dart`, one file per trip type) → passenger + fare form (`book_flight_formpage.dart` / `book_domestic_flight.dart`) → `flightOnewayPrice` → `flightOnewayBlock` → `flightOnewayBook` (all in `api_services_list.dart`) → `TicketView`/`ticketview_roundtrip.dart` shows the PNR. There is currently no payment-gateway step between block and book (see `docs/architecture.md` — this is an active gap, not an oversight to preserve).

**Session/auth**: `lib/widgets/sharedprefservices.dart` is the single source of truth for local session state (`islogged`, JWT, `customerId`, currency/guest/room defaults). Login (`lib/loginflow/userloginpage.dart`) and agent login (`agentloginpage.dart`) both write to it; registration (`userregistrationpage.dart`) is UI-only today — its submit handler does not call any API (there is no signup endpoint yet).

**Known legacy/dead files** (do not use as a pattern; safe to ignore or clean up when touched): `dummy.dart`, `testFlight.dart`, `flightranjith.dart`, `flightbalaji.dart` under `lib/dashboard/flights/`.

**Design tokens & theming**: `lib/core/theme/design_tokens.dart` is the single source of truth for brand colors, semantic colors, typography scale, radius/shadow/spacing scale, and the one "glass surface" style — see `docs/architecture.md` §4 and `specs/0011-design-token-system.md`. Home/Dashboard, Flights, and Bus are migrated onto it (Hotels/Cars/Visa/Agent are tracked in `specs/0013-*`, not yet migrated). **Any screen you write or touch must read `Theme.of(context)` (preferred) or a `design_tokens.dart` constant directly (acceptable where threading `BuildContext` through a large pre-existing file isn't worth the risk — see spec 0011's Flights migration) — never a hardcoded `Color(0xFF...)`/inline hex, and never import a module's legacy `colors.dart`.** Those color files are retired module-by-module as each module migrates; a file may still physically exist afterward if something outside that module still depends on it (e.g. a shared widget also used by an unmigrated module) — that's expected, not a shim, and goes away once the last dependent migrates. Glass/blur is only ever applied via the shared `GlassSurface` widget (`lib/core/widgets/glass_surface.dart`), and only on the one hero surface per flow called out in the spec — never as a base style, never copy-pasted `BackdropFilter`.

**App feedback states** (loading / error / empty / no-data / no-internet): tracked as `specs/0012-app-feedback-states.md`, built on top of the tokens above but a separate concern (behavior/consistency, not visual identity). Until that spec lands, screens still use ad hoc `CircularProgressIndicator`/inconsistent error handling — don't invent a new one-off pattern when touching a screen; either follow spec 0012 once it exists, or flag it rather than adding another bespoke loading/error widget.

## Process & standards

This repo is developed spec-first because the product owner does not read Dart:

- `docs/architecture.md` — the engineering standard (module boundaries, layering, the payment/payer
  abstractions). Read before making any structural change.
- `docs/spec-driven-workflow.md` — how a feature goes from idea → spec → plan → code → review. Follow
  this instead of jumping straight to implementation.
- `specs/` — one file per feature, copied from `specs/TEMPLATE.md`. `specs/0001-*` is the foundational
  one and should be read first.
- Before reporting any implementation work as done, run the `architecture-reviewer` subagent
  (`.claude/agents/architecture-reviewer.md`) against the diff — it's the substitute for a human
  code-reading review.
- `docs/commit-convention.md` — commit message format and PR expectations; every commit implementing a
  spec must reference it (`Refs: specs/000X-name.md`).

## Definition of Done (until CI exists)

- `flutter analyze` is clean (no new errors; avoid introducing new warnings in touched files).
- The change matches the module-boundary and layering rules in `docs/architecture.md`.
- For anything user-facing, actually run it on a physical phone (`flutter run -d <device-id>`) and exercise the changed flow — analyzer/tests don't prove a screen works, and Chrome doesn't prove it either (mouse/hover and unconstrained browser width hide touch-target and layout bugs that only show up on-device).
