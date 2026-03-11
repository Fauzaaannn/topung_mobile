import 'package:flutter/material.dart';
import 'package:topung_mobile/core/modules/app_module.dart';
import 'package:topung_mobile/core/routing/app_route_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeAllModules();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Topung Mobile',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF00BCD4)),
      ),
      routerConfig: serviceLocator<AppRouter>().config(),
    );
  }
}
