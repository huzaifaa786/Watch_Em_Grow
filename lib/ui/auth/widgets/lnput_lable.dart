import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class InputLable extends StatelessWidget {
  final String label;

  const InputLable({
    Key? key,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return label.text.bold.make().pOnly(right:270,top: 10);
  }
}
