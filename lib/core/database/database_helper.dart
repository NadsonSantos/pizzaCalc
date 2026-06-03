import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'seed_data.dart';

class DatabaseHelper {
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

  Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'pizzacalc.db');

    return openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await _createV1Tables(db);
    await _createV2Tables(db);
    await _seedCatalog(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await _createV2Tables(db);
      await _addPedidosV2Columns(db);
    }
  }

  Future<void> _createV1Tables(Database db) async {
    await db.execute('''
      CREATE TABLE pedidos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        numero INTEGER NOT NULL UNIQUE,
        tipo TEXT NOT NULL,
        endereco TEXT,
        taxa_entrega REAL NOT NULL DEFAULT 0,
        valor_total REAL NOT NULL,
        data TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE pizzas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        pedido_id INTEGER NOT NULL,
        numero_pizza INTEGER NOT NULL,
        FOREIGN KEY (pedido_id) REFERENCES pedidos(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE sabores (
        id INTEGER PRIMARY KEY,
        nome TEXT NOT NULL,
        preco REAL NOT NULL DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE pizza_sabores (
        pizza_id INTEGER NOT NULL,
        sabor_id INTEGER NOT NULL,
        PRIMARY KEY (pizza_id, sabor_id),
        FOREIGN KEY (pizza_id) REFERENCES pizzas(id),
        FOREIGN KEY (sabor_id) REFERENCES sabores(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE extras (
        id INTEGER PRIMARY KEY,
        nome TEXT NOT NULL,
        categoria TEXT NOT NULL,
        preco REAL NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE pedido_extras (
        pedido_id INTEGER NOT NULL,
        extra_id INTEGER NOT NULL,
        quantidade INTEGER NOT NULL DEFAULT 1,
        PRIMARY KEY (pedido_id, extra_id),
        FOREIGN KEY (pedido_id) REFERENCES pedidos(id),
        FOREIGN KEY (extra_id) REFERENCES extras(id)
      )
    ''');
  }

  Future<void> _createV2Tables(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS clientes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        telefone TEXT NOT NULL,
        endereco TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS rascunhos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        titulo TEXT NOT NULL,
        payload TEXT NOT NULL,
        atualizado_em TEXT NOT NULL
      )
    ''');
  }

  Future<void> _addPedidosV2Columns(Database db) async {
    final columns = await db.rawQuery('PRAGMA table_info(pedidos)');
    final names = columns.map((c) => c['name'] as String).toSet();

    if (!names.contains('cliente_id')) {
      await db.execute(
        'ALTER TABLE pedidos ADD COLUMN cliente_id INTEGER REFERENCES clientes(id)',
      );
    }
    if (!names.contains('formas_pagamento')) {
      await db.execute(
        "ALTER TABLE pedidos ADD COLUMN formas_pagamento TEXT NOT NULL DEFAULT '[]'",
      );
    }
    if (!names.contains('troco_para')) {
      await db.execute('ALTER TABLE pedidos ADD COLUMN troco_para REAL');
    }
    if (!names.contains('observacao')) {
      await db.execute('ALTER TABLE pedidos ADD COLUMN observacao TEXT');
    }
  }

  Future<void> _seedCatalog(Database db) async {
    final batch = db.batch();
    for (final sabor in SeedData.sabores) {
      batch.insert(
        'sabores',
        sabor.toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }
    for (final extra in SeedData.extras) {
      batch.insert(
        'extras',
        extra.toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }
    await batch.commit(noResult: true);
  }
}
