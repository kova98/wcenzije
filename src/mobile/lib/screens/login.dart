import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:wcenzije/screens/add_review/where.dart';
import 'package:wcenzije/screens/register.dart';
import 'package:wcenzije/services/auth.dart';

class LoginScreen extends StatefulWidget {
  final Widget redirect;
  const LoginScreen(this.redirect, {Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _authService = AuthService();
  String? _username;
  String? _password;
  String? _error;
  bool _loading = false;
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Container(
        margin: EdgeInsets.all(20),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Padding(padding: EdgeInsets.all(15)),
              const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Prijavi se za nastavak',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              Spacer(),
              _error == null
                  ? SizedBox.shrink()
                  : Text(
                      _error!,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
              const Padding(padding: EdgeInsets.all(5)),
              Material(
                elevation: 3,
                borderRadius: BorderRadius.circular(50),
                color: Colors.transparent,
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      _username = value;
                      _error = null;
                    });
                  },
                  style: const TextStyle(color: Colors.black87),
                  decoration: InputDecoration(
                    errorStyle: TextStyle(color: Colors.white),
                    hintText: 'ime',
                    prefixIcon: const Icon(Icons.person),
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: const BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                  ),
                ),
              ),
              const Padding(padding: EdgeInsets.all(5)),
              Material(
                elevation: 3,
                borderRadius: BorderRadius.circular(50),
                color: Colors.transparent,
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      _password = value;
                      _error = null;
                    });
                  },
                  obscureText: !_passwordVisible,
                  style: const TextStyle(color: Colors.black87),
                  decoration: InputDecoration(
                    hintText: 'lozinka',
                    prefixIcon: const Icon(Icons.key),
                    suffixIcon: IconButton(
                      splashRadius: 5,
                      icon: Icon(_passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: const BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                  ),
                ),
              ),
              const Padding(padding: EdgeInsets.all(10)),
              RichText(
                text: TextSpan(
                  text: 'Nemaš račun? ',
                  style: TextStyle(color: Colors.white70),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Registriraj se!',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    RegisterScreen(widget.redirect),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
              Spacer(),
              ElevatedButton(
                onPressed: () {
                  if (_username == null || _password == null) {
                    setState(() {
                      _error = 'Pogrešno ime i/ili lozinka.';
                    });
                    return;
                  }

                  setState(() {
                    _loading = true;
                    _error = null;
                  });

                  _authService.login(_username!, _password!).then((value) {
                    _loading = false;
                    if (value == true) {
                      _error = null;
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => widget.redirect,
                        ),
                      );
                    } else {
                      setState(() {
                        _error = 'Pogrešno ime i/ili lozinka.';
                      });
                    }
                  });
                },
                child: _loading
                    ? CircularProgressIndicator()
                    : Text(
                        'PRIJAVA',
                        style: TextStyle(color: Colors.blue),
                      ),
                style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    backgroundColor: Colors.white,
                    minimumSize: Size(120, 50)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
