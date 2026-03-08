import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:topung_mobile/core/app_theme/color_constant.dart';
import 'package:topung_mobile/core/routing/app_route_service.gr.dart';

@RoutePage()
class NavbarPage extends StatelessWidget {
  const NavbarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoTabsScaffold(
      routes: const [
        IllnessCategoryRoute(),
        ChatHistoryRoute(),
        ProfileRoute(),
      ],
      bottomNavigationBuilder: (_, tabsRouter) {
        return BottomNavigationBar(
          currentIndex: tabsRouter.activeIndex,
          onTap: tabsRouter.setActiveIndex,
          selectedItemColor: ColorConstant.primary,
          unselectedItemColor: ColorConstant.grey,
          backgroundColor: ColorConstant.white,
          type: BottomNavigationBarType.fixed,
          elevation: 8,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.local_hospital_outlined),
              activeIcon: Icon(Icons.local_hospital),
              label: 'Penyakit',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline),
              activeIcon: Icon(Icons.chat_bubble),
              label: 'Chat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profil',
            ),
          ],
        );
      },
    );
  }
}
