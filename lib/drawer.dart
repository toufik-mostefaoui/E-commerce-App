import 'package:flutter/material.dart';

class MyDrawer extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;

  const MyDrawer({super.key, required this.cartItems});

  @override
  State<MyDrawer> createState() => _drawerState();
}

class _drawerState extends State<MyDrawer> {
  double getTotal() {
    double total = 0.00;
    for (var element in widget.cartItems) {
      final priceString = element['price'].toString().replaceAll(
        RegExp(r'[^0-9.]'),
        '',
      );
      final price = double.tryParse(priceString) ?? 0;

      final quantityString = element['quantity'].toString().replaceAll(
        RegExp(r'[^0-9.]'),
        '',
      );
      final quantity = double.tryParse(quantityString) ?? 0;

      total = total + price * quantity;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 250,
      child: ListView(
        padding: EdgeInsets.only(top: 50),
        children: [
          if (widget.cartItems.isNotEmpty)
            ...widget.cartItems.map((item) {
              return Container(
                height: 60,
                child: ListTile(
                  leading: Stack(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.asset(
                            "images/${item['imageName']}",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      Container(
                        width: 15,
                        height: 15,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          border: Border.all(color: Colors.orange),
                        ),
                        child: Text(
                          item['quantity'],
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),

                  title: Text(item['productName']),
                  subtitle: Text(
                    item['price'],
                    style: TextStyle(color: Colors.orange),
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(
                              "Are you sure you need to remove this item fom chart ?",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    widget.cartItems.remove(item);
                                  });
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  "Yes",
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text("Cancel"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    icon: Icon(Icons.delete_outlined, color: Colors.red),
                  ),
                ),
              );
            })
          else
            Container(child: Center(child: Text("No item in chart"))),

          Divider(),
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              "Total: \$${getTotal().toStringAsFixed(2)}",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
