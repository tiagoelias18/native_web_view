import Foundation
import Flutter
import WebKit
 
class FlutterWebView: NSObject, FlutterPlatformView, WKNavigationDelegate {
    private var _nativeWebView: WKWebView
    private var _methodChannel: FlutterMethodChannel
 
    func view() -> UIView {
        return _nativeWebView
    }
 
    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        binaryMessenger messenger: FlutterBinaryMessenger
    ) {
        let config = WKWebViewConfiguration()
        _nativeWebView = WKWebView(frame: frame, configuration: config)
        _methodChannel = FlutterMethodChannel(name: "web_view_channel", binaryMessenger: messenger)
 
        super.init()
        _nativeWebView.navigationDelegate = self
        _methodChannel.setMethodCallHandler(onMethodCall)
    }
 
    func onMethodCall(call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "setUrl":
            setUrl(call: call, result: result)
        case "evaluateJavascript":
            evaluateJavascript(call: call, result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
 
    func setUrl(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let urlString = call.arguments as? String, let url = URL(string: urlString) else {
            result(FlutterError(code: "INVALID_URL", message: "Invalid URL", details: nil))
            return
        }
 
        let request = URLRequest(url: url)
        _nativeWebView.load(request)
    }
 
    func evaluateJavascript(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let script = call.arguments as? String else {
            result(FlutterError(code: "INVALID_SCRIPT", message: "Invalid JavaScript script", details: nil))
            return
        }
 
        _nativeWebView.evaluateJavaScript(script) { _, error in
            if let error = error {
                result(FlutterError(code: "JAVASCRIPT_ERROR", message: "JavaScript injection failed", details: error.localizedDescription))
            } else {
                result(nil)
            }
        }
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        _methodChannel.invokeMethod("onPageFinished", arguments: nil)
    }
}