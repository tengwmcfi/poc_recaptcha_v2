import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:poc_recaptcha_v2/sitekey.dart';
import 'package:recaptcha_enterprise_flutter/recaptcha_action.dart';
import 'package:recaptcha_enterprise_flutter/recaptcha_client.dart';

class RecaptchaEnterpriseForm extends StatefulWidget {
  final RecaptchaClient client;
  const RecaptchaEnterpriseForm({super.key, required this.client});

  @override
  State<RecaptchaEnterpriseForm> createState() =>
      _RecaptchaEnterpriseFormState();
}

class _RecaptchaEnterpriseFormState extends State<RecaptchaEnterpriseForm> {
  static const String _projectId = 'pc-api-6165234984838583469-144';
  static const String _apiKey = 'AIzaSyCm0NciAm49H2ikWJCoc1X534GWDdb0D48';
  static const String _verifyUrl =
      'https://recaptchaenterprise.googleapis.com/v1/projects/$_projectId/assessments?key=$_apiKey';

  Future<void> _submit() async {
    try {
      final String token = await widget.client
          .execute(RecaptchaAction.custom('recaptcha_action'));
      log('reCAPTCHA token: $token');

      // backend verification of the reCAPTCHA token
      final response = await http.post(Uri.parse(_verifyUrl),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'event': {
              'token': token,
              'siteKey': sitekey,
              'expectedAction': 'tes_action',
            }
          }));

      if (response.statusCode == 200) {
        final data = response.body;
        log(data);

        final isValid = data.contains('"valid": true');
        if (isValid) {
          log('Token verified and data submitted successfully');
          _showSnackbar('Data submitted successfully');
        } else {
          log('Token is invalid');
          _showSnackbar('Token is invalid');
        }
      } else {
        log('Token verification failed: ${response.body}');
      }
    } catch (err) {
      log('reCAPTCHA execution error: $err');
      _showSnackbar('reCAPTCHA execution error');
    }
  }

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
                  onPressed: _submit,
                  child: const Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
