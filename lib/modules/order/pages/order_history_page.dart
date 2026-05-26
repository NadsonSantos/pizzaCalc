import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_constants.dart';
import '../../printer/services/printer_service.dart';
import '../controllers/order_history_controller.dart';
import '../models/order.dart';

class OrderHistoryPage extends GetView<OrderHistoryController> {
  const OrderHistoryPage({super.key});

  static final _currency = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
  static final _dateFormat = DateFormat('dd/MM/yyyy HH:mm');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Histórico')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.orders.isEmpty) {
          return const Center(child: Text('Nenhum pedido registrado.'));
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: controller.orders.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (context, index) {
            final order = controller.orders[index];
            return ListTile(
              title: Text('Pedido #${order.numero}'),
              subtitle: Text(
                '${_dateFormat.format(order.data)} • ${order.tipo.label}\n'
                '${_currency.format(order.valorTotal)}',
              ),
              isThreeLine: true,
              trailing: IconButton(
                icon: const Icon(Icons.print),
                tooltip: 'Reimprimir',
                onPressed: () => _reprint(order),
              ),
              onTap: () => _showDetails(context, order),
            );
          },
        );
      }),
    );
  }

  Future<void> _reprint(Order order) async {
    final printer = PrinterService();
    final printed = await printer.printOrder(order);
    Get.snackbar(
      printed ? 'Impressão' : 'Falha',
      printed
          ? 'Pedido #${order.numero} reimpresso.'
          : 'Verifique se a impressora está pareada e conectada.',
    );
  }

  void _showDetails(BuildContext context, Order order) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Pedido #${order.numero}',
                  style: Theme.of(ctx).textTheme.titleLarge),
              const SizedBox(height: 8),
              ...order.pizzas.map((p) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Pizza ${p.numeroPizza}:',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      ...p.sabores.map((s) => Text('- ${s.nome}')),
                    ],
                  )),
              const SizedBox(height: 8),
              Text('Total: ${_currency.format(order.valorTotal)}'),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () {
                  Navigator.pop(ctx);
                  _reprint(order);
                },
                icon: const Icon(Icons.print),
                label: const Text('Reimprimir'),
              ),
            ],
          ),
        );
      },
    );
  }
}
