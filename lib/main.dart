import 'package:ecommerce_app/homePage.dart';
import 'package:ecommerce_app/loginPage.dart';
import 'package:ecommerce_app/productDetails.dart';
import 'package:ecommerce_app/services/api_service.dart';
import 'package:ecommerce_app/signupPage.dart';
import 'package:ecommerce_app/splashScreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {




  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Colors.orange, // Cursor color
          selectionColor: Colors.orange.shade100, // Highlighted selection color
          selectionHandleColor: Colors.orange, // Bubbles (handles) color
        ),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android:
                ZoomPageTransitionsBuilder(), // Standard smooth zoom transition
            TargetPlatform.iOS:
                CupertinoPageTransitionsBuilder(), // iOS swipe-style transition
          },
        ),
      ),
      debugShowCheckedModeBanner: false,
      routes: {
        "home": (context) {
          final args =
              ModalRoute.of(context)?.settings.arguments
                  as Map<String, dynamic>?;
          return Homepage(
            imageName: args?["imageName"],
            fullName: args?["fullName"],
            email: args?["email"],
            cartItems: args?["cartItems"] ?? [],
          );
        },

        "productDetails": (context) => Productdetails(),
        "loginPage": (context) => Loginpage(),
        "signupPage": (context) => Signuppage(),
      },
      home: Splashscreen(),
    );
  }
}
