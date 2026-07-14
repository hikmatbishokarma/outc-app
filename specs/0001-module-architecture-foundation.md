# 0001 — Module Architecture Foundation

**Status:** Draft
**Module(s):** core (affects all modules)

## Overview

Introduce the structural pieces that let this codebase be sold as separate products (Flight-only,
Flight+Hotel, Flight+Hotel+Bus, B2C-only, B2C+Agent, etc.) and let each client engagement own an
independent repo/deployment — without every future change becoming a rewrite. This is the foundation
spec everything else builds on; see `docs/architecture.md` for the full reasoning.

## User story

As the product owner, I want service modules, the B2C/Agent split, and the payment provider to each be
swappable independently, so that a future client engagement can be scoped to exactly the services they
bought and handed off as a clean, standalone codebase.

## Acceptance criteria

- [ ] A single module registry/config declares which service modules (flights/hotels/cars/visa/bus)
      and which sides (B2C / B2C+Agent) are enabled for a given build.
- [ ] Home-screen tiles (`lib/dashboard/homepage.dart`) and side-menu entries
      (`lib/sidemenu/sidemenu.dart`) render from that registry instead of being hardcoded.
- [ ] A `BookingContext { payerType, userId, walletId? }` type exists and replaces the hardcoded
      `roleType: 5` in the flight booking request builders
      (`book_flight_formpage.dart`, `book_domestic_flight.dart`) as the reference implementation.
- [ ] A `PaymentGateway` interface exists with one working adapter (provider TBD — see Open Questions),
      and the flight booking pipeline is restructured to
      `airBlock → PaymentGateway → airBook` instead of the current `block → book` (no payment step).
- [ ] Deleting any one service module's folder (e.g. `lib/dashboard/cars/`) does not break compilation
      of the rest of the app, once its registry entry is also removed.

## API contract

N/A at this layer — this spec is about app-side structure. The `PaymentGateway` adapter's concrete API
contract depends on the provider chosen (see Open Questions) and will be a follow-up spec.

## Out of scope

- Implementing Hotel/Bus/Cars payment or booking completion (Flights is the reference implementation
  first; other modules follow once this pattern is proven).
- The actual "generate a client repo from a manifest" tooling — worth building once there are ≥2 real
  client engagements to design it against, not speculatively now.
- OTP/Firebase auth, registration API, SSR selection — tracked as separate specs (see the flight B2C
  journey gap analysis for the full list).

## Open questions

These block full approval and are also open with the client — see `OUTC_STATUS_REPORT.md` §8:

- Which payment gateway should the default adapter target (Razorpay assumed likely, not confirmed)?
- Is Agent in scope for the first shippable version at all, or purely an architectural placeholder for
  now (i.e. do we need a working wallet-debit path yet, or just the seam for one later)?
- Which service combination is the flagship package to demo first (Flight+Hotel assumed, not confirmed)?
