# Quickstart: App de Atendimento Pizzaria Offline

## Prerequisites

- Flutter SDK 3.x
- Android device/emulator (API 21+)
- Optional: Bluetooth thermal printer paired in Android settings

## Setup

```bash
cd /Users/mac/projects/Personal/pizzacalc
flutter pub get
flutter run
```

## Manual Test Flow

1. **Home** → tap "Novo Pedido"
2. **Quantidade** → set 2 pizzas → Continuar
3. **Sabores** → select flavors for Pizza 1 and 2 → Continuar
4. **Tipo** → select Entrega, enter address → Continuar
5. **Extras** → add Coca Cola ×1, Mousse Chocolate ×2 → Continuar
6. **Resumo** → verify total → Confirmar pedido
7. **Histórico** → open from home → verify order listed → Reimprimir

## Expected Total Example

- 2 pizzas × R$ 35,00 = R$ 70,00
- Entrega = R$ 5,00
- Coca R$ 5,00 + 2× Mousse R$ 6,00 = R$ 17,00
- **Total: R$ 92,00**

## Verify Database

After confirming an order, restart app; history must still show the order.

## Printer

If no printer paired, confirmation still saves order and shows snackbar about
print failure. Pair printer in Android Bluetooth settings and retry Reimprimir.
