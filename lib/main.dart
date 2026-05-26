import 'package:flutter/material.dart';
import 'app.dart';
import 'core/database/database_helper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.instance.database;
  runApp(const App());
}
