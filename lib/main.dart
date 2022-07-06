import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mipromo/app/app.locator.dart';
import 'package:mipromo/app/app.router.dart';
import 'package:mipromo/ui/shared/helpers/setup_dialog_ui.dart';
import 'package:mipromo/ui/shared/helpers/setup_snackbar_ui.dart';
import 'package:mipromo/ui/shared/helpers/styles.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:stacked_themes/stacked_themes.dart';
import 'package:webview_flutter/webview_flutter.dart';

Future<void> main() async {
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(systemNavigationBarColor: Color(4281348144)));
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  if (Platform.isIOS) FirebaseMessaging.instance.requestPermission();
  await ThemeManager.initialise();
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
      defaultThemeMode: ThemeMode.dark,
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
