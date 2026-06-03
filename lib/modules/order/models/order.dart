import '../../../core/constants/app_constants.dart';
import '../../catalog/models/extra.dart';
import '../../catalog/models/sabor.dart';
import 'payment_method.dart';

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
  final int? clienteId;
  final String? clienteNome;
  final List<PaymentMethod> formasPagamento;
  final double? trocoPara;
  final String? observacao;

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
    this.clienteId,
    this.clienteNome,
    this.formasPagamento = const [],
    this.trocoPara,
    this.observacao,
  });

  double? get trocoDevolver {
    if (trocoPara == null ||
        !formasPagamento.contains(PaymentMethod.dinheiro)) {
      return null;
    }
    return trocoPara! - valorTotal;
  }

  String get formasPagamentoLabel =>
      formasPagamento.map((p) => p.label).join(', ');
}
