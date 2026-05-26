import '../../../core/database/database_helper.dart';
import '../models/extra.dart';
import '../models/sabor.dart';

class CatalogRepository {
  CatalogRepository(this._db);

  final DatabaseHelper _db;

  Future<List<Sabor>> getSabores() async {
    final db = await _db.database;
    final rows = await db.query('sabores', orderBy: 'nome ASC');
    return rows.map(Sabor.fromMap).toList();
  }

  Future<List<Extra>> getExtras() async {
    final db = await _db.database;
    final rows = await db.query('extras', orderBy: 'categoria ASC, nome ASC');
    return rows.map(Extra.fromMap).toList();
  }

  Future<Sabor?> getSaborById(int id) async {
    final db = await _db.database;
    final rows = await db.query('sabores', where: 'id = ?', whereArgs: [id]);
    if (rows.isEmpty) return null;
    return Sabor.fromMap(rows.first);
  }

  Future<Extra?> getExtraById(int id) async {
    final db = await _db.database;
    final rows = await db.query('extras', where: 'id = ?', whereArgs: [id]);
    if (rows.isEmpty) return null;
    return Extra.fromMap(rows.first);
  }
}
