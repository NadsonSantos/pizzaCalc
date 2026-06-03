# Quickstart: Melhorias do Fluxo

## Pré-requisitos

- Flutter SDK; emulador Android ou dispositivo
- Branch `002-melhorias-fluxo`

## Cenários manuais

### 1. Pedido 2 pizzas (fluxo por pizza)

1. Home → Novo Pedido → 2 pizzas → Continuar
2. Pizza 1 de 2: buscar "cal", selecionar sabores → Próximo
3. Pizza 2 de 2: sabores → Próximo → Extras → Resumo → Confirmar

### 2. Cliente novo

1. NewOrder: buscar "João Silva" → Criar → telefone `99999-9999` → OK
2. Entrega + endereço → confirmar pedido
3. Novo pedido: buscar "João" → endereço preenchido

### 3. Rascunho

1. Montar pedido até Resumo → Salvar como rascunho → Home lista item
2. Tocar rascunho → resumo preenchido → Confirmar → rascunho some da Home

### 4. Pagamento com troco

1. Resumo: marcar Dinheiro + Pix
2. Troco para R$ 100 (total menor) → ver troco calculado
3. Confirmar → cupom com pagamentos e troco

### 5. Migração

1. Instalar build anterior (v1 DB), criar 1 pedido
2. Atualizar app → histórico ainda lista pedido antigo
