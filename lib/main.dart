import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mipromo/app/app.locator.dart';
import 'package:mipromo/app/app.router.dart';
import 'package:mipromo/services/dynamic_link_service.dart';
import 'package:mipromo/ui/shared/helpers/setup_dialog_ui.dart';
import 'package:mipromo/ui/shared/helpers/setup_snackbar_ui.dart';
import 'package:mipromo/ui/shared/helpers/styles.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:stacked_themes/stacked_themes.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = 'pk_live_51LMrcMIyrTaw9Whhb82s3YTv3fCWgMPHouoyCdXLExGXWiq4ZBRXwohHB2rditj4g0dCSNzvMWnGskoPZSik7x2X00gB5zucjU';
  // Stripe.publishableKey = 'pk_test_51LMrcMIyrTaw9Whhb9fdxxVov1uVO5lgPazvNNeS1ndVRufahTSI9j44airu6YbJ78dtGCH1zwAndIzbGwxb1Qyg00GkXCkDI7';
  Stripe.merchantIdentifier = 'merchant.flutter.stripe';
  Stripe.urlScheme = 'flutterstripe';
  await Stripe.instance.applySettings();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(systemNavigationBarColor: Color(4281348144)));
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  if (Platform.isIOS) FirebaseMessaging.instance.requestPermission();
  await ThemeManager.initialise();
  if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  // App Orientation fixed as Portrait
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  setupLocator();
  setupDialogUi();
  setupSnackbarUI();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ThemeBuilder(
      lightTheme: Styles.lightTheme,
      darkTheme: Styles.darkTheme,
      defaultThemeMode: ThemeMode.light,
      builder: (context, lightTheme, darkTheme, themeMode) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: themeMode,
        navigatorKey: StackedService.navigatorKey,
        onGenerateRoute: StackedRouter().onGenerateRoute,
      ),
    );
  }
}
