import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:ecommerce_app/bottmNavigatioBar.dart';
import 'package:ecommerce_app/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Profilepage extends StatefulWidget {
  final String? imageName;

  final List<Map<String, dynamic>> cartItems;

  const Profilepage({
    super.key,
    required this.imageName,
    required this.cartItems,
  });

  @override
  State<Profilepage> createState() => _ProfilepageState();
}

class _ProfilepageState extends State<Profilepage> {
  late String fullName = "";
  late String email = "";

  @override
  void initState() {
    super.initState();
    profileHandler();
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.orange.shade50, // makes status bar transparent
        statusBarIconBrightness:
            Brightness.dark, // or Brightness.light based on your background
      ),
    );
  }

  Future<void> handleLogOut() async {
    try {
      await ApiService().logout();

      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed("loginPage");
    } catch (e) {
      if (mounted) {
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
        setState(() => isclicked = false);
      }
    }
  }

  Future<void> profileHandler() async {
    try {
      final data = await ApiService().getProfile();
      if (!mounted) return;
      setState(() {
        fullName = data['username'] as String;
        email = data['email'] as String;
      });
    } catch (e) {
      print(e);
      if (e.toString().contains('Token expired or invalid') ||
          e.toString().contains("Refresh token is invalid or revoked")) {
        if (mounted) {
          await ApiService().logout(); // Clear tokens
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              elevation: 0,
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.transparent,
              content: AwesomeSnackbarContent(
                title: 'Note!',
                message: 'Session expired. Please login again.',
                contentType: ContentType.warning,
              ),
            ),
          );
          Navigator.of(context).pushReplacementNamed("loginPage");
        }
        return;
      }

      if (!mounted) return;
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

  bool isclicked = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 50),
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white, Colors.orange],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  width: 200,
                  height: 200,

                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.orange, width: 4),
                    borderRadius: BorderRadius.all(Radius.circular(200)),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.asset(
                      "images/${widget.imageName}",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                Container(
                  padding: EdgeInsets.all(20),
                  width: 300,
                  height: 400,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          fullName,
                          style: TextStyle(
                            color: Colors.orange,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Divider(),
                      Container(
                        height: 30, // Adjust based on your layout
                        alignment: Alignment.centerLeft,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: AnimatedSwitcher(
                            duration: Duration(milliseconds: 300),
                            transitionBuilder: (child, animation) =>
                                SlideTransition(
                                  position: Tween<Offset>(
                                    begin: Offset(1, 0),
                                    end: Offset(0, 0),
                                  ).animate(animation),
                                  child: child,
                                ),
                            child: Text(
                              email,
                              key: ValueKey(email),
                              style: TextStyle(
                                color: Colors.orange,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ),

                      Divider(),
                      SizedBox(height: 50),
                      GestureDetector(
                        onTap: () async {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("Warning"),
                                content: Text("Are you sure  you want exit ?"),
                                actions: [
                                  TextButton(
                                    onPressed: () async {
                                      setState(() {
                                        isclicked = true;
                                      });
                                      Navigator.of(context).pop();
                                      handleLogOut();
                                    },
                                    child: Text(
                                      "Yes",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(
                                        context,
                                      ).pop(); //just exit the alert dialog widget if click cancel
                                    },
                                    child: Text("Cancel"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            border: Border.all(color: Colors.orange),
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          width: 250,
                          height: 60,
                          child: !isclicked
                              ? Text(
                                  "Log out",
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
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Bottmnavigatiobar(
        cartItems: widget.cartItems,
        imageName: widget.imageName,
        selectedIndexInBottomNavigationBar: 2,
      ),
    );
  }
}
