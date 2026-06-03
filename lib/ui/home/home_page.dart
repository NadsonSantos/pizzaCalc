import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../core/routing/routes.dart';
import '../../modules/order/bindings/order_bindings.dart';
import '../../modules/order/controllers/order_wizard_controller.dart';
import 'home_controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  static final _currency =
      NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
  static final _dateFormat = DateFormat('dd/MM HH:mm');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Atendimento Pizzaria')),
      body: Obx(() {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FilledButton.icon(
                    onPressed: () {
                      Get.delete<OrderWizardController>(force: true);
                      Get.toNamed(AppRoutes.newOrder);
                    },
                    icon: const Icon(Icons.add_shopping_cart),
                    label: const Text('Novo Pedido'),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(0, 64),
                      textStyle: const TextStyle(fontSize: 20),
                    ),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: () => Get.toNamed(AppRoutes.orderHistory),
                    icon: const Icon(Icons.history),
                    label: const Text('Histórico'),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(0, 56),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
            if (controller.isLoading.value)
              const Expanded(
                child: Center(child: CircularProgressIndicator()),
              )
            else if (controller.drafts.isEmpty)
              const Expanded(
                child: Center(
                  child: Text(
                    'Nenhum rascunho salvo.',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              )
            else ...[
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'Rascunhos',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.drafts.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final draft = controller.drafts[index];
                    return ListTile(
                      title: Text(draft.titulo),
                      subtitle: Text(
                        '${_dateFormat.format(draft.atualizadoEm)} • '
                        '${_currency.format(draft.totalPreview)}',
                      ),
                      onTap: () {
                        Get.delete<OrderWizardController>(force: true);
                        Get.toNamed(
                          AppRoutes.orderSummary,
                          arguments: {'draftId': draft.id},
                          binding: OrderWizardBinding(),
                        );
                      },
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () async {
                          final confirm = await Get.dialog<bool>(
                            AlertDialog(
                              title: const Text('Excluir rascunho?'),
                              content: Text(
                                'Deseja excluir "${draft.titulo}"?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Get.back(result: false),
                                  child: const Text('Cancelar'),
                                ),
                                FilledButton(
                                  onPressed: () => Get.back(result: true),
                                  child: const Text('Excluir'),
                                ),
                              ],
                            ),
                          );
                          if (confirm == true) {
                            await controller.deleteDraft(draft.id);
                          }
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        );
      }),
    );
  }
}
