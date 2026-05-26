import 'package:get/get.dart';

import '../../../core/database/database_helper.dart';
import '../../catalog/repositories/catalog_repository.dart';
import '../models/order.dart';
import '../repositories/order_repository.dart';

class OrderHistoryController extends GetxController {
  final orders = <Order>[].obs;
  final isLoading = true.obs;

  late final OrderRepository _orderRepo;

  @override
  void onInit() {
    super.onInit();
    final catalog = CatalogRepository(DatabaseHelper.instance);
    _orderRepo = OrderRepository(DatabaseHelper.instance, catalog);
    loadOrders();
  }

  Future<void> loadOrders() async {
    isLoading.value = true;
    orders.assignAll(await _orderRepo.getAllOrders());
    isLoading.value = false;
  }

  Future<Order?> getOrder(int id) => _orderRepo.getOrderById(id);
}
