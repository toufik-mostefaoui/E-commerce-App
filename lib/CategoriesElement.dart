import 'package:flutter/material.dart';

class Categorieselement extends StatelessWidget {
  final int index;
  final VoidCallback onTap;
  final List<bool> isSelected;
  final Widget? imageOrIcon;
  final String? categorieName;

  const Categorieselement({
    super.key,
    required this.index,
    required this.onTap,
    required this.isSelected,
    required this.imageOrIcon,
    required this.categorieName,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: !isSelected[index]
                    ? const Color.fromARGB(255, 224, 214, 214)
                    : Colors.orange,
                borderRadius: BorderRadius.circular(70),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(70),
                child: imageOrIcon,
              ),
            ),
            Text(
              categorieName!,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
