import 'dart:convert';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:ecommerce_app/services/api_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:http/http.dart' as http;
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  bool googleClicked = false;
  bool facebookClicked = false;
  bool appleClicked = false;

  Future<void> loginHandle(String email, String password) async {
    setState(() => loginClicked = true);
    FocusScope.of(context).unfocus();

    try {
      final user = await ApiService().login(email: email, password: password);

      if (!mounted) return;
      await Future.delayed(const Duration(seconds: 2));
      setState(() {
        loginClicked = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Awsome!',
            message: 'Login Successfully!',
            contentType: ContentType.success,
          ),
        ),
      );
      await Future.delayed(const Duration(microseconds: 500));
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed(
        'home',
        arguments: {
          'id': user['id'],
          'fullName': user['username'],
          'email': user['email'],
          'role': user['role'],
        },
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              title: 'Failed!',
              message: e.toString().contains('Incorrect')
                  ? 'Incorrect email or password !!'
                  : 'Server error. Please try again later.',

              contentType: ContentType.failure,
            ),
          ),
        );
        setState(() => loginClicked = false);
      }
    }
  }

  Future<void> _googleLogin() async {
    // ✅ Use the singleton, never `GoogleSignIn(...)`
    final googleSignIn = GoogleSignIn.instance;

    // 1️⃣ (Optional) If you need to pass your own client IDs (e.g. on web)
    await googleSignIn.initialize(
      clientId:
          '750367811891-k52krsb3nr114702vvmjfneh8neimeao.apps.googleusercontent.com',
      serverClientId:
          '750367811891-u5f5i5hjupqpps0v5e7vrurbqpdgpuka.apps.googleusercontent.com',
    );

    // 2️⃣ Kick off the native flow (or web button) and get back your account
    late GoogleSignInAccount account;
    try {
      account = await googleSignIn.authenticate(scopeHint: ['email']);
    } on GoogleSignInException catch (e) {
      print('Google Sign‑In failed: ${e.code.name} – ${e.description}');
      return;
    }

    // 3️⃣ Grab the ID token
    final idToken = account.authentication.idToken;
    if (idToken == null) {
      print('No ID token!');
      return;
    }

    // 4️⃣ Send it up to your Node.js /auth/google
    try {
      setState(() {
        loginClicked = true;
      });
      final resp = await http
          .post(
            Uri.parse('http://10.163.74.102:5000/api/auth/google'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'idToken': idToken}),
          )
          .timeout(const Duration(seconds: 5));
      final _storage = const FlutterSecureStorage();
      if (resp.statusCode == 200) {
        setState(() {
          loginClicked = true;
        });
        final data = jsonDecode(resp.body);
        final user = data['user'];
        await _storage.write(key: 'accessToken', value: data['accessToken']);
        await _storage.write(key: 'refreshToken', value: data['refreshToken']);
        await Future.delayed(Duration(seconds: 2));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              title: 'Awsome!',
              message: 'Login Successfully!',
              contentType: ContentType.success,
            ),
          ),
        );
        await Future.delayed(const Duration(microseconds: 500));
        Navigator.pushReplacementNamed(
          context,
          'home',
          arguments: {
            'id': user['id'],
            'fullName': user['username'],
            'email': user['email'],
            'role': user['role'],
          },
        );
        setState(() {
          loginClicked = false;
        });
      } else {
        print('Google login failed: ${resp.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              title: 'Error!',
              message: 'Google login failed',

              contentType: ContentType.failure,
            ),
          ),
        );
        throw Exception('Google login failed');
      }
    } catch (e) {
      setState(() {
        loginClicked = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Failed!',
            message: 'Server error. Please try again later.',

            contentType: ContentType.failure,
          ),
        ),
      );
    }
  }

  Future<void> _facebookLogin() async {
    // 1. Show Facebook login UI
    final result = await FacebookAuth.instance.login();
    print(result.message);
    if (result.status != LoginStatus.success) return;

    final fbToken = result.accessToken!.tokenString;

    // 2. Send token to backend
    try {
      final resp = await http
          .post(
            Uri.parse('http://10.163.74.102:5000/api/auth/facebook'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'fbToken': fbToken}),
          )
          .timeout(const Duration(seconds: 5));

      // 3. On success, store JWTs and navigate
      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body);
        final storage = FlutterSecureStorage();
        await storage.write(key: 'accessToken', value: data['accessToken']);
        await storage.write(key: 'refreshToken', value: data['refreshToken']);
        final user = data['user'];
        setState(() {
          loginClicked = true;
        });
        await Future.delayed(Duration(seconds: 2));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              title: 'Awsome!',
              message: 'Login Successfully!',
              contentType: ContentType.success,
            ),
          ),
        );
        await Future.delayed(const Duration(microseconds: 500));
        Navigator.pushReplacementNamed(
          context,
          'home',
          arguments: {
            'id': user['id'],
            'fullName': user['username'],
            'email': user['email'],
            'role': user['role'],
          },
        );
        setState(() {
          loginClicked = false;
        });
      } else {
        final error = jsonDecode(resp.body)['msg'] ?? 'Login failed';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              title: 'Error!',
              message: 'facebook login failed',

              contentType: ContentType.failure,
            ),
          ),
        );
        throw Exception('Facebook login failed: $error');
      }
    } catch (e) {
      setState(() {
        loginClicked = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Failed!',
            message: 'Server error. Please try again later.',

            contentType: ContentType.failure,
          ),
        ),
      );
    }
  }

  GlobalKey<FormState> formaState = GlobalKey();
  String? email;
  String? password;
  final _emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  bool loginClicked = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // makes status bar transparent
        statusBarIconBrightness:
            Brightness.dark, // or Brightness.light based on your background
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: -30, // shift upward (adjust as needed)
            left: -60, // shift to the left (adjust as needed)
            child: Container(
              width: 360,
              height: 360,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange.shade300, Colors.white],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.1, 0.8],
                ),

                borderRadius: BorderRadius.circular(360),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 150),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 30),
                    Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 30,
                      ),
                    ),

                    Form(
                      key: formaState,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            padding: EdgeInsets.all(10),
                            width: 300,
                            child: TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              cursorColor: Colors.orange,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade300,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.orange),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30),
                                  ),
                                ),

                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30),
                                  ),
                                ),

                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30),
                                  ),
                                ),

                                hintText: "email",
                                prefixIcon: Icon(Icons.email_outlined),
                              ),
                              onSaved: (val) {
                                email = val;
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "must be not empty";
                                }
                                if (!_emailRegExp.hasMatch(value)) {
                                  return "Enter a valid email address";
                                }
                                return null;
                              },
                              autovalidateMode: AutovalidateMode.onUnfocus,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            padding: EdgeInsets.all(10),
                            width: 300,
                            child: TextFormField(
                              cursorColor: Colors.orange,
                              obscureText: true,

                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade300,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.orange),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30),
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30),
                                  ),
                                ),

                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30),
                                  ),
                                ),

                                hintText: "password",
                                prefixIcon: Icon(Icons.lock_outline),
                              ),
                              onSaved: (val) {
                                password = val;
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "must be not empty";
                                }
                                return null;
                              },
                              autovalidateMode: AutovalidateMode.onUnfocus,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account ? ",
                          style: TextStyle(color: Colors.black),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(
                              context,
                            ).pushReplacementNamed("signupPage");
                          },
                          child: Text(
                            "Sign up",
                            style: TextStyle(color: Colors.orange),
                          ),
                        ),
                      ],
                    ),

                    GestureDetector(
                      onTap: loginClicked
                          ? null
                          : () async {
                              FocusScope.of(context).unfocus();
                              if (formaState.currentState!.validate()) {
                                setState(() {
                                  loginClicked = true;
                                });
                                formaState.currentState!.save();
                                loginHandle(email!, password!);
                              }
                            },
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(10),
                        width: 250,
                        height: 50,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          color: Colors.orange,
                        ),
                        child: !loginClicked
                            ? Text(
                                "Login",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : const SizedBox(
                                width: 30,
                                height: 30,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 3,
                                ),
                              ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 1,
                            indent: 20,
                            endIndent: 10,
                          ),
                        ),
                        Text(
                          "Or login with",
                          style: TextStyle(color: Colors.grey),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 1,
                            indent: 10,
                            endIndent: 20,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTapDown: (_) {
                            setState(() {
                              googleClicked = true;
                            });
                          },
                          onTapUp: (_) async {
                            await Future.delayed(Duration(milliseconds: 50));
                            setState(() {
                              googleClicked = false;
                              print("tap up");
                            });
                            //here to do login with google
                            await _googleLogin();
                          },
                          onTapCancel: () {
                            setState(() {
                              googleClicked = false;
                              print("tap cancel");
                            });
                          },
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.only(right: 10, left: 10),
                            width: 80,
                            height: 50,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.red),
                              borderRadius: BorderRadius.all(
                                Radius.circular(30),
                              ),
                              color: googleClicked ? Colors.red : Colors.white,
                            ),
                            child: Image.asset(
                              "images/google_icon.png",
                              width: 30,
                              height: 30,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTapDown: (_) {
                            setState(() {
                              facebookClicked = true;
                            });
                          },
                          onTapUp: (_) async {
                            await Future.delayed(Duration(milliseconds: 50));
                            setState(() {
                              facebookClicked = false;
                              print("tap up");
                            });
                            //here to do login with facebook
                            await _facebookLogin();
                          },
                          onTapCancel: () {
                            setState(() {
                              facebookClicked = false;
                              print("tap cancel");
                            });
                          },
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.only(right: 10, left: 10),
                            width: 80,
                            height: 50,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.blue),
                              borderRadius: BorderRadius.all(
                                Radius.circular(30),
                              ),
                              color: facebookClicked
                                  ? Colors.blue
                                  : Colors.white,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.asset(
                                "images/Facebook-logo-sign-blue.png",
                                width: 50,
                                height: 50,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTapDown: (_) {
                            setState(() {
                              appleClicked = true;
                            });
                          },
                          onTapUp: (_) async {
                            await Future.delayed(Duration(milliseconds: 50));
                            setState(() {
                              appleClicked = false;
                              print("tap up");
                            });
                            //here to do login with apple
                          },
                          onTapCancel: () {
                            setState(() {
                              appleClicked = false;
                              print("tap cancel");
                            });
                          },
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.only(right: 10, left: 10),
                            width: 80,
                            height: 50,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.all(
                                Radius.circular(30),
                              ),
                              color: appleClicked ? Colors.black : Colors.white,
                            ),
                            child: Image.asset(
                              appleClicked
                                  ? "images/apple_white_icon.png"
                                  : "images/apple_icon.png",
                              width: 30,
                              height: 30,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
