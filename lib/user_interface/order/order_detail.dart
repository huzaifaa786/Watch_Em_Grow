

import 'package:flutter/material.dart';
import 'package:mipromo/ui/static_widget/top_bar.dart';
import 'package:mipromo/ui/value/colors.dart';
import 'package:mipromo/user_interface/product/top_product.dart';

class OrderDetailScreen extends StatelessWidget {
  const OrderDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: textGrey,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TopBar(
              title: 'Nahida Home Botique',
              onPressed: (){
                Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const TopProductScreen()),
                        );
              },
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 20, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('February 1,2023',style: TextStyle(fontFamily:'Default',)),
                  Text('Amount',
                      style: TextStyle(
                          color: primaryColor, fontWeight: FontWeight.bold,fontFamily: 'Default'))
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text('Order ID:',
                          style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.bold,fontFamily: 'Default')),
                      Text('#167534897212',
                          style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.bold,fontFamily: 'Default')),
                    ],
                  ),
                  Row(
                    children: [
                        Text(
                                  '£ ',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: textGrey,
                                  ),
                                ),
                      Text('50.00',style: TextStyle(fontFamily: 'Default'),),
                    ],
                  )
                ],
              ),
            ),
            Divider(
              color: Colors.grey,
              thickness: 1,
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 20, bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Cancelled',
                        style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,fontFamily: 'Default'),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text('February 1,2023',style: TextStyle(fontFamily: 'Default'),),
                    ],
                  ),
                  Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 30.0,
                  )
                ],
              ),
            ),
            Divider(
              color: Colors.grey,
              thickness: 1,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, top: 25),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 25.0,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Order Placed',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18,fontFamily: 'Default'),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 25.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Colors.grey,
                    size: 25.0,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Order Recieved',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18,fontFamily: 'Default'),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 25.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Colors.grey,
                    size: 25.0,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Rent Period Finish',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18,fontFamily: 'Default'),
                      ),
                      Text(
                        'Due 12/7/2023',
                        style: TextStyle(fontSize: 18,fontFamily: 'Default'),
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: 25.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, bottom: 45.0),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Colors.grey,
                    size: 25.0,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Order Return',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18,fontFamily: 'Default'),
                  )
                ],
              ),
            ),
            Divider(
              color: Colors.grey,
              thickness: 1,
            ),
            Container(
              height: 70,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(left:15.0,top:20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Booking Details',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,fontFamily: 'Default'),),
                      Padding(
                        padding: const EdgeInsets.only(top:10.0),
                        child: Row(
                          children: [
                            Text('Product Name:',style: TextStyle(fontFamily: 'Default'),),
                            Text('My Product',style: TextStyle(fontFamily: 'Default'),),
                          ],
                        ),
                      ),
                      Padding(
                           padding: const EdgeInsets.only(top:10.0),
                        child: Row(
                          children: [
                            Text('Product Price:',style: TextStyle(fontFamily: 'Default'),),
                            Text('50',style: TextStyle(fontFamily: 'Default'),),
                          ],
                        ),
                      ),
                      Padding(
                           padding: const EdgeInsets.only(top:10.0),
                        child: Row(
                          children: [
                            Text('Booking Days:',style: TextStyle(fontFamily: 'Default')),
                            Text('2 days',style: TextStyle(fontFamily: 'Default')),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
              
              ),
          Divider(
              color: Colors.grey,
              thickness: 1,
            ),
SizedBox(height: 20,),
 Row(
                      children: [
                        Expanded(
                          child: MaterialButton(
                            color: const Color(0xffd09a4e),
                           child: const Text(
                              'Ready to return',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,fontFamily: 'Default'
                              ),
                            ),
                            height:45,
                            onPressed: (){
                                Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const TopProductScreen()),
                        );
                            }
                          ),
                        ),
                      ],
                    ),
              
            SizedBox(height: 20,),
             Row(
                      children: [
                        Expanded(
                          child: MaterialButton(
                            color: const Color(0xffd09a4e),
                             child: const Text(
                              'Some Thing Wrong ?',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,fontFamily: 'Default'
                              ),
                            ),
                            height:45,
                            onPressed: (){
                                Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const TopProductScreen()),
                        );
                            }
                          ),
                        ),
                      ],
                    ),
                   
            
          ],
        ),
      )),
    );
  }
}
