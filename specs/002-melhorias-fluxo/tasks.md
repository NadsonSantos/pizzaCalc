# Tasks: Melhorias do Fluxo

**Input**: `/specs/002-melhorias-fluxo/`
**Prerequisites**: plan.md, spec.md, data-model.md, research.md, contracts/

## Phase 1: Foundational (DB v2 + models)

- [ ] T001 Migrate DatabaseHelper to v2 with clientes, rascunhos, pedidos columns in lib/core/database/database_helper.dart
- [ ] T002 [P] Create Cliente model and ClienteRepository in lib/modules/client/
- [ ] T003 [P] Create PaymentMethod enum in lib/modules/order/models/payment_method.dart
- [ ] T004 Extend OrderDraft with cliente, pagamento, JSON in lib/modules/order/models/order_draft.dart
- [ ] T005 Create DraftRepository in lib/modules/order/repositories/draft_repository.dart
- [ ] T006 Update OrderRepository and Order model for v2 fields

## Phase 2: User Story 1–2 (P1) Wizard

- [ ] T007 [US1] Refactor PizzaFlavorsPage per-pizza + search in lib/modules/order/pages/pizza_flavors_page.dart
- [ ] T008 [US1] Extend OrderWizardController with pizza index and flavor search
- [ ] T009 [US2] Merge OrderTypePage into NewOrderPage; delete order_type_page.dart
- [ ] T010 [US2] Remove orderType route from routes.dart and app_pages.dart

## Phase 3: User Story 3 (P2) Cliente

- [ ] T011 [US3] Create SearchableClientField widget in lib/shared/widgets/searchable_client_field.dart
- [ ] T012 [US3] Wire cliente search/create in NewOrderPage and OrderWizardController

## Phase 4: User Story 4 (P2) Resumo pagamento

- [ ] T013 [US4] Add payment, troco, observacao to OrderSummaryPage
- [ ] T014 [US4] validateSummaryStep and persist payment in confirmOrder
- [ ] T015 [US4] Extend PrinterService receipt lines

## Phase 5: User Story 5 (P2) Rascunhos

- [ ] T016 [US5] HomeController list/delete drafts; HomePage UI
- [ ] T017 [US5] saveDraft/loadDraft in OrderWizardController and summary button
- [ ] T018 [US5] Resume draft via Get.arguments draftId on OrderSummaryPage

## Phase 6: Polish

- [ ] T019 Update OrderHistory detail for new fields
- [ ] T020 Set minAddressLength to 5 in app_constants.dart
