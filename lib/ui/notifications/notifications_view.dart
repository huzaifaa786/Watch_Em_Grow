import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mipromo/api/database_api.dart';
import 'package:mipromo/models/app_user.dart';
import 'package:mipromo/ui/notifications/notifications_viewmodel.dart';
import 'package:mipromo/ui/profile/seller/seller_profile_viewmodel.dart';
import 'package:mipromo/ui/shared/widgets/avatar.dart';
import 'package:mipromo/ui/shared/widgets/basic_loader.dart';
import 'package:mipromo/ui/shared/widgets/busy_loader.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class NotificationsView extends StatelessWidget {
  final AppUser currentUser;

  NotificationsView({Key? key, required this.currentUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return ViewModelBuilder<NotificationsViewModel>.reactive(
      onModelReady: (model) => model.init(currentUser.id),
      builder: (context, model, child) => model.isBusy
          ? const BasicLoader()
          : model.newNotifications.isEmpty
              ? const Center(
                  child: Text('No Notifications'),
                )
              : Stack(
                  children: [
                    ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: model.newNotifications.length,
                        itemBuilder: (context, index) {
                          String? title;
                          if (model.newNotifications[index].title != "") {
                            title = model.newNotifications[index].title.toString();
                            String tempA = title[0].toUpperCase();
                            title = title.substring(1, title.length).toLowerCase();
                            title = tempA + title;
                          }

                          var body = model.newNotifications[index].body.toString();
                          var bodyA = body[0].toUpperCase();
                          body = body.substring(1, body.length).toLowerCase();
                          body = bodyA + body;

                          if (model.newNotifications[index].orderID == "null") {
                            //model.getFollowings(model.newNotifications[index].userId.toString());
                          }

                          return InkWell(
                            onTap: () {
                              if (model.newNotifications[index].orderID == "null") {
                                model.readNotification(
                                    model.currentUser.id, model.newNotifications[index].id.toString());
                                model.navigateTo(model.newNotifications[index].userId.toString(), index);
                              } else {
                                 model.readNotification(
                                    model.currentUser.id, model.newNotifications[index].id.toString());
                                model.navigateToOrder(model.newNotifications[index].orderID.toString());
                              }
                            },
                            child: Column(
                              children: [
                                if (index == 0) 8.heightBox,
                                Container(
                                  height: size.height * 0.08,
                                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 3),
                                  child: Row(
                                    //assets/images/default.jpeg
                                    children: [
                                      model.newNotifications[index].orderID == "null"
                                          ? model.newNotifications[index].image == ''
                                              ? Container(
                                                  decoration: BoxDecoration(shape: BoxShape.circle),
                                                  child: ClipOval(
                                                    child: SizedBox.fromSize(
                                                      size: Size.fromRadius(23), // Image radius
                                                      child:
                                                          Image.asset('assets/images/default.png', fit: BoxFit.cover),
                                                    ),
                                                  ),
                                                )
                                              : Avatar(
                                                  radius: 25,
                                                  imageUrl: model.newNotifications[index].image.toString(),
                                                )
                                          : Container(
                                              height: size.height * 0.064,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                              ),
                                              child: Image.asset(
                                                "assets/icon/ic_orders.png",
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                      Expanded(
                                          child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            // Text(),
                                            if (title != "" && title != null)
                                              title.toString().text.sm.fontWeight(FontWeight.w600).make(),

                                            model.newNotifications[index].title == 'New order'
                                                ? body
                                                    // .split('on')[0]
                                                    .text
                                                    .sm
                                                    .maxLines(2)
                                                    .make()
                                                : body.text.xs.sm.maxLines(2).make(),
                                          ],
                                        ),
                                      )),
                                      if (model.newNotifications[index].orderID == "null" && title != null)
                                        InkWell(
                                          onTap: model.isFollowing[index]
                                              ? () {
                                                  model.unfollow(
                                                      model.newNotifications[index].userId.toString(), index);
                                                }
                                              : () {
                                                  model.follow(model.newNotifications[index].userId.toString(), index);
                                                },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(5),
                                              color: Color(0xff828CFC),
                                            ),
                                            child: Text(
                                              model.isFollowing[index] ? "Following" : "Follow",
                                              style: TextStyle(fontSize: size.height * 0.014, color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      // if (model.notifications[index].read == false)
                                      //   const Icon(Icons.circle,
                                      //       size: 10, color: Colors.lightBlueAccent)
                                    ],
                                  ),
                                ),
                                Divider(
                                  color: Colors.grey,
                                  height: 8,
                                ),
                              ],
                            ),
                          ); /*.h(65).box.make()*/
                        }),
                    BusyLoader(busy: model.isLoading),
                  ],
                ),
      viewModelBuilder: () => NotificationsViewModel(),
    );
  }
}
