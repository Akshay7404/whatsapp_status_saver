// ignore_for_file: prefer_const_constructors

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:whats_app_saver/firebase_options.dart';
import 'package:whats_app_saver/splash_screen.dart';
import 'package:whats_app_saver/youtube/models/notification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(
     MyApp(),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: ThemeData(
        brightness: Brightness.light,
        appBarTheme: AppBarTheme(foregroundColor: Colors.black),
        accentColor: Color(0xFFFF0A6C),
      ),
      dark: ThemeData(
        brightness: Brightness.dark,
        appBarTheme: AppBarTheme(foregroundColor: Colors.white),
        accentColor: Colors.white,
      ),
      initial: AdaptiveThemeMode.light,
      builder: (theme, darkTheme) => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Status Saver',
        theme: theme,
        darkTheme: darkTheme,
        home: DefaultTabController(length: 2, child: SplashScreen()),
      ),
    );
  }
}
