import Flutter
import UIKit

public class SwiftWebViewPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        registrar.register(WebViewFactory(messenger: registrar.messenger()), withId: "web_view")
       }
}
