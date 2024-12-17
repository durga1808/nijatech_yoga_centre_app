import 'package:flutter/material.dart';
class MonthContainer extends StatelessWidget {
  final String month;
  final Color fillColor;
  final Color borderColor;
  final Color textColor;
  final TextStyle? textStyle;

  const MonthContainer({
    required this.month,
    required this.fillColor,
    required this.borderColor,
    required this.textColor,
    this.textStyle,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: fillColor,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: Text(
          month,
          style: textStyle?.copyWith(color: textColor) ??
              TextStyle(color: textColor), // Ensure textColor is applied
        ),
      ),
    );
  }
}
