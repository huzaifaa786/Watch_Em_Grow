import 'package:flutter/material.dart';
import 'package:mipromo/ui/value/colors.dart';

class CartItemCard extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  CartItemCard({
    Key? key,
    required this.itemName,
    required this.itemPrice,
  }) : super(key: key);

  final String itemName;
  final String itemPrice;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10, bottom: 10),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration:
            BoxDecoration(color: white, borderRadius: BorderRadius.circular(5)),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 10.0, top: 10.0, bottom: 10.0),
                  child: Row(
                    children: [
                      Container(
                        height: 55,
                        width: 55,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: ExactAssetImage('assets/images/child.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              itemName,
                              style: TextStyle(
                                  fontSize: 15,
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            Row(
                              children: [
                                Text(
                                  '£',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: textGrey,
                                  ),
                                ),
                                Text(
                                  itemPrice,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: textGrey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                              color: textGrey,
                              borderRadius: BorderRadius.circular(50)),
                          child: const Icon(
                            Icons.remove,
                            size: 15,
                            color: white,
                          )),
                      const SizedBox(
                          width: 30,
                          child: Center(
                              child: Text(
                            '2',
                            style: TextStyle(fontSize: 20),
                          ))),
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                            color: Color(0xffd09a4e),
                            borderRadius: BorderRadius.circular(50)),
                        child: const Icon(
                          Icons.add,
                          size: 15,
                          color: white,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
