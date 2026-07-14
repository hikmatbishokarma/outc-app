# OutC Travel Booking App — Status & Scope Report

**Current State & Migration Readiness**

An evidence-based assessment of the inherited Flutter application — what exists, what works, what is broken or unbuilt — prepared to align on scope with the client before the **anjmal → OutC** backend migration proceeds.

| | |
|---|---|
| **Prepared for** | Client sign-off |
| **App version** | 1.0.0+1 |
| **Date** | 12 Jul 2026 |
| **Status** | Draft for review |
| **Source** | Code review + live testing |

---

## 01 — Executive Summary

OutC is a **cross-platform travel-booking app built in Flutter** (Dart), covering flights, hotels, cars, visa and bus, with a second, agent-facing side (reports, wallet/deposits, statements). The project was handed over from a previous team that had stalled. The codebase is **substantially built but uneven**: the flight journey is the most complete, several modules are UI-only shells, and some core commerce pieces (payment, registration) are not implemented.

The client's headline objective is to **replace the current backend (`anjmal.i2space.in`) with their own OutC backend (`outc.in`)**. Good news: both run the *same API contract*, so the switch is largely configuration. The real work is confirming the OutC server exposes every route with live data, and closing the app-side gaps below.

| Metric | Value |
|---|---|
| Service modules present | **6** |
| Target platforms configured | **6** (Android, iOS, Web, macOS, Windows, Linux) |
| Backend endpoints referenced | **18** |
| Overall build completeness (est.) | **~45%** |

> Primary intended target is mobile (Android/iOS); web is being used here for rapid local testing.

---

## 02 — What the App Is: A Dual-Sided Travel Platform

The app is not a single product — it serves **two distinct audiences** from one codebase, which is important for scoping.

**B2C · Customer — Traveller booking app**
A guest or registered customer searches and books flights, hotels, cars, visas and bus. Intended flow: browse freely, log in to book. Currency defaults to INR; India-focused content.

**B2B · Travel Agent — Partner / agent portal**
Logged-in agents access a side-menu portal: booking reports (flight/hotel/car/visa), deposit requests, account statements, wallet balance, bank details and password change. Distinguished by a `roleType` at login.

> **Scoping implication:** "finish the app" means finishing *two* products. The client should confirm whether both the B2C traveller app *and* the B2B agent portal are in scope for this phase, or whether one comes first.

---

## 03 — Module Progress: Completeness by Service

*Percentages are engineering estimates from code review + live testing, not exact.*

| Module | Status | Est. | Notes |
|---|---|---|---|
| ✈️ **Flights** | 🟢 Working | ~75% | Search → results → fare price → block → book endpoints all present and reachable. One-way tested live against OutC (search + price OK). Missing: payment step; guest booking rejected by design. |
| 🏨 **Hotels** | 🟡 Partial | ~50% | City search, hotel list, rooms, amenities, gallery all built. The booking form has **no submit / API call wired** — journey stops before booking completes. |
| 🛂 **Visa** | 🟡 Partial | ~45% | Country search, visa lists, full details and guidelines work against the backend. Application form submission not confirmed wired end-to-end. |
| 🚗 **Cars** | ⚪ Shell only | ~15% | Only a search screen and pickup-location picker exist. **No backend calls at all.** Placeholder UI. |
| 🚌 **Bus** | ⚪ Shell only | ~10% | A single dashboard screen, no backend integration. On the home screen but non-functional. |
| 🧾 **Agent Portal** | 🟡 Partial | ~55% | Flight/hotel/car/visa reports, deposits and statements wired with filters and state management. Needs end-to-end testing against OutC and real agent accounts. |

### Authentication & Access

| Area | Status | Est. | Notes |
|---|---|---|---|
| 🔑 **Login** | 🟢 Working | ~70% | User & agent login via `mobileLogin`. Verified live: request reaches OutC and returns a valid response ("User Not Found" — i.e. no accounts on the OutC server yet). JWT stored locally. |
| 📝 **Registration** | 🔴 Not implemented | ~20% | Screen fully designed but the REGISTER button **only prints data to the console** — no API call, and no registration endpoint exists in the app. Sign-up currently does nothing. |

**Legend:** 🟢 Working · 🟡 Partial · 🔴 Broken / missing · ⚪ Shell only

---

## 04 — Backend & API: Endpoints in Use & Migration Status

Because `anjmal` and `outc` are the same product on different servers, the migration is a **base-URL switch** — already applied in the app and pointed at `https://outc.in/`. What remains is confirming each route is live with data on the OutC server.

| Endpoint | Area | App status |
|---|---|---|
| `admin/mobileLogin` | Auth | 🟢 Live-tested |
| `admin/changePassword` | Auth | 🟢 Wired |
| `admin/getAllServicesTopCities` | Common | 🟢 Wired |
| `admin/myBookings` | Account | 🟡 Wired, untested |
| `flights/updatedAirPort/search` | Flights | 🟢 Live-tested |
| `flights/airSearch` | Flights | 🟢 Live-tested |
| `flights/airPrice` | Flights | 🟢 Live-tested |
| `flights/airBlock` | Flights | 🟡 Wired, untested |
| `flights/airBook` | Flights | 🟡 Wired, untested |
| `hotels-v2/hotelsearch` | Hotels | 🟡 Wired |
| `hotels-v2/hotelrooms` | Hotels | 🟡 Wired |
| `hotels-v2/searchhotelcity` | Hotels | 🟡 Wired |
| `visa/visaSearch` | Visa | 🟢 Wired |
| `visa/getVisaMasterByVisaCode` | Visa | 🟢 Wired |
| `visa/getVisaBookignReportsByFilter` | Agent | 🟡 Wired |
| `carextranet/carBookingReportsByFilter` | Agent | 🟡 Wired |
| `agentbalancelog/getagentbalancelogrecords` | Agent | 🟡 Wired |
| `admin/agentdepositrequest` | Agent | 🟡 Wired |

