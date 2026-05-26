import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/database/database_helper.dart';
import '../../catalog/models/extra.dart';
import '../../catalog/models/sabor.dart';
import '../../catalog/repositories/catalog_repository.dart';
import '../models/order.dart';
import '../models/order_draft.dart';
import '../repositories/order_repository.dart';

class OrderWizardController extends GetxController {
  final draft = OrderDraft().obs;
  final sabores = <Sabor>[].obs;
  final extras = <Extra>[].obs;
  final isLoading = true.obs;
  final previewOrderNumber = 0.obs;

  final enderecoController = TextEditingController();

  late final CatalogRepository _catalog;
  late final OrderRepository _orderRepo;

  @override
  void onInit() {
    super.onInit();
    _catalog = CatalogRepository(DatabaseHelper.instance);
    _orderRepo = OrderRepository(DatabaseHelper.instance, _catalog);
    _loadCatalog();
  }

  Future<void> _loadCatalog() async {
    isLoading.value = true;
    sabores.assignAll(await _catalog.getSabores());
    extras.assignAll(await _catalog.getExtras());
    previewOrderNumber.value = await _peekNextOrderNumber();
    isLoading.value = false;
  }

  Future<int> _peekNextOrderNumber() async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.rawQuery(
      'SELECT COALESCE(MAX(numero), 0) as max_num FROM pedidos',
    );
    return (result.first['max_num'] as int) + 1;
  }

  void setPizzaCount(int count) {
    final clamped = count.clamp(AppConstants.minPizzas, AppConstants.maxPizzas);
    draft.update((d) => d!.setPizzaCount(clamped));
  }

  void toggleSabor(int pizzaIndex, int saborId) {
    draft.update((d) => d!.toggleSabor(pizzaIndex, saborId));
  }

  void setOrderType(OrderType tipo) {
    draft.update((d) {
      d!.tipo = tipo;
      if (tipo == OrderType.retirada) {
        d.endereco = '';
        enderecoController.clear();
      }
    });
  }

  void setEndereco(String value) {
    draft.update((d) => d!.endereco = value);
  }

  void incrementExtra(int extraId) {
    draft.update((d) {
      d!.extraQuantities[extraId] = (d.extraQuantities[extraId] ?? 0) + 1;
    });
  }

  void decrementExtra(int extraId) {
    draft.update((d) {
      final current = d!.extraQuantities[extraId] ?? 0;
      if (current <= 1) {
        d.extraQuantities.remove(extraId);
      } else {
        d.extraQuantities[extraId] = current - 1;
      }
    });
  }

  int extraQuantity(int extraId) => draft.value.extraQuantities[extraId] ?? 0;

  double get total {
    final saborPrices = {for (final s in sabores) s.id: s.preco};
    final extraPrices = {for (final e in extras) e.id: e.preco};
    return draft.value.calculateTotal(
      saborPrices: saborPrices,
      extraPrices: extraPrices,
    );
  }

  String? validateFlavorsStep() {
    if (!draft.value.allPizzasHaveSabores) {
      return 'Selecione ao menos um sabor para cada pizza.';
    }
    return null;
  }

  String? validateTypeStep() {
    if (!draft.value.isAddressValid) {
      return 'Informe o endereço completo para entrega.';
    }
    return null;
  }

  Future<int> confirmOrder() async {
    return _orderRepo.saveOrder(draft.value);
  }

  Future<Order?> getSavedOrder(int numero) =>
      _orderRepo.getOrderByNumero(numero);

  void resetDraft() {
    draft.value = OrderDraft();
    enderecoController.clear();
    _loadCatalog();
  }

  @override
  void onClose() {
    enderecoController.dispose();
    super.onClose();
  }

  List<Extra> extrasByCategory(String categoria) =>
      extras.where((e) => e.categoria == categoria).toList();
}
