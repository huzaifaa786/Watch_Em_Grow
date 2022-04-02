import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';

class StarRatings extends StatelessWidget {
  final double rating;
  final int color;
  final double spacing;
  final double size;
  const StarRatings({
    Key? key,
    required this.rating,
    required this.color,
    this.spacing = 1,
    this.size = 20,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RatingStars(
      value: rating,
      starSpacing: spacing,
      starSize: size,
    );
  }
}
