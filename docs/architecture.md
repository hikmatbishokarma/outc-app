# Architecture Standard

This is the engineering constitution for this repo. It exists because the product owner does not
read Dart, so the rules — not a person eyeballing a diff — are what keeps the codebase able to grow
into separate, independently-ownable products (Flight-only, Flight+Hotel, Flight+Hotel+Bus, B2C-only,
B2C+Agent, etc.) without every change becoming a rewrite.

Everything below exists to serve one goal: **adding or changing one thing should never require
editing something unrelated.** That's the Open/Closed Principle, applied concretely.

## 1. Module contract

Every travel service (`flights`, `hotels`, `cars`, `visa`, `bus`, and any future one) lives under
`lib/dashboard/<service>/` with this shape:

```
<service>/
  screens/     — UI only
  models/      — request/response DTOs (typed, generated from API contracts)
  providers/   — ChangeNotifier state, calls into services/
  services/    — the ONLY place that talks to the network for this module
```

**Rule:** a module folder may only import from itself and from `lib/core/` (shared theme, auth
session, HTTP client, common widgets). It may **never** import another module's screens, providers,
or models. If two modules seem to need the same thing, that thing belongs in `lib/core/`, not copied,
and not cross-imported.

**Why this matters for the product-line goal:** if a module only depends on core, it can be deleted
wholesale (to ship a "Flight-only" build) without hunting for broken references elsewhere. That's
the actual test for whether a module is "clean" — *could someone delete this folder and only this
folder, and have the app still compile?*

**Registration, not wiring-in:** home-screen tiles, side-menu entries, and routes must be driven by a
single module registry (a config listing which modules are enabled), not hardcoded per-screen the way
`lib/dashboard/homepage.dart` and `lib/sidemenu/sidemenu.dart` currently do. Turning a module on/off,
or omitting it entirely for a client build, is then a one-line config change — never a hunt through
UI files. (This registry does not exist yet — building it is the first spec, see `specs/0001-*`.)

## 2. Layering (Single Responsibility + Dependency Inversion)

```
Widget (screens/)  →  Provider (providers/, ChangeNotifier)  →  Service (services/)  →  Model (models/)
```

- **Widgets never call `http` directly and never build request JSON inline.** They read/trigger state
  through a Provider. Today's `lib/dashboard/flights/screens/book_domestic_flight.dart` does exactly
  the thing this rule forbids (raw `http.post` inside the widget file) — treat it as legacy, not a
  pattern to copy, and pull the network call out into a service the next time that file is touched.
- **Services return typed models, never raw `Map`/`dynamic`.** A service method's job is one HTTP call
  and one parse step — nothing else.
- **One service class per module**, exposing only that module's endpoints. Today's
  `lib/services/api_services_list.dart` is a single `APIService` god-class holding every module's
  endpoints (flights, hotels, visa, agent reports, auth) — this violates Interface Segregation. Don't
  add new endpoints to it; new endpoints go into the owning module's `services/` folder. Splitting the
  existing god-class is a cleanup task, not a blocker for new work.

## 3. The two abstractions that make B2C-first / Agent-later actually work

The current revenue logic assumes an agent books and a wallet gets debited server-side — hardcoded as
`roleType: 5` scattered through flight booking request models. For a B2C-first product where Agent is
an optional add-on (possibly per client), that has to become a seam, not a hardcoded value:

```dart
class BookingContext {
  final PayerType payerType; // customer | agent
  final int userId;
  final String? walletId;   // only meaningful when payerType == agent
}
```

Every booking request builder takes a `BookingContext` instead of a literal `roleType`. A B2C build's
pipeline is `block → PaymentGateway → book`; an agent-enabled build's pipeline is
`block → wallet debit → book`. Same pipeline, same models, different branch on `payerType` — not two
divergent code paths.

**Payment must be an interface, not a call site**, because different client deployments may use
different providers:

```dart
abstract class PaymentGateway {
  Future<PgOrder> createOrder(BookingContext ctx, num amount);
  Future<void> open(PgOrder order, {required void Function(PgResult) onResult});
  Future<PgResult> verifyCallback(Map<String, dynamic> payload);
}
```

One concrete adapter ships as the default (Razorpay is the likely first one — see the open question in
`specs/0001-*`). A client who needs Stripe/PayU/other only ever writes a new class implementing this
interface — the booking pipeline that calls it does not change. That's Liskov Substitution: any
`PaymentGateway` implementation must be swappable without the caller knowing which one it got.

Neither of these exists yet — see `specs/0001-module-architecture-foundation.md` for the concrete,
checkable spec.

## 4. Design tokens & theming — visual identity is a seam too

