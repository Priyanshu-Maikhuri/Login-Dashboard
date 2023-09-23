import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum AuthMode { Signup, Login }

FirebaseAuth _firebase = FirebaseAuth.instance;

class LoginScreen extends StatefulWidget {
  static const routeName = '/auth';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
                  const Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          SingleChildScrollView(
            child: SizedBox(
                height: deviceSize.height,
                width: deviceSize.width,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Flexible(
                        flex: deviceSize.width > 600 ? 2 : 1,
                        child: const AuthCard(),
                      ),
                    ])),
          ),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({super.key});

  @override
  State<AuthCard> createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  AuthMode _authMode = AuthMode.Login;
  final Map<String, String> _authCredentials = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  var _hidePassword = true;
  final _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void dispose() {
    // TODO: implement dispose
    _passwordController.dispose();
    super.dispose();
  }

  void _showErrorDialog(String error) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              icon: const Icon(
                Icons.error,
                size: 90,
                shadows: [
                  Shadow(
                      offset: Offset(1.5, 2.7),
                      blurRadius: 5,
                      color: Colors.orangeAccent),
                  Shadow(
                      offset: Offset(1.5, 2.7),
                      blurRadius: 5,
                      color: Colors.grey)
                ],
              ),
              iconColor: Colors.deepOrange.shade900,
              iconPadding: const EdgeInsets.only(top: 1),
              title: const Text('Ooops!',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
              content: Text(error),
              actions: [
                TextButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: const Text('Close'))
              ],
            ));
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return; //Invalid
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.Login) {
        await _firebase.signInWithEmailAndPassword(
            email: _authCredentials['email']!,
            password: _authCredentials['password']!);
      } else {
        await _firebase.createUserWithEmailAndPassword(
            email: _authCredentials['email']!,
            password: _authCredentials['password']!);
      }
    } on FirebaseAuthException catch (error) {
      var errorMessage = 'Authentication Failed.';
      if (error.code == 'email-already-in-use') {
        errorMessage =
            'The email address is already in use by another account.';
      } else if (error.code == 'user-not-found') {
        errorMessage = 'There is no existing corresponding user record.';
      } else if (error.code == 'invalid-email') {
        errorMessage =
            'There is no user record corresponding to this emai id. The user may have been deleted.';
      } else if (error.code == 'invalid-password') {
        errorMessage = 'The password is invalid.';
      } else if (error.code == 'weak-password') {
        errorMessage = 'This password is too weak.';
      } else if (error.code == 'wrong-password') {
        errorMessage = 'The password is invalid for the email.';
      }
      _showErrorDialog(errorMessage);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return PhysicalModel(
      color: Colors.white,
      shadowColor: Theme.of(context).colorScheme.primary,
      elevation: 20.0,
      borderRadius: BorderRadius.circular(10.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeIn,
          height: _authMode == AuthMode.Signup ? 520 : 400,
          constraints: BoxConstraints(
              minHeight: _authMode == AuthMode.Signup ? 520 : 400),
          width: deviceSize.width * 0.75,
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Icon(Icons.account_circle,
                      size: 100, color: Theme.of(context).primaryColor),
                  TextFormField(
                    decoration: const InputDecoration(
                        labelText: 'E-Mail',
                        prefixIcon:
                            Icon(Icons.mail_outline, color: Colors.black)),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value!.isEmpty || !value.contains('@')) {
                        return 'Invalid email!';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _authCredentials['email'] = value!;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon:
                          const Icon(Icons.key_outlined, color: Colors.black),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _hidePassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Theme.of(context).primaryColorDark,
                        ),
                        onPressed: () {
                          setState(() {
                            _hidePassword = !_hidePassword;
                          });
                        },
                      ),
                    ),
                    obscureText: _hidePassword,
                    controller: _passwordController,
                    validator: (value) {
                      if (value!.isEmpty || value.length < 6) {
                        return 'Password is too short!'; //password should be of atleast 6 characters
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _authCredentials['password'] = value!;
                    },
                  ),
                  if (_authMode == AuthMode.Signup)
                    TextFormField(
                      enabled: _authMode == AuthMode.Signup,
                      decoration: const InputDecoration(
                        labelText: 'Confirm Password',
                        prefixIcon: Icon(Icons.check_circle_outline_outlined,
                            color: Colors.black),
                      ),
                      obscureText: true,
                      validator: _authMode == AuthMode.Signup
                          ? (value) {
                              if (value != _passwordController.text) {
                                return 'Passwords do not match!';
                              }
                              return null;
                            }
                          : null,
                    ),
                  const SizedBox(
                    height: 20,
                  ),
                  (_isLoading)
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: _submit,
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30.0, vertical: 8.0),
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Colors.white,
                          ),
                          child: Text(_authMode == AuthMode.Login
                              ? 'LOGIN'
                              : 'SIGN UP'),
                        ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextButton(
                      onPressed: () {
                        _authMode = (_authMode == AuthMode.Login)
                            ? AuthMode.Signup
                            : AuthMode.Login;
                        setState(() {});
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 4),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        textStyle: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      child: Text(
                        '${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD',
                        style: const TextStyle(
                            decoration: TextDecoration.underline),
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
