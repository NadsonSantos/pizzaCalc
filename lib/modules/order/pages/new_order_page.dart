import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/routing/routes.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/quantity_stepper.dart';
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

        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Quantidade de pizzas',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              QuantityStepper(
                value: controller.draft.value.pizzaCount,
                onDecrement: () => controller.setPizzaCount(
                  controller.draft.value.pizzaCount - 1,
                ),
                onIncrement: () => controller.setPizzaCount(
                  controller.draft.value.pizzaCount + 1,
                ),
              ),
              const Spacer(),
              PrimaryButton(
                label: 'Continuar',
                onPressed: () => Get.toNamed(AppRoutes.pizzaFlavors),
              ),
            ],
          ),
        );
      }),
    );
  }
}
