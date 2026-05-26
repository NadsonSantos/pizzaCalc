import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/routing/routes.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Atendimento Pizzaria')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FilledButton.icon(
              onPressed: () => Get.toNamed(AppRoutes.newOrder),
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
    );
  }
}
