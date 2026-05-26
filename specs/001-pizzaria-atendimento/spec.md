# Feature Specification: App de Atendimento Pizzaria Offline

**Feature Branch**: `001-pizzaria-atendimento`

**Created**: 2026-05-26

**Status**: Draft

**Input**: User description: "App offline para atendentes de pizzaria registrar pedidos rapidamente, salvar localmente e imprimir em impressora térmica PDV."

## Clarifications

### Session 2026-05-26

- Q: Como calcular preço das pizzas (base vs sabores)? → A: Preço base fixo R$ 35,00/pizza; sabores usam preco do catálogo (default 0).
- Q: Como funciona "Editar" no resumo? → A: Volta ao wizard com estado preservado em memória.
- Q: Qual transporte de impressora no MVP? → A: Bluetooth clássico Android (print_bluetooth_thermal).
- Q: Escopo do histórico? → A: Todos os pedidos salvos, ordenados por data decrescente.
- Q: Formato do endereço? → A: Texto livre, mínimo 5 caracteres, obrigatório só em entrega.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Registrar pedido completo (Priority: P1)

Como atendente, quero registrar um pedido informando quantidade de pizzas, sabores
por pizza, tipo (retirada/entrega), extras e confirmar, para que a cozinha receba
o pedido impresso e salvo localmente.

**Why this priority**: Core value of the MVP — without this flow the app has no purpose.

**Independent Test**: Complete the 5-screen wizard from quantity to confirmation;
verify order saved with auto-increment number and correct total.

**Acceptance Scenarios**:

1. **Given** app aberto na tela inicial, **When** atendente seleciona 2 pizzas e
   continua, **Then** vê configuração de sabores para Pizza 1 e Pizza 2.
2. **Given** sabores selecionados, **When** escolhe Entrega e informa endereço,
   **Then** taxa de R$ 5,00 é aplicada ao total.
3. **Given** extras adicionados, **When** confirma no resumo, **Then** pedido é
   salvo localmente com número automático e impressão é disparada.

---

### User Story 2 - Consultar histórico e reimprimir (Priority: P2)

Como atendente, quero ver pedidos salvos e reimprimir um pedido, para reenviar
comprovante à cozinha ou balcão.

**Why this priority**: Operational need after first orders are taken; depends on P1 persistence.

**Independent Test**: Open history, select a saved order, trigger re-print; receipt
matches original order data.

**Acceptance Scenarios**:

1. **Given** pedidos confirmados no dia, **When** abre histórico, **Then** vê lista
   com número, horário e total.
2. **Given** pedido selecionado, **When** toca Reimprimir, **Then** comprovante
   idêntico ao original é enviado à impressora.

---

### User Story 3 - Editar pedido antes de confirmar (Priority: P3)

Como atendente, quero voltar e corrigir dados antes de confirmar, para evitar
pedidos errados na cozinha.

**Why this priority**: Reduces errors; wizard state must be preserved while navigating back.

**Independent Test**: Reach summary, tap Editar, change delivery to pickup, verify
total updates without saving until Confirmar.

**Acceptance Scenarios**:

1. **Given** resumo exibido, **When** toca Editar, **Then** retorna ao fluxo com
   dados preenchidos preservados.
2. **Given** pedido em rascunho, **When** altera quantidade de extras, **Then**
   total no resumo reflete a mudança.

---

### User Story 4 - Impressão térmica ESC/POS (Priority: P4)

Como atendente, quero que o pedido confirmado imprima automaticamente em impressora
térmica PDV, no formato padronizado da pizzaria.

**Why this priority**: Kitchen workflow depends on printed ticket; can stub in dev but
must integrate for production MVP.

**Independent Test**: Confirm order with paired printer; physical or log output shows
header, items, total, and timestamp.

**Acceptance Scenarios**:

1. **Given** impressora pareada, **When** confirma pedido, **Then** ticket ESC/POS
   é impresso com layout definido.
2. **Given** falha de impressão, **When** confirma pedido, **Then** pedido ainda é
   salvo e mensagem informa falha de impressão.

---

### Edge Cases

- Quantidade de pizzas mínima: 1; máximo razoável: 20 (validação na UI).
- Entrega sem endereço: bloquear continuação até preencher endereço.
- Nenhum sabor selecionado em uma pizza: bloquear continuação.
- Impressora desconectada: salvar pedido e exibir aviso; permitir reimpressão depois.
- Primeiro pedido do dia: número inicia em 1 (ou continua sequência global local).

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: Sistema MUST permitir iniciar novo pedido selecionando quantidade de pizzas (stepper +/-).
- **FR-002**: Sistema MUST exibir tela de sabores por pizza com seleção múltipla (checkboxes).
- **FR-003**: Sistema MUST permitir escolher Retirada ou Entrega; Entrega MUST adicionar R$ 5,00 ao total.
- **FR-004**: Campo endereço MUST aparecer e ser obrigatório apenas quando Entrega estiver selecionada.
- **FR-005**: Sistema MUST permitir adicionar extras (Bebidas, Geladinhos, Mousses) com quantidade +/-.
- **FR-006**: Sistema MUST exibir resumo com número do pedido (pré-atribuído), itens, taxa, extras e total.
- **FR-007**: Sistema MUST gerar número de pedido automático e sequencial (único localmente).
- **FR-008**: Sistema MUST persistir pedido confirmado localmente (pedido, pizzas, sabores, extras).
- **FR-009**: Sistema MUST permitir editar pedido antes da confirmação (botão Editar no resumo).
- **FR-010**: Sistema MUST imprimir pedido após confirmação no formato definido (ESC/POS).
- **FR-011**: Sistema MUST permitir reimprimir pedidos do histórico.
- **FR-012**: Sistema MUST pré-carregar catálogo de sabores e extras no banco local (seed).
- **FR-013**: Total MUST ser calculado como: (quantidade_pizzas × preço_base_pizza) + soma(extras × preço) + taxa_entrega.

### Key Entities

- **Pedido**: id, numero, tipo (RETIRADA|ENTREGA), endereco, taxaEntrega, valorTotal, data.
- **Pizza**: id, pedidoId, numeroPizza (1-based index within order).
- **Sabor**: id, nome, preco (adicional por sabor; preço base da pizza é constante).
- **PizzaSabores**: pizzaId, saborId (many-to-many).
- **Extra**: id, nome, categoria (BEBIDA|GELADINHO|MOUSSE), preco.
- **PedidoExtras**: pedidoId, extraId, quantidade.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Atendente completa pedido típico (2 pizzas, entrega, 2 extras) em menos de 60 segundos.
- **SC-002**: 100% dos pedidos confirmados persistem após fechar e reabrir o app.
- **SC-003**: Total exibido no resumo coincide com total impresso em 100% dos casos testados.
- **SC-004**: Reimpressão produz output idêntico ao comprovante original para o mesmo pedido.

## Assumptions

- Preço base por pizza: R$ 35,00 (fixo no MVP); sabores sem custo adicional salvo preço > 0 no catálogo.
- Extras têm preço individual no catálogo seed.
- Um único atendente por dispositivo; sem login.
- Histórico mostra todos os pedidos salvos (ordenados por data decrescente).
- Impressora: Bluetooth clássico em Android PDV (pareamento manual prévio).
- Endereço: texto livre, mínimo 5 caracteres para entrega.
- Editar no resumo: navega de volta mantendo estado do wizard em memória.
