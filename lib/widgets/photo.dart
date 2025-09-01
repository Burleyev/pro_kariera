import 'package:flutter/material.dart';

class Photo extends StatelessWidget {
  const Photo({super.key, required this.asset, required this.h, this.w});

  final String asset;
  final double h;
  final double? w;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: h,
      width:
          w, // Можно использовать w ?? double.infinity если нужна ширина по умолчанию
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            blurRadius: 20,
            color: Color.fromARGB(126, 0, 0, 0),
            offset: Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.hardEdge,
      child: Image.asset(
        asset,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const SizedBox(
          width: 200,
          child: Center(child: Icon(Icons.broken_image)),
        ),
      ),
    );
  }
}
