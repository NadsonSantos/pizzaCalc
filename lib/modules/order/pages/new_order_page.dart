import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/routing/routes.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/quantity_stepper.dart';
import '../../../shared/widgets/searchable_client_field.dart';
import '../controllers/order_wizard_controller.dart';

class NewOrderPage extends GetView<OrderWizardController> {
  const NewOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Novo Pedido')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final draft = controller.draft.value;
        final isEntrega = draft.tipo == OrderType.entrega;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Quantidade de pizzas',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              QuantityStepper(
                value: draft.pizzaCount,
                onDecrement: () => controller.setPizzaCount(
                  controller.draft.value.pizzaCount - 1,
                ),
                onIncrement: () => controller.setPizzaCount(
                  controller.draft.value.pizzaCount + 1,
                ),
              ),
              const SizedBox(height: 24),
              SearchableClientField(controller: controller),
              const SizedBox(height: 24),
              Text(
                'Tipo do pedido',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              RadioListTile<OrderType>(
                title: const Text('Retirada'),
                value: OrderType.retirada,
                groupValue: draft.tipo,
                onChanged: (v) => controller.setOrderType(v!),
              ),
              RadioListTile<OrderType>(
                title: Text(
                  'Entrega (+R\$ ${AppConstants.deliveryFee.toStringAsFixed(0)})',
                ),
                value: OrderType.entrega,
                groupValue: draft.tipo,
                onChanged: (v) => controller.setOrderType(v!),
              ),
              if (isEntrega) ...[
                const SizedBox(height: 8),
                const Text('Endereço:'),
                const SizedBox(height: 8),
                TextField(
                  decoration: const InputDecoration(
                    hintText: 'Rua, número, bairro...',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                  controller: controller.enderecoController,
                  onChanged: controller.setEndereco,
                ),
              ],
              const SizedBox(height: 32),
              PrimaryButton(
                label: 'Continuar',
                onPressed: () {
                  final error = controller.validateNewOrderStep();
                  if (error != null) {
                    Get.snackbar('Atenção', error);
                    return;
                  }
                  controller.resetPizzaWizard();
                  Get.toNamed(AppRoutes.pizzaFlavors);
                },
              ),
            ],
          ),
        );
      }),
    );
  }
}
