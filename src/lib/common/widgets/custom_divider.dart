import 'package:flutter/material.dart';

class RoundedDivider extends StatelessWidget {
  final double height;
  final double width;
  final Color color;

  const RoundedDivider({
    Key? key,
    this.height = 2.0,
    this.width = double.infinity,
    this.color = Colors.grey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(height / 2),
        color: color,
      ),
    );
  }
}
