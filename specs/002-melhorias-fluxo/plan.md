# Implementation Plan: Melhorias do Fluxo

**Branch**: `002-melhorias-fluxo` | **Date**: 2026-06-02 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `/specs/002-melhorias-fluxo/spec.md`

## Summary

Evolução do app Flutter offline: wizard de sabores por pizza com busca; fusão de
tipo/endereço/cliente em NewOrderPage; remoção de OrderTypePage; resumo com
pagamento multi, troco calculado e observação; clientes e rascunhos em SQLite v2.

## Technical Context

**Language/Version**: Dart 3.9+ / Flutter 3.x

**Primary Dependencies**: get ^4.6.6, sqflite, path, intl, esc_pos_utils, print_bluetooth_thermal

**Storage**: SQLite v2 — tabelas `clientes`, `rascunhos`; colunas novas em `pedidos`

**Testing**: flutter_test smoke; testes manuais em dispositivo

**Target Platform**: Android PDV (primary)

**Project Type**: mobile-app (Flutter)

**Performance Goals**: Transições < 200ms; save rascunho < 300ms

**Constraints**: Offline; migração v1→v2; pt-BR

**Scale/Scope**: ~6 telas wizard + Home com rascunhos

## Constitution Check

| Principle | Status | Notes |
|-----------|--------|-------|
| I. Offline-First | PASS | SQLite local |
| II. Speed of Service | PASS* | +N telas para N pizzas — requisito explícito |
| III. Simplicity | PASS | Sem pacotes novos; Material Autocomplete |
| IV. Local Data Integrity | PASS | Transações em pedidos; rascunhos separados |
| V. Portuguese UX | PASS | Labels e cupom pt-BR |

Post-design re-check: PASS

## Complexity Tracking

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| Mais telas no wizard (N pizzas) | UX por pizza solicitada | Lista única confunde atendente |

## Project Structure

### Documentation

```text
specs/002-melhorias-fluxo/
├── plan.md
├── spec.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
└── tasks.md
```

### Source Code

```text
lib/
├── core/database/database_helper.dart
├── modules/
│   ├── client/
│   │   ├── models/cliente.dart
│   │   └── repositories/cliente_repository.dart
│   └── order/
│       ├── models/order_draft.dart
│       ├── models/payment_method.dart
│       ├── repositories/draft_repository.dart
│       ├── repositories/order_repository.dart
│       ├── controllers/order_wizard_controller.dart
│       └── pages/
├── ui/home/
└── shared/widgets/
```

**Structure Decision**: Estender módulos existentes; novo módulo `client` mínimo.
