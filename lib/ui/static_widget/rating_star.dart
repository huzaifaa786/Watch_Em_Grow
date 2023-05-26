// import 'package:flutter/material.dart';
// class RatingStar extends StatelessWidget {
//   final double initialRating;
//   const RatingStar(
//       {Key? key,
//       this.initialRating = 0.0
//       // this.mainheight = 50,
//       })
//       : super(key: key);


//   @override
//   Widget build(BuildContext context) {
//     return RatingBar.builder(
//    initialRating: 3,
//    minRating: 1,
//    direction: Axis.horizontal,
//    allowHalfRating: true,
//    itemCount: 5,
//    itemSize: 20,
//    itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
//    itemBuilder: (context, _) => Icon(
//      Icons.star,
//      color: Colors.amber,
//    ),
//    onRatingUpdate: (rating) {
//      print(rating);
//    },
// );
//   }
// }