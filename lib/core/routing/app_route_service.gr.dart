// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i12;
import 'package:flutter/material.dart' as _i13;
import 'package:topung_mobile/presentation/pages/auth_pages/login_page.dart'
    as _i6;
import 'package:topung_mobile/presentation/pages/auth_pages/profile_page.dart'
    as _i8;
import 'package:topung_mobile/presentation/pages/auth_pages/register_page.dart'
    as _i9;
import 'package:topung_mobile/presentation/pages/chatbot_pages/chat_history_page.dart'
    as _i1;
import 'package:topung_mobile/presentation/pages/chatbot_pages/chat_page.dart'
    as _i2;
import 'package:topung_mobile/presentation/pages/error_pages/server_error_page.dart'
    as _i10;
import 'package:topung_mobile/presentation/pages/illness_pages/illness_category_page.dart'
    as _i3;
import 'package:topung_mobile/presentation/pages/illness_pages/illness_material_page.dart'
    as _i4;
import 'package:topung_mobile/presentation/pages/illness_pages/illness_type_page.dart'
    as _i5;
import 'package:topung_mobile/presentation/pages/navbar/navbar_page.dart'
    as _i7;
import 'package:topung_mobile/presentation/pages/splash_screen/splash_page.dart'
    as _i11;

/// generated route for
/// [_i1.ChatHistoryPage]
class ChatHistoryRoute extends _i12.PageRouteInfo<void> {
  const ChatHistoryRoute({List<_i12.PageRouteInfo>? children})
    : super(ChatHistoryRoute.name, initialChildren: children);

  static const String name = 'ChatHistoryRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return const _i1.ChatHistoryPage();
    },
  );
}

/// generated route for
/// [_i2.ChatPage]
class ChatRoute extends _i12.PageRouteInfo<ChatRouteArgs> {
  ChatRoute({_i13.Key? key, String? chatId, List<_i12.PageRouteInfo>? children})
    : super(
        ChatRoute.name,
        args: ChatRouteArgs(key: key, chatId: chatId),
        initialChildren: children,
      );

  static const String name = 'ChatRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ChatRouteArgs>(
        orElse: () => const ChatRouteArgs(),
      );
      return _i2.ChatPage(key: args.key, chatId: args.chatId);
    },
  );
}

class ChatRouteArgs {
  const ChatRouteArgs({this.key, this.chatId});

  final _i13.Key? key;

  final String? chatId;

  @override
  String toString() {
    return 'ChatRouteArgs{key: $key, chatId: $chatId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ChatRouteArgs) return false;
    return key == other.key && chatId == other.chatId;
  }

  @override
  int get hashCode => key.hashCode ^ chatId.hashCode;
}

/// generated route for
/// [_i3.IllnessCategoryPage]
class IllnessCategoryRoute extends _i12.PageRouteInfo<void> {
  const IllnessCategoryRoute({List<_i12.PageRouteInfo>? children})
    : super(IllnessCategoryRoute.name, initialChildren: children);

  static const String name = 'IllnessCategoryRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return const _i3.IllnessCategoryPage();
    },
  );
}

/// generated route for
/// [_i4.IllnessMaterialPage]
class IllnessMaterialRoute
    extends _i12.PageRouteInfo<IllnessMaterialRouteArgs> {
  IllnessMaterialRoute({
    _i13.Key? key,
    required String materialId,
    List<_i12.PageRouteInfo>? children,
  }) : super(
         IllnessMaterialRoute.name,
         args: IllnessMaterialRouteArgs(key: key, materialId: materialId),
         initialChildren: children,
       );

  static const String name = 'IllnessMaterialRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<IllnessMaterialRouteArgs>();
      return _i4.IllnessMaterialPage(
        key: args.key,
        materialId: args.materialId,
      );
    },
  );
}

class IllnessMaterialRouteArgs {
  const IllnessMaterialRouteArgs({this.key, required this.materialId});

  final _i13.Key? key;

  final String materialId;

  @override
  String toString() {
    return 'IllnessMaterialRouteArgs{key: $key, materialId: $materialId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! IllnessMaterialRouteArgs) return false;
    return key == other.key && materialId == other.materialId;
  }

  @override
  int get hashCode => key.hashCode ^ materialId.hashCode;
}

