import 'package:flutter/material.dart';
import 'colors_theme.dart';

ThemeData customTheme = ThemeData(
  fontFamily: 'ProductSans',
  scaffoldBackgroundColor: AppColors.backgroundColor,
  textTheme: const TextTheme(
    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: AppColors.blackColor,
    ),
  ),
  colorScheme: primaryColorScheme,
);
