import 'package:flutter/material.dart';

class Productinfos extends StatelessWidget {
  final String? imageName;
  final String? productName;
  final String? productDescription;
  final String? price;
  const Productinfos({
    super.key,
    required this.imageName,
    required this.productName,
    required this.productDescription,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 224, 214, 214),
              ),

              width: double.infinity,
              child: Image.asset("images/$imageName", fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "$productName",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            "$productDescription",
            style: TextStyle(color: const Color.fromARGB(255, 63, 56, 56)),
          ),
          Text(
            "$price",
            style: TextStyle(
              color: Colors.orange,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
