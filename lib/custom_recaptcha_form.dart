import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';

class CustomRecaptchaForm extends StatefulWidget {
  const CustomRecaptchaForm({super.key});

  @override
  State<CustomRecaptchaForm> createState() => _CustomRecaptchaFormState();
}

class _CustomRecaptchaFormState extends State<CustomRecaptchaForm> {
  static const String _siteKey = '6LesrGQrAAAAAI0Ci_d-YE7cYaVlGzMZ6L2JEGIi';
  static const String _secretKey = '6LesrGQrAAAAADMCVBtNjDSQzVYSUVeNmkpgiqvB';
  static const String _recaptchaUrl =
      'https://cfi-recaptcha-v2.netlify.app?sitekey=$_siteKey';
  static const String _verifyUrl =
      'https://www.google.com/recaptcha/api/siteverify';

  bool _canSubmit = false;

  late final WebViewController _webViewController;

  @override
  void initState() {
    super.initState();
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..addJavaScriptChannel(
        'RecaptchaHandler',
        onMessageReceived: (message) {
          log('Received token from webview: ${message.message}');
          final token = message.message;
          _validateToken(token);
        },
      )
      ..loadRequest(Uri.parse(_recaptchaUrl));
  }

  // backend verification of the reCAPTCHA token
  Future<void> _validateToken(String token) async {
    log('Validating token');
    try {
      final response = await http.post(Uri.parse(_verifyUrl), body: {
        'secret': _secretKey,
        'response': token,
      });

      if (response.statusCode == 200 &&
          response.body.contains('"success": true')) {
        setState(() {
          log('Token verified successfully');
          _canSubmit = true;
        });
      } else {
        log('Token verification failed: ${response.body}');
        _showSnackbar('Verification failed: ${response.body}');
      }
    } catch (e) {
      log('Error verifying token: $e');
      _showSnackbar('Error verifying token: $e');
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: _canSubmit
                      ? () => _showSnackbar('Data submitted successfully')
                      : null,
                  child: const Text('Submit'),
                ),
              ),
              Expanded(
                child: WebViewWidget(
                  controller: _webViewController,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
