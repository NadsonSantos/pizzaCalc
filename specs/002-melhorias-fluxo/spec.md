# Feature Specification: Melhorias do Fluxo

**Feature Branch**: `002-melhorias-fluxo`

**Created**: 2026-06-02

**Status**: Draft

**Input**: Melhorias no wizard de pedidos, clientes, pagamento, observação e rascunhos persistidos.

## User Scenarios & Testing

### User Story 1 - Sabores por pizza com busca (Priority: P1)

Como atendente, quero escolher sabores de uma pizza por vez, com lista em ordem alfabética e busca, para montar pedidos com várias pizzas sem confusão.

**Why this priority**: Core do fluxo diário; substitui tela única com todas as pizzas.

**Independent Test**: Pedido com 3 pizzas passa por 3 telas de sabores; busca filtra lista; não avança sem ≥1 sabor na pizza atual.

**Acceptance Scenarios**:

1. **Given** 2 pizzas no pedido, **When** conclui sabores da pizza 1 e toca Próximo, **Then** vê tela "Pizza 2 de 2".
2. **Given** lista de sabores, **When** digita na busca, **Then** apenas sabores cujo nome contém o texto (sem diferenciar maiúsculas) são exibidos, em ordem A–Z.
3. **Given** pizza atual sem sabor, **When** toca Próximo, **Then** mensagem impede avanço.

---

### User Story 2 - Tipo e endereço na tela inicial do pedido (Priority: P1)

Como atendente, quero definir retirada/entrega e endereço na mesma tela da quantidade de pizzas, sem tela intermediária de tipo.

**Why this priority**: Remove passo extra; alinha com requisito de excluir OrderTypePage.

**Independent Test**: Novo pedido com entrega exige endereço ≥5 caracteres antes de ir aos sabores; retirada não exige endereço.

**Acceptance Scenarios**:

1. **Given** novo pedido, **When** seleciona Entrega sem endereço válido e continua, **Then** snackbar de validação.
2. **Given** OrderTypePage removida, **When** fluxo completo, **Then** navegação é NewOrder → PizzaFlavors → Extras → Summary.

---

### User Story 3 - Cliente com busca e cadastro rápido (Priority: P2)

Como atendente, quero associar um cliente ao pedido com busca por nome, criar se não existir, e preencher endereço automaticamente.

**Why this priority**: Agiliza entregas recorrentes; depende de NewOrderPage estendida.

**Independent Test**: Buscar cliente existente preenche endereço; criar "João" com telefone válido persiste cliente; endereço digitado salva no cliente se este não tinha endereço.

**Acceptance Scenarios**:

1. **Given** cliente "Maria" com endereço cadastrado, **When** seleciona na busca, **Then** campo endereço do pedido é preenchido.
2. **Given** busca sem resultado, **When** escolhe criar com texto pesquisado, **Then** dialog com nome, telefone (#####-####) e endereço opcional.
3. **Given** cliente sem endereço, **When** atendente digita endereço no pedido, **Then** endereço é salvo no cadastro do cliente ao confirmar pedido ou salvar rascunho.

---

### User Story 4 - Pagamento, troco e observação no resumo (Priority: P2)

Como atendente, quero registrar formas de pagamento (uma ou mais), troco quando houver dinheiro, e observações antes de confirmar.

**Why this priority**: Informação operacional no balcão e na cozinha.

**Independent Test**: Selecionar Dinheiro exibe "Troco para"; valor menor que total bloqueia confirmação; troco calculado = trocoPara - total.

**Acceptance Scenarios**:

1. **Given** resumo, **When** confirma sem forma de pagamento, **Then** validação impede.
2. **Given** Dinheiro selecionado, **When** informa troco para R$ 100 e total R$ 80, **Then** exibe troco a devolver R$ 20.
3. **Given** observação preenchida, **When** confirma, **Then** persiste e aparece no cupom.

---

### User Story 5 - Rascunhos na Home (Priority: P2)

Como atendente, quero salvar pedidos incompletos, listá-los na Home, retomar no resumo ou excluir.

**Why this priority**: Evita perder pedidos longos; não consome número de pedido.

**Independent Test**: Salvar rascunho na Home; tocar abre resumo preenchido; confirmar remove rascunho; excluir remove da lista.

**Acceptance Scenarios**:

1. **Given** resumo com dados, **When** Salvar como rascunho, **Then** aparece na Home sem número de pedido.
2. **Given** rascunho na Home, **When** toca, **Then** OrderSummaryPage com todos os dados.
3. **Given** rascunho retomado, **When** confirma pedido, **Then** rascunho é removido da lista.

---

## Requirements

### Functional

- FR-001: Uma tela de sabores por pizza (índice 1..N) com Próximo/Voltar.
- FR-002: Sabores ordenados A–Z; busca client-side por nome.
- FR-003: Remover OrderTypePage; tipo/endereço em NewOrderPage.
- FR-004: Cliente: nome ≤80, telefone #####-####, endereço opcional no cadastro.
- FR-005: Pagamento: Cartão, Pix, Dinheiro (multi); trocoPara se Dinheiro; observação texto livre.
- FR-006: Rascunhos em SQLite (payload JSON); listar/excluir na Home; retomar no resumo.

### Non-Functional

- NFR-001: 100% offline (SQLite).
- NFR-002: UI pt-BR; migração DB v1→v2 sem perda de pedidos existentes.

## Success Criteria

- Atendente completa pedido 3 pizzas em fluxo por pizza sem erro de validação.
- Rascunho salvo e retomado mantém cliente, sabores, extras e pagamento.
- Cupom impresso inclui cliente, pagamento, troco e observação quando preenchidos.
