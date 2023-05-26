// // ignore_for_file: prefer_typing_uninitialized_variables, deprecated_member_use

// import 'package:flutter/material.dart';
// import 'package:mipromo/ui/value/colors.dart';

// class GoogleButton extends StatelessWidget {
//   const GoogleButton(
//       {Key? key,
//       @required this.title,
//       @required this.onPressed,
//       this.text,
//       this.textcolor,
//       this.icon='assets/images/google.png',
//       this.sreenRatio = 0.9,
//       this.buttonwidth = 0.37,
//       this.color = primaryTextColor})
//       : super(key: key);

//   final title;
//   final onPressed;
//   final sreenRatio;
//   final color;
//   final text;
//   final textcolor;
//   final icon;
//   final buttonwidth;
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: MediaQuery.of(context).size.width * sreenRatio,

//       child: ElevatedButton(
        
//         onPressed: onPressed,
//        style: ElevatedButton.styleFrom(
//           primary: color,
//           // onPrimary: primaryTextColor,
//             side: const BorderSide(
//                   width: 1.0,
//                   color:textGrey,
//                 ),
//                 shadowColor: null,
//            shape: RoundedRectangleBorder(
            
//               borderRadius: BorderRadius.circular(5.0),
//           ),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.only(top:12.0,bottom: 12.0),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//              Container(
//                height:25,
//                width: 25,
//                decoration: BoxDecoration(
//                    // border: Border.all(color:textGrey),
//                    borderRadius: BorderRadius.circular(20)),
//               child: Image.asset(icon),
//              ),
             
//               Padding(
//                 padding: const EdgeInsets.only(left:60.0),
//                 child: Text(
//                   title,
//                   style: TextStyle(
//                     color: textcolor,
//                     fontSize: 15,
//                     fontWeight: FontWeight.bold,
//                     fontFamily: 'Default'
//                   ),
//                 ),
//               ),
             
//             ],
//           ),
//         ),
//       ),
//     );
//   }

// }
