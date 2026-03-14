import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'app/app.dart';
import 'app/theme/theme_controller.dart';
import 'features/records/records_controller.dart';
import 'shared/storage/app_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  final repository = await AppRepository.create();
  runApp(
    MultiProvider(
      providers: [
        Provider<AppRepository>.value(value: repository),
        ChangeNotifierProvider(
          create: (_) => ThemeController(repository)..load(),
        ),
        ChangeNotifierProvider(
          create: (_) => RecordsController(repository)..load(),
        ),
      ],
      child: const ShortInsuranceApp(),
    ),
  );
}

