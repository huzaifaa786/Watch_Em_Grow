// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:mipromo/ui/value/colors.dart';

class CategorysCard extends StatelessWidget {
  const CategorysCard(
      {Key? key,
    required  this.title,
    required  this.onPressed,
    required this.image})
      : super(key: key);

   final String title;
  final Function() onPressed;
  final String image;
 
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: SizedBox(
        child: Column(children: [
        Padding(
         padding: const EdgeInsets.all(8.0),
         child: Container(
           width:MediaQuery.of(context).size.width* 0.45,
           height:290,
           decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
         image: AssetImage("assets/images/top.jpg"),
         fit: BoxFit.fill,
        ),
           ),
           
         ),
        ),
        Text("Tops",style:TextStyle(fontFamily: 'Default',fontSize:15,fontWeight: FontWeight.bold),),
        ],),
      ),
    );
  }
  
}
