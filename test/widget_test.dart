import 'package:flutter_test/flutter_test.dart';

import 'package:pizzacalc/core/constants/app_constants.dart';
import 'package:pizzacalc/modules/order/models/order_draft.dart';

void main() {
  test('OrderDraft calculates total with delivery and extras', () {
    final draft = OrderDraft(
      pizzaCount: 2,
      pizzaSabores: [{1}, {2}],
      tipo: OrderType.entrega,
      endereco: 'Rua Teste 123',
      extraQuantities: {1: 1, 9: 2},
    );

    final total = draft.calculateTotal(
      saborPrices: {1: 0, 2: 0},
      extraPrices: {1: 5, 9: 6},
    );

    // 2×35 + 5 delivery + 5 coca + 2×6 mousse = 92
    expect(total, 92.0);
  });

  test('OrderDraft pickup has no delivery fee', () {
    final draft = OrderDraft(pizzaCount: 1, pizzaSabores: [{1}]);

    final total = draft.calculateTotal(
      saborPrices: {1: 0},
      extraPrices: {},
    );

    expect(total, AppConstants.basePizzaPrice);
  });
}
