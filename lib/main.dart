import 'package:flutter/material.dart';
import 'package:poc_recaptcha_v2/mixture_recaptha_form.dart';
import 'package:poc_recaptcha_v2/sitekey.dart';
import 'package:recaptcha_enterprise_flutter/recaptcha.dart';
import 'package:recaptcha_enterprise_flutter/recaptcha_client.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  RecaptchaClient client = await Recaptcha.fetchClient(sitekey);
  runApp(MyApp(client: client));
}

class MyApp extends StatelessWidget {
  final RecaptchaClient client;
  const MyApp({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      // To test specific packages, uncomment the desired home widget below.
      // home: const CustomRecaptchaForm(),
      // home: RecaptchaEnterpriseForm(client: client),
      // home: const RecaptchaV2CompatForm(),
      // home: const EasyRecaptchaV2Form(),
      home: const MixtureRecaptchaForm(),
    );
  }
}
