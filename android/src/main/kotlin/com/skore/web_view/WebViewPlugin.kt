package com.skore.web_view

import io.flutter.embedding.engine.plugins.FlutterPlugin

class WebViewPlugin :FlutterPlugin {

  override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    binding.platformViewRegistry.registerViewFactory(
      "plugins.skore/flutter_web_view", WebViewFactory(binding.binaryMessenger))
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
  }
}
