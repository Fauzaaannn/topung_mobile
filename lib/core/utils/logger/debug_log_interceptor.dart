import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class DebugLogInterceptor extends Interceptor {
  final Logger _logger = Logger(
    printer: PrettyPrinter(methodCount: 0, colors: true, printEmojis: true),
  );

  final JsonEncoder _encoder = const JsonEncoder.withIndent('  ');

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      _logger.i(
        '\x1B[33m=== REQUEST ===\x1B[0m\n'
        '➡️  [${options.method}] ${options.uri}\n'
        '🔑 Headers: ${_prettyJson(options.headers)}\n'
        '🧾 Body: ${_prettyJson(options.data)}\n'
        '\x1B[33m===============\x1B[0m',
      );
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      _logger.i(
        '\x1B[32m=== RESPONSE ===\x1B[0m\n'
        '✅ [${response.requestOptions.method}] ${response.requestOptions.uri}\n'
        '📦 Status: ${response.statusCode}\n'
        '🧾 Data: ${_prettyJson(response.data)}\n'
        '\x1B[32m================\x1B[0m',
      );
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      _logger.e(
        '\x1B[31m=== ERROR ===\x1B[0m\n'
        '❌ [${err.requestOptions.method}] ${err.requestOptions.uri}\n'
        '🚨 Message: ${err.message}\n'
        '📦 Status: ${err.response?.statusCode}\n'
        '🧾 Data: ${_prettyJson(err.response?.data)}\n'
        '\x1B[31m=============\x1B[0m',
      );
    }
    super.onError(err, handler);
  }

  String _prettyJson(dynamic data) {
    try {
      if (data is String) {
        return _encoder.convert(json.decode(data));
      }
      return _encoder.convert(data);
    } catch (_) {
      return data.toString();
    }
  }
}
