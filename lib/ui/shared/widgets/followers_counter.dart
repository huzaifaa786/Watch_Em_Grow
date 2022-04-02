import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class FollowersCounter extends StatelessWidget {
  final bool richText;
  final int followers;

  const FollowersCounter({
    Key? key,
    this.richText = true,
    required this.followers,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const followersLabel = 'Followers';
    final shortFollowers = (followers / 1000).toDoubleStringAsFixed(digit: 1);

    if (richText) {
      return (followers > 999 ? "${shortFollowers}k" : "$followers")
          .richText
          .center
          .withTextSpanChildren([
        "\n$followersLabel"
            .textSpan
            .size(12)
            .color(
              Colors.grey,
            )
            .make()
      ]).make();
    } else {
      return (followers > 999
              ? "${shortFollowers}k $followersLabel"
              : "$followers $followersLabel")
          .text
          .color(Colors.grey)
          .xs
          .make();
    }
  }
}
