import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wcenzije/screens/home.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:wcenzije/screens/intro.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  await dotenv.load();
  HttpOverrides.global = MyHttpOverrides();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColorDark: Colors.blue[700],
        useMaterial3: false,
      ),
      title: 'Wcenzije',
      home: FutureBuilder<bool>(
        future: introCompleted(),
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ((snapshot.data ?? false) ? HomeScreen() : const IntroScreen())
              : const CircularProgressIndicator();
        },
      ),
    );
  }

  Future<bool> introCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('intro_completed') ?? false;
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
