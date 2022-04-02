import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class AuthButton extends StatelessWidget {
  final String label;
  final void Function() onPressed;

  const AuthButton({
    Key? key,
    required this.label,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: label.text.white.bold.make(),
    ).objectCenterRight();
  }
}
