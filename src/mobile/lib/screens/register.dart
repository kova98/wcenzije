import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:wcenzije/helpers/string_helper.dart';
import 'package:wcenzije/screens/login.dart';
import 'package:wcenzije/services/auth.dart';

class RegisterScreen extends StatefulWidget {
  final Widget redirect;
  const RegisterScreen(this.redirect, {Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _authService = AuthService();
  String _email = "";
  String _username = "";
  String _password = "";
  String? _error;
  bool _loading = false;
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Container(
        margin: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Padding(padding: EdgeInsets.all(25)),
            const Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Postani \nwcenzent',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            const Spacer(),
            _error == null
                ? const SizedBox.shrink()
                : Text(
                    _error!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
            const Padding(padding: EdgeInsets.all(5)),
            Material(
              elevation: 3,
              borderRadius: BorderRadius.circular(50),
              color: Colors.transparent,
              child: TextField(
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  setState(() {
                    _email = value;
                    _error = null;
                  });
                },
                style: const TextStyle(color: Colors.black87),
                decoration: InputDecoration(
                  errorStyle: const TextStyle(color: Colors.white),
                  hintText: 'email',
                  prefixIcon: const Icon(Icons.email),
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
                    _username = value;
                    _error = null;
                  });
                },
                style: const TextStyle(color: Colors.black87),
                decoration: InputDecoration(
                  errorStyle: const TextStyle(color: Colors.white),
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
                text: 'Imaš račun? ',
                style: const TextStyle(color: Colors.white70),
                children: <TextSpan>[
                  TextSpan(
                    text: 'Prijavi se!',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  LoginScreen(widget.redirect),
                            ),
                          ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _loading = false;

                  if (_password.length < 8) {
                    _error = 'Lozinka je prekratka.';
                  }

                  if (_username.length < 4) {
                    _error = 'Ime je prekratko';
                  }

                  if (!_email.isValidEmail()) {
                    _error = 'Email je neispravan.';
                  }
                });

                if (_error != null) {
                  return;
                }

                setState(() {
                  _loading = true;
                });

                _authService
                    .register(_email, _username, _password)
                    .then((responseCode) {
                  _loading = false;
                  _error = null;

                  if (responseCode == 200) {
                    _authService.login(_username, _password).then((value) => {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => widget.redirect,
                            ),
                          )
                        });
                  } else {
                    final errorMsg = responseCode == 409
                        ? 'Korisnik $_username već postoji.'
                        : 'Došlo je do pogreške.';

                    setState(() {
                      _error = errorMsg;
                    });
                  }
                });
              },
              style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  backgroundColor: Colors.white,
                  minimumSize: const Size(120, 50)),
              child: _loading
                  ? const CircularProgressIndicator()
                  : const Text(
                      'REGISTRIRAJ SE',
                      style: TextStyle(color: Colors.blue),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
