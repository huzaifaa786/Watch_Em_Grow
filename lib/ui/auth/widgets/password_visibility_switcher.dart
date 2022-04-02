import 'package:flutter/material.dart';

class PasswordVisibilitySwitcher extends StatelessWidget {
  final bool visibility;
  final void Function() onPressed;

  const PasswordVisibilitySwitcher({
    Key? key,
    required this.visibility,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      splashColor: Colors.transparent,
      icon: visibility
          ? const Icon(
              Icons.visibility,
            )
          : const Icon(
              Icons.visibility_off,
              color: Colors.grey,
            ),
      onPressed: onPressed,
    );
  }
}
