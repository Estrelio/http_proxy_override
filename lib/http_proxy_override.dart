import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

const MethodChannel _channel = MethodChannel(
  'com.littlegnal.http_proxy_override',
);

Future<String?> _getProxyHost() =>
    _channel.invokeMethod<String>('getProxyHost');

Future<String?> _getProxyPort() =>
    _channel.invokeMethod<String>('getProxyPort');

class HttpProxyOverride extends HttpOverrides {
  HttpProxyOverride._(this.host, this.port);

  late final String? host;
  late final String? port;

  static Future<HttpProxyOverride> createHttpProxy() async {
    return HttpProxyOverride._(await _getProxyHost(), await _getProxyPort());
  }

  @override
  HttpClient createHttpClient(SecurityContext? context) {
    final HttpClient client = super.createHttpClient(context);
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) {
          return true;
        };
    return client;
  }

  @override
  String findProxyFromEnvironment(Uri url, Map<String, String>? environment) {
    if (host == null) {
      return super.findProxyFromEnvironment(url, environment);
    }

    final Map<String, String> proxyEnvironment = environment == null
        ? <String, String>{}
        : Map<String, String>.of(environment);

    final String proxy = '$host:${port ?? 8888}';
    proxyEnvironment['http_proxy'] = proxy;
    proxyEnvironment['https_proxy'] = proxy;

    return super.findProxyFromEnvironment(url, proxyEnvironment);
  }
}
