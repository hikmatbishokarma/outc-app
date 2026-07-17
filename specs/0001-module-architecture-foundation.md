# 0001 — Module Architecture Foundation

**Status:** Approved (2026-07-15) — approved on stated assumptions below, pending client confirmation
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

## Open questions — resolved with assumptions for this build

Still genuinely open with the client (see `OUTC_STATUS_REPORT.md` §8) — approved anyway on the
assumptions below because the abstractions are cheap to redirect later (nothing depends on them yet).
If the client answers differently, only the adapter/config changes, not the pipeline shape:

- **Payment gateway** — confirmed by the client to be **Cashfree**, not Razorpay (the original
  assumption in this section). The block response returns `{ payment_link, pgType }`:
  `pgType: 1` = Cashfree (customer), `pgType: 3` = wallet, already paid server-side (agent). This build
  implements the real interface (`PaymentGateway`, `paymentGatewayFor`) and a real wallet adapter
  (`WalletAlreadyPaidGateway`), with a mock adapter (`MockCashfreeGateway`) standing in for the actual
  Cashfree SDK until sandbox/live environment and one test transaction are confirmed (tracked as
  spec 0002).
- **Agent scope** — assumed **architectural placeholder only** for this build: `BookingContext`
  supports `payerType: agent`, and the wallet payment path (`pgType: 3`) is real and working since it's
  just an immediate-success short-circuit on the backend's own confirmation. No wallet-*debit* API call
  is made from this app — that already happens server-side before block returns. Not otherwise
  confirmed with client.
- **Flagship combo** — assumed **Flight+Hotel**, but this spec only implements the Flights reference
  path; Hotel follows once the pattern is proven (see Out of scope). Not confirmed with client.
