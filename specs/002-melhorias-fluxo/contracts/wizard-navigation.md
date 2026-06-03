# Contract: Wizard Navigation

## Routes

| Route | Page | Next | Back |
|-------|------|------|------|
| `/home` | HomePage | newOrder / orderSummary?draftId | — |
| `/new-order` | NewOrderPage | pizzaFlavors | home |
| `/pizza-flavors` | PizzaFlavorsPage | pizzaFlavors (index+1) or extras | pizzaFlavors (index-1) or newOrder |
| `/extras` | ExtrasPage | orderSummary | pizzaFlavors (last index) |
| `/order-summary` | OrderSummaryPage | home (confirm/draft) | extras |

**Removed**: `/order-type`

## Validations per step

### NewOrderPage

- `pizzaCount` in [minPizzas, maxPizzas]
- If `tipo == entrega`: `endereco.trim().length >= 5`
- Cliente optional; if creating, telefone valid

### PizzaFlavorsPage

- `pizzaSabores[currentPizzaIndex].isNotEmpty` before next
- On last pizza: navigate to extras
- Reset `flavorSearchQuery` on index change

### OrderSummaryPage

- `formasPagamento.isNotEmpty`
- If DINHEIRO: `trocoPara != null && trocoPara >= total`

## Arguments

- `Get.arguments` for summary resume: `{ 'draftId': int }` optional
