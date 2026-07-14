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

## 4. Flutter-specific conventions (bare minimum)

- `const` constructors wherever the widget's inputs allow it.
- Extract a widget into its own class/file once a `build()` method needs scrolling to read — don't
  let screens grow into multi-thousand-line files mixing five concerns (several existing screens do
  this; don't add to them, extract when you touch them).
- No business logic inside `build()` — computation belongs in the provider or a plain function it calls.
- File names `snake_case`, one primary public class per file.
- No throwaway/demo files committed (`dummy.dart`, `testFlight.dart`, `flightranjith.dart`,
  `flightbalaji.dart` are pre-existing examples — don't add new ones; delete these when the area they
  sit in is next touched).

## 5. Review checklist (what "closed for modification, open for extension" looks like in practice)

Before merging, a change should pass all of these:

- [ ] Does this touch more than one module's folder? If yes, is the shared thing actually core, or
      should this have been two separate changes?
- [ ] Does a widget call `http`/build request JSON directly? Should be in a service instead.
- [ ] Does a new payment provider, new payer type, or new service module require editing existing
      files beyond the one registration point? If yes, the abstraction is leaking.
- [ ] Is `flutter analyze` clean on the changed files?

This checklist is what the `architecture-reviewer` subagent (`.claude/agents/architecture-reviewer.md`)
runs automatically — see `docs/spec-driven-workflow.md` for when it's invoked.
