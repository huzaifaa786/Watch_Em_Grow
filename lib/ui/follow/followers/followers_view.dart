import 'package:flutter/material.dart';
import 'package:mipromo/ui/follow/followers/followers_viewmodel.dart';
import 'package:mipromo/ui/shared/widgets/basic_loader.dart';
import 'package:stacked/stacked.dart';

import '../../shared/widgets/avatar.dart';

class FollowersView extends StatelessWidget {
  const FollowersView({
    Key? key,
    required this.sellerId,
  }) : super(key: key);

  final String sellerId;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<FollowersViewModel>.reactive(
      onModelReady: (model) => model.init(sellerId),
      builder: (context, model, child) => model.isBusy
          ? const BasicLoader()
          : Scaffold(
              appBar: AppBar(
                title: const Text(
                  'Followers',
                ),
              ),
              body: model.users.isEmpty
                  ? const Center(
                      child: Text('No Followers yet!'),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: model.users.length,
                      itemBuilder: (context, index) => Column(
                        children: [
                          ListTile(
                            onTap: () {
                              if(model.users[index].shopId.isNotEmpty){
                                print("is SELLER");
                                model.navigateToShopView(
                                  owner: model.users[index],
                                );
                              }else{
                                print("is BUYER");
                                model.navigateToBuyerView(
                                  owner: model.users[index],
                                );
                              }

                            },
                            leading:   model.users[index].imageUrl == ''
                                              ? Container(
                                                  decoration: BoxDecoration( shape: BoxShape.circle),
                                                  child: ClipOval(
                                                    child: SizedBox.fromSize(
                                                      size: Size.fromRadius(25), // Image radius
                                                      child:
                                                          Image.asset('assets/images/default.jpeg', fit: BoxFit.cover),
                                                    ),
                                                  ),
                                                )
                                              :  Avatar(
                              radius: 25,
                              imageUrl: model.users[index].imageUrl,
                            ),
                            title: Text(
                              model.users[index].username,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Divider(),
                        ],
                      ),
                    ),
            ),
      viewModelBuilder: () => FollowersViewModel(),
    );
  }
}
