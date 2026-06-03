import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/routing/routes.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../printer/services/printer_service.dart';
import '../controllers/order_wizard_controller.dart';
import '../models/payment_method.dart';

class OrderSummaryPage extends GetView<OrderWizardController> {
  const OrderSummaryPage({super.key});

  static final _currency =
      NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Resumo')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final draft = controller.draft.value;
        final sabores = controller.sabores;
        final extras = controller.extras;
        final orderNum = controller.previewOrderNumber.value;
        final isDraftResume = draft.rascunhoId != null;

        return Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Text(
                    isDraftResume
                        ? 'Rascunho'
                        : 'Pedido #$orderNum',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  if (draft.clienteNome != null) ...[
                    const SizedBox(height: 8),
                    Text('Cliente: ${draft.clienteNome}'),
                  ],
                  const SizedBox(height: 8),
                  Text(
                    '${draft.pizzaCount} pizza${draft.pizzaCount > 1 ? 's' : ''}',
                  ),
                  const SizedBox(height: 16),
                  ...List.generate(draft.pizzaCount, (i) {
                    final selectedIds = draft.pizzaSabores[i];
                    final names = selectedIds
                        .map(
                          (id) =>
                              sabores.firstWhere((s) => s.id == id).nome,
                        )
                        .toList();
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pizza ${i + 1}:',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          ...names.map((n) => Text('- $n')),
                        ],
                      ),
                    );
                  }),
                  const Divider(),
                  Text('Tipo: ${draft.tipo.label}'),
                  if (draft.tipo == OrderType.entrega) ...[
                    Text('Endereço: ${draft.endereco}'),
                    Text(
                      'Taxa: ${_currency.format(AppConstants.deliveryFee)}',
                    ),
                  ],
                  if (draft.extraQuantities.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    const Text(
                      'Extras:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    ...draft.extraQuantities.entries.map((entry) {
                      final extra =
                          extras.firstWhere((e) => e.id == entry.key);
                      final label = extra.categoria == 'MOUSSE'
                          ? 'Mousses ${extra.nome}'
                          : extra.nome;
                      return Text('${entry.value} $label');
                    }),
                  ],
                  const Divider(),
                  Text(
                    'Total: ${_currency.format(controller.total)}',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Forma de pagamento',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  CheckboxListTile(
                    title: const Text('Cartão'),
                    value: draft.formasPagamento.contains(PaymentMethod.cartao),
                    onChanged: (_) =>
                        controller.togglePayment(PaymentMethod.cartao),
                  ),
                  CheckboxListTile(
                    title: const Text('Pix'),
                    value: draft.formasPagamento.contains(PaymentMethod.pix),
                    onChanged: (_) =>
                        controller.togglePayment(PaymentMethod.pix),
                  ),
                  CheckboxListTile(
                    title: const Text('Dinheiro'),
                    value:
                        draft.formasPagamento.contains(PaymentMethod.dinheiro),
                    onChanged: (_) =>
                        controller.togglePayment(PaymentMethod.dinheiro),
                  ),
                  if (draft.hasDinheiro) ...[
                    const SizedBox(height: 8),
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Troco para (R\$)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      controller: controller.trocoParaController,
                      onChanged: controller.setTrocoPara,
                    ),
                    if (controller.trocoDevolver != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          'Troco a devolver: ${_currency.format(controller.trocoDevolver!)}',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                  ],
                  const SizedBox(height: 16),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Observação',
                      border: OutlineInputBorder(),
                      alignLabelWithHint: true,
                    ),
                    maxLines: 3,
                    controller: controller.observacaoController,
                    onChanged: controller.setObservacao,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  OutlinedButton(
                    onPressed: () => Get.offNamedUntil(
                      AppRoutes.newOrder,
                      (route) => route.settings.name == AppRoutes.home,
                    ),
                    child: const Text('Editar'),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton(
                    onPressed: _saveDraft,
                    child: const Text('Salvar como rascunho'),
                  ),
                  const SizedBox(height: 8),
                  PrimaryButton(
                    label: 'Confirmar pedido',
                    onPressed: () => _confirm(context),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Future<void> _saveDraft() async {
    try {
      await controller.saveDraft();
      controller.resetDraft();
      Get.offAllNamed(AppRoutes.home);
      Get.snackbar('Salvo', 'Rascunho salvo com sucesso.');
    } catch (_) {
      Get.snackbar('Erro', 'Não foi possível salvar o rascunho.');
    }
  }

  Future<void> _confirm(BuildContext context) async {
    final error = controller.validateSummaryStep();
    if (error != null) {
      Get.snackbar('Atenção', error);
      return;
    }

    try {
      final numero = await controller.confirmOrder();
      final order = await controller.getSavedOrder(numero);

      if (order != null) {
        final printer = PrinterService();
        final printed = await printer.printOrder(order);
        if (!printed) {
          Get.snackbar(
            'Impressão',
            'Pedido salvo, mas não foi possível imprimir. Use Reimprimir no histórico.',
          );
        }
      }

      controller.resetDraft();
      Get.offAllNamed(AppRoutes.home);
      Get.snackbar('Sucesso', 'Pedido #$numero confirmado!');
    } catch (e) {
      Get.snackbar('Erro', 'Não foi possível salvar o pedido.');
    }
  }
}
