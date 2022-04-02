import 'package:flutter/material.dart';
import 'package:mipromo/ui/shared/helpers/styles.dart';

class BusyButton extends StatefulWidget {
  final double height;
  final double width;
  final IconData icon;
  final bool busy;
  final void Function() onPressed;

  const BusyButton({
    this.height = 60,
    this.width = 60,
    this.icon = Icons.arrow_forward,
    this.busy = false,
    required this.onPressed,
  });

  @override
  BusyButtonState createState() => BusyButtonState();
}

class BusyButtonState extends State<BusyButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: MaterialButton(
        padding: const EdgeInsets.all(8),
        color: Styles.kcPrimaryColor,
        disabledColor: Colors.grey[300],
        elevation: 12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        onPressed: widget.onPressed,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: animation,
              child: child,
            ),
          ),
          child: !widget.busy
              ? Icon(
                  widget.icon,
                  key: UniqueKey(),
                )
              : CircularProgressIndicator(
                  key: UniqueKey(),
                  strokeWidth: 2,
                ),
        ),
      ),
    );
  }
}
