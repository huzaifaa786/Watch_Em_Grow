import 'package:flutter/material.dart';
import 'package:mipromo/ui/static_widget/shop_card.dart';
import 'package:mipromo/ui/value/colors.dart';
import 'package:mipromo/user_interface/store/store_product.dart';

class TopProductScreen extends StatefulWidget {
  const TopProductScreen({Key? key}):super(key: key);

  @override
  _TopProductScreenState createState() => _TopProductScreenState();
}

class _TopProductScreenState extends State<TopProductScreen> {
  void didChangeDependencies() {
    precacheImage(AssetImage("assets/images/product3.jpg"), context);
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                  children: [
                    Container(
              width: MediaQuery.of(context).size.width,
              height: 80,
              decoration: BoxDecoration(color: Color(0xffd09a4e)),
              child: Center(
                  child: Text(
                'Tops',
                style: TextStyle(color: white, fontSize: 25,fontWeight: FontWeight.bold,fontFamily: 'Default'),
              ))),
                    SizedBox(
                      height: 20,
                    ),
                    ShopeCard(
                       onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const StoreProductScreen()),
                        );
                      },
                      image: 'assets/images/product3.jpg',
                      onTap: (){},
                    ),
                    SizedBox(height:10,),
                    ShopeCard(
                       onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const StoreProductScreen()),
                        );
                      },
                      image: 'assets/images/product3.jpg',
                      onTap: (){},
                    ),
                    SizedBox(height:10,),
                   ShopeCard(
                       onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const StoreProductScreen()),
                        );
                      },
                      image: 'assets/images/product3.jpg',
                      onTap: (){},
                    ),
                    SizedBox(height:10,),
                    ShopeCard(
                       onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const StoreProductScreen()),
                        );
                      },
                      image: 'assets/images/product3.jpg',
                      onTap: (){},
                    ),
                  ],
                ),
            )));
  }
}
