import 'package:flutter/material.dart';
import 'package:topung_mobile/core/routing/app_route_service.dart';

final _appRouter = AppRouter();

void main() {
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
      routerConfig: _appRouter.config(),
    );
  }
}
