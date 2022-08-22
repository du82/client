import 'package:flutter/material.dart';

Widget verticalLine(context, double height) {
  return Container(
    height: height * 0.4,
    width: 0.5,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).colorScheme.primary.withOpacity(0.1)),
  );
}
