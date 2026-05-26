import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:intl/intl.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

import '../../../core/constants/app_constants.dart';
import '../../order/models/order.dart';

class PrinterService {
  final _currency = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
  final _dateFormat = DateFormat('dd/MM/yyyy HH:mm');

  Future<bool> isConnected() => PrintBluetoothThermal.connectionStatus;

  Future<List<BluetoothInfo>> getPairedDevices() =>
      PrintBluetoothThermal.pairedBluetooths;

  Future<bool> connect(String macAddress) =>
      PrintBluetoothThermal.connect(macPrinterAddress: macAddress);

  Future<bool> printOrder(Order order) async {
    final bytes = await _buildReceipt(order);
    return PrintBluetoothThermal.writeBytes(bytes);
  }

  Future<List<int>> _buildReceipt(Order order) async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);
    final bytes = <int>[];

    bytes.addAll(generator.text(AppConstants.storeName,
        styles: const PosStyles(align: PosAlign.center, bold: true)));
    bytes.addAll(generator.text('Pedido #${order.numero}',
        styles: const PosStyles(align: PosAlign.center, bold: true)));
    bytes.addAll(generator.hr());

    for (final pizza in order.pizzas) {
      bytes.addAll(generator.text('Pizza ${pizza.numeroPizza}:',
          styles: const PosStyles(bold: true)));
      for (final sabor in pizza.sabores) {
        bytes.addAll(generator.text('- ${sabor.nome}'));
      }
      bytes.addAll(generator.feed(1));
    }

    bytes.addAll(generator.text('Tipo:'));
    bytes.addAll(generator.text(order.tipo.label));

    if (order.tipo == OrderType.entrega) {
      bytes.addAll(generator.text('Endereço:'));
      bytes.addAll(generator.text(order.endereco ?? ''));
      bytes.addAll(generator.text('Taxa:'));
      bytes.addAll(generator.text(_currency.format(order.taxaEntrega)));
    }

    if (order.extras.isNotEmpty) {
      bytes.addAll(generator.text('Extras:'));
      for (final item in order.extras) {
        final label = item.extra.categoria == 'MOUSSE'
            ? 'Mousses ${item.extra.nome}'
            : item.extra.nome;
        bytes.addAll(generator.text('${item.quantidade} $label'));
      }
    }

    bytes.addAll(generator.hr());
    bytes.addAll(generator.text('Total:',
        styles: const PosStyles(bold: true)));
    bytes.addAll(generator.text(_currency.format(order.valorTotal),
        styles: const PosStyles(bold: true)));
    bytes.addAll(generator.feed(1));
    bytes.addAll(generator.text(_dateFormat.format(order.data),
        styles: const PosStyles(align: PosAlign.center)));
    bytes.addAll(generator.feed(2));
    bytes.addAll(generator.cut());

    return bytes;
  }
}
