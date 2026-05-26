import 'package:get/get_navigation/src/routes/get_route.dart';

import './routes.dart';

import '../../modules/order/bindings/order_bindings.dart';
import '../../modules/order/pages/extras_page.dart';
import '../../modules/order/pages/new_order_page.dart';
import '../../modules/order/pages/order_history_page.dart';
import '../../modules/order/pages/order_summary_page.dart';
import '../../modules/order/pages/order_type_page.dart';
import '../../modules/order/pages/pizza_flavors_page.dart';
import '../../ui/splash/splash_page.dart';
import '../../ui/home/home_binding.dart';
import '../../ui/home/home_page.dart';

class AppPages {
  static final pages = [
    GetPage(name: AppRoutes.splash, page: () => SplashPage()),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomePage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.newOrder,
      page: () => const NewOrderPage(),
      binding: OrderWizardBinding(),
    ),
    GetPage(
      name: AppRoutes.pizzaFlavors,
      page: () => const PizzaFlavorsPage(),
      binding: OrderWizardBinding(),
    ),
    GetPage(
      name: AppRoutes.orderType,
      page: () => const OrderTypePage(),
      binding: OrderWizardBinding(),
    ),
    GetPage(
      name: AppRoutes.extras,
      page: () => const ExtrasPage(),
      binding: OrderWizardBinding(),
    ),
    GetPage(
      name: AppRoutes.orderSummary,
      page: () => const OrderSummaryPage(),
      binding: OrderWizardBinding(),
    ),
    GetPage(
      name: AppRoutes.orderHistory,
      page: () => const OrderHistoryPage(),
      binding: OrderHistoryBinding(),
    ),
  ];
}
