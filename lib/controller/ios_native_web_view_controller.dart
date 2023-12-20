import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class IosNativeWebViewController extends ChangeNotifier {
  final MethodChannel channel = const MethodChannel('web_view_channel');
  final _loadingWebview = StreamController<bool>();
  final String initialUrl;

  IosNativeWebViewController(this.initialUrl);

  Stream<bool> get outLoadingWebview => _loadingWebview.stream;

  void onPlatformViewCreated(int id) {
    _setUrl(url: initialUrl);
  }

  Future<void> _setUrl({required String url}) async {
    return await channel.invokeMethod('setUrl', url);
  }

  Future<dynamic> handleMethodCall(MethodCall call, {String? javascriptCode}) async {
    switch (call.method) {
      case 'onPageFinished':
        await _evaluateJavascript(
          javascriptCode: javascriptCode ?? '',
        );
        _loadingWebview.sink.add(false);
        break;
      default:
        debugPrint("Method not implemented: ${call.method}");
    }
  }

  Future<void> _evaluateJavascript({required String javascriptCode}) async {
    return await channel.invokeMethod('evaluateJavascript', javascriptCode);
  }

  @override
  void dispose() {
    _loadingWebview.close();
    super.dispose();
  }
}