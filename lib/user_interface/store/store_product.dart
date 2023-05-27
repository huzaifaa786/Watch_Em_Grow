// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:mipromo/ui/shared/widgets/basic_loader.dart';
import 'package:mipromo/ui/static_widget/product_card.dart';
import 'package:mipromo/ui/static_widget/shope_review_card.dart';
import 'package:mipromo/ui/static_widget/top_bar.dart';
import 'package:mipromo/ui/value/colors.dart';
import 'package:mipromo/user_interface/order/current_screen.dart';
import 'package:mipromo/user_interface/product/product_detail.dart';
import 'package:mipromo/user_interface/product/top_product.dart';

class StoreProductScreen extends StatefulWidget {
  const StoreProductScreen({Key? key}) : super(key: key);

  @override
  State<StoreProductScreen> createState() => _StoreProductScreenState();
}

class _StoreProductScreenState extends State<StoreProductScreen> {
  // bool vertical = false;
  // int index = 0;
  // toggleFun(state) {
  //   print(state);
  //   setState(() {
  //     index = state;
  //   });
  // }
  bool tap = false;
  void didChangeDependencies() {
    precacheImage(AssetImage("assets/images/product2.jpg"), context);
    super.didChangeDependencies();
    const BasicLoader();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
      child: Column(children: [
        TopBar(
            title: 'Store Products',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const TopProductScreen()),
              );
            }),
        ShopReviewCard(),
        Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.5, color: textGrey),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
                left: 10.0, right: 10.0, bottom: 20.0, top: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Filter by Size',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontFamily: 'Default')),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      width: 50,
                      height: 40,
                      decoration: BoxDecoration(
                          border: Border.all(color: textGrey),
                          borderRadius: BorderRadius.circular(20)),
                      child: Center(
                          child: Text(
                        'XXL',
                        style: TextStyle(fontFamily: 'Default'),
                      )),
                    ),
                    Container(
                      width: 50,
                      height: 40,
                      decoration: BoxDecoration(
                          border: Border.all(color: textGrey),
                          borderRadius: BorderRadius.circular(20)),
                      child: Center(
                          child: Text('XL',
                              style: TextStyle(fontFamily: 'Default'))),
                    ),
                    Container(
                      width: 50,
                      height: 40,
                      decoration: BoxDecoration(
                          border: Border.all(color: textGrey),
                          borderRadius: BorderRadius.circular(20)),
                      child: Center(
                          child: Text('L',
                              style: TextStyle(fontFamily: 'Default'))),
                    ),
                    Container(
                      width: 50,
                      height: 40,
                      decoration: BoxDecoration(
                          border: Border.all(color: textGrey),
                          borderRadius: BorderRadius.circular(20)),
                      child: Center(
                          child: Text('M',
                              style: TextStyle(fontFamily: 'Default'))),
                    ),
                    Container(
                      width: 50,
                      height: 40,
                      decoration: BoxDecoration(
                          border: Border.all(color: textGrey),
                          borderRadius: BorderRadius.circular(20)),
                      child: Center(
                          child: Text('S',
                              style: TextStyle(fontFamily: 'Default'))),
                    ),
                    Container(
                      width: 50,
                      height: 40,
                      decoration: BoxDecoration(
                          border: Border.all(color: textGrey),
                          borderRadius: BorderRadius.circular(20)),
                      child: Center(
                          child: Text('XS',
                              style: TextStyle(fontFamily: 'Default'))),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        Row(
          children: [
            Row(
              children: [
                ProductCard(
                  title: 'Fabric Kurti',
                  currency: '£.',
                  price: '1500',
                  image: 'assets/images/product2.jpg',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ProductDetailScreen()),
                    );
                  },
                )
              ],
            ),
            Row(
              children: [
                ProductCard(
                  title: 'Fabric Kurti',
                  currency: '£.',
                  price: "1500",
                  image: 'assets/images/product2.jpg',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ProductDetailScreen()),
                    );
                  },
                )
              ],
            ),
          ],
        ),
        Row(
          children: [
            Row(
              children: [
                ProductCard(
                  title: 'Fabric Kurti',
                  currency: '£.',
                  price: '1500',
                  image: 'assets/images/product2.jpg',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ProductDetailScreen()),
                    );
                  },
                )
              ],
            ),
            Row(
              children: [
                ProductCard(
                  title: 'Fabric Kurti',
                  currency: '£.',
                  price: "1500",
                  image: 'assets/images/product2.jpg',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ProductDetailScreen()),
                    );
                  },
                )
              ],
            ),
          ],
        ),
        Row(
          children: [
            Row(
              children: [
                ProductCard(
                  title: 'Fabric Kurti',
                  currency: '£.',
                  price: '1500',
                  image: 'assets/images/product2.jpg',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ProductDetailScreen()),
                    );
                  },
                )
              ],
            ),
            Row(
              children: [
                ProductCard(
                  title: 'Fabric Kurti',
                  currency: '£.',
                  price: "1500",
                  image: 'assets/images/product2.jpg',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ProductDetailScreen()),
                    );
                  },
                )
              ],
            ),
          ],
        )
      ]),
    )));
  }
}
