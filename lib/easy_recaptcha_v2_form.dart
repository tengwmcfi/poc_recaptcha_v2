import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_easy_recaptcha_v2/flutter_easy_recaptcha_v2.dart';
import 'package:http/http.dart' as http;

class EasyRecaptchaV2Form extends StatefulWidget {
  const EasyRecaptchaV2Form({super.key});

  @override
  State<EasyRecaptchaV2Form> createState() => _EasyRecaptchaV2FormState();
}

class _EasyRecaptchaV2FormState extends State<EasyRecaptchaV2Form> {
  static const String _siteKey = '6LesrGQrAAAAAI0Ci_d-YE7cYaVlGzMZ6L2JEGIi';
  static const String _secretKey = '6LesrGQrAAAAADMCVBtNjDSQzVYSUVeNmkpgiqvB';
  static const String _verifyUrl =
      'https://www.google.com/recaptcha/api/siteverify';

  bool _canSubmit = false;

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
                child: RecaptchaV2(
                  apiKey: _siteKey,
                  onVerifiedSuccessfully: (token) async {
                    log('Token received: $token');
                    _validateToken(token);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
