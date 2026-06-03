-- Schema v2 migration (from v1)
-- Run via database_helper onUpgrade

CREATE TABLE IF NOT EXISTS clientes (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  nome TEXT NOT NULL,
  telefone TEXT NOT NULL,
  endereco TEXT
);

CREATE TABLE IF NOT EXISTS rascunhos (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  titulo TEXT NOT NULL,
  payload TEXT NOT NULL,
  atualizado_em TEXT NOT NULL
);

ALTER TABLE pedidos ADD COLUMN cliente_id INTEGER REFERENCES clientes(id);
ALTER TABLE pedidos ADD COLUMN formas_pagamento TEXT NOT NULL DEFAULT '[]';
ALTER TABLE pedidos ADD COLUMN troco_para REAL;
ALTER TABLE pedidos ADD COLUMN observacao TEXT;