/// generated route for
/// [_i5.IllnessTypePage]
class IllnessTypeRoute extends _i12.PageRouteInfo<IllnessTypeRouteArgs> {
  IllnessTypeRoute({
    _i13.Key? key,
    required String categoryId,
    required String categoryTitle,
    List<_i12.PageRouteInfo>? children,
  }) : super(
         IllnessTypeRoute.name,
         args: IllnessTypeRouteArgs(
           key: key,
           categoryId: categoryId,
           categoryTitle: categoryTitle,
         ),
         initialChildren: children,
       );

  static const String name = 'IllnessTypeRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<IllnessTypeRouteArgs>();
      return _i5.IllnessTypePage(
        key: args.key,
        categoryId: args.categoryId,
        categoryTitle: args.categoryTitle,
      );
    },
  );
}

class IllnessTypeRouteArgs {
  const IllnessTypeRouteArgs({
    this.key,
    required this.categoryId,
    required this.categoryTitle,
  });

  final _i13.Key? key;

  final String categoryId;

  final String categoryTitle;

  @override
  String toString() {
    return 'IllnessTypeRouteArgs{key: $key, categoryId: $categoryId, categoryTitle: $categoryTitle}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! IllnessTypeRouteArgs) return false;
    return key == other.key &&
        categoryId == other.categoryId &&
        categoryTitle == other.categoryTitle;
  }

  @override
  int get hashCode =>
      key.hashCode ^ categoryId.hashCode ^ categoryTitle.hashCode;
}

/// generated route for
/// [_i6.LoginPage]
class LoginRoute extends _i12.PageRouteInfo<void> {
  const LoginRoute({List<_i12.PageRouteInfo>? children})
    : super(LoginRoute.name, initialChildren: children);

  static const String name = 'LoginRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return const _i6.LoginPage();
    },
  );
}

/// generated route for
/// [_i7.NavbarPage]
class NavbarRoute extends _i12.PageRouteInfo<void> {
  const NavbarRoute({List<_i12.PageRouteInfo>? children})
    : super(NavbarRoute.name, initialChildren: children);

  static const String name = 'NavbarRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return const _i7.NavbarPage();
    },
  );
}

/// generated route for
/// [_i8.ProfilePage]
class ProfileRoute extends _i12.PageRouteInfo<void> {
  const ProfileRoute({List<_i12.PageRouteInfo>? children})
    : super(ProfileRoute.name, initialChildren: children);

  static const String name = 'ProfileRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return const _i8.ProfilePage();
    },
  );
}

/// generated route for
/// [_i9.RegisterPage]
class RegisterRoute extends _i12.PageRouteInfo<void> {
  const RegisterRoute({List<_i12.PageRouteInfo>? children})
    : super(RegisterRoute.name, initialChildren: children);

  static const String name = 'RegisterRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return const _i9.RegisterPage();
    },
  );
}

/// generated route for
/// [_i10.ServerErrorPage]
class ServerErrorRoute extends _i12.PageRouteInfo<void> {
  const ServerErrorRoute({List<_i12.PageRouteInfo>? children})
    : super(ServerErrorRoute.name, initialChildren: children);

  static const String name = 'ServerErrorRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return const _i10.ServerErrorPage();
    },
  );
}

/// generated route for
/// [_i11.SplashPage]
class SplashRoute extends _i12.PageRouteInfo<SplashRouteArgs> {
  SplashRoute({
    _i13.Key? key,
    bool fromLogin = false,
    List<_i12.PageRouteInfo>? children,
  }) : super(
         SplashRoute.name,
         args: SplashRouteArgs(key: key, fromLogin: fromLogin),
         initialChildren: children,
       );

  static const String name = 'SplashRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SplashRouteArgs>(
        orElse: () => const SplashRouteArgs(),
      );
      return _i11.SplashPage(key: args.key, fromLogin: args.fromLogin);
    },
  );
}

class SplashRouteArgs {
  const SplashRouteArgs({this.key, this.fromLogin = false});

  final _i13.Key? key;

  final bool fromLogin;

  @override
  String toString() {
    return 'SplashRouteArgs{key: $key, fromLogin: $fromLogin}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! SplashRouteArgs) return false;
    return key == other.key && fromLogin == other.fromLogin;
  }

  @override
  int get hashCode => key.hashCode ^ fromLogin.hashCode;
}
