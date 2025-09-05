import 'package:flutter/material.dart';

class NetPhoto extends StatelessWidget {
  final String url;
  final String fallback;
  final double h;

  const NetPhoto({required this.url, required this.fallback, required this.h});

  @override
  Widget build(BuildContext context) {
    final imageWidget = url.isNotEmpty
        ? Image.network(
            url,
            height: h,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) =>
                Image.asset(fallback, fit: BoxFit.cover, height: h),
          )
        : Image.asset(fallback, fit: BoxFit.cover, height: h);

    return Container(
      height: h,
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
      child: imageWidget,
    );
  }
}
