// import 'package:dropdown_button2/dropdown_button2.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:watch_em_grow/values/colors.dart';

// class DropdownField extends StatelessWidget {
//   const DropdownField(
//       {Key? key,
//       this.controller,
//       this.selectedvalue,
//       this.text,
//       this.icon,
//       this.imageIcon,
//       this.color = secondaryColor,
//       this.items,
//       this.maxlines = false,
//       this.onChange,
//       this.type = TextInputType.text,
//       this.onpressed})
//       : super(key: key);

//   final controller;
//   final List<String>? items;
//   final selectedvalue;
//   final type;
//   final text;
//   final icon;
//   final imageIcon;
//   final color;
//   final maxlines;
//   final onChange;
//   final onpressed;

//   @override
//   Widget build(BuildContext context) {
//     // bool isDark = Provider.of<DarkThemeProvider>(context).darkTheme;

//     return LayoutBuilder(builder: (context, constraints) {
//       bool largeScreen = constraints.maxWidth > 900;
//       var screenWidth = MediaQuery.of(context).size.width;
//       return DropdownButtonHideUnderline(
//         child: DropdownButton2(
//           hint: Text(
//             text,
//             style: TextStyle(
//               fontSize: 17,
//               color: Theme.of(context).hintColor,
//             ),
//           ),
//           items: items!
//               .map((item) => DropdownMenuItem<String>(
//                     value: item,
//                     child: Text(
//                       item,
//                       style: const TextStyle(
//                         fontSize: 14,
//                       ),
//                     ),
//                   ))
//               .toList(),
//           value: selectedvalue,
//           onChanged: (value) {
//             onChange(value);
//           },
//           buttonHeight: 40,
//           buttonWidth: !largeScreen
//               ? MediaQuery.of(context).size.width * 0.9
//               : MediaQuery.of(context).size.width,
//           itemHeight: 40,
//           icon: icon,
//         ),
//       );
//     });
//   }
// }
