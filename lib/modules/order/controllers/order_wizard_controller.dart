import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/database/database_helper.dart';
import '../../catalog/models/extra.dart';
import '../../catalog/models/sabor.dart';
import '../../catalog/repositories/catalog_repository.dart';
import '../../client/models/cliente.dart';
import '../../client/repositories/cliente_repository.dart';
import '../models/order.dart';
import '../models/order_draft.dart';
import '../models/payment_method.dart';
import '../repositories/draft_repository.dart';
import '../repositories/order_repository.dart';

class OrderWizardController extends GetxController {
  final draft = OrderDraft().obs;
  final sabores = <Sabor>[].obs;
  final extras = <Extra>[].obs;
  final isLoading = true.obs;
  final previewOrderNumber = 0.obs;
  final currentPizzaIndex = 0.obs;
  final flavorSearchQuery = ''.obs;
  final trocoParaText = ''.obs;

  final enderecoController = TextEditingController();
  final observacaoController = TextEditingController();
  final trocoParaController = TextEditingController();

  late final CatalogRepository _catalog;
  late final OrderRepository _orderRepo;
  late final ClienteRepository _clienteRepo;
  late final DraftRepository _draftRepo;

  @override
  void onInit() {
    super.onInit();
    _catalog = CatalogRepository(DatabaseHelper.instance);
    _clienteRepo = ClienteRepository(DatabaseHelper.instance);
    _orderRepo = OrderRepository(DatabaseHelper.instance, _catalog, _clienteRepo);
    _draftRepo = DraftRepository(DatabaseHelper.instance, _catalog);
    _loadCatalog().then((_) {
      final args = Get.arguments;
      if (args is Map && args['draftId'] is int) {
        loadDraft(args['draftId'] as int);
      }
    });
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

  List<Sabor> get filteredSabores {
    final q = flavorSearchQuery.value.trim().toLowerCase();
    if (q.isEmpty) return sabores;
    return sabores
        .where((s) => s.nome.toLowerCase().contains(q))
        .toList();
  }

  void setPizzaCount(int count) {
    final clamped =
        count.clamp(AppConstants.minPizzas, AppConstants.maxPizzas);
    draft.update((d) => d!.setPizzaCount(clamped));
  }

  void resetPizzaWizard() {
    currentPizzaIndex.value = 0;
    flavorSearchQuery.value = '';
  }

  void setFlavorSearch(String value) => flavorSearchQuery.value = value;

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

  Future<void> selectCliente(Cliente cliente) async {
    draft.update((d) {
      d!
        ..clienteId = cliente.id
        ..clienteNome = cliente.nome;
      if (cliente.endereco != null && cliente.endereco!.trim().isNotEmpty) {
        d.endereco = cliente.endereco!.trim();
        enderecoController.text = d.endereco;
      }
    });
  }

  void clearCliente() {
    draft.update((d) {
      d!
        ..clienteId = null
        ..clienteNome = null;
    });
  }

  Future<Cliente?> createCliente({
    required String nome,
    required String telefone,
    String? endereco,
  }) async {
    final cliente = await _clienteRepo.create(
      nome: nome,
      telefone: telefone,
      endereco: endereco,
    );
    await selectCliente(cliente);
    return cliente;
  }

  Future<List<Cliente>> searchClientes(String query) async {
    if (query.trim().length < 1) return [];
    return _clienteRepo.searchByNome(query.trim());
  }

  void togglePayment(PaymentMethod method) {
    draft.update((d) {
      if (d!.formasPagamento.contains(method)) {
        d.formasPagamento.remove(method);
        if (method == PaymentMethod.dinheiro) {
          d.trocoPara = null;
          trocoParaController.clear();
          trocoParaText.value = '';
        }
      } else {
        d.formasPagamento.add(method);
      }
    });
  }

  void setTrocoPara(String value) {
    trocoParaText.value = value;
    final parsed = double.tryParse(value.replaceAll(',', '.'));
    draft.update((d) => d!.trocoPara = parsed);
  }

  void setObservacao(String value) {
    draft.update((d) => d!.observacao = value);
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
    final t = draft.value.calculateTotal(
      saborPrices: saborPrices,
      extraPrices: extraPrices,
    );
    draft.value.cacheTotal(t);
    return t;
  }

  double? get trocoDevolver {
    if (!draft.value.hasDinheiro || draft.value.trocoPara == null) return null;
    return draft.value.trocoPara! - total;
  }

  String? validateNewOrderStep() {
    if (!draft.value.isAddressValid) {
      return 'Informe o endereço completo para entrega.';
    }
    return null;
  }

  String? validateCurrentPizzaStep() {
    if (!draft.value.pizzaHasSabores(currentPizzaIndex.value)) {
      return 'Selecione ao menos um sabor para esta pizza.';
    }
    return null;
  }

  String? validateSummaryStep() {
    if (draft.value.formasPagamento.isEmpty) {
      return 'Selecione ao menos uma forma de pagamento.';
    }
    if (draft.value.hasDinheiro) {
      if (draft.value.trocoPara == null) {
        return 'Informe o valor para troco.';
      }
      if (draft.value.trocoPara! < total) {
        return 'O valor para troco deve ser maior ou igual ao total.';
      }
    }
    return null;
  }

  bool advancePizzaOrExtras() {
    final error = validateCurrentPizzaStep();
    if (error != null) {
      Get.snackbar('Atenção', error);
      return false;
    }
    flavorSearchQuery.value = '';
    if (currentPizzaIndex.value < draft.value.pizzaCount - 1) {
      currentPizzaIndex.value++;
      return false;
    }
    return true;
  }

  void goToPreviousPizza() {
    if (currentPizzaIndex.value > 0) {
      currentPizzaIndex.value--;
      flavorSearchQuery.value = '';
    }
  }

  Future<int> confirmOrder() async {
    final rascunhoId = draft.value.rascunhoId;
    final numero = await _orderRepo.saveOrder(draft.value);
    if (rascunhoId != null) {
      await _draftRepo.deleteDraft(rascunhoId);
    }
    return numero;
  }

  Future<int> saveDraft() async {
    final id = await _draftRepo.saveDraft(draft.value);
    draft.update((d) => d!.rascunhoId = id);
    return id;
  }

  Future<void> loadDraft(int id) async {
    isLoading.value = true;
    final loaded = await _draftRepo.loadDraft(id);
    if (loaded == null) {
      isLoading.value = false;
      Get.snackbar('Erro', 'Rascunho não encontrado.');
      return;
    }

    final validIds = sabores.map((s) => s.id).toSet();
    loaded.sanitizeSabores(validIds);

    draft.value = loaded;
    enderecoController.text = loaded.endereco;
    observacaoController.text = loaded.observacao;
    if (loaded.trocoPara != null) {
      trocoParaController.text = loaded.trocoPara!.toStringAsFixed(2);
      trocoParaText.value = trocoParaController.text;
    }
    currentPizzaIndex.value = 0;
    flavorSearchQuery.value = '';
    isLoading.value = false;
  }

  Future<Order?> getSavedOrder(int numero) =>
      _orderRepo.getOrderByNumero(numero);

  void resetDraft() {
    draft.value = OrderDraft();
    enderecoController.clear();
    observacaoController.clear();
    trocoParaController.clear();
    trocoParaText.value = '';
    currentPizzaIndex.value = 0;
    flavorSearchQuery.value = '';
    _loadCatalog();
  }

  @override
  void onClose() {
    enderecoController.dispose();
    observacaoController.dispose();
    trocoParaController.dispose();
    super.onClose();
  }

  List<Extra> extrasByCategory(String categoria) =>
      extras.where((e) => e.categoria == categoria).toList();
}
