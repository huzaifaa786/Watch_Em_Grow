import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class AuthHeader extends StatelessWidget {
  final String label;

  const AuthHeader({
    Key? key,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return label.text.bold.xl2.make().pOnly(right:40,bottom: 10);
  }
}
