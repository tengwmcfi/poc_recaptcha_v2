# poc_recaptcha_v2

This project demonstrates multiple ways to integrate **Google reCAPTCHA v2** in a Flutter application, including:

- Package-based integrations
  - `flutter_easy_recaptcha_v2`
  - `flutter_recaptcha_v2_compat`
  - `recaptcha_enterprise_flutter` (v3-style, included for comparison)
- A custom WebView-based implementation using `webview_flutter`

## 🚀 Getting Started

### 1. Install Dependencies

```bash
flutter pub get
```

⚠️ flutter_easy_recaptcha_v2 requires Dart SDK ≥3.6.1, which is only available in Flutter ≥3.27.2.

### 2. Choose Your Integration Approach

Open lib/main.dart and update the home: widget to switch between demo methods:

```dart
// For Custom WebView integration:
home: const CustomRecaptchaForm();

// To test reCAPTCHA Enterprise SDK:
// home: RecaptchaEnterpriseForm(client: client);

// To test flutter_recaptcha_v2_compat:
// home: const RecaptchaV2CompatForm();

// To test flutter_easy_recaptcha_v2:
// home: const EasyRecaptchaV2Form();
```

⚠️ Only uncomment one demo at a time.

### 3. Run the App

```bash
flutter run
```

Supported on Android and iOS
