<!--
Sync Impact Report
- Version change: template → 1.0.0
- Modified principles: All placeholders replaced with pizzacalc MVP principles
- Added sections: Additional Constraints, Development Workflow
- Templates: plan/spec/tasks templates reviewed — no structural changes required
- Follow-up TODOs: none
-->

# Pizzacalc Constitution

## Core Principles

### I. Offline-First Operation

The order-taking flow MUST work without network connectivity. All order data MUST
be persisted locally on the device before confirmation. Network sync is out of
scope for the MVP.

**Rationale**: Attendants need reliable operation during peak hours regardless of
connectivity.

### II. Speed of Service

UI flows MUST minimize taps and screen transitions. Each step in the order wizard
MUST have a single clear primary action. Large touch targets and minimal typing
are required for counter use.

**Rationale**: The primary user goal is registering orders in seconds, not
exploring features.

### III. Simplicity (YAGNI)

Implement only what the active specification requires. Avoid abstractions,
frameworks, or patterns beyond what the current user story needs. Complexity MUST
be justified in the plan's Complexity Tracking table.

**Rationale**: MVP delivery speed and maintainability by a small team.

### IV. Local Data Integrity

Order persistence MUST use transactional writes so a confirmed order is never
partially saved. Order numbers MUST be auto-incremented and unique. Re-print
MUST read from persisted data, not in-memory draft state.

**Rationale**: Kitchen and counter depend on accurate, durable order records.

### V. Portuguese (pt-BR) UX

All user-facing labels, messages, and printed receipts MUST use Brazilian
Portuguese. Currency MUST display as R$ with two decimal places.

**Rationale**: End users are Brazilian pizza shop staff and customers reading
printed orders.

## Additional Constraints

- **Stack**: Flutter with GetX for routing/state; SQLite for local storage;
  ESC/POS for thermal printing on Android PDV devices.
- **Platform focus**: Android tablets/phones for MVP; iOS/desktop are secondary.
- **Printing**: Confirmed orders MUST trigger automatic print; re-print from
  history is required.
- **Pricing**: Delivery fee is fixed at R$ 5,00 when delivery is selected.

## Development Workflow

- Spec-driven: changes start from `specs/` artifacts before code.
- User stories are implemented in priority order (P1 → P2 → P3 → P4).
- Each sprint increment MUST be independently demonstrable.
- Prefer extending existing modules over creating parallel patterns.

## Governance

This constitution supersedes ad-hoc implementation decisions. Amendments require
updating this file, bumping the version (semver), and noting the change in the
Sync Impact Report comment. All plans MUST include a Constitution Check gate.
PRs SHOULD verify compliance with offline-first, speed, and data integrity
principles.

**Version**: 1.0.0 | **Ratified**: 2026-05-26 | **Last Amended**: 2026-05-26
