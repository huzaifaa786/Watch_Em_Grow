import 'package:flutter/material.dart';
import 'package:mipromo/ui/value/colors.dart';

class OrderSummeryCard extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  OrderSummeryCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration:
          BoxDecoration(color: white, borderRadius: BorderRadius.circular(5)),
      child: Padding(
        padding: const EdgeInsets.only(
            left: 15.0, right: 15.0, top: 15.0, bottom: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ORDER SUMMARY',
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontFamily: 'Default')),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tops',
                  style: TextStyle(fontFamily: 'Default'),
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
                    Text(
                      '2500.00',
                      style: TextStyle(fontFamily: 'Default'),
                    ),
                  ],
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Divider(
              thickness: 1,
              color: Color(0xffd09a4e),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Sub Total',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontFamily: 'Default'),
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
                    Text(
                      '2500.00',
                      style: TextStyle(fontFamily: 'Default'),
                    ),
                  ],
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Discount',
                  style: TextStyle(color: hintText, fontFamily: 'Default'),
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
                    Text(
                      '00.00',
                      style: TextStyle(fontFamily: 'Default'),
                    ),
                  ],
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Delivery Fee',
                  style: TextStyle(color: hintText, fontFamily: 'Default'),
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
                    Text(
                      '20.00',
                      style: TextStyle(fontFamily: 'Default'),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
