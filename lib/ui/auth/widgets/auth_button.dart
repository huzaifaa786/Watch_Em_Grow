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
    return Container(
      width: MediaQuery.of(context).size.width*0.9,
      child: ElevatedButton(
       style: ElevatedButton.styleFrom(
                fixedSize: const Size(600, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5))
                ),
        onPressed: onPressed,
        child: label.text.white.bold.make(),
      ).objectCenterRight(),
    );
  }
}
