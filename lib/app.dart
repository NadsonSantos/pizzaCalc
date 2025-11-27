import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'core/routing/app_pages.dart';
import 'core/routing/routes.dart';
import 'core/theme/theme_app.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: customTheme,
      initialRoute: AppRoutes.splash,
      getPages: AppPages.pages,
      // supportedLocales: const [Locale('pt', 'BR')],
      locale: const Locale('pt', 'BR'),
    );
  }
}
