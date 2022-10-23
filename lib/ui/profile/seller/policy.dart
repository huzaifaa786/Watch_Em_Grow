import 'package:flutter/material.dart';

class PolicyScreen extends StatelessWidget {
   PolicyScreen({Key? key,required this.policy}) : super(key: key);
  String policy;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Policy'),
      ),
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.height ,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [ Container(
                  margin: EdgeInsets.only(left: 20,right: 20,top: 30),
                child:  policy.isNotEmpty ?
                 Text(policy,style: TextStyle(color: Colors.black.withOpacity(0.7),fontSize: 17),textAlign: TextAlign.justify,): Text("No Policy",style: TextStyle(color: Colors.black.withOpacity(0.7),fontSize: 17),textAlign: TextAlign.justify,)),
              
              ],
            ),
          ),
        ),
      ),
    );
  }
}
