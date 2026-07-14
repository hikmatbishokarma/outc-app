## Spec

<Link to the `specs/000X-*.md` this implements. No spec, no PR — see `docs/spec-driven-workflow.md`.>

## What changed (plain English)

<Describe what this does for a user/agent, not how the code does it. This is what the product owner
reads instead of the diff.>

## How to verify

<Steps to see it working in the running app — e.g. "run `flutter run -d chrome`, go to Home → Flights,
search HYD→BLR, confirm the fare screen no longer crashes." Should be followable by someone who has
never seen the code.>

## Architecture review

<Paste the `architecture-reviewer` subagent's pass/fail summary. If it found violations, either they're
fixed below or there's a stated reason they're deferred.>

## Checklist

- [ ] Spec status is Approved
- [ ] Plan was reviewed before implementation
- [ ] `flutter analyze` is clean
- [ ] `architecture-reviewer` has been run against this diff
