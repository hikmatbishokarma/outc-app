# 0012 — App Feedback States (Loading, Error, Empty, No Internet)

**Status:** Approved (2026-07-30) — the empty-vs-error open question below is resolved on a stated
assumption, not a confirmed API contract; cheap to redirect if wrong since it's one conditional in the
async-state mapping, not a rewrite
**Module(s):** core (new) — the shared state widgets and the async-state contract; flights, bus,
dashboard/home — adopt them in this build, matching 0011's rollout; hotels, cars, visa, partnerSidemenu
— follow-up, same as 0013

## Overview

Give the app one consistent way to show "waiting," "something went wrong," "nothing here," and "you're
offline" — instead of the current per-screen ad hoc handling. This is a different seam from
`specs/0011-design-token-system.md`: 0011 is what things look like (color/type/shape); this is what the
app *does* when a request is loading, fails, times out, comes back empty, or there's no connectivity.
It's still built from 0011's tokens (an error screen uses the same palette and type scale as everything
else), but the two are reviewed and can ship independently.

**Current state, checked directly against the code** (this is the actual gap, not a hypothetical):
- No connectivity-detection package is installed — the app has no way to distinguish "no internet" from
  "server error" before making a request.
- `lib/load_data/http_client.dart` catches `SocketException` and throws a `FetchDataException` with a
  hardcoded `"No Internet connection"` message — but most screens call `lib/services/api_services_list.dart`
  instead (per `docs/architecture.md`'s own note on the god-class), and it's unconfirmed whether that
  path surfaces the same exception consistently.
- Only 5 files in the entire app use `CircularProgressIndicator` — meaning most async calls show no
  loading state at all today, not an inconsistent one.
- There is no shared empty-state, error-state, or no-internet widget anywhere in `lib/` — each screen
  that does handle a failure does so with its own inline `catch (e)` (15 files), typically a `SnackBar`,
  with no consistent copy or retry affordance.

## User story

As a customer or agent, I want the app to always tell me clearly what's happening — loading, failed,
empty, or offline — with a way to retry, instead of a spinner that never resolves or a screen that just
looks broken, so that the app feels reliable even when the network or backend doesn't cooperate.

## Acceptance criteria

- [ ] A connectivity-detection package (e.g. `connectivity_plus`) is added, and `lib/core/` exposes a
      single way for a provider to check/observe "online vs offline" — not per-screen platform checks.
- [ ] Four shared widgets exist once in `lib/core/widgets/`, each styled from `design_tokens.dart`
      (spec 0011) — no new hardcoded colors/type introduced here:
      - `LoadingState` — the one loading treatment (spinner + optional label), replacing inline
        `CircularProgressIndicator` in touched screens.
      - `ErrorState` — message + retry action, used for thrown exceptions (`FetchDataException` and
        unhandled failures alike).
      - `EmptyState` — "no results" treatment (e.g. no flights found, no buses on this route), distinct
        from `ErrorState` — an empty result set is not a failure.
      - `NoInternetState` — distinct from `ErrorState`: detected via the connectivity check before or
        instead of hitting the network, with its own retry action.
- [ ] A single async-state contract (e.g. a small sealed class/enum: `loading | data | empty | error |
      offline`) is used by providers in Home/Flights/Bus instead of each provider inventing its own
      boolean flags (`isLoading`, `hasError`, etc. scattered ad hoc) — screens render purely off that
      state, not off separate flags that can drift out of sync with each other.
- [ ] Home/Dashboard, Flights (search → results → booking), and Bus (search → results → seats →
      checkout) each render one of the four states above for every network call on their critical path
      — no bare `CircularProgressIndicator`, no silent failure, no blank screen on empty results.
- [ ] Retry from `ErrorState`/`NoInternetState` re-runs the same request rather than requiring the user
      to navigate away and back.
- [ ] `flutter analyze` is clean on every touched file.
- [ ] Verified on a physical device: airplane-mode test (no-internet path), a deliberately broken
      endpoint or timeout (error path), and an empty-result search (empty path) for each of the three
      flows.

## API contract

N/A — this is client-side state/UX handling. It consumes whatever `api_services_list.dart` /
`http_client.dart` already throw; it does not change any request/response shape.

Assumed (per product owner, not yet verified against an actual response payload): flights and bus
search return a normal success response with a zero/empty result list when nothing matches — not an
error status code. The async-state mapping treats "success + zero items" as `empty`, and only a thrown
exception or non-2xx response as `error`. If either endpoint turns out to return zero-results as an
error code instead, that's a one-line change to the mapping for that module, not a redesign.

## Out of scope

- Hotels, Cars, Visa, `lib/partnerSidemenu/` — same phased rollout as spec 0013; not touched here.
- Splitting `api_services_list.dart` into per-module services, or changing what exceptions
  `http_client.dart` throws — this spec standardizes how the *UI* reacts to failures, not the network
  layer's shape (that's `docs/architecture.md`'s existing Interface Segregation cleanup, tracked
  separately).
- Retry/backoff policy at the network layer (exponential backoff, request queuing) — retry here means
  "user taps retry, request re-runs once," not automatic background retry logic.
- Skeleton-loading placeholders (shimmer effects mimicking final content) — `LoadingState` is a single
  spinner treatment for this build; richer skeleton loaders are a nice-to-have, not required.

## Open questions

None blocking. **Resolved with assumption:** zero-result flight/bus searches come back from the backend
as a normal response with an empty/zero-count list, not an error code (product owner's expectation,
not yet verified against a live payload) — see API contract above. Worth a quick sanity check against
one real zero-result response per endpoint the first time each flow is implemented, since it's the
kind of thing that's easy to confirm in five minutes and annoying to have silently wrong.
