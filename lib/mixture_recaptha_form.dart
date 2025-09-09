import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:poc_recaptcha_v2/recaptcha_service.dart';

class MixtureRecaptchaForm extends StatefulWidget {

  const MixtureRecaptchaForm({super.key});

  @override
  State<MixtureRecaptchaForm> createState() => _MixtureRecaptchaFormState();
}

class _MixtureRecaptchaFormState extends State<MixtureRecaptchaForm> {
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
              ElevatedButton(
                onPressed: () async {
                  var token = await RecaptchaService().verifyRecaptcha(context);

                  log('Received token: $token');
                },
                child: const Text('Submit'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
