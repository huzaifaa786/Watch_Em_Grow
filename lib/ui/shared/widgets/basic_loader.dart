import 'package:flutter/material.dart';

class BasicLoader extends StatelessWidget {
  final bool background;

  const BasicLoader({
    Key? key,
    this.background = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => background
      ? Material(
          child: progressIndicator,
        )
      : progressIndicator;
}

Widget progressIndicator = const Center(
  child: CircularProgressIndicator(
    strokeWidth: 2,
  ),
);
