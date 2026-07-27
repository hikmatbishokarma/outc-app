# 0002 — Guest-First Home & Separate Agent Entry Point

**Status:** Approved (2026-07-17)
**Module(s):** core (splash/routing), loginflow, dashboard (home)

## Overview

Two related fixes to the app's entry experience, referencing MakeMyTrip's pattern of a guest-first
consumer app with a separate, deliberately secondary "MyBiz"-style entry for business/agent users:

1. The splash screen currently forces every non-logged-in user into the login screen before they can
   see anything — this contradicts the client's explicit requirement that login is not mandatory to
   search flights/hotels/etc. as a guest.
2. User Login and Agent Login are currently presented as two equal, side-by-side tabs on the same
   screen. For a B2C-first product, Agent should not be a first-class equal option on the primary
   entry screen — it should be a smaller, secondary link (MMT's "MyBiz" pattern), reached from the main
   guest/customer flow rather than competing with it.

## User story

As a customer, I want to land on the app and search flights/hotels immediately without being forced to
log in, so that I can browse and compare before deciding to book or create an account.

As an agent, I want a clearly separate, low-key entry point to my login (not equal billing with
customer login), so that the app's primary identity reads as consumer-first, matching how the client's
business is going to market.

## Acceptance criteria

- [ ] `Splashscreen` routes every user (logged in or not) to `Dashboard` (home). It no longer redirects
      guests to `MultiLoginScreen`. Search (flights/hotels/cars/visa/bus) works fully as a guest —
      no login prompt anywhere in search or fare-viewing.
- [x] ~~Checkout gate at Book Now, before the passenger-details form opens~~ — **superseded
      2026-07-27**: the gate blocked guests with a login screen that had no back/close affordance
      (`MultiLoginScreen`/`UserLogin` in gate mode had no `AppBar`, no pop control), so a guest who
      declined to log in was stuck with no way back to the flight results. Revised placement below.
- [ ] **Checkout gate, revised 2026-07-27**: a guest may browse fares and fill in the passenger-details
      form (`book_flight_formpage.dart`/`book_domestic_flight.dart`) without being prompted to log in.
      The login prompt now fires **after fare price confirmation succeeds and immediately before the
      block call** (`flightOnewayBlock`/`flightRoundTripBlock`), i.e. the guest sees the confirmed
      price before any login is required. If already logged in, this is a no-op passthrough. Flights is
      the reference implementation (matching spec 0001's precedent); Hotel/Bus/Visa booking completion
      is out of scope regardless (per spec 0001).
- [ ] The gate-mode login screen (`MultiLoginScreen`/`UserLogin` with `isGateMode: true`) must present a
      visible back/close control that pops the route (returning "not logged in" to the caller) whenever
      it was pushed onto an existing stack, so a guest who backs out of login is returned to what they
      were doing, never stuck on the login screen.
- [ ] After successful login at the gate, the flow resumes exactly where it left off — the already
      price-confirmed booking proceeds straight into the block call — confirmed by the client: never
      drop back to search results, Home, or the passenger-details form after a successful gate login.
- [ ] The login screen's identifier field is **cosmetically** relabeled/widened to accept "Email or
      Phone Number" (matching MMT's first-screen look). The underlying flow is unchanged: still a
      single screen, still requires a password, still posts to the existing `Loginrequestauth`
      (`UserName`/`Password`) endpoint as today — `UserName` just now may contain a phone number or an
      email, both sent as plain text exactly as before. **No OTP step, no new backend endpoint** — this
      is explicitly deferred (see Out of scope).
- [ ] The primary login screen presents **User Login** as the default, full-width experience — not a
      50/50 tab split with Agent Login.
- [ ] Agent Login is reached via a distinctly smaller, secondary link/button (e.g. "Partner/Agent
      Login" text link below the main login form) — reference MMT's MyBiz entry point for the visual
      treatment (small, not a competing tab).
- [ ] Agent Login itself keeps its existing form/fields — no functional change to how an agent
      authenticates, only how that option is discovered from the main screen.
- [ ] No agent self-registration path is added or implied anywhere in the app. Agent onboarding is
      confirmed to happen outside the app entirely (agent provides details to admin via the website;
      admin provisions the account). `AgentLogin` today already has no sign-up CTA — this spec keeps
      it that way explicitly, so a future contributor doesn't add one by mistake.

## API contract

N/A — this is routing/navigation and layout only. No new endpoints. `Loginrequestauth` (`UserName`/
`Password`) is sent exactly as today; only the label of the field collecting `UserName` changes.

## Out of scope

- Redesigning the home screen's visual content (search-widget-first layout, offers carousel, recent
  searches) — that's a separate, larger design pass the product owner flagged as still to be scoped;
  this spec only fixes the login-gate and the agent-entry hierarchy.
- **A real phone/email + OTP two-step login**, matching MMT exactly — requires a backend OTP
  send/verify endpoint that does not exist today. Explicitly deferred to a future spec once that
  endpoint exists; not attempted here even partially (e.g. no partial UI scaffolding for an OTP step).
- Any change to `userregistrationpage.dart` (still UI-only, no signup API — tracked separately).
- Applying the same checkout-gate pattern to Hotel/Bus/Visa booking — those don't have a working
  booking-completion flow yet (spec 0001), so there's nothing to gate.

## Open questions

- Exact visual treatment of the Agent Login link (plain text link vs. small button, placement above or
  below the main login CTA) — needs one round of design sign-off before implementation, even though
  the direction (small/secondary, MMT MyBiz-style) is confirmed. Approved anyway on the assumption of a
  plain small text link (cheap to redirect visually later; no structural impact).
