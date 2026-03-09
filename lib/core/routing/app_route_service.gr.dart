// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i9;
import 'package:flutter/material.dart' as _i10;
import 'package:topung_mobile/presentation/pages/auth_pages/login_page.dart'
    as _i5;
import 'package:topung_mobile/presentation/pages/auth_pages/profile_page.dart'
    as _i7;
import 'package:topung_mobile/presentation/pages/auth_pages/register_page.dart'
    as _i8;
import 'package:topung_mobile/presentation/pages/chatbot_pages/chat_history_page.dart'
    as _i1;
import 'package:topung_mobile/presentation/pages/illness_pages/illness_category_page.dart'
    as _i2;
import 'package:topung_mobile/presentation/pages/illness_pages/illness_material_page.dart'
    as _i3;
import 'package:topung_mobile/presentation/pages/illness_pages/illness_type_page.dart'
    as _i4;
import 'package:topung_mobile/presentation/pages/navbar/navbar_page.dart'
    as _i6;

/// generated route for
/// [_i1.ChatHistoryPage]
class ChatHistoryRoute extends _i9.PageRouteInfo<void> {
  const ChatHistoryRoute({List<_i9.PageRouteInfo>? children})
    : super(ChatHistoryRoute.name, initialChildren: children);

  static const String name = 'ChatHistoryRoute';

  static _i9.PageInfo page = _i9.PageInfo(
    name,
    builder: (data) {
      return const _i1.ChatHistoryPage();
    },
  );
}

/// generated route for
/// [_i2.IllnessCategoryPage]
class IllnessCategoryRoute extends _i9.PageRouteInfo<void> {
  const IllnessCategoryRoute({List<_i9.PageRouteInfo>? children})
    : super(IllnessCategoryRoute.name, initialChildren: children);

  static const String name = 'IllnessCategoryRoute';

  static _i9.PageInfo page = _i9.PageInfo(
    name,
    builder: (data) {
      return const _i2.IllnessCategoryPage();
    },
  );
}

/// generated route for
/// [_i3.IllnessMaterialPage]
class IllnessMaterialRoute extends _i9.PageRouteInfo<IllnessMaterialRouteArgs> {
  IllnessMaterialRoute({
    _i10.Key? key,
    required String illnessName,
    required String materialTitle,
    String? youtubeUrl,
    String? imageUrl,
    required String content,
    List<_i9.PageRouteInfo>? children,
  }) : super(
         IllnessMaterialRoute.name,
         args: IllnessMaterialRouteArgs(
           key: key,
           illnessName: illnessName,
           materialTitle: materialTitle,
           youtubeUrl: youtubeUrl,
           imageUrl: imageUrl,
           content: content,
         ),
         initialChildren: children,
       );

  static const String name = 'IllnessMaterialRoute';

  static _i9.PageInfo page = _i9.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<IllnessMaterialRouteArgs>();
      return _i3.IllnessMaterialPage(
        key: args.key,
        illnessName: args.illnessName,
        materialTitle: args.materialTitle,
        youtubeUrl: args.youtubeUrl,
        imageUrl: args.imageUrl,
        content: args.content,
      );
    },
  );
}

class IllnessMaterialRouteArgs {
  const IllnessMaterialRouteArgs({
    this.key,
    required this.illnessName,
    required this.materialTitle,
    this.youtubeUrl,
    this.imageUrl,
    required this.content,
  });

  final _i10.Key? key;

  final String illnessName;

  final String materialTitle;

  final String? youtubeUrl;

  final String? imageUrl;

  final String content;

  @override
  String toString() {
    return 'IllnessMaterialRouteArgs{key: $key, illnessName: $illnessName, materialTitle: $materialTitle, youtubeUrl: $youtubeUrl, imageUrl: $imageUrl, content: $content}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! IllnessMaterialRouteArgs) return false;
    return key == other.key &&
        illnessName == other.illnessName &&
        materialTitle == other.materialTitle &&
        youtubeUrl == other.youtubeUrl &&
        imageUrl == other.imageUrl &&
        content == other.content;
  }

  @override
  int get hashCode =>
      key.hashCode ^
      illnessName.hashCode ^
      materialTitle.hashCode ^
      youtubeUrl.hashCode ^
      imageUrl.hashCode ^
      content.hashCode;
}

/// generated route for
/// [_i4.IllnessTypePage]
class IllnessTypeRoute extends _i9.PageRouteInfo<IllnessTypeRouteArgs> {
  IllnessTypeRoute({
    _i10.Key? key,
    required String categoryTitle,
    List<_i9.PageRouteInfo>? children,
  }) : super(
         IllnessTypeRoute.name,
         args: IllnessTypeRouteArgs(key: key, categoryTitle: categoryTitle),
         rawPathParams: {'categoryTitle': categoryTitle},
         initialChildren: children,
       );

  static const String name = 'IllnessTypeRoute';

  static _i9.PageInfo page = _i9.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<IllnessTypeRouteArgs>(
        orElse: () => IllnessTypeRouteArgs(
          categoryTitle: pathParams.getString('categoryTitle'),
        ),
      );
      return _i4.IllnessTypePage(
        key: args.key,
        categoryTitle: args.categoryTitle,
      );
    },
  );
}

class IllnessTypeRouteArgs {
  const IllnessTypeRouteArgs({this.key, required this.categoryTitle});

  final _i10.Key? key;

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
/// [_i5.LoginPage]
class LoginRoute extends _i9.PageRouteInfo<void> {
  const LoginRoute({List<_i9.PageRouteInfo>? children})
    : super(LoginRoute.name, initialChildren: children);

  static const String name = 'LoginRoute';

  static _i9.PageInfo page = _i9.PageInfo(
    name,
    builder: (data) {
      return const _i5.LoginPage();
    },
  );
}

/// generated route for
/// [_i6.NavbarPage]
class NavbarRoute extends _i9.PageRouteInfo<void> {
  const NavbarRoute({List<_i9.PageRouteInfo>? children})
    : super(NavbarRoute.name, initialChildren: children);

  static const String name = 'NavbarRoute';

  static _i9.PageInfo page = _i9.PageInfo(
    name,
    builder: (data) {
      return const _i6.NavbarPage();
    },
  );
}

/// generated route for
/// [_i7.ProfilePage]
class ProfileRoute extends _i9.PageRouteInfo<void> {
  const ProfileRoute({List<_i9.PageRouteInfo>? children})
    : super(ProfileRoute.name, initialChildren: children);

  static const String name = 'ProfileRoute';

  static _i9.PageInfo page = _i9.PageInfo(
    name,
    builder: (data) {
      return const _i7.ProfilePage();
    },
  );
}

/// generated route for
/// [_i8.RegisterPage]
class RegisterRoute extends _i9.PageRouteInfo<void> {
  const RegisterRoute({List<_i9.PageRouteInfo>? children})
    : super(RegisterRoute.name, initialChildren: children);

  static const String name = 'RegisterRoute';

  static _i9.PageInfo page = _i9.PageInfo(
    name,
    builder: (data) {
      return const _i8.RegisterPage();
    },
  );
}
