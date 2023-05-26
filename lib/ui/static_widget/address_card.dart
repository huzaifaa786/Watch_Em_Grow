// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:mipromo/ui/value/colors.dart';

class AddressCard extends StatelessWidget {
  const AddressCard(
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
        padding: const EdgeInsets.only(left:10.0,right:10,top:5,bottom: 15),
       child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
          Text('DELIVERY ADDRES',style:TextStyle(fontWeight: FontWeight.bold),),
          Container(width:30,
          height: 30,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color:Colors.grey[200]),
          child: Icon(Icons.edit,size: 15,),
          ),
        ],),
        Row(children: [
          Container(width: 50,
          height: 50,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),
          border: Border.all(color: textGrey)
          ),
          child: Icon(Icons.location_on,color: Color(0xffd09a4e),),
          ),
          Padding(
            padding: const EdgeInsets.only(left:10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('DHA PHASE 3',style: TextStyle(fontWeight: FontWeight.bold),),
                SizedBox(
                  width: MediaQuery.of(context).size.width*0.6,
                  child: Text('House #62 main street 32 block 9D Lahore ',style: TextStyle(color: hintText),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],)

       ],),
      ),
    );
  }
}
