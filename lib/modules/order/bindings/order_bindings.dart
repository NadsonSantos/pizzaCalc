import 'package:get/get.dart';

import '../../../core/database/database_helper.dart';
import '../../catalog/repositories/catalog_repository.dart';
import '../controllers/order_history_controller.dart';
import '../controllers/order_wizard_controller.dart';
import '../repositories/order_repository.dart';

class OrderWizardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrderWizardController>(() => OrderWizardController());
  }
}

class OrderHistoryBinding extends Bindings {
  @override
  void dependencies() {
    final catalog = CatalogRepository(DatabaseHelper.instance);
    Get.lazyPut<OrderRepository>(
      () => OrderRepository(DatabaseHelper.instance, catalog),
    );
    Get.lazyPut<OrderHistoryController>(() => OrderHistoryController());
  }
}
