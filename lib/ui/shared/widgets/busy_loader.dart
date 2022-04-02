import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class BusyLoader extends StatelessWidget {
  final bool busy;

  const BusyLoader({
    Key? key,
    required this.busy,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: child,
      ),
      child: busy
          ? SizedBox(
              key: UniqueKey(),
              width: context.screenWidth,
              height: context.screenHeight,
              child: Material(
                color: Colors.black.withOpacity(0.3),
                child: const Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            )
          : SizedBox.shrink(
              key: UniqueKey(),
            ),
    );
  }
}
