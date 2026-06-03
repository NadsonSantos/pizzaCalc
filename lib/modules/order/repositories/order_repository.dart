import 'dart:convert';

import '../../../core/constants/app_constants.dart';
import '../../../core/database/database_helper.dart';
import '../../catalog/models/extra.dart';
import '../../catalog/models/sabor.dart';
import '../../catalog/repositories/catalog_repository.dart';
import '../../client/repositories/cliente_repository.dart';
import '../models/order.dart';
import '../models/order_draft.dart';
import '../models/payment_method.dart';

class OrderRepository {
  OrderRepository(this._db, this._catalog, [ClienteRepository? clienteRepo])
      : _clienteRepo = clienteRepo ?? ClienteRepository(_db);

  final DatabaseHelper _db;
  final CatalogRepository _catalog;
  final ClienteRepository _clienteRepo;

  Future<int> saveOrder(OrderDraft draft) async {
    final db = await _db.database;
    final saborPrices = {
      for (final s in await _catalog.getSabores()) s.id: s.preco,
    };
    final extraPrices = {
      for (final e in await _catalog.getExtras()) e.id: e.preco,
    };
    final total = draft.calculateTotal(
      saborPrices: saborPrices,
      extraPrices: extraPrices,
    );

    await _syncClienteEndereco(draft);

    final formasJson = jsonEncode(
      draft.formasPagamento.map((p) => p.dbValue).toList(),
    );

    return db.transaction((txn) async {
      final maxResult = await txn.rawQuery(
        'SELECT COALESCE(MAX(numero), 0) as max_num FROM pedidos',
      );
      final nextNumero = (maxResult.first['max_num'] as int) + 1;

      final pedidoId = await txn.insert('pedidos', {
        'numero': nextNumero,
        'tipo': draft.tipo.dbValue,
        'endereco': draft.tipo == OrderType.entrega ? draft.endereco.trim() : null,
        'taxa_entrega': draft.deliveryFeeAmount,
        'valor_total': total,
        'data': DateTime.now().toIso8601String(),
        'cliente_id': draft.clienteId,
        'formas_pagamento': formasJson,
        'troco_para': draft.hasDinheiro ? draft.trocoPara : null,
        'observacao':
            draft.observacao.trim().isEmpty ? null : draft.observacao.trim(),
      });

      for (var i = 0; i < draft.pizzaCount; i++) {
        final pizzaId = await txn.insert('pizzas', {
          'pedido_id': pedidoId,
          'numero_pizza': i + 1,
        });

        for (final saborId in draft.pizzaSabores[i]) {
          await txn.insert('pizza_sabores', {
            'pizza_id': pizzaId,
            'sabor_id': saborId,
          });
        }
      }

      for (final entry in draft.extraQuantities.entries) {
        if (entry.value > 0) {
          await txn.insert('pedido_extras', {
            'pedido_id': pedidoId,
            'extra_id': entry.key,
            'quantidade': entry.value,
          });
        }
      }

      return nextNumero;
    });
  }

  Future<void> _syncClienteEndereco(OrderDraft draft) async {
    if (draft.clienteId == null) return;
    final endereco = draft.endereco.trim();
    if (endereco.isEmpty) return;

    final cliente = await _clienteRepo.getById(draft.clienteId!);
    if (cliente == null) return;

    final clienteEndereco = cliente.endereco?.trim() ?? '';
    if (clienteEndereco.isEmpty) {
      await _clienteRepo.updateEndereco(draft.clienteId!, endereco);
    }
  }

  Future<List<Order>> getAllOrders() async {
    final db = await _db.database;
    final pedidoRows = await db.query('pedidos', orderBy: 'data DESC');

    final orders = <Order>[];
    for (final row in pedidoRows) {
      orders.add(await _loadOrderDetails(row));
    }
    return orders;
  }

  Future<Order?> getOrderById(int id) async {
    final db = await _db.database;
    final rows = await db.query('pedidos', where: 'id = ?', whereArgs: [id]);
    if (rows.isEmpty) return null;
    return _loadOrderDetails(rows.first);
  }

  Future<Order?> getOrderByNumero(int numero) async {
    final db = await _db.database;
    final rows = await db.query(
      'pedidos',
      where: 'numero = ?',
      whereArgs: [numero],
    );
    if (rows.isEmpty) return null;
    return _loadOrderDetails(rows.first);
  }

  Future<Order> _loadOrderDetails(Map<String, dynamic> row) async {
    final db = await _db.database;
    final pedidoId = row['id'] as int;

    String? clienteNome;
    final clienteId = row['cliente_id'] as int?;
    if (clienteId != null) {
      final cliente = await _clienteRepo.getById(clienteId);
      clienteNome = cliente?.nome;
    }

    final formasRaw = row['formas_pagamento'] as String? ?? '[]';
    final formasList = (jsonDecode(formasRaw) as List<dynamic>)
        .map((v) => PaymentMethod.fromDb(v as String))
        .whereType<PaymentMethod>()
        .toList();

    final pizzaRows = await db.query(
      'pizzas',
      where: 'pedido_id = ?',
      whereArgs: [pedidoId],
      orderBy: 'numero_pizza ASC',
    );

    final pizzas = <OrderPizzaDetail>[];
    for (final pizzaRow in pizzaRows) {
      final pizzaId = pizzaRow['id'] as int;
      final saborRows = await db.rawQuery('''
        SELECT s.* FROM sabores s
        INNER JOIN pizza_sabores ps ON ps.sabor_id = s.id
        WHERE ps.pizza_id = ?
        ORDER BY s.nome ASC
      ''', [pizzaId]);

      pizzas.add(
        OrderPizzaDetail(
          numeroPizza: pizzaRow['numero_pizza'] as int,
          sabores: saborRows.map(Sabor.fromMap).toList(),
        ),
      );
    }

    final extraRows = await db.rawQuery('''
      SELECT e.*, pe.quantidade FROM extras e
      INNER JOIN pedido_extras pe ON pe.extra_id = e.id
      WHERE pe.pedido_id = ?
    ''', [pedidoId]);

    final extras = extraRows
        .map(
          (r) => OrderExtraDetail(
            extra: Extra.fromMap(r),
            quantidade: r['quantidade'] as int,
          ),
        )
        .toList();

    return Order(
      id: pedidoId,
      numero: row['numero'] as int,
      tipo: OrderTypeLabel.fromDb(row['tipo'] as String),
      endereco: row['endereco'] as String?,
      taxaEntrega: (row['taxa_entrega'] as num).toDouble(),
      valorTotal: (row['valor_total'] as num).toDouble(),
      data: DateTime.parse(row['data'] as String),
      pizzas: pizzas,
      extras: extras,
      clienteId: clienteId,
      clienteNome: clienteNome,
      formasPagamento: formasList,
      trocoPara: (row['troco_para'] as num?)?.toDouble(),
      observacao: row['observacao'] as String?,
    );
  }
}
