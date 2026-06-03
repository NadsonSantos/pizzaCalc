import 'dart:convert';

import '../../../core/constants/app_constants.dart';
import 'payment_method.dart';

class OrderDraft {
  static const schemaVersion = 1;

  int pizzaCount;
  List<Set<int>> pizzaSabores;
  OrderType tipo;
  String endereco;
  Map<int, int> extraQuantities;
  int? clienteId;
  String? clienteNome;
  Set<PaymentMethod> formasPagamento;
  double? trocoPara;
  String observacao;
  int? rascunhoId;

  OrderDraft({
    this.pizzaCount = 1,
    List<Set<int>>? pizzaSabores,
    this.tipo = OrderType.retirada,
    this.endereco = '',
    Map<int, int>? extraQuantities,
    this.clienteId,
    this.clienteNome,
    Set<PaymentMethod>? formasPagamento,
    this.trocoPara,
    this.observacao = '',
    this.rascunhoId,
  })  : pizzaSabores = pizzaSabores ?? [{}],
        extraQuantities = extraQuantities ?? {},
        formasPagamento = formasPagamento ?? {};

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

  bool pizzaHasSabores(int pizzaIndex) =>
      pizzaIndex >= 0 &&
      pizzaIndex < pizzaSabores.length &&
      pizzaSabores[pizzaIndex].isNotEmpty;

  bool get allPizzasHaveSabores =>
      pizzaSabores.length == pizzaCount &&
      pizzaSabores.every((s) => s.isNotEmpty);

  bool get isAddressValid =>
      tipo == OrderType.retirada ||
      endereco.trim().length >= AppConstants.minAddressLength;

  bool get hasDinheiro => formasPagamento.contains(PaymentMethod.dinheiro);

  double? get trocoDevolver {
    if (trocoPara == null || !hasDinheiro) return null;
    return trocoPara! - _lastCalculatedTotal;
  }

  double _lastCalculatedTotal = 0;

  void cacheTotal(double total) => _lastCalculatedTotal = total;

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
    _lastCalculatedTotal = total;
    return total;
  }

  OrderDraft copy() {
    return OrderDraft(
      pizzaCount: pizzaCount,
      pizzaSabores: pizzaSabores.map((s) => Set<int>.from(s)).toList(),
      tipo: tipo,
      endereco: endereco,
      extraQuantities: Map<int, int>.from(extraQuantities),
      clienteId: clienteId,
      clienteNome: clienteNome,
      formasPagamento: Set<PaymentMethod>.from(formasPagamento),
      trocoPara: trocoPara,
      observacao: observacao,
      rascunhoId: rascunhoId,
    );
  }

  Map<String, dynamic> toJson() => {
        'schemaVersion': schemaVersion,
        'pizzaCount': pizzaCount,
        'pizzaSabores': pizzaSabores.map((s) => s.toList()).toList(),
        'tipo': tipo.dbValue,
        'endereco': endereco,
        'extraQuantities':
            extraQuantities.map((k, v) => MapEntry(k.toString(), v)),
        'clienteId': clienteId,
        'clienteNome': clienteNome,
        'formasPagamento': formasPagamento.map((p) => p.dbValue).toList(),
        'trocoPara': trocoPara,
        'observacao': observacao,
      };

  factory OrderDraft.fromJson(Map<String, dynamic> json) {
    final extrasRaw = json['extraQuantities'] as Map<String, dynamic>? ?? {};
    final extras = <int, int>{};
    extrasRaw.forEach((k, v) => extras[int.parse(k)] = v as int);

    final saboresRaw = json['pizzaSabores'] as List<dynamic>? ?? [[]];
    final pizzaSabores = saboresRaw
        .map((e) => (e as List<dynamic>).map((id) => id as int).toSet())
        .toList();

    final formasRaw = json['formasPagamento'] as List<dynamic>? ?? [];
    final formas = formasRaw
        .map((v) => PaymentMethod.fromDb(v as String))
        .whereType<PaymentMethod>()
        .toSet();

    return OrderDraft(
      pizzaCount: json['pizzaCount'] as int? ?? 1,
      pizzaSabores: pizzaSabores,
      tipo: OrderTypeLabel.fromDb(json['tipo'] as String? ?? 'RETIRADA'),
      endereco: json['endereco'] as String? ?? '',
      extraQuantities: extras,
      clienteId: json['clienteId'] as int?,
      clienteNome: json['clienteNome'] as String?,
      formasPagamento: formas,
      trocoPara: (json['trocoPara'] as num?)?.toDouble(),
      observacao: json['observacao'] as String? ?? '',
      rascunhoId: json['rascunhoId'] as int?,
    );
  }

  static OrderDraft fromJsonString(String source) =>
      OrderDraft.fromJson(jsonDecode(source) as Map<String, dynamic>);

  String toJsonString() => jsonEncode(toJson());

  void sanitizeSabores(Set<int> validSaborIds) {
    for (var i = 0; i < pizzaSabores.length; i++) {
      pizzaSabores[i] =
          pizzaSabores[i].where(validSaborIds.contains).toSet();
    }
  }
}
