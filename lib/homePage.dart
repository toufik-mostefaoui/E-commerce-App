import 'package:ecommerce_app/CategoriesElement.dart';
import 'package:ecommerce_app/bottmNavigatioBar.dart';
import 'package:ecommerce_app/drawer.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_app/productInfos.dart';
import 'package:flutter/services.dart';

class Homepage extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final String? imageName;
  final String? fullName;
  final String? email;

  const Homepage({
    super.key,
    this.cartItems = const [],
    this.fullName,
    this.email,
    this.imageName,
  });

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  GlobalKey<ScaffoldState> scafoldKey = GlobalKey();

  int indexSelected = 0;
  List<bool> isSelected = [false, false, false, false];
  late List<Map<String, dynamic>> cartItems;

  final List<Widget> productsinfos = [
    Productinfos(
      imageName: "téléchargement.png",
      productName: "Parfin",
      productDescription: "Cosmetic Serum Pipette Bottle Package",
      price: "200\$",
    ),
    Productinfos(
      imageName: "images (1).png",
      productName: "Air Pod",
      productDescription: "Clear Background Air Pod",
      price: "100\$",
    ),
    Productinfos(
      imageName: "images.png",
      productName: "Apple watch",
      productDescription: "Smart Watch from apple",
      price: "200\$",
    ),
    Productinfos(
      imageName: "133596-notebook-dell-xps-16-9640-strieborny-01.png",
      productName: "laptop",
      productDescription: "this is laptop",
      price: "300\$",
    ),
  ];

  @override
  void initState() {
    cartItems = List.from(widget.cartItems);
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
      key: scafoldKey,
      endDrawer: MyDrawer(cartItems: cartItems),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                //root column
                Container(
                  margin: EdgeInsets.only(top: 30),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color.fromARGB(255, 224, 214, 214),

                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: const Color.fromARGB(255, 224, 214, 214),
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),

                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(10),
                            ),

                            prefixIcon: Icon(Icons.search, color: Colors.black),
                            hintText: "Search",
                            // label: Text(
                            //   "Search",
                            //   style: TextStyle(color: Colors.black),
                            // ),
                          ),
                          cursorColor: Colors.black,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          scafoldKey.currentState!.openEndDrawer();
                        },
                        icon: Icon(Icons.menu),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 10, top: 30, bottom: 30),
                      child: Text(
                        "Categories",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w800,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Categorieselement(
                        index: 0,
                        onTap: () {
                          setState(() {
                            isSelected[0] = !isSelected[0];
                          });
                        },
                        isSelected: isSelected,
                        imageOrIcon: Image.asset(
                          "images/6000380.png",
                          fit: BoxFit.cover,
                          color: !isSelected[0] ? Colors.black : Colors.white,
                        ),
                        categorieName: 'Men',
                      ),

                      Categorieselement(
                        index: 1,
                        onTap: () {
                          setState(() {
                            isSelected[1] = !isSelected[1];
                          });
                        },
                        isSelected: isSelected,
                        imageOrIcon: Image.asset(
                          "images/heels.png",
                          fit: BoxFit.contain,
                          color: !isSelected[1] ? Colors.black : Colors.white,
                        ),
                        categorieName: 'Women',
                      ),

                      Categorieselement(
                        index: 2,
                        onTap: () {
                          setState(() {
                            isSelected[2] = !isSelected[2];
                          });
                        },
                        isSelected: isSelected,
                        imageOrIcon: Icon(
                          Icons.electric_bolt_rounded,
                          size: 40,
                          color: !isSelected[2] ? Colors.black : Colors.white,
                        ),
                        categorieName: 'Elecrical',
                      ),

                      Categorieselement(
                        index: 3,
                        onTap: () {
                          setState(() {
                            isSelected[3] = !isSelected[3];
                          });
                        },
                        isSelected: isSelected,
                        imageOrIcon: Icon(
                          Icons.interests_sharp,
                          size: 40,
                          color: !isSelected[3] ? Colors.black : Colors.white,
                        ),
                        categorieName: 'Hobbies',
                      ),
                    ],
                  ),
                ),

                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 10, top: 30, bottom: 30),
                      child: Text(
                        "Best Selling",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w800,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                GridView.builder(
                  physics:
                      NeverScrollableScrollPhysics(), // Disable inner scroll
                  shrinkWrap: true, // Let it fit its content
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio:
                        0.5, // Controls height vs width , smaller ratio = taller item
                  ),
                  itemCount: productsinfos.length,
                  itemBuilder: (context, i) {
                    final product = productsinfos[i] as Productinfos;
                    return GestureDetector(
                      onTap: () async {
                        final updatedCartItem = await Navigator.of(context)
                            .pushNamed(
                              "productDetails",
                              arguments: {
                                "imageName": product.imageName,
                                "productName": product.productName,
                                "productDescription":
                                    product.productDescription,
                                "price": product.price,
                                "cartItems": cartItems,
                                "email": widget.email,
                                "profileImageName": widget.imageName,
                                "fullName": widget.fullName,
                              },
                            );
                        if (updatedCartItem != null && mounted) {
                          setState(() {
                            cartItems =
                                updatedCartItem as List<Map<String, dynamic>>;
                          });
                        }
                      },
                      child: productsinfos[i],
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),

      bottomNavigationBar: Bottmnavigatiobar(
        cartItems: cartItems,
        fullName: widget.fullName,
        email: widget.email,
        imageName: widget.imageName,
      ),
    );
  }
}
