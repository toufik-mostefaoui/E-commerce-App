import 'package:ecommerce_app/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class Signuppage extends StatefulWidget {
  const Signuppage({super.key});

  @override
  State<Signuppage> createState() => _SignuppageState();
}

class _SignuppageState extends State<Signuppage> {
  Future<void> signUpHandler(
    String email,
    String username,
    String password,
    String confirmPassword,
  ) async {
    FocusScope.of(context).unfocus();
    setState(() => signUpClicked = true);

    try {
      await ApiService().signUp(
        email: email,
        username: username,
        password: password,
        confirmPassword: confirmPassword,
      );
      if (!mounted) return;
      await Future.delayed(const Duration(seconds: 2));
      setState(() {
        signUpClicked = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Awsome!',
            message: 'Registered Successfully!',
            contentType: ContentType.success,
          ),
        ),
      );

      await Future.delayed(const Duration(microseconds: 500));
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed("loginPage");
    } catch (e) {
      print(e);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Error!',
            message: e.toString().contains('already exists')
                ? 'You are already registered'
                : 'Registration failed: server error. Please try again later!',

            contentType: ContentType.failure,
          ),
        ),
      );
      setState(() => signUpClicked = false);
    }
  }

  GlobalKey<FormState> formState = GlobalKey();
  TextEditingController passController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();

  bool signUpClicked = false;
  String? fullName;
  String? email;
  String? password;
  String? confirmPaassword;

  @override
  void dispose() {
    passController.dispose();
    confirmPassController.dispose();
    super.dispose();
  }

  final _emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
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
                padding: EdgeInsets.symmetric(vertical: 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 30),
                    Text(
                      "Create an account",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 30,
                      ),
                    ),

                    Form(
                      key: formState,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            padding: EdgeInsets.all(10),
                            width: 300,
                            child: TextFormField(
                              keyboardType: TextInputType.name,
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

                                hintText: "Full name",
                                prefixIcon: Icon(Icons.person_outline),
                              ),
                              onSaved: (val) {
                                fullName = val;
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "must be not empty";
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
                                if (value!.isEmpty) {
                                  return "must be not empty";
                                }
                                return null;
                              },
                              controller: passController,
                              autovalidateMode: AutovalidateMode.onUnfocus,
                            ),
                          ),

                          Container(
                            margin: EdgeInsets.only(top: 10),
                            padding: EdgeInsets.all(10),
                            width: 300,
                            child: TextFormField(
                              obscureText: true,

                              cursorColor: Colors.orange,
                              keyboardType: TextInputType.visiblePassword,

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

                                hintText: "confirm password",
                                prefixIcon: Icon(Icons.lock_outline),
                              ),
                              onSaved: (val) {
                                confirmPaassword = val;
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "must be not empty";
                                }
                                if (value != passController.text) {
                                  return "Passwords do not match";
                                }
                                return null;
                              },
                              controller: confirmPassController,
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
                          "Already have an account ? ",
                          style: TextStyle(color: Colors.black),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(
                              context,
                            ).pushReplacementNamed("loginPage");
                          },
                          child: Text(
                            "Sign in",
                            style: TextStyle(color: Colors.orange),
                          ),
                        ),
                      ],
                    ),

                    GestureDetector(
                      onTap: signUpClicked
                          ? null
                          : () async {
                              FocusScope.of(context).unfocus();
                              if (formState.currentState!.validate()) {
                                setState(() {
                                  signUpClicked = true;
                                });
                                formState.currentState!.save();
                                signUpHandler(
                                  email!,
                                  fullName!,
                                  password!,
                                  confirmPaassword!,
                                );
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
                        child: !signUpClicked
                            ? Text(
                                "Sign up",
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
