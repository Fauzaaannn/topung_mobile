import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:topung_mobile/core/routing/app_route_service.gr.dart';

import 'package:topung_mobile/core/modules/app_module.dart';
import 'package:topung_mobile/core/services/i_secure_storage_services.dart';

@RoutePage()
class SplashPage extends StatefulWidget {
  final bool fromLogin;
  const SplashPage({super.key, this.fromLogin = false});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final _secureStorage = serviceLocator<ISecureStorageService>();

  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  void _navigateToNext() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    final token = await _secureStorage.getToken();

    if (token == null || token.isEmpty) {
      context.router.replace(const LoginRoute());
    } else {
      context.router.replaceAll([const NavbarRoute(), ChatRoute()]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF00BCD4), Color(0xFF00ACC1)],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 1500),
                  curve: Curves.easeOutBack,
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: Opacity(opacity: value.clamp(0.0, 1.0), child: child),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Image.asset('asset/app_icon.png', width: 80, height: 80),
                  ),
                ),
                const SizedBox(height: 24),
                TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 1000),
                  curve: Curves.easeIn,
                  builder: (context, value, child) {
                    return Opacity(opacity: value.clamp(0.0, 1.0), child: child);
                  },
                  child: const Text(
                    'TopungEdu',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
