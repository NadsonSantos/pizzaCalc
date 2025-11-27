import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/routing/routes.dart';

class SplashPage extends StatelessWidget {
  SplashPage({super.key}) {
    startTimeout();
  }

  startTimeout() async {
    return Timer(Duration(seconds: 2), () async {
      Get.toNamed(AppRoutes.home);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            color: const Color.fromRGBO(250, 129, 47, 1),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 20,
                children: [
                  Image.asset(
                    'assets/images/splash_logo.jpeg',
                    height: constraints.maxHeight * 0.2,
                  ),
                  Text(
                    'Seja bem-vindo ao PizzaCalc',
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(color: Colors.white),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
