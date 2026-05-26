import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/routing/routes.dart';
import '../../../shared/widgets/primary_button.dart';
import '../controllers/order_wizard_controller.dart';

class PizzaFlavorsPage extends GetView<OrderWizardController> {
  const PizzaFlavorsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sabores')),
      body: Obx(() {
        final draft = controller.draft.value;
        final sabores = controller.sabores;

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: draft.pizzaCount,
                itemBuilder: (context, pizzaIndex) {
                  final selected = draft.pizzaSabores[pizzaIndex];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pizza ${pizzaIndex + 1}',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text('Selecione sabores:'),
                      const SizedBox(height: 8),
                      ...sabores.map((sabor) {
                        final isSelected = selected.contains(sabor.id);
                        return CheckboxListTile(
                          value: isSelected,
                          title: Text(sabor.nome),
                          onChanged: (_) =>
                              controller.toggleSabor(pizzaIndex, sabor.id),
                        );
                      }),
                      if (pizzaIndex < draft.pizzaCount - 1)
                        const Divider(height: 32),
                    ],
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: PrimaryButton(
                label: 'Continuar',
                onPressed: () {
                  final error = controller.validateFlavorsStep();
                  if (error != null) {
                    Get.snackbar('Atenção', error);
                    return;
                  }
                  Get.toNamed(AppRoutes.orderType);
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}
