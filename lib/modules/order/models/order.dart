import '../../../core/constants/app_constants.dart';
import '../../catalog/models/extra.dart';
import '../../catalog/models/sabor.dart';

class OrderPizzaDetail {
  final int numeroPizza;
  final List<Sabor> sabores;

  const OrderPizzaDetail({required this.numeroPizza, required this.sabores});
}

class OrderExtraDetail {
  final Extra extra;
  final int quantidade;

  const OrderExtraDetail({required this.extra, required this.quantidade});
}

class Order {
  final int id;
  final int numero;
  final OrderType tipo;
  final String? endereco;
  final double taxaEntrega;
  final double valorTotal;
  final DateTime data;
  final List<OrderPizzaDetail> pizzas;
  final List<OrderExtraDetail> extras;

  const Order({
    required this.id,
    required this.numero,
    required this.tipo,
    required this.endereco,
    required this.taxaEntrega,
    required this.valorTotal,
    required this.data,
    required this.pizzas,
    required this.extras,
  });
}
