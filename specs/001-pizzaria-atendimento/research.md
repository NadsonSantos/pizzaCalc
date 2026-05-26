# Research: App de Atendimento Pizzaria Offline

**Date**: 2026-05-26

## SQLite package choice

**Decision**: `sqflite` with manual schema + migrations in `database_helper.dart`

**Rationale**: Minimal setup for MVP; team already on Flutter/GetX; schema is
small (6 tables). Drift adds code generation overhead not justified yet.

**Alternatives considered**: drift (rejected: boilerplate for MVP speed), hive
(rejected: relational model fits orders better)

## ESC/POS printing on Android

**Decision**: `esc_pos_utils` for byte generation + `print_bluetooth_thermal` for
Bluetooth transport

**Rationale**: Common combo in Brazilian PDV Flutter apps; supports 58mm/80mm
thermal printers paired via Android settings.

**Alternatives considered**: `flutter_pos_printer_platform` (more complex API);
USB OTG (deferred — Bluetooth covers most counter setups)

**Risks**: Requires BLUETOOTH/LOCATION permissions on Android 12+; printer must
be pre-paired in system settings; iOS printing out of MVP scope.

## State management for wizard

**Decision**: Single `OrderWizardController` (GetX) holding `OrderDraft` in memory;
persist only on confirm

**Rationale**: Matches "edit before confirm" requirement; avoids partial DB rows.

**Alternatives considered**: Per-screen controllers (rejected: harder to preserve
state across back navigation)

## Pricing model

**Decision**: Fixed base pizza price R$ 35,00 + extra line items + R$ 5,00 delivery

**Rationale**: Matches spec assumptions; sabores preco defaults to 0 in seed.

## Order number generation

**Decision**: `MAX(numero)+1` from pedidos table inside transaction on confirm

**Rationale**: Simple, offline-safe, unique per device.
