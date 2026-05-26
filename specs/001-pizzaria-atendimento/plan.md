# Implementation Plan: App de Atendimento Pizzaria Offline

**Branch**: `001-pizzaria-atendimento` | **Date**: 2026-05-26 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `/specs/001-pizzaria-atendimento/spec.md`

## Summary

Flutter offline MVP for pizza shop attendants: 5-step order wizard (quantity →
flavors → delivery type → extras → summary), SQLite persistence, automatic
sequential order numbers, and ESC/POS thermal printing via Bluetooth on Android.
GetX retained for routing and controllers. Catalog (sabores/extras) seeded on first
DB open.

## Technical Context

**Language/Version**: Dart 3.9+ / Flutter 3.x

**Primary Dependencies**: get ^4.6.6, sqflite, path, intl, esc_pos_utils, print_bluetooth_thermal

**Storage**: SQLite (sqflite) — local file on device

**Testing**: flutter_test (widget smoke tests); manual device test for printing

**Target Platform**: Android PDV tablets/phones (primary); iOS/desktop secondary

**Project Type**: mobile-app (Flutter)

**Performance Goals**: Wizard screen transitions < 200ms; order save < 500ms

**Constraints**: 100% offline order flow; pt-BR UI; transactional DB writes

**Scale/Scope**: Single device, ~5 screens + history; ~50 catalog items max

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Principle | Status | Notes |
|-----------|--------|-------|
| I. Offline-First | PASS | sqflite local; no network calls |
| II. Speed of Service | PASS | Minimal wizard; large buttons |
| III. Simplicity | PASS | sqflite over drift; direct repositories |
| IV. Local Data Integrity | PASS | Transactions for order save |
| V. Portuguese UX | PASS | pt-BR strings; R$ formatting |

Post-design re-check: PASS — no violations.

## Project Structure

### Documentation (this feature)

```text
specs/001-pizzaria-atendimento/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── spec.md
└── tasks.md
```

### Source Code (repository root)

```text
lib/
├── main.dart
├── app.dart
├── core/
│   ├── constants/app_constants.dart
│   ├── database/
│   │   ├── database_helper.dart
│   │   └── seed_data.dart
│   ├── routing/
│   │   ├── app_pages.dart
│   │   └── routes.dart
│   └── theme/
├── modules/
│   ├── order/
│   │   ├── models/order_draft.dart
│   │   ├── models/order.dart
│   │   ├── repositories/order_repository.dart
│   │   ├── controllers/order_wizard_controller.dart
│   │   ├── controllers/order_history_controller.dart
│   │   ├── bindings/order_wizard_binding.dart
│   │   ├── bindings/order_history_binding.dart
│   │   └── pages/
│   │       ├── new_order_page.dart
│   │       ├── pizza_flavors_page.dart
│   │       ├── order_type_page.dart
│   │       ├── extras_page.dart
│   │       ├── order_summary_page.dart
│   │       └── order_history_page.dart
│   ├── catalog/
│   │   ├── models/sabor.dart
│   │   ├── models/extra.dart
│   │   └── repositories/catalog_repository.dart
│   └── printer/
│       └── services/printer_service.dart
├── shared/
│   └── widgets/
│       ├── quantity_stepper.dart
│       └── primary_button.dart
└── ui/
    └── home/home_page.dart          # entry: Novo Pedido + Histórico
```

**Structure Decision**: New code under `lib/modules/`; existing `lib/core/routing`
and `lib/ui/home` extended. Legacy splash kept; home becomes launcher.

## Complexity Tracking

No constitution violations requiring justification.
