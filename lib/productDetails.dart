import 'package:ecommerce_app/bottmNavigatioBar.dart';
import 'package:ecommerce_app/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Productdetails extends StatefulWidget {
  const Productdetails({super.key});

  @override
  State<Productdetails> createState() => _ProductdetailsState();
}

class _ProductdetailsState extends State<Productdetails> {
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

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  String? color;
  String? size;
  int quantity = 1;
  bool addButtonIsClicked = false;

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final String imageName = args["imageName"];
    final String productName = args["productName"];
    final String productDescription = args["productDescription"];
    final String price = args["price"];
    final List<Map<String, dynamic>> cartItems = args["cartItems"];

    return Scaffold(
      key: scaffoldKey,
      endDrawer: MyDrawer(cartItems: cartItems),
      body: ListView(
        children: [
          Container(
            color: const Color.fromARGB(255, 238, 226, 226),
            height: 350,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Container(
                        child: IconButton(
                          onPressed: () {
                            Navigator.of(context).pop(cartItems);
                          },
                          icon: Icon(Icons.arrow_back, color: Colors.black),
                        ),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment
                              .center, // Prevents full width expansion
                          children: [
                            Text(
                              "Gispy",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              "Bee",
                              style: TextStyle(
                                color: Colors.orange,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Stack(
                        children: [
                          IconButton(
                            onPressed: () {
                              scaffoldKey.currentState!.openEndDrawer();
                            },
                            icon: Icon(
                              Icons.shopping_cart_outlined,
                              size: 30,
                              color: Colors.orange,
                            ),
                          ),
                          if (cartItems.isNotEmpty)
                            Positioned(
                              right: 6,
                              top: 6,
                              child: Container(
                                padding: EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                constraints: BoxConstraints(
                                  minWidth: 12,
                                  minHeight: 12,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 300,
                  height: 250,
                  child: Image.asset("images/$imageName", fit: BoxFit.cover),
                ),
              ],
            ),
          ),

          Container(
            padding: EdgeInsets.all(10),
            child: Center(
              child: Text(
                productName,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 15),
            child: Center(
              child: Text(
                productDescription,
                style: TextStyle(color: const Color.fromARGB(255, 63, 56, 56)),
              ),
            ),
          ),

          Container(
            padding: EdgeInsets.only(bottom: 15),
            child: Center(
              child: Text(
                price,
                style: TextStyle(
                  color: Colors.orange,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(right: 15),
                  child: Text(
                    "Color : ",
                    style: TextStyle(color: Colors.black),
                  ),
                ),

                GestureDetector(
                  onTap: () {
                    setState(() {
                      color = "black";
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            border: Border.all(
                              color: color == "black"
                                  ? Colors.orange
                                  : Colors.black,
                              width: 2,
                            ),
                          ),
                        ),
                        Text(
                          "Black",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),

                GestureDetector(
                  onTap: () {
                    setState(() {
                      color = "grey";
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            border: Border.all(
                              color: color == "grey"
                                  ? Colors.orange
                                  : Colors.grey,
                              width: 2,
                            ),
                          ),
                        ),
                        Text(
                          "Grey",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding: EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Size : ", style: TextStyle(fontSize: 20)),

                GestureDetector(
                  onTap: () {
                    setState(() {
                      size = "39";
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.only(left: 5, right: 5),
                    child: Text(
                      "39",
                      style: TextStyle(
                        color: size == "39" ? Colors.black : Colors.grey,
                        fontSize: size != "39" ? 15 : 20,
                      ),
                    ),
                  ),
                ),

                GestureDetector(
                  onTap: () {
                    setState(() {
                      size = "40";
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.only(left: 5, right: 5),
                    child: Text(
                      "40",
                      style: TextStyle(
                        color: size == "40" ? Colors.black : Colors.grey,
                        fontSize: size != "40" ? 15 : 20,
                      ),
                    ),
                  ),
                ),

                GestureDetector(
                  onTap: () {
                    setState(() {
                      size = "41";
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.only(left: 5, right: 5),
                    child: Text(
                      "41",
                      style: TextStyle(
                        color: size == "41" ? Colors.black : Colors.grey,
                        fontSize: size != "41" ? 15 : 20,
                      ),
                    ),
                  ),
                ),

                GestureDetector(
                  onTap: () {
                    setState(() {
                      size = "42";
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.only(left: 5, right: 5),
                    child: Text(
                      "42",
                      style: TextStyle(
                        color: size == "42" ? Colors.black : Colors.grey,
                        fontSize: size != "42" ? 15 : 20,
                      ),
                    ),
                  ),
                ),

                GestureDetector(
                  onTap: () {
                    setState(() {
                      size = "43";
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.only(left: 5, right: 5),
                    child: Text(
                      "43",
                      style: TextStyle(
                        color: size == "43" ? Colors.black : Colors.grey,
                        fontSize: size != "43" ? 15 : 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Quantity : ",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                Container(
                  alignment: Alignment.center,

                  margin: EdgeInsets.only(left: 10, right: 10),
                  width: 40,
                  height: 40,

                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.all(Radius.circular(40)),
                  ),
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        quantity = quantity + 1;
                      });
                    },
                    icon: Icon(Icons.add),
                    color: Colors.white,
                  ),
                ),

                SizedBox(
                  width: 60,
                  height: 40,

                  child: TextField(
                    textAlign: TextAlign.center,
                    enabled: false,
                    decoration: InputDecoration(
                      fillColor: const Color.fromARGB(255, 214, 207, 207),
                      filled: true,
                      hintText: "$quantity",
                      hintStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.orange),
                        borderRadius: BorderRadius.all(Radius.circular(40)),
                      ),
                    ),
                  ),
                ),

                Container(
                  alignment: Alignment.center,

                  margin: EdgeInsets.only(left: 10),
                  width: 40,
                  height: 40,

                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.all(Radius.circular(40)),
                  ),
                  child: IconButton(
                    onPressed: () {
                      if (quantity != 1) {
                        setState(() {
                          quantity = quantity - 1;
                        });
                      }
                    },
                    icon: Icon(Icons.minimize),
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          Container(
            width: 100,
            height: 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MaterialButton(
                  color: Colors.black,
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    setState(() {
                      addButtonIsClicked = true;
                    });

                    Future.delayed(Duration(seconds: 2), () {
                      if (mounted) {
                        setState(() {
                          addButtonIsClicked = false;
                        });
                      }
                    });
                    final existingItemIndex = cartItems.indexWhere(
                      (item) =>
                          item["productName"] == productName &&
                          item["price"] == price,
                    );

                    if (existingItemIndex != -1) {
                      // If exists, update the quantity
                      int existingQuantity = int.parse(
                        cartItems[existingItemIndex]["quantity"],
                      );
                      cartItems[existingItemIndex]["quantity"] =
                          (existingQuantity + quantity).toString();
                    } else {
                      setState(() {
                        cartItems.add({
                          "imageName": imageName,
                          "productName": productName,
                          "price": price,
                          "quantity": quantity.toString(),
                        });
                      });
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        duration: Duration(seconds: 2),
                        action: SnackBarAction(
                          //like button in the end of snack bar
                          label: "ok",
                          onPressed: () {
                            setState(() {
                              addButtonIsClicked = false;
                            });
                          },
                        ),
                        content: Text("Succefuly added!!"),
                      ),
                    );
                  },
                  child: !addButtonIsClicked
                      ? Text(
                          "+Add to chart",
                          style: TextStyle(color: Colors.white),
                        )
                      : const SizedBox(
                          width: 10,
                          height: 10,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 1,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),

      bottomNavigationBar: Bottmnavigatiobar(
        cartItems: cartItems,
      ),
    );
  }
}
