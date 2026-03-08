// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i8;
import 'package:flutter/material.dart' as _i9;
import 'package:topung_mobile/presentation/pages/auth_pages/login_page.dart'
    as _i4;
import 'package:topung_mobile/presentation/pages/auth_pages/profile_page.dart'
    as _i6;
import 'package:topung_mobile/presentation/pages/auth_pages/register_page.dart'
    as _i7;
import 'package:topung_mobile/presentation/pages/chatbot_pages/chat_history_page.dart'
    as _i1;
import 'package:topung_mobile/presentation/pages/illness_pages/illness_category_page.dart'
    as _i2;
import 'package:topung_mobile/presentation/pages/illness_pages/illness_type_page.dart'
    as _i3;
import 'package:topung_mobile/presentation/pages/navbar/navbar_page.dart'
    as _i5;

/// generated route for
/// [_i1.ChatHistoryPage]
class ChatHistoryRoute extends _i8.PageRouteInfo<void> {
  const ChatHistoryRoute({List<_i8.PageRouteInfo>? children})
    : super(ChatHistoryRoute.name, initialChildren: children);

  static const String name = 'ChatHistoryRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i1.ChatHistoryPage();
    },
  );
}

/// generated route for
/// [_i2.IllnessCategoryPage]
class IllnessCategoryRoute extends _i8.PageRouteInfo<void> {
  const IllnessCategoryRoute({List<_i8.PageRouteInfo>? children})
    : super(IllnessCategoryRoute.name, initialChildren: children);

  static const String name = 'IllnessCategoryRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i2.IllnessCategoryPage();
    },
  );
}

/// generated route for
/// [_i3.IllnessTypePage]
class IllnessTypeRoute extends _i8.PageRouteInfo<IllnessTypeRouteArgs> {
  IllnessTypeRoute({
    _i9.Key? key,
    required String categoryTitle,
    List<_i8.PageRouteInfo>? children,
  }) : super(
         IllnessTypeRoute.name,
         args: IllnessTypeRouteArgs(key: key, categoryTitle: categoryTitle),
         rawPathParams: {'categoryTitle': categoryTitle},
         initialChildren: children,
       );

  static const String name = 'IllnessTypeRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<IllnessTypeRouteArgs>(
        orElse: () => IllnessTypeRouteArgs(
          categoryTitle: pathParams.getString('categoryTitle'),
        ),
      );
      return _i3.IllnessTypePage(
        key: args.key,
        categoryTitle: args.categoryTitle,
      );
    },
  );
}

class IllnessTypeRouteArgs {
  const IllnessTypeRouteArgs({this.key, required this.categoryTitle});

  final _i9.Key? key;

  final String categoryTitle;

  @override
  String toString() {
    return 'IllnessTypeRouteArgs{key: $key, categoryTitle: $categoryTitle}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! IllnessTypeRouteArgs) return false;
    return key == other.key && categoryTitle == other.categoryTitle;
  }

  @override
  int get hashCode => key.hashCode ^ categoryTitle.hashCode;
}

/// generated route for
/// [_i4.LoginPage]
class LoginRoute extends _i8.PageRouteInfo<void> {
  const LoginRoute({List<_i8.PageRouteInfo>? children})
    : super(LoginRoute.name, initialChildren: children);

  static const String name = 'LoginRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i4.LoginPage();
    },
  );
}

/// generated route for
/// [_i5.NavbarPage]
class NavbarRoute extends _i8.PageRouteInfo<void> {
  const NavbarRoute({List<_i8.PageRouteInfo>? children})
    : super(NavbarRoute.name, initialChildren: children);

  static const String name = 'NavbarRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i5.NavbarPage();
    },
  );
}

/// generated route for
/// [_i6.ProfilePage]
class ProfileRoute extends _i8.PageRouteInfo<void> {
  const ProfileRoute({List<_i8.PageRouteInfo>? children})
    : super(ProfileRoute.name, initialChildren: children);

  static const String name = 'ProfileRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i6.ProfilePage();
    },
  );
}

/// generated route for
/// [_i7.RegisterPage]
class RegisterRoute extends _i8.PageRouteInfo<void> {
  const RegisterRoute({List<_i8.PageRouteInfo>? children})
    : super(RegisterRoute.name, initialChildren: children);

  static const String name = 'RegisterRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i7.RegisterPage();
    },
  );
}
