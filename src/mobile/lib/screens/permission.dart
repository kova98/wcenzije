import 'package:flutter/material.dart';
import 'package:wcenzije/services/geolocator.dart';

import 'home.dart';

class PermissionScreen extends StatelessWidget {
  const PermissionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'WCenzije za rad trebaju tvoju lokaciju.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const Padding(padding: EdgeInsets.all(10)),
              ElevatedButton(
                onPressed: () => requestPermission().then((value) =>
                    value != null
                        ? ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text(value)))
                        : Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (_) => HomeScreen()),
                            (route) => false)),
                child: const Text('DOZVOLI PRISTUP LOKACIJI'),
                style: TextButton.styleFrom(
                    primary: Colors.blue, backgroundColor: Colors.white),
              )
            ],
          ),
        ),
      ),
    );
  }
}
