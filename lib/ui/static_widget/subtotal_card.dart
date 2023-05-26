import 'package:flutter/material.dart';
import 'package:mipromo/ui/value/colors.dart';
class SubTotalCard extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  SubTotalCard({
    Key? key,

  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width ,
      decoration:
          BoxDecoration(color: white, borderRadius: BorderRadius.circular(5)),
      child: Padding(
        padding: const EdgeInsets.only(left:15.0,right: 15.0,top:15.0,bottom: 15.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              Text('Sub Total',style: TextStyle(fontWeight: FontWeight.bold),),
              Row(
                children: [
                   Text('£ ',style: TextStyle(
                                    fontSize: 15,
                                    color: textGrey,
                                    
                                  ),),
                  Text('2500.00'),
                ],
              )
            ],),
            SizedBox(height: 10,),
             Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              Text('Discount',style: TextStyle(color: hintText),),
              Row(
                children: [
                    Text(
                                  '£ ',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: textGrey,
                                  ),
                                ),
                  Text('00.00'),
                ],
              )
            ],),
            SizedBox(height: 10,),
             Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              const Text('Delivery Fee',style: TextStyle(color: hintText),),
              Row(
                children: [
                  Text(
                                  '£ ',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: textGrey,
                                  ),
                                ),
                  const Text('20.00'),
                ],
              )
            ],),
            
        
          ],
        ),
      ),
    );
  }
}
