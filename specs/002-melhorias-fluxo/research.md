# Research: Melhorias do Fluxo

**Date**: 2026-06-02

## Wizard por pizza

- **Decision**: `OrderWizardController.currentPizzaIndex` (0..N-1); mesma rota `pizzaFlavors`; AppBar "Pizza {i+1} de {N}".
- **Rationale**: Reutiliza binding GetX existente; evita rotas parametrizadas extras.
- **Alternatives considered**: Rotas `/pizza/:index` — rejeitado por complexidade de back stack.

## Busca de sabores

- **Decision**: Filtro client-side em lista já `ORDER BY nome ASC` do repositório.
- **Rationale**: Catálogo pequeno (~20 itens); zero latência offline.
- **Alternatives considered**: FTS SQLite — overkill.

## Select cliente com busca

- **Decision**: `Autocomplete<Cliente>` + opção "Criar \"{query}\""; dialog para telefone/endereço.
- **Rationale**: Sem dependência extra; Material 3 nativo.
- **Alternatives considered**: `dropdown_search` — rejeitado (YAGNI).

## Persistência de rascunho

- **Decision**: Tabela `rascunhos` com `payload` JSON (`schemaVersion: 1`).
- **Rationale**: Rascunho não precisa de joins para relatórios; serialização de `OrderDraft` completa.
- **Alternatives considered**: Espelhar schema de pedidos — rejeitado por duplicação.

## Migração DB

- **Decision**: `database_helper` version 2, `onUpgrade` ADD COLUMN / CREATE TABLE.
- **Rationale**: Padrão sqflite; pedidos existentes ganham defaults NULL/JSON vazio.
- **Alternatives considered**: Recriar DB — rejeitado (perda de histórico).

## Troco (Dinheiro)

- **Decision**: Campo `trocoPara` (valor pago); exibir `max(0, trocoPara - total)`; bloquear se `trocoPara < total`.
- **Rationale**: Alinhado à escolha do usuário no planejamento.
- **Alternatives considered**: Troco digitado manualmente — rejeitado (erro humano).

## Impressão

- **Decision**: Estender `PrinterService` com cliente, pagamentos, troco para/devolver, observação.
- **Rationale**: Cozinha/balcão precisam das mesmas infos do resumo.
