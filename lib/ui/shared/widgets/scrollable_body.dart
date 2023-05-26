import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class ScrollableBody extends StatelessWidget {
  final List<Widget> children;

  /// Creates a body to build a form inside it
  const ScrollableBody({
    Key? key,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: SizedBox(
        height: context.screenHeight,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.screenWidth / 18,
          ),
          child: Column(
            children: children,
          ),
        ),
      ),
    );
  }
}
