import 'package:flutter/material.dart';
import 'package:wcenzije/screens/home.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      title: 'Wcenzije',
      home: const HomeScreen(),
    );
  }
}
