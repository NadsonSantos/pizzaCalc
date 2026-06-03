# Data Model: Melhorias do Fluxo

**Date**: 2026-06-02

## Entity Relationship

```text
Cliente 1──* Pedido
Pedido 1──* Pizza *──* Sabor
Pedido 1──* PedidoExtra *──1 Extra
Rascunho (standalone JSON payload)
```

## Tables

### clientes (NEW)

| Column | Type | Constraints |
|--------|------|-------------|
| id | INTEGER | PK AUTOINCREMENT |
| nome | TEXT | NOT NULL, max 80 chars |
| telefone | TEXT | NOT NULL, pattern #####-#### |
| endereco | TEXT | NULL |

### rascunhos (NEW)

| Column | Type | Constraints |
|--------|------|-------------|
| id | INTEGER | PK AUTOINCREMENT |
| titulo | TEXT | NOT NULL |
| payload | TEXT | NOT NULL JSON |
| atualizado_em | TEXT | NOT NULL ISO8601 |

### pedidos (ALTER v2)

| Column | Type | Constraints |
|--------|------|-------------|
| cliente_id | INTEGER | FK → clientes.id NULL |
| formas_pagamento | TEXT | NOT NULL DEFAULT '[]' JSON array |
| troco_para | REAL | NULL |
| observacao | TEXT | NULL |

## OrderDraft (in-memory / JSON)

| Field | Type | Notes |
|-------|------|-------|
| pizzaCount | int | |
| pizzaSabores | List<Set<int>> | |
| tipo | OrderType | |
| endereco | String | |
| extraQuantities | Map<int,int> | |
| clienteId | int? | |
| clienteNome | String? | snapshot |
| formasPagamento | Set<PaymentMethod> | |
| trocoPara | double? | |
| observacao | String | |
| rascunhoId | int? | when resuming |

## Validation

- Cliente nome: 1–80 após trim
- Telefone: `^\d{5}-\d{4}$`
- formasPagamento: non-empty on confirm
- trocoPara: required if DINHEIRO; must be >= total
- Entrega: endereco length >= 5 on pedido
- Pizza step: >=1 sabor on current index

## State Transitions

```text
[Draft memory] --Salvar rascunho--> [Rascunho DB]
[Rascunho DB] --Abrir--> [Draft memory @ Summary]
[Draft memory] --Confirmar--> [Pedido DB] + delete rascunho if any
```
