# Commit & PR Convention

## Commit messages

```
<type>(<scope>): <short summary, imperative mood>

<body — optional, only if the summary needs context>

Refs: specs/000X-name.md
```

**Type**: `feat` (new capability) · `fix` (bug fix) · `refactor` (no behavior change) · `docs`
(documentation/process only) · `chore` (deps, config, tooling) · `test`.

**Scope**: the module touched — `flights`, `hotels`, `cars`, `visa`, `bus`, `agent`, `core`, `docs`,
`specs` — or omitted for a repo-wide change.

**`Refs:` line**: required whenever the commit implements (part of) a spec's acceptance criteria —
this is what makes every code change traceable back to something the product owner approved. Not
required for pure infrastructure/process commits (like the one that introduced this file).

**One commit = one reviewable unit.** Don't bundle two unrelated specs, or a feature and an unrelated
cleanup, into the same commit — it defeats the point of being able to trace a commit to a spec.

## Pull requests

Every PR uses `.github/PULL_REQUEST_TEMPLATE.md` (GitHub applies it automatically when a PR is opened).
It asks for exactly what the product owner needs to approve without reading the diff: which spec, what
changed in plain English, how to verify it by using the app, and the `architecture-reviewer` result.

A PR should not be opened before: the spec is Approved, the plan is Approved, `flutter analyze` is
clean, and the `architecture-reviewer` subagent has been run at least once (see
`docs/spec-driven-workflow.md`).
