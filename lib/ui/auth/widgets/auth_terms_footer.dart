import 'package:flutter/material.dart';
import 'package:mipromo/ui/shared/helpers/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';

class AuthTermsFooter extends StatelessWidget {
  const AuthTermsFooter({
    Key? key,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  final bool value;
  final void Function(bool?) onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
        ),
        Flexible(
          child: "".richText.xs.withTextSpanChildren([
            Constants.bySigningLabel.textSpan.gray500.make(),
            Constants.tAndCLabel.textSpan.tap(() async {
              await launch('https://www.sadje.org/copy-of-privacy');
            }).underline.make(),
            Constants.andLabel.textSpan.gray500.make(),
            Constants.privacyPolicyLabel.textSpan.tap(() async {
              await launch('https://www.sadje.org/privacy');
            }).underline.make(),
          ]).make(),
        ),
      ],
    ).p12();
  }
}
