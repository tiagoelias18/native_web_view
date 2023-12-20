import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:web_view/controller/ios_native_web_view_controller.dart';
import 'package:web_view/ui/loading_web_view.dart';

class IosNativeWebView extends StatefulWidget {
  final String initialUrl;
  final Widget? loadingPage;
  final String? evaluateJavascript;

  const IosNativeWebView({
    Key? key,
    required this.initialUrl,
    this.loadingPage,
    this.evaluateJavascript,
  }) : super(key: key);

  @override
  State<IosNativeWebView> createState() => _IosNativeWebViewState();
}

class _IosNativeWebViewState extends State<IosNativeWebView> {
  late IosNativeWebViewController _controller;

  @override
  void initState() {
    _controller = IosNativeWebViewController(widget.initialUrl);
    _controller.channel.setMethodCallHandler(_handleMethodCall);
    super.initState();
  }

  Future<dynamic> _handleMethodCall(MethodCall call) async {
    await _controller.handleMethodCall(call,
        javascriptCode: widget.evaluateJavascript);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        UiKitView(
          viewType: 'web_view',
          onPlatformViewCreated: _controller.onPlatformViewCreated,
        ),
        LoadingWebview(
          stream: _controller.outLoadingWebview,
          loadingPage: widget.loadingPage,
        ),
      ],
    );
  }
}
