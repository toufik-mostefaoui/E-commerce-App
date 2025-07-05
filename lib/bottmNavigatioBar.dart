import 'package:ecommerce_app/profilePage.dart';
import 'package:flutter/material.dart';

class Bottmnavigatiobar extends StatefulWidget {
  final int? selectedIndexInBottomNavigationBar;
  final String? imageName;
  final String? fullName;
  final String? email;
  final List<Map<String, dynamic>> cartItems;
  const Bottmnavigatiobar({
    super.key,
    required this.cartItems,
    this.selectedIndexInBottomNavigationBar,
    this.imageName,
    this.fullName,
    this.email, 
  });

  @override
  State<Bottmnavigatiobar> createState() => _BottmnavigatiobarState();
}

class _BottmnavigatiobarState extends State<Bottmnavigatiobar> {
  late int currentIndex;
  @override
  void initState() {
    currentIndex = widget.selectedIndexInBottomNavigationBar ?? 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      selectedItemColor: Colors.orange,
      unselectedItemColor: Colors.black,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      currentIndex: currentIndex,
      onTap: (val) async {
        setState(() {
          currentIndex = val;
        });
        if (val == 0) {
          Navigator.of(context).pushReplacementNamed(
            "home",
            arguments: {
              "imageName": widget.imageName,
              "fullName": widget.fullName,
              "email": widget.email,
              "cartItems": widget.cartItems,
            },
          );
        } else if (val == 2) {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => Profilepage(
                imageName: widget.imageName ?? "unknown.png",
                cartItems: widget.cartItems,
              ),
            ),
          );
        }
      },

      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined, size: 30),
          label: "",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_bag_outlined, size: 30),
          label: "",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline_sharp, size: 30),
          label: "",
        ),
      ],
    );
  }
}
