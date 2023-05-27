// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard(
      {Key? key,
    required  this.title,
    required  this.onPressed,
    required this.image 
   })
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
           height:130,
           decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
         image: AssetImage(image),
         fit: BoxFit.fill,
        ),
           ),
           
         ),
        ),
        Text(title,style:TextStyle(fontFamily: 'Default',fontSize:15,fontWeight: FontWeight.bold),),
        ],),
      ),
    );
  }
  
}
