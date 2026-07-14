# Spec-Driven Workflow

You (the product owner) don't read Dart. This is the process that lets you stay in control of what
gets built and confirm it's right — without ever opening a code diff.

## Roles

- **You**: write or commission specs, approve specs, approve plans. That's it — those two approvals
  are your entire checkpoint.
- **Junior developer**: implements against an *approved plan* (never against a vague idea).
- **Claude Code**: turns a spec into a plan, a plan into code, and reviews the resulting diff against
  `docs/architecture.md` before anything is called done.

## The flow

```
1. SPEC        →  2. PLAN        →  3. IMPLEMENT   →  4. REVIEW           →  5. MERGE
   (specs/*.md)     (Plan Mode)       (code changes)     (architecture-
                                                          reviewer + analyze)
   You approve       You approve       Junior dev or       Automated —
   this               this              Claude codes        you read the
                                                             plain-English
                                                             result
```

**1. Spec** — a short markdown file in `specs/`, copied from `specs/TEMPLATE.md`. It describes *what*
the feature does and how you'll know it's done (acceptance criteria), not how it's coded. Ask Claude
to draft one from a plain description of what you want; you edit/approve it. Nothing gets built from
an idea that isn't written down as a spec first.

**2. Plan** — ask Claude to plan the approved spec. This uses Claude Code's Plan Mode, which produces
a step-by-step implementation plan in plain English *before* touching any files. **This is your real
review checkpoint** — you're reading a numbered list of what will change and why, not code. Push back
here if something sounds wrong; it's far cheaper to redirect a plan than a finished implementation.

**3. Implement** — once you approve the plan, the junior developer (or Claude directly) writes the
code against it.

**4. Review** — two automatic checks, no code-reading required from you:
   - `flutter analyze` must be clean.
   - The `architecture-reviewer` subagent runs the checklist in `docs/architecture.md` §5 against the
     diff and reports violations in plain language (e.g. "this hardcodes a new payment call instead of
     using PaymentGateway" or "this widget calls http directly"). Ask Claude to run it, or invoke it
     with `Agent(subagent_type: "architecture-reviewer")`.

   You read the review's plain-English summary, not the diff.

**5. Merge** — only after analyze is clean and the review has no unresolved findings.

## What you're actually approving at each gate

| Gate | What you read | What you're checking |
|---|---|---|
| Spec approval | User story + acceptance criteria (checkboxes) | "Is this the right thing to build?" |
| Plan approval | Numbered step list in plain English | "Is this how I expected it to be built, touching what I expected?" |
| Review result | Plain-language pass/fail summary | "Did it actually follow the standard, and does analyze pass?" |

## Hard rules — don't skip these

- No code without an **approved spec** and an **approved plan**. A plan built from an unwritten idea
  is a plan built on a guess.
- No merge with `flutter analyze` errors.
- No new service module without following the module contract in `docs/architecture.md` §1.
- Open questions surfaced in a spec (see `specs/0001-*` for a live example, and
  `OUTC_STATUS_REPORT.md` for the outstanding client-facing ones) block that spec's approval until
  answered — don't let Claude or a developer guess at business decisions.

## Starting a new spec

Tell Claude what you want in plain business terms — "customers should be able to filter hotel results
by star rating" is enough. Ask it to draft `specs/000X-<short-name>.md` from `specs/TEMPLATE.md`. Read
the acceptance criteria; if they match what you meant, approve it and move to the Plan step.
