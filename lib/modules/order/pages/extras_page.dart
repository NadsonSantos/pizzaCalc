import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/routing/routes.dart';
import '../../../shared/widgets/primary_button.dart';
import '../controllers/order_wizard_controller.dart';

class ExtrasPage extends GetView<OrderWizardController> {
  const ExtrasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Extras')),
      body: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _CategorySection(
                    title: 'Bebidas',
                    categoria: 'BEBIDA',
                  ),
                  const Divider(height: 32),
                  _CategorySection(
                    title: 'Geladinhos',
                    categoria: 'GELADINHO',
                  ),
                  const Divider(height: 32),
                  _CategorySection(
                    title: 'Mousses',
                    categoria: 'MOUSSE',
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: PrimaryButton(
                label: 'Continuar',
                onPressed: () => Get.toNamed(AppRoutes.orderSummary),
              ),
            ),
          ],
        ),
    );
  }
}

class _CategorySection extends GetView<OrderWizardController> {
  const _CategorySection({required this.title, required this.categoria});

  final String title;
  final String categoria;

  @override
  Widget build(BuildContext context) {
    final items = controller.extrasByCategory(categoria);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        ...items.map((extra) {
          return Obx(() {
              final qty = controller.extraQuantity(extra.id);

              return ListTile(
                title: Text(extra.nome),
                subtitle: qty > 0 ? Text('Quantidade: $qty') : null,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (qty > 0)
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: () => controller.decrementExtra(extra.id),
                      ),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: () => controller.incrementExtra(extra.id),
                    ),
                  ],
                ),
              );
            });
        }),
      ],
    );
  }
}