> **Note:** there is *no car/bus booking or search endpoint* anywhere in the app — consistent with those modules being shells. "Wired, untested" means the app calls it but we have not yet confirmed a successful round-trip against the OutC server.

---

## 05 — Findings: What Works, What's Broken, What's Missing

### ✅ Confirmed working (live)
- App builds and runs; login reaches the OutC backend and parses responses.
- Flight search → results list → fare pricing works end-to-end against OutC.
- Airport / hotel-city / visa-country autocomplete pulls live data.

### ⚠️ Broken or incomplete (found during review)
- **Registration does nothing** — button prints to console; no endpoint exists.
- **Hotel booking** — form has no submit; journey can't complete a booking.
- **Cars & Bus** — UI shells with no backend; not usable.
- **No payment gateway** — no Razorpay/Stripe/Paytm (or any) integration exists; bookings cannot take money.
- **Autocomplete noise** — search fires on every keystroke incl. empty input, causing harmless 404s.
- **Guest-mode crashes** — several screens assumed a logged-in user and crashed for guests (already patched during this review).

### 🔧 Already fixed during this review
- Centralised the API base URL and pointed the app at `outc.in` (the client's core ask).
- Enabled guest access so customers can search without logging in (per B2C intent).
- Fixed null-value crashes on the dashboard and the flight booking form for guests.
- Resolved build-blocking package incompatibilities and a missing logo asset.

> *These fixes are staged pending client confirmation of intended behaviour — no product decisions have been made unilaterally.*

---

## 06 — Proposed Blueprint: How the Flow Should Work

A proposed target flow for the client to confirm or correct. Nothing here is final — it's a starting point to react to.

**B2C · Customer journey**
1. **Browse** — Open app → home, no login wall
2. **Search** — Flights / hotels / visa as guest
3. **Select** — Pick result, view fare / rooms
4. **Log in** — Prompt at "Book" if guest
5. **Pay** — Payment gateway *(to build)*
6. **Confirm** — Ticket / voucher + My Bookings

**B2B · Agent journey**
1. **Agent login** — Role-based access
2. **Book on wallet** — Deduct from deposit balance
3. **Reports** — Flight / hotel / car / visa
4. **Deposits** — Request & track top-ups
5. **Statements** — Account ledger

> **The two biggest scope questions** hidden in this blueprint: (1) which *payment provider* OutC wants, and (2) whether agents book against a *prepaid wallet* while customers pay per booking. Both are unbuilt today and both need client direction.

---

## 07 — Stakeholders

| Role | Who | Needs |
|---|---|---|
| **End user** | Retail traveller | Fast search, clear pricing, easy payment |
| **Channel partner** | Travel agent | Wallet/credit booking, reports & statements |
| **Owner** | OutC (product / client) | App running on their own backend & brand |
| **Delivery** | Development (you) | Migration, gap-closure and launch |

> Stakeholder list is inferred from the code and the brief — please confirm the real names/roles, especially who owns/administers the OutC backend and who provides flight/hotel/visa inventory (the supplier APIs behind it).

---

## 08 — Questions for the Client

Answering these turns the guesswork above into a firm plan and estimate.

1. **Scope · priority — Is this phase B2C, B2B, or both?** Should we prioritise the customer booking app, the agent portal, or deliver both together?
2. **Backend — Is the OutC backend fully live with the same API routes and real data?** Which environments (staging/prod) and credentials can we test against? Who administers it?
3. **Accounts — How are user & agent accounts created on OutC?** Login works but there are no accounts yet, and in-app registration is not built. Self-registration, admin-provisioned accounts, or both?
4. **Payments — Which payment gateway should we integrate?** (Razorpay / PayU / Stripe / other.) None exists today — required before any real booking can complete.
5. **Services — Which services are actually in scope?** Flights, hotels and visa are furthest along. Cars and Bus are placeholders — build them, hide them, or defer?
6. **Booking model — How do agents pay?** Prepaid wallet/deposit (the code hints at this) vs. per-transaction? Affects the whole booking + reports flow.
7. **Design — Is there brand/UX guidance to follow?** Final logo, colours, and any approved designs — or do we keep the current look and tidy it?
8. **Platforms — Which platforms ship first?** Android, iOS, or both? (Web is only being used for testing.)
9. **Handover — What did the previous team leave undone or undocumented?** Any known issues, API docs, Postman collections, or design files we should receive.
10. **Timeline — What's the target launch and the must-have vs. nice-to-have list?** So we can sequence migration → gap-closure → launch realistically.

---

*OutC Travel App — Status & Scope Report · Draft for client review · Findings from code review + live testing · 12 Jul 2026*
