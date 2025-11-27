import 'package:get/get_navigation/src/routes/get_route.dart';

import './routes.dart';

import '../../ui/splash/splash_page.dart';
import '../../ui/home/home_binding.dart';
import '../../ui/home/home_page.dart';

class AppPages {
  static final pages = [
    GetPage(name: AppRoutes.splash, page: () => SplashPage()),
    GetPage(
      name: AppRoutes.home,
      page: () => HomePage(),
      binding: HomeBinding(),
    ),
  ];
}
