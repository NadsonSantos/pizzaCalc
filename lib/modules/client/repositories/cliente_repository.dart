import '../../../core/database/database_helper.dart';
import '../models/cliente.dart';

class ClienteRepository {
  ClienteRepository(this._db);

  final DatabaseHelper _db;

  static final telefonePattern = RegExp(r'^\d{5}-\d{4}$');

  static bool isValidTelefone(String value) => telefonePattern.hasMatch(value);

  static String? validateNome(String nome) {
    final trimmed = nome.trim();
    if (trimmed.isEmpty) return 'Informe o nome do cliente.';
    if (trimmed.length > 80) return 'Nome deve ter no máximo 80 caracteres.';
    return null;
  }

  Future<List<Cliente>> searchByNome(String query) async {
    final db = await _db.database;
    final rows = await db.query(
      'clientes',
      where: 'nome LIKE ?',
      whereArgs: ['%$query%'],
      orderBy: 'nome ASC',
      limit: 20,
    );
    return rows.map(Cliente.fromMap).toList();
  }

  Future<Cliente?> getById(int id) async {
    final db = await _db.database;
    final rows = await db.query('clientes', where: 'id = ?', whereArgs: [id]);
    if (rows.isEmpty) return null;
    return Cliente.fromMap(rows.first);
  }

  Future<Cliente> create({
    required String nome,
    required String telefone,
    String? endereco,
  }) async {
    final db = await _db.database;
    final id = await db.insert('clientes', {
      'nome': nome.trim(),
      'telefone': telefone,
      'endereco': endereco?.trim().isEmpty ?? true ? null : endereco!.trim(),
    });
    return Cliente(
      id: id,
      nome: nome.trim(),
      telefone: telefone,
      endereco: endereco?.trim().isEmpty ?? true ? null : endereco!.trim(),
    );
  }

  Future<void> updateEndereco(int clienteId, String endereco) async {
    final db = await _db.database;
    await db.update(
      'clientes',
      {'endereco': endereco.trim()},
      where: 'id = ?',
      whereArgs: [clienteId],
    );
  }
}
