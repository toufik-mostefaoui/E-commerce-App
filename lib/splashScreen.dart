import 'package:ecommerce_app/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    staySignIn();
    super.initState();
  }

  Future<void> staySignIn() async {
    final staySignIn = await ApiService().staySignIn();

    if (staySignIn) {
      await Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacementNamed("home");
    });
    }else{
      await Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacementNamed("loginPage");
    });
    }
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.orange],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/icon/app_icon.png", width: 200, height: 200),
            CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}
