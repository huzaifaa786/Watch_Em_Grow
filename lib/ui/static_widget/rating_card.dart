// // ignore_for_file: prefer_typing_uninitialized_variables, prefer_const_constructors

// import 'package:flutter/material.dart';
// import 'package:mipromo/ui/value/colors.dart';

// class RatingCard extends StatelessWidget {
//   const RatingCard(
//       {Key? key,
//       this.title,
//       this.onPressed,
//       this.image = 'assets/images/edit.svg',
//       this.icon,
//       this.subtitle,
//       this.sreenRatio = 0.9,
//       this.color = cardGrey})
//       : super(key: key);

//   final title;
//   final onPressed;
//   final sreenRatio;
//   final color;
//   final image;
//   // final textcolor;
//   final icon;
//   final subtitle;
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onPressed,
//       child: Container(
//         width: MediaQuery.of(context).size.width * 0.9,
//         // height: 200,
//         decoration: BoxDecoration(color:white,
//         borderRadius: BorderRadius.circular(10.0),
//          boxShadow: [
//         BoxShadow(
//           color: Colors.grey.withOpacity(0.5),
//           spreadRadius: 5,
//           blurRadius: 7,
//           offset: Offset(0, 3),
//            // changes position of shadow
//         ),
//         // BoxShadow(
//         //   color: Colors.pinkAccent,
//         //   blurRadius: 4,
//         //   offset: Offset(0, 8), // Shadow position
//         // ),
//       ],
//         ),
//         child: Padding(
//           padding: const EdgeInsets.only(top:5.0,bottom:5),
//           child: Column(
//             children: [
//               Row(
//                 children: [
                  
//                    Padding(
//                      padding: const EdgeInsets.only(left:60.0,top:5.0),
//                      child: RatingStar(),
//                    )
//                 ],
//               ),
//               Stack(
//                 // overflow: Overflow.visible,
//                 alignment: AlignmentDirectional.centerStart,
//                 fit: StackFit.loose,
//                 children: <Widget>[
//                   Divider(
//                     thickness: 2,
//                     color: textGrey,
//                   ),
//                   Positioned(
//                     // top: 15,
//                     child: Row(
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.only(left:10.0),
//                           child: const CircleAvatar(
//                             radius: 25,
//                             backgroundImage: AssetImage("assets/images/product.jpg"),
//                           ),
//                         ),
//                         SizedBox(
//                           width: MediaQuery.of(context).size.width * 0.1,
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.only(top:30.0),
//                           child: const Text('@mishope',style: TextStyle(fontSize:15),),
//                         )
//                       ],
//                     ),
//                   )
//                 ],
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(left:8.0,right:8.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Row(
//                       children: [
//                         const Text("minkendsuit",style: TextStyle(fontSize: 15),),
//                       ],
//                     ),
//                     Row(
//                       children: [
//                         Column(
//                           children: [
//                             const Text('5',style:TextStyle(color: primaryColor,fontSize: 15),),
//                             const Text('Reviews',style:TextStyle(color:Colors.grey,fontSize: 15)),
                           
//                             const Text('50',style:TextStyle(color:primaryColor,fontSize: 15)),
//                             const Text('Bundle Pack',style:TextStyle(color:Colors.grey,fontSize: 15))
//                           ],
//                         )
//                       ],
//                     )
//                   ],
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
