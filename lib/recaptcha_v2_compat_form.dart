import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_recaptcha_v2_compat/flutter_recaptcha_v2_compat.dart';

class RecaptchaV2CompatForm extends StatefulWidget {
  const RecaptchaV2CompatForm({super.key});

  @override
  State<RecaptchaV2CompatForm> createState() => _RecaptchaV2CompatFormState();
}

class _RecaptchaV2CompatFormState extends State<RecaptchaV2CompatForm> {
  static const String _siteKey = '6LesrGQrAAAAAI0Ci_d-YE7cYaVlGzMZ6L2JEGIi';
  static const String _secretKey = '6LesrGQrAAAAADMCVBtNjDSQzVYSUVeNmkpgiqvB';
  static const String _recaptchaUrl =
      'https://recaptcha-flutter-plugin.firebaseapp.com';

  final _recaptchaController = RecaptchaV2Controller();

  bool _canSubmit = false;

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  apiSecret: _secretKey,
                  pluginURL: _recaptchaUrl,
                  controller: _recaptchaController,
                  onVerifiedError: (err) {
                    log('Error verifying token: $err');
                    _showSnackbar('Verification error: $err');
                  },
                  onVerifiedSuccessfully: (success) {
                    log('Token verified successfully');
                    if (success) {
                      setState(() {
                        _canSubmit = true;
                      });
                    }
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
