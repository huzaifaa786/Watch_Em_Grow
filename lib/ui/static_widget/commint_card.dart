// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:mipromo/ui/value/colors.dart';

class CommintsCard extends StatelessWidget {
  const CommintsCard(
      {Key? key,
      })
      : super(key: key); 
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width ,
      decoration: BoxDecoration(
          color: white, borderRadius: BorderRadius.circular(5)),
      child: Padding(
        padding: const EdgeInsets.only(left:10.0,right:10,top:10,bottom: 15),
       child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        Text('COMMINTS(optional)',style:TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Default'),),
        SizedBox(height: 10,),
     Container(
      width: MediaQuery.of(context).size.width*0.9 ,
      height: 70,
      decoration: BoxDecoration(color: Colors.grey[200],border: Border.all(color: textGrey),borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.only(left:15.0,top: 10.0,bottom: 10.0),
        child: Text('Write Commint Here',style: TextStyle(fontFamily: 'Default'),),
),
      ),
      
       ],),
      ),
    );
  }
}
