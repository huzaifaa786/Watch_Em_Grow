import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class InputLableMobile extends StatelessWidget {
  final String label;

  const InputLableMobile({
    Key? key,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return label.text.bold.make().pOnly(right:240,top: 10);
  }
}
