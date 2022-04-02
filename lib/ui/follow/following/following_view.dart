import 'package:flutter/material.dart';
import 'package:mipromo/ui/follow/following/following_viewmodel.dart';
import 'package:mipromo/ui/shared/widgets/avatar.dart';
import 'package:mipromo/ui/shared/widgets/basic_loader.dart';
import 'package:stacked/stacked.dart';

class FollowingView extends StatelessWidget {
  const FollowingView({
    Key? key,
    required this.sellerId,
  }) : super(key: key);

  final String sellerId;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<FollowingViewModel>.reactive(
      onModelReady: (model) => model.init(sellerId),
      builder: (context, model, child) => model.isBusy
          ? const BasicLoader()
          : Scaffold(
              appBar: AppBar(
                title: const Text(
                  'Following',
                ),
              ),
              body: model.users.isEmpty
                  ? const Center(
                      child: Text('No Following yet!'),
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
                            leading: Avatar(
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
      viewModelBuilder: () => FollowingViewModel(),
    );
  }
}
