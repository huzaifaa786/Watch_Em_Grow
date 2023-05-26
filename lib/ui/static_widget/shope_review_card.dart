import 'package:flutter/material.dart';
import 'package:mipromo/ui/value/colors.dart';

class ShopReviewCard extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  ShopReviewCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color:pink,
        border: Border(
          bottom: BorderSide(width: 1.5,color: textGrey),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left:10.0,top:10.0),
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
                        border: Border.all(color: hintText),
                       borderRadius: BorderRadius.circular(10)
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left:15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        
                        children: [
                          Row(
                            children: [
                              Text(
                                'Nahis Fabric company',
                                style: TextStyle(fontSize: 15, color: primaryColor,fontWeight:FontWeight.bold),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: Colors.orange,
                              ),
                              Text(
                                '4.3',
                                style: TextStyle(fontSize: 15, color: primaryColor),
                              ),
                              Text(
                                '(131 review)',
                                style: TextStyle(fontSize: 15, color: primaryColor),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right:10.0),
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(shape: BoxShape.circle ,
                      color:white,
                      ),
                      child: Icon(
                        Icons.favorite,
                        color: Colors.red,
                      ),
                    ),
                  
                  )
                ],
              ),
            ],
          ),
          SizedBox(
            height: 40,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10.0,right:10.0),
              child: Text(
                'Member Since 2021',
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 14, color: Color(0xff666666)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
