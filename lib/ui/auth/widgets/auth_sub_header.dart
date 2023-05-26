import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class AuthSubHeader extends StatelessWidget {
  final String label;

  const AuthSubHeader({
    Key? key,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return label.text.base.make().pOnly(left:3,right:3);
  }
}
