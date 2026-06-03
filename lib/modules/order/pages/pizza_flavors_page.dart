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
      appBar: AppBar(
        title: Obx(() {
          final idx = controller.currentPizzaIndex.value + 1;
          final total = controller.draft.value.pizzaCount;
          return Text('Pizza $idx de $total');
        }),
      ),
      body: Obx(() {
        final draft = controller.draft.value;
        final pizzaIndex = controller.currentPizzaIndex.value;
        final selected = draft.pizzaSabores[pizzaIndex];
        final filtered = controller.filteredSabores;
        final isLast = pizzaIndex >= draft.pizzaCount - 1;

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Buscar sabor...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onChanged: controller.setFlavorSearch,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: filtered.isEmpty
                  ? const Center(child: Text('Nenhum sabor encontrado.'))
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final sabor = filtered[index];
                        final isSelected = selected.contains(sabor.id);
                        return CheckboxListTile(
                          value: isSelected,
                          title: Text(sabor.nome),
                          onChanged: (_) =>
                              controller.toggleSabor(pizzaIndex, sabor.id),
                        );
                      },
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  if (pizzaIndex > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: controller.goToPreviousPizza,
                        child: const Text('Voltar'),
                      ),
                    ),
                  if (pizzaIndex > 0) const SizedBox(width: 8),
                  Expanded(
                    flex: 2,
                    child: PrimaryButton(
                      label: isLast ? 'Continuar' : 'Próximo',
                      onPressed: () {
                        final goExtras = controller.advancePizzaOrExtras();
                        if (goExtras) {
                          Get.toNamed(AppRoutes.extras);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
