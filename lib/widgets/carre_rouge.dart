import 'package:flutter/material.dart';

class Carre extends StatelessWidget {
  final Color color;
  const Carre({
    super.key, required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 50,
      color: color,
    );
  }
}
