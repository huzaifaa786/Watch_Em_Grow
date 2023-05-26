// // ignore_for_file: prefer_const_constructors

// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';

// class MCheckBox extends StatefulWidget {
//   const MCheckBox({Key? key, this.checkbox = false,
//   this.text, 
//   required Function this.onchanged
  
//   }) : super(key: key);
//   final checkbox;
//   final onchanged;
//   final text;
//   @override
//   State<MCheckBox> createState() => _MCheckBoxState(onchanged);
// }

// class _MCheckBoxState extends State<MCheckBox> {
//   final Function onchanged;

//   _MCheckBoxState(Function this.onchanged) {}

//   changeValue() {
//     onchanged();
//   }
  

//   @override
//   Widget build(BuildContext context) {
   
//     return CheckboxListTile(
//       controlAffinity: ListTileControlAffinity.leading,
//       checkColor: Colors.white,
//       activeColor: primaryColor,
//       title: RichText(
//         textAlign: TextAlign.start,
//         text: TextSpan(
//           // ignore: prefer_const_literals_to_create_immutables
//           children: [
//             TextSpan(text:'I agree to the' ,style: TextStyle(
//             color: hintText,
//             fontSize: 14,
//             fontFamily: 'Default'
//           ),),
//             TextSpan(text: ' Privacy Policy ',style: TextStyle(fontWeight: FontWeight.w600,color:primaryColor, fontSize: 14,
//             fontFamily: 'Default'),
//             recognizer: TapGestureRecognizer()
//               ..onTap = () {
//                Navigator.pushNamed(context, 'privacy');
//               }),
//                 TextSpan(text: ' ,',style: TextStyle(
//             color: hintText,
//             fontSize: 12,
//           ),),
//            TextSpan(text: 'Terms of User',style: TextStyle(fontWeight: FontWeight.w600,color:primaryColor, fontSize: 14,
//             fontFamily: 'Default'),
//             recognizer: TapGestureRecognizer()
//               ..onTap = () {
//                Navigator.pushNamed(context, 'terms');
//               }),
//                TextSpan(text: ' and ',style: TextStyle(
//             color: hintText,
//              fontSize: 14,
//             fontFamily: 'Default'
//           ),),
//                 TextSpan(text: 'Terms of Service',style: TextStyle(fontWeight: FontWeight.w600,color:primaryColor, fontSize: 14,
//             fontFamily: 'Default'),
//             recognizer: TapGestureRecognizer()
//               ..onTap = () {
//                Navigator.pushNamed(context, 'terms');
//               }),
//           ]
//         ),
//       ),
//       value: widget.checkbox,
//       onChanged: (value) {
//         changeValue();
//       },
//     );
//   }
// }
            