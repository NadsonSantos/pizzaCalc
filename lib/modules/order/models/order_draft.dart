import '../../../core/constants/app_constants.dart';

class OrderDraft {
  int pizzaCount;
  List<Set<int>> pizzaSabores;
  OrderType tipo;
  String endereco;
  Map<int, int> extraQuantities;

  OrderDraft({
    this.pizzaCount = 1,
    List<Set<int>>? pizzaSabores,
    this.tipo = OrderType.retirada,
    this.endereco = '',
    Map<int, int>? extraQuantities,
  }) : pizzaSabores = pizzaSabores ?? [{}],
       extraQuantities = extraQuantities ?? {};

  void setPizzaCount(int count) {
    pizzaCount = count;
    while (pizzaSabores.length < count) {
      pizzaSabores.add({});
    }
    while (pizzaSabores.length > count) {
      pizzaSabores.removeLast();
    }
  }

  void toggleSabor(int pizzaIndex, int saborId) {
    final set = pizzaSabores[pizzaIndex];
    if (set.contains(saborId)) {
      set.remove(saborId);
    } else {
      set.add(saborId);
    }
  }

  bool get allPizzasHaveSabores =>
      pizzaSabores.length == pizzaCount &&
      pizzaSabores.every((s) => s.isNotEmpty);

  bool get isAddressValid =>
      tipo == OrderType.retirada ||
      endereco.trim().length >= AppConstants.minAddressLength;

  double get deliveryFeeAmount =>
      tipo == OrderType.entrega ? AppConstants.deliveryFee : 0;

  double calculateTotal({
    required Map<int, double> saborPrices,
    required Map<int, double> extraPrices,
  }) {
    var total = 0.0;

    for (final sabores in pizzaSabores) {
      if (sabores.isEmpty) continue;
      double highest = 0;
      for (final saborId in sabores) {
        final price = saborPrices[saborId] ?? 0;
        if (price > highest) highest = price;
      }
      total += highest;
    }

    extraQuantities.forEach((extraId, qty) {
      total += (extraPrices[extraId] ?? 0) * qty;
    });

    total += deliveryFeeAmount;
    return total;
  }

  OrderDraft copy() {
    return OrderDraft(
      pizzaCount: pizzaCount,
      pizzaSabores: pizzaSabores.map((s) => Set<int>.from(s)).toList(),
      tipo: tipo,
      endereco: endereco,
      extraQuantities: Map<int, int>.from(extraQuantities),
    );
  }
}
