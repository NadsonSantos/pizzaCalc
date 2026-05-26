# Tasks: App de Atendimento Pizzaria Offline

**Input**: Design documents from `/specs/001-pizzaria-atendimento/`
**Prerequisites**: plan.md, spec.md, data-model.md, research.md

**Organization**: Tasks grouped by user story (Sprint 1–4 alignment)

## Format: `[ID] [P?] [Story] Description`

## Phase 1: Setup (Sprint 1 — Foundation)

**Purpose**: Dependencies, DB, catalog seed, constants

- [x] T001 Add sqflite, path, intl, esc_pos_utils, print_bluetooth_thermal to pubspec.yaml
- [x] T002 [P] Create app constants in lib/core/constants/app_constants.dart
- [x] T003 Create DatabaseHelper with schema in lib/core/database/database_helper.dart
- [x] T004 Create seed data in lib/core/database/seed_data.dart
- [x] T005 [P] Create Sabor and Extra models in lib/modules/catalog/models/
- [x] T006 Create CatalogRepository in lib/modules/catalog/repositories/catalog_repository.dart
- [x] T007 Add Android Bluetooth permissions in android/app/src/main/AndroidManifest.xml
- [x] T008 Initialize database on app start in lib/main.dart

**Checkpoint**: DB opens with seeded sabores and extras

---

## Phase 2: Foundational (Blocking)

**Purpose**: Shared widgets, routes, draft model

- [x] T009 [P] Create QuantityStepper in lib/shared/widgets/quantity_stepper.dart
- [x] T010 [P] Create PrimaryButton in lib/shared/widgets/primary_button.dart
- [x] T011 Create OrderDraft model in lib/modules/order/models/order_draft.dart
- [x] T012 Create Order model in lib/modules/order/models/order.dart
- [x] T013 Add order routes to lib/core/routing/routes.dart and app_pages.dart
- [x] T014 Create OrderWizardController in lib/modules/order/controllers/order_wizard_controller.dart
- [x] T015 Create OrderWizardBinding in lib/modules/order/bindings/order_wizard_binding.dart

**Checkpoint**: Routes registered; controller holds draft state

---

## Phase 3: User Story 1 — Registrar pedido completo (P1) — Sprint 2

**Goal**: Full 5-screen wizard with save and total calculation

**Independent Test**: Complete wizard and confirm; order persisted with correct total

- [x] T016 [US1] Create NewOrderPage in lib/modules/order/pages/new_order_page.dart
- [x] T017 [US1] Create PizzaFlavorsPage in lib/modules/order/pages/pizza_flavors_page.dart
- [x] T018 [US1] Create OrderTypePage in lib/modules/order/pages/order_type_page.dart
- [x] T019 [US1] Create ExtrasPage in lib/modules/order/pages/extras_page.dart
- [x] T020 [US1] Create OrderSummaryPage in lib/modules/order/pages/order_summary_page.dart
- [x] T021 [US1] Implement total calculation in OrderWizardController
- [x] T022 [US1] Create OrderRepository with transactional save in lib/modules/order/repositories/order_repository.dart
- [x] T023 [US1] Wire confirm action to OrderRepository in OrderSummaryPage
- [x] T024 [US1] Update HomePage with Novo Pedido button in lib/ui/home/home_page.dart

**Checkpoint**: End-to-end order save works

---

## Phase 4: User Story 2 — Histórico e reimpressão (P2) — Sprint 3

**Goal**: List saved orders and re-print

**Independent Test**: View history; re-print produces same receipt content

- [x] T025 [US2] Create OrderHistoryController in lib/modules/order/controllers/order_history_controller.dart
- [x] T026 [US2] Create OrderHistoryBinding in lib/modules/order/bindings/order_history_binding.dart
- [x] T027 [US2] Create OrderHistoryPage in lib/modules/order/pages/order_history_page.dart
- [x] T028 [US2] Add list/query methods to OrderRepository
- [x] T029 [US2] Add Histórico button to HomePage

**Checkpoint**: History lists orders; re-print hook wired (stub ok until US4)

---

## Phase 5: User Story 3 — Editar antes de confirmar (P3)

**Goal**: Editar button preserves wizard state

**Independent Test**: From summary, edit and change delivery type; total updates

- [x] T030 [US3] Add edit navigation from OrderSummaryPage back to wizard
- [x] T031 [US3] Ensure OrderWizardController restores state on back navigation

**Checkpoint**: Edit flow works without premature save

---

## Phase 6: User Story 4 — Impressão ESC/POS (P4) — Sprint 4

**Goal**: Auto-print on confirm; re-print from history

**Independent Test**: Receipt bytes generated; print attempted on confirm/re-print

- [x] T032 [US4] Create PrinterService in lib/modules/printer/services/printer_service.dart
- [x] T033 [US4] Integrate print on confirm in OrderSummaryPage
- [x] T034 [US4] Integrate re-print in OrderHistoryPage

**Checkpoint**: Print on confirm + re-print from history

---

## Phase 7: Polish

- [x] T035 [P] Update widget_test.dart smoke test
- [x] T036 Run flutter analyze and fix issues

---

## Dependencies & Execution Order

```text
Phase 1 → Phase 2 → Phase 3 (US1) → Phase 4 (US2) → Phase 5 (US3) → Phase 6 (US4) → Phase 7
```

## Parallel Opportunities

- T002, T005 can run parallel after T001
- T009, T010 parallel in Phase 2
- T035 independent at end

## Implementation Strategy

**MVP First**: Complete Phase 1–3 for working order flow without print.
**Incremental**: Add history (4), edit polish (5), printing (6).
