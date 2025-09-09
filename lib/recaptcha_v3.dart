import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class RecaptchaV3Service {
  final String siteKey;

  RecaptchaV3Service({required this.siteKey});

  /// Returns a reCAPTCHA v3 token
  Future<String> getToken(String action, BuildContext context) async {
    final Completer<String> completer = Completer<String>();

    final htmlContent = '''
<!DOCTYPE html>
<html>
  <head>
    <script src="https://www.google.com/recaptcha/api.js?render=$siteKey"></script>
    <script>
      function getRecaptchaToken() {
        grecaptcha.ready(function() {
          grecaptcha.execute('$siteKey', {action: '$action'}).then(function(token) {
            Recaptcha.postMessage(token);
          });
        });
      }
      window.onload = getRecaptchaToken;
    </script>
  </head>
  <body></body>
</html>
''';

    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..addJavaScriptChannel(
        'Recaptcha',
        onMessageReceived: (message) {
          if (!completer.isCompleted) {
            completer.complete(message.message);
          }
        },
      )
      ..setOnConsoleMessage(
          (message) => debugPrint('WebView console: ${message.message}'))
      ..loadHtmlString(htmlContent);

    final webview = WebViewWidget(
      controller: controller,
    );

    // Run the WebView offstage so it is not visible
    final app = OverlayEntry(builder: (_) => Offstage(child: webview));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Overlay.of(context).insert(app);
    });

    // Wait for token
    final token = await completer.future;

    // Remove WebView
    app.remove();

    return token;
  }
}
