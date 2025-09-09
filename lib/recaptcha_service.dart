import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_easy_recaptcha_v2/flutter_easy_recaptcha_v2.dart';
import 'package:poc_recaptcha_v2/recaptcha_v3.dart';

class RecaptchaService {

  Future<String> verifyRecaptcha(BuildContext context) async {
    try {
      // throw('Force fallback to reCAPTCHA v2');
      return await RecaptchaV3Service(siteKey: '6LfsYRIrAAAAAOKyyf4aqtBtwmVO7sICO8fcSJQI').getToken('login', context);
    } catch (e) {
      log('Error executing reCAPTCHA v3: $e');
      return (await _recaptchaV2Fallback(context)) ?? '';
    }
  }

  Future<String?> _recaptchaV2Fallback(BuildContext context) {
    return showDialog<String>(
      useRootNavigator: false,
      context: context,
      builder: (context) => FractionallySizedBox(
        heightFactor: 0.8,
        child: RecaptchaV2(
          apiKey: '6LckO5srAAAAAKQwwTHKG0_eZZw7IO_qaW-SkZrU',
          onVerifiedSuccessfully: (token) async {
            Navigator.pop(context, token);
          },
        ),
      ),
    );
  }
}
