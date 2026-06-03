import 'dart:convert';

import '../../../core/database/database_helper.dart';
import '../../catalog/repositories/catalog_repository.dart';
import '../models/draft_summary.dart';
import '../models/order_draft.dart';

class DraftRepository {
  DraftRepository(this._db, this._catalog);

  final DatabaseHelper _db;
  final CatalogRepository _catalog;

  Future<List<DraftSummary>> listSummaries() async {
    final db = await _db.database;
    final rows = await db.query(
      'rascunhos',
      orderBy: 'atualizado_em DESC',
    );

    final saborPrices = {
      for (final s in await _catalog.getSabores()) s.id: s.preco,
    };
    final extraPrices = {
      for (final e in await _catalog.getExtras()) e.id: e.preco,
    };

    return rows.map((row) {
      final draft = OrderDraft.fromJsonString(row['payload'] as String);
      final total = draft.calculateTotal(
        saborPrices: saborPrices,
        extraPrices: extraPrices,
      );
      return DraftSummary(
        id: row['id'] as int,
        titulo: row['titulo'] as String,
        atualizadoEm: DateTime.parse(row['atualizado_em'] as String),
        totalPreview: total,
      );
    }).toList();
  }

  Future<OrderDraft?> loadDraft(int id) async {
    final db = await _db.database;
    final rows = await db.query(
      'rascunhos',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (rows.isEmpty) return null;
    final draft = OrderDraft.fromJsonString(rows.first['payload'] as String);
    draft.rascunhoId = id;
    return draft;
  }

  Future<int> saveDraft(OrderDraft draft) async {
    final db = await _db.database;
    final titulo = draft.clienteNome?.trim().isNotEmpty == true
        ? draft.clienteNome!.trim()
        : 'Rascunho';
    final payload = draft.toJsonString();
    final now = DateTime.now().toIso8601String();

    if (draft.rascunhoId != null) {
      await db.update(
        'rascunhos',
        {
          'titulo': titulo,
          'payload': payload,
          'atualizado_em': now,
        },
        where: 'id = ?',
        whereArgs: [draft.rascunhoId],
      );
      return draft.rascunhoId!;
    }

    return db.insert('rascunhos', {
      'titulo': titulo,
      'payload': payload,
      'atualizado_em': now,
    });
  }

  Future<void> deleteDraft(int id) async {
    final db = await _db.database;
    await db.delete('rascunhos', where: 'id = ?', whereArgs: [id]);
  }
}
