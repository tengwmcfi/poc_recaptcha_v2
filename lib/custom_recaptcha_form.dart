import 'dart:convert';

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
  static const String _recaptchaUrl = 'https://cfi-recaptcha-v2.netlify.app';
  static const String _verifyUrl =
      'https://www.google.com/recaptcha/api/siteverify';

  final _log = ValueNotifier<String>('');

  bool _canSubmit = false;

  late final WebViewController _webViewController;

  @override
  void initState() {
    super.initState();
    _addLog('Load recaptcha in Webview:\nURL: $_recaptchaUrl');
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..addJavaScriptChannel(
        'RecaptchaHandler',
        onMessageReceived: (message) {
          final token = message.message;
          _addLog('Captured token: ${token.substring(0, 5)}... from Webview');
          _validateToken(token);
        },
      )
      ..loadRequest(Uri.parse(_recaptchaUrl + '?sitekey=$_siteKey'));
  }

  // backend verification of the reCAPTCHA token
  Future<void> _validateToken(String token) async {
    _addLog('Validate token in: $_verifyUrl');
    try {
      final response = await http.post(Uri.parse(_verifyUrl), body: {
        'secret': _secretKey,
        'response': token,
      });

      if (response.statusCode == 200 &&
          response.body.contains('"success": true')) {
        setState(() {
          _addLog('Result: ${response.body}');
          _addLog('Token is verified by Google');
          final data = jsonDecode(response.body) as Map<String, dynamic>;
          _addLog('Checking hostname: ${data["hostname"]}');

          if (_recaptchaUrl.contains(data['hostname'])) {
            _addLog('Token hostname verified. Enable Submit button');
            _canSubmit = true;
          } else {
            _addLog('Token verification failed: Invalid hostname');
          }
        });
      } else {
        _addLog('Token verification failed: ${response.body}');
      }
    } catch (e) {
      _addLog('Error verifying token: $e');
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void _addLog(String log) {
    _log.value = _log.value.isEmpty ? '- $log' : '${_log.value}\n- $log';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Recaptcha Form'),
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Center(
                  child: ElevatedButton(
                    onPressed: _canSubmit
                        ? () => _showSnackbar('Data submitted successfully')
                        : null,
                    child: const Text('Submit'),
                  ),
                ),
              ),
              ValueListenableBuilder(
                valueListenable: _log,
                builder: (context, log, _) {
                  return Text(
                    log,
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.visible,
                  );
                },
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
