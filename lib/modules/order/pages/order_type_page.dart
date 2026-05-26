import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/routing/routes.dart';
import '../../../shared/widgets/primary_button.dart';
import '../controllers/order_wizard_controller.dart';

class OrderTypePage extends GetView<OrderWizardController> {
  const OrderTypePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tipo do pedido')),
      body: Obx(() {
        final draft = controller.draft.value;
        final isEntrega = draft.tipo == OrderType.entrega;

        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              RadioListTile<OrderType>(
                title: const Text('Retirada'),
                value: OrderType.retirada,
                groupValue: draft.tipo,
                onChanged: (v) => controller.setOrderType(v!),
              ),
              RadioListTile<OrderType>(
                title: Text('Entrega (+R\$ ${AppConstants.deliveryFee.toStringAsFixed(0)})'),
                value: OrderType.entrega,
                groupValue: draft.tipo,
                onChanged: (v) => controller.setOrderType(v!),
              ),
              if (isEntrega) ...[
                const SizedBox(height: 16),
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
              const Spacer(),
              PrimaryButton(
                label: 'Continuar',
                onPressed: () {
                  final error = controller.validateTypeStep();
                  if (error != null) {
                    Get.snackbar('Atenção', error);
                    return;
                  }
                  Get.toNamed(AppRoutes.extras);
                },
              ),
            ],
          ),
        );
      }),
    );
  }
}