Same principle as §3's `PaymentGateway`, applied to how the app looks: brand color, shape, and elevation
must be an interface a client can swap, not a value hardcoded per screen. Concretely (see
`specs/0011-design-token-system.md` for the build that introduced this):

- **One source of truth**: `lib/core/theme/design_tokens.dart` defines every brand color, semantic
  color (success/warning/error), radius, shadow/elevation, spacing, and the one "glass surface" style
  in use. If a value is needed in more than one screen, it lives here — it is never re-typed as a hex
  literal at the call site.
- **Screens read `Theme.of(context)` or a `design_tokens.dart` constant directly — never a hardcoded
  hex, never a module's `colors.dart`.** Both `Theme.of(context).colorScheme.primary` and
  `AppColors.primary` are acceptable: `ThemeData` itself is built from `AppColors`, so either path
  traces back to the same one source, and a client rebrand (editing `design_tokens.dart`) reaches both
  equally. Prefer `Theme.of(context)` in new/small screens; a direct `AppColors.*` reference is fine
  where threading `BuildContext` through would mean touching a large volume of pre-existing call sites
  for no visual difference (see spec 0011's Flights migration for the precedent — the large,
  pre-existing screens use `AppColors` directly, the smaller/newer ones use `Theme.of(context)`). The
  one thing that actually matters: no screen invents its own hex value or imports a module's legacy
  `colors.dart`. `lib/widgets/colors/colors.dart` and the per-module `colors.dart` files
  (`dashboard/flights/widgets/`, etc.) are legacy — as each module is migrated (Flights/Bus/Home in
  0011; Hotels/Cars/Visa/Agent tracked in 0013), no screen in that module should still import its old
  color file. The color file itself may still physically exist afterward if something outside that
  module's scope still depends on it (e.g. a shared loading-spinner widget used by an unmigrated
  module) — that's fine; it's not a re-export shim, it's a real remaining dependency, and it goes away
  once the last dependent is migrated. **Do not import a module's `colors.dart` or write a new
  hardcoded `Color(0xFF...)` in any screen you touch — pull the value from the theme or
  `design_tokens.dart`.** If the token you need doesn't exist yet, add it to `design_tokens.dart`; don't
  inline it.
- **Glass is a reserved accent, not a base style.** `lib/core/widgets/glass_surface.dart` is the one
  implementation of the frosted/translucent treatment. It is used on exactly one hero surface per flow
  (a search entry point, a confirmation screen, a key bottom sheet) — never on list items, forms, or
  more than one surface in the same flow. Base surfaces stay flat (rounded card, soft shadow token).
  Reaching for `BackdropFilter` directly in a screen file instead of using `GlassSurface` is the same
  mistake as a widget calling `http` directly instead of going through a service.
- **A client rebrand is a new `design_tokens.dart`, not a screen-by-screen edit.** That's the actual
  test for whether this is done right: could a new client's whole visual identity be swapped in by
  pointing the build at a different token file, with zero screen files touched?

## 5. Flutter-specific conventions (bare minimum)

- `const` constructors wherever the widget's inputs allow it.
- Extract a widget into its own class/file once a `build()` method needs scrolling to read — don't
  let screens grow into multi-thousand-line files mixing five concerns (several existing screens do
  this; don't add to them, extract when you touch them).
- No business logic inside `build()` — computation belongs in the provider or a plain function it calls.
- File names `snake_case`, one primary public class per file.
- No throwaway/demo files committed (`dummy.dart`, `testFlight.dart`, `flightranjith.dart`,
  `flightbalaji.dart` are pre-existing examples — don't add new ones; delete these when the area they
  sit in is next touched).

## 6. Review checklist (what "closed for modification, open for extension" looks like in practice)

Before merging, a change should pass all of these:

- [ ] Does this touch more than one module's folder? If yes, is the shared thing actually core, or
      should this have been two separate changes?
- [ ] Does a widget call `http`/build request JSON directly? Should be in a service instead.
- [ ] Does a new payment provider, new payer type, or new service module require editing existing
      files beyond the one registration point? If yes, the abstraction is leaking.
- [ ] Does this screen hardcode a `Color(0xFF...)` or import a module's `colors.dart` instead of
      reading `Theme.of(context)`/`design_tokens.dart`? Does it use `BackdropFilter` directly instead
      of `GlassSurface`, or apply glass to more than one surface in the flow?
- [ ] Is `flutter analyze` clean on the changed files?

This checklist is what the `architecture-reviewer` subagent (`.claude/agents/architecture-reviewer.md`)
runs automatically — see `docs/spec-driven-workflow.md` for when it's invoked.
