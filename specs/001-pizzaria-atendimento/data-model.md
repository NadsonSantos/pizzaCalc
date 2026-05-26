# Data Model: App de Atendimento Pizzaria Offline

**Date**: 2026-05-26

## Entity Relationship

```text
Pedido 1──* Pizza *──* Sabor (via pizza_sabores)
Pedido 1──* PedidoExtra *──1 Extra
```

## Tables

### pedidos

| Column | Type | Constraints |
|--------|------|-------------|
| id | INTEGER | PK AUTOINCREMENT |
| numero | INTEGER | NOT NULL UNIQUE |
| tipo | TEXT | NOT NULL ('RETIRADA' \| 'ENTREGA') |
| endereco | TEXT | NULL (required when ENTREGA) |
| taxa_entrega | REAL | NOT NULL DEFAULT 0 |
| valor_total | REAL | NOT NULL |
| data | TEXT | NOT NULL ISO8601 |

### pizzas

| Column | Type | Constraints |
|--------|------|-------------|
| id | INTEGER | PK AUTOINCREMENT |
| pedido_id | INTEGER | FK → pedidos.id |
| numero_pizza | INTEGER | NOT NULL |

### sabores

| Column | Type | Constraints |
|--------|------|-------------|
| id | INTEGER | PK AUTOINCREMENT |
| nome | TEXT | NOT NULL |
| preco | REAL | NOT NULL DEFAULT 0 |

### pizza_sabores

| Column | Type | Constraints |
|--------|------|-------------|
| pizza_id | INTEGER | FK → pizzas.id |
| sabor_id | INTEGER | FK → sabores.id |
| PRIMARY KEY (pizza_id, sabor_id) | | |

### extras

| Column | Type | Constraints |
|--------|------|-------------|
| id | INTEGER | PK AUTOINCREMENT |
| nome | TEXT | NOT NULL |
| categoria | TEXT | NOT NULL ('BEBIDA' \| 'GELADINHO' \| 'MOUSSE') |
| preco | REAL | NOT NULL |

### pedido_extras

| Column | Type | Constraints |
|--------|------|-------------|
| pedido_id | INTEGER | FK → pedidos.id |
| extra_id | INTEGER | FK → extras.id |
| quantidade | INTEGER | NOT NULL DEFAULT 1 |
| PRIMARY KEY (pedido_id, extra_id) | | |

## Validation Rules

- `numero`: auto-increment, never user-editable
- `tipo = ENTREGA` → `endereco` length >= 5, `taxa_entrega = 5.0`
- `tipo = RETIRADA` → `endereco` null, `taxa_entrega = 0`
- Each pizza must have >= 1 sabor before advancing wizard
- `valor_total = (pizza_count × BASE_PIZZA_PRICE) + sum(extra.preco × qty) + taxa_entrega + sum(sabor.preco per selection)`

## Seed Data (initial catalog)

**Sabores**: Calabresa, Portuguesa, Frango Catupiry, Quatro Queijos, Moda da Casa, Bacon (preco 0)

**Extras**:
- BEBIDA: Coca Cola (5), Guaraná (5), Água (3)
- GELADINHO: Morango (4), Chocolate (4), Coco (4)
- MOUSSE: Maracujá (6), Limão (6), Chocolate (6)

## State Transitions

```text
[Draft in memory] --Confirmar--> [Persisted Pedido] --Reimprimir--> [Print job]
```

No edit after confirm in MVP.
