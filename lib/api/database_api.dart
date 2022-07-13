import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:booking_calendar/booking_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mipromo/exceptions/database_api_exception.dart';
import 'package:mipromo/models/app_user.dart';
import 'package:mipromo/models/book_service.dart';
import 'package:mipromo/models/chat.dart';
import 'package:mipromo/models/follow.dart';
import 'package:mipromo/models/notification.dart';
import 'package:mipromo/models/order.dart';
import 'package:mipromo/models/shop.dart';
import 'package:mipromo/models/shop_service.dart';
import 'package:mipromo/ui/notifications/notification_model.dart';
import 'package:mipromo/ui/shared/helpers/enums.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../exceptions/database_api_exception.dart';

class DatabaseApi {
  static final _firestore = FirebaseFirestore.instance;

  final CollectionReference _usersCollection = _firestore.collection("users");
  final CollectionReference _ordersCollection = _firestore.collection("orders");
  final CollectionReference _shopsCollection = _firestore.collection("shops");
  final CollectionReference _serviceChargesCollection = _firestore.collection("serviceCharges");
  final CollectionReference _disputesCollection = _firestore.collection("disputes");
  final CollectionReference _contactMessages = _firestore.collection("contactMessages");
  final CollectionReference _reportCollection = _firestore.collection("reports");
  final CollectionReference _servicesCollection = _firestore.collection("services");
  final CollectionReference _chatsCollection = _firestore.collection("chats");
  final CollectionReference _chatRoomCollection = _firestore.collection("chatRoom");
  final CollectionReference _followCollection = _firestore.collection("follow");
  final CollectionReference _bookingsCollection = _firestore.collection("bookings");

  // * Controllers

  // * User Controllers
  final StreamController<AppUser> _userController = StreamController<AppUser>.broadcast();

  final StreamController<List<AppUser>> _usersController = StreamController<List<AppUser>>.broadcast();

  final StreamController<List<AppUser>> _shopOwnersController = StreamController<List<AppUser>>.broadcast();

  // * Shop Controllers
  final StreamController<Shop> _shopController = StreamController<Shop>.broadcast();

  final StreamController<List<Shop>> _shopsController = StreamController<List<Shop>>.broadcast();

  // * Service Controller
  final StreamController<List<ShopService>> _servicesController = StreamController<List<ShopService>>.broadcast();

  final StreamController<List<ShopService>> _allServicesController = StreamController<List<ShopService>>.broadcast();

  // * Chats Controller
  final StreamController<List<Chat>> _chatsController = StreamController<List<Chat>>.broadcast();

  final StreamController<List<Chat>> _currentUserChatsController = StreamController<List<Chat>>.broadcast();

  final StreamController<List<AppUser>> _usersChatsController = StreamController<List<AppUser>>.broadcast();

  final StreamController<List<Follow>> _followController = StreamController<List<Follow>>.broadcast();

  final StreamController<List<Order>> _boughtOrder = StreamController<List<Order>>.broadcast();
  final StreamController<List<Order>> _soldOrder = StreamController<List<Order>>.broadcast();
  // * Create
  /// Creates a User document inside the users collection with User Id as Document Id
  Future<void> createUser(AppUser user) async {
    try {
      await _usersCollection.doc(user.id).set(user.toJson());
    } on PlatformException catch (e) {
      throw DatabaseApiException(
        title: 'Failed to create User',
        message: e.message,
      );
    }
  }

  Future<void> updateUserToken(String uid, String token) async {
    try {
      await _usersCollection.doc(uid).update({'token': token});
    } on PlatformException catch (e) {
      throw DatabaseApiException(
        title: 'Failed to update User token',
        message: e.message,
      );
    }
  }

  Future<void> createShop(Shop shop) async {
    try {
      await _shopsCollection.doc(shop.id).set(shop.toJson());
    } on PlatformException catch (e) {
      throw DatabaseApiException(
        title: 'Failed to create Shop',
        message: e.message,
      );
    }
  }

  Future<void> createService(ShopService service) async {
    try {
      await _servicesCollection.doc(service.id).set(service.toJson());
    } on PlatformException catch (e) {
      throw DatabaseApiException(
        title: 'Failed to create Service',
        message: e.message,
      );
    }
  }

  Future<void> follow({
    required String currentUserId,
    required String userId,
  }) async {
    await _followCollection.doc(currentUserId).collection('following').doc(userId).set({'id': userId});

    await _usersCollection.doc(currentUserId).update({'following': FieldValue.increment(1)});

    await _followCollection.doc(userId).collection('followers').doc(currentUserId).set({'id': currentUserId});

    await _usersCollection.doc(userId).update({'followers': FieldValue.increment(1)});
  }

  Future<void> unfollow({
    required String currentUserId,
    required String userId,
  }) async {
    await _followCollection.doc(currentUserId).collection('following').doc(userId).delete();

    await _usersCollection.doc(currentUserId).update({'following': FieldValue.increment(-1)});

    await _followCollection.doc(userId).collection('followers').doc(currentUserId).delete();

    await _usersCollection.doc(userId).update({'followers': FieldValue.increment(-1)});
  }

  // * Read
  /// Get the current user's data
  Future<AppUser> getUser(String userId) async {
    try {
      final userDoc = await _usersCollection.doc(userId).get();

      if (!userDoc.exists) {}
      final userData = userDoc.data()! as Map<String, dynamic>;
      return AppUser.fromJson(userData);
    } on PlatformException catch (e) {
      throw DatabaseApiException(
        title: 'Failed to get User Data',
        message: e.message,
      );
    }
  }

  Future<AppUser> getUserLogin(String userId) async {
    try {
      final userDoc = await _usersCollection.doc(userId).get();

      if (!userDoc.exists) {
        return AppUser(token: '123', id: '123');
      } else {
        final userData = userDoc.data()! as Map<String, dynamic>;
        return AppUser.fromJson(userData);
      }
    } on PlatformException catch (e) {
      throw DatabaseApiException(
        title: 'Failed to get User Data',
        message: e.message,
      );
    }
  }

  Future<double> getAllEarnings(String shopID) async {
    try {
      double totalSale = 0.0;
      final ordersList = await _ordersCollection.get();
      final orders = ordersList.docs
          .map((snapshot) => Order.fromJson(
                snapshot.data()! as Map<String, dynamic>,
              ))
          .toList();

      for (var item in orders) {
        if (item.shopId == shopID) {
          if (item.status == OrderStatus.completed) {
            DateTime a = DateTime.fromMicrosecondsSinceEpoch(item.time);
            if (a.isAfter(DateTime.now().subtract(Duration(days: 60)))) {
         
              totalSale = totalSale + item.service.price;
            }
          }
        }
      }
      return totalSale;
    } on PlatformException catch (e) {
      throw DatabaseApiException(
        title: 'Failed to get User Data',
        message: e.message,
      );
    }
  }

  Future<void> sendReport(AppUser currentUser, Shop? shop, String type) async {
    await _reportCollection.doc(shop!.ownerId).set({
      "reportBy": currentUser.id,
      "reported": shop.ownerId,
      "shopID": shop.id,
      "type": type,
      "time": DateTime.now().millisecondsSinceEpoch
    }).then((value) {
      return true;
    });
  }

    Future<void> sendReportBuyer(AppUser currentUser, AppUser? otherUser, String type) async {
    await _reportCollection.doc(otherUser!.id).set({
      "reportBy": currentUser.id,
      "reported": otherUser.id,
      "shopID": '',
      "type": type,
      "time": DateTime.now().millisecondsSinceEpoch
    }).then((value) {
      return true;
    });
  }
  

  ///get seller paypal account
  Future<String?> getSellerPaypal(String userId) async {
    try {
      final userDoc = await _usersCollection.doc(userId).get();

      if (!userDoc.exists) {
        return null;
      }
      final userData = userDoc.data()! as Map<String, dynamic>;
      return userData['paypalMail'].toString();
    } on PlatformException catch (e) {
      throw DatabaseApiException(
        title: 'Failed to get User Data',
        message: e.message,
      );
    }
  }

  /// Get a Shop's data
  Future<Shop> getShop(String shopId) async {
    try {
      final shopDocumentSnapshot = await _shopsCollection.doc(shopId).get();
      final shopData = shopDocumentSnapshot.data()! as Map<String, dynamic>;
      return Shop.fromJson(shopData);
    } on PlatformException catch (e) {
      throw DatabaseApiException(
        title: 'Failed to get Shop Data',
        message: e.message,
      );
    }
  }

  /// Get all Services of a Shop
  Future<List<ShopService>> getShopServices(String shopId) async {
    try {
      final servicesCollectionSnapshot = await _servicesCollection.get();

      final services = servicesCollectionSnapshot.docs
          .map(
            (servicesData) => ShopService.fromJson(servicesData.data()! as Map<String, dynamic>),
          )
          .toList();

      return services;
    } on PlatformException catch (e) {
      throw DatabaseApiException(
        title: 'Failed to get Services Data',
        message: e.message,
      );
    }
  }

  Future<double> getProcessingFee() async {
    try {
      final shopDocumentSnapshot = await _serviceChargesCollection.doc('1').get();
      final shopData = shopDocumentSnapshot.data()! as Map<String, dynamic>;
      return double.parse(shopData['processingFee'].toString());
    } on PlatformException catch (e) {
      throw DatabaseApiException(
        title: 'Failed to get getProcessingFee',
        message: e.message,
      );
    }
  }

  Future<List<AppUser>> getAllUsers() async {
    try {
      final usersDoc = await _usersCollection.get();

      final users = usersDoc.docs
          .map((snapshot) => AppUser.fromJson(
                snapshot.data()! as Map<String, dynamic>,
              ))
          .toList();

      return users;
    } catch (e) {
      throw DatabaseApiException(title: '');
    }
  }

  Future<List<Follow>> getFollowers(String userId) async {
    final followData = await _followCollection.doc(userId).collection('followers').get();
    final follows = followData.docs
        .map((snapshot) => Follow.fromJson(
              snapshot.data(),
            ))
        .toList();

    return follows;
  }

  Future<List<Follow>> getMyFollowers(String userId) async {
    final followData = await _followCollection.doc(userId).collection('following').get();
    final follows = followData.docs
        .map((snapshot) => Follow.fromJson(
              snapshot.data(),
            ))
        .toList();

    return follows;
  }

  Future<List<Follow>> getFollowing(String userId) async {
    final followData = await _followCollection.doc(userId).collection('following').get();
    final follows = followData.docs
        .map((snapshot) => Follow.fromJson(
              snapshot.data(),
            ))
        .toList();

    return follows;
  }

  // * Update

  Future<void> updateUsername({
    required String userId,
    required String username,
  }) async {
    try {
      await _usersCollection.doc(userId).update({
        "username": username,
      });
    } on PlatformException catch (e) {
      throw DatabaseApiException(
        title: 'Failed to create username',
        message: e.message,
      );
    }
  }
  Future<void> updateSkip({
    required String userId,
    required int skip,
  }) async {
    try {
      await _usersCollection.doc(userId).update({
        "skip": skip,
      });
    } on PlatformException catch (e) {
      throw DatabaseApiException(
        title: 'Failed to create username',
        message: e.message,
      );
    }
  }

  Future<void> createUserInfo({
    required String userId,
    required String username,
    required String firstName,
    required String lastName,
  }) async {
    try {
      await _usersCollection
          .doc(userId)
          .update({"username": username, "fullName": firstName.trim() + " " + lastName.trim()});
    } on PlatformException catch (e) {
      throw DatabaseApiException(
        title: 'Failed to create username',
        message: e.message,
      );
    }
  }

  Future<void> updateAddress({
    required String userId,
    required String fullName,
    required String address,
    required String postCode,
  }) async {
    try {
      await _usersCollection.doc(userId).update({"fullName": fullName, "address": address, 'postCode': postCode});
    } on PlatformException catch (e) {
      throw DatabaseApiException(
        title: 'Failed to update address.',
        message: e.message,
      );
    }
  }

  Future<void> updatePostCode({
    required String userId,
    required String postCode,
  }) async {
    try {
      await _usersCollection.doc(userId).update({
        "postCode": postCode,
      });
    } on PlatformException catch (e) {
      throw DatabaseApiException(
        title: 'Failed to update postCode.',
        message: e.message,
      );
    }
  }

  Future<void> updateProfileImageData({
    required String userId,
    required String profileImageFileName,
    required String profileImageUrl,
  }) async {
    try {
      await _usersCollection.doc(userId).update({
        "imageId": profileImageFileName,
        "imageUrl": profileImageUrl,
      });
    } on PlatformException catch (e) {
      throw DatabaseApiException(
        title: 'Failed to update image data',
        message: e.message,
      );
    }
  }

  Future<void> createSellerAccount({
    required String userId,
    required String fullName,
    required String phoneNumber,
    required String dateOfBirth,
    required String paypalMail,
  }) async {
    try {
      await _usersCollection.doc(userId).update({
        "fullName": fullName,
        "phoneNumber": phoneNumber,
        "dateOfBirth": dateOfBirth,
        "paypalMail": paypalMail,
        "userType": "seller",
      });
    } on PlatformException catch (e) {
      throw DatabaseApiException(
        title: 'Failed to create seller account',
        message: e.message,
      );
    }
  }

  Future<void> updateShopName(
    String shopId,
    String name,
  ) async {
    try {
      await _shopsCollection.doc(shopId).update(
        {
          'name': name,
        },
      );
    } on PlatformException catch (e) {
      throw DatabaseApiException(
        title: 'Failed to create Shop',
        message: e.message,
      );
    }
  }

  Future<void> updateShopDescription(
    String shopId,
    String description,
  ) async {
    try {
      await _shopsCollection.doc(shopId).update(
        {
          'description': description,
        },
      );
    } on PlatformException catch (e) {
      throw DatabaseApiException(
        title: 'Failed to create Shop',
        message: e.message,
      );
    }
  }

  Future<void> updateShopCategory(
    String shopId,
    String category,
  ) async {
    try {
      await _shopsCollection.doc(shopId).update(
        {
          'category': category,
        },
      );
    } on PlatformException catch (e) {
      throw DatabaseApiException(
        title: 'Failed to create Shop',
        message: e.message,
      );
    }
  }

  Future<void> updateShoplocation(
    String shopId,
    String location,
  ) async {
    try {
      await _shopsCollection.doc(shopId).update(
        {
          'location': location,
        },
      );
    } on PlatformException catch (e) {
      throw DatabaseApiException(
        title: 'Failed to create Shop',
        message: e.message,
      );
    }
  }

  Future<void> updateShopBorough(
    String shopId,
    String borough,
  ) async {
    try {
      await _shopsCollection.doc(shopId).update(
        {
          'borough': borough,
        },
      );
    } on PlatformException catch (e) {
      throw DatabaseApiException(
        title: 'Failed to create Shop',
        message: e.message,
      );
    }
  }

  Future<void> updateShopAddress(
    String shopId,
    String address,
  ) async {
    try {
      await _shopsCollection.doc(shopId).update(
        {
          'address': address,
        },
      );
    } on PlatformException catch (e) {
      throw DatabaseApiException(
        title: 'Failed to create Shop',
        message: e.message,
      );
    }
  }

  Future<void> updateShopFontStyle(
    String shopId,
    String fontStyle,
  ) async {
    try {
      await _shopsCollection.doc(shopId).update(
        {
          'fontStyle': fontStyle,
        },
      );
    } on PlatformException catch (e) {
      throw DatabaseApiException(
        title: 'Failed to create Shop',
        message: e.message,
      );
    }
  }

  Future<void> updateShopColor(
    String shopId,
    int color,
  ) async {
    try {
      await _shopsCollection.doc(shopId).update(
        {
          'color': color,
        },
      );
    } on PlatformException catch (e) {
      throw DatabaseApiException(
        title: 'Failed to create Shop',
        message: e.message,
      );
    }
  }

  Future<void> updateUserShopId({
    required String userId,
    required String shopId,
  }) async {
    try {
      await _usersCollection.doc(userId).update({
        "shopId": shopId,
      });
    } on PlatformException catch (e) {
      throw DatabaseApiException(
        title: 'Failed to create Shop',
        message: e.message,
      );
    }
  }

  Future<void> updateShopService({
    required String shopId,
    required String serviceId,
  }) async {
    try {
      await _shopsCollection.doc(shopId).update({
        "hasService": true,
      });
    } on PlatformException catch (e) {
      throw DatabaseApiException(
        title: 'Failed to create Service',
        message: e.message,
      );
    }
  }

  Future<void> updateShopHighestPrice({
    required String shopId,
    required double highestPrice,
  }) async {
    try {
      await _shopsCollection.doc(shopId).update({
        "highestPrice": highestPrice,
      });
    } on PlatformException catch (e) {
      throw DatabaseApiException(
        title: 'Failed to create Service',
        message: e.message,
      );
    }
  }

  Future<void> updateShopLowestPrice({
    required String shopId,
    required double lowestPrice,
  }) async {
    try {
      await _shopsCollection.doc(shopId).update({
        "lowestPrice": lowestPrice,
      });
    } on PlatformException catch (e) {
      throw DatabaseApiException(
        title: 'Failed to create Service',
        message: e.message,
      );
    }
  }

  Future updateServiceImageData({
    required String shopId,
    required String serviceId,
    required String imageFileName,
    required String imageUrl,
  }) async {
    try {
      await _servicesCollection.doc(serviceId).update({
        "imageId": imageFileName,
        "imageUrl": imageUrl,
      });
    } on PlatformException catch (e) {
      throw DatabaseApiException(
        title: 'Failed to create Service',
        message: e.message,
      );
    }
  }

  Future updateServiceImage1Data({
    required String shopId,
    required String serviceId,
    required String imageFileName,
    required String imageUrl,
  }) async {
    try {
      await _servicesCollection.doc(serviceId).update({
        "imageId1": imageFileName,
        "imageUrl1": imageUrl,
      });
    } on PlatformException catch (e) {
      throw DatabaseApiException(
        title: 'Failed to create Service',
        message: e.message,
      );
    }
  }

  Future updateServiceVideo({
    required String shopId,
    required String serviceId,
    required String imageFileName,
    required String imageUrl,
  }) async {
    try {
      await _servicesCollection.doc(serviceId).update({
        "videoUrl": imageUrl,
      });
    } on PlatformException catch (e) {
      throw DatabaseApiException(
        title: 'Failed to create Service',
        message: e.message,
      );
    }
  }

  Future updateServiceImage2Data({
    required String shopId,
    required String serviceId,
    required String imageFileName,
    required String imageUrl,
  }) async {
    try {
      await _servicesCollection.doc(serviceId).update({
        "imageId2": imageFileName,
        "imageUrl2": imageUrl,
      });
    } on PlatformException catch (e) {
      throw DatabaseApiException(
        title: 'Failed to create Service',
        message: e.message,
      );
    }
  }

  Future updateServiceImage3Data({
    required String shopId,
    required String serviceId,
    required String imageFileName,
    required String imageUrl,
  }) async {
    try {
      await _servicesCollection.doc(serviceId).update({
        "imageId3": imageFileName,
        "imageUrl3": imageUrl,
      });
    } on PlatformException catch (e) {
      throw DatabaseApiException(
        title: 'Failed to create Service',
        message: e.message,
      );
    }
  }

  Future<void> updateProfileName({
    required String userId,
    required String name,
  }) async {
    try {
      await _usersCollection.doc(userId).update({
        "fullName": name,
      });
    } on PlatformException catch (e) {
      throw DatabaseApiException(
        title: 'Failed to update data',
        message: e.message,
      );
    }
  }

  Future<void> updateProfilePhoneNumber({
    required String userId,
    required String number,
  }) async {
    try {
      await _usersCollection.doc(userId).update({
        "phoneNumber": number,
      });
    } on PlatformException catch (e) {
      throw DatabaseApiException(
        title: 'Failed to update data',
        message: e.message,
      );
    }
  }

  Future<void> updateProfileDateOfBirth({
    required String userId,
    required String dateOfBirth,
  }) async {
    try {
      await _usersCollection.doc(userId).update({
        "dateOfBirth": dateOfBirth,
      });
    } on PlatformException catch (e) {
      throw DatabaseApiException(
        title: 'Failed to update data',
        message: e.message,
      );
    }
  }

  Future<void> updateProfileGender({
    required String userId,
    required String gender,
  }) async {
    try {
      await _usersCollection.doc(userId).update({
        "gender": gender,
      });
    } on PlatformException catch (e) {
      throw DatabaseApiException(
        title: 'Failed to update data',
        message: e.message,
      );
    }
  }

  Future<void> updateChatIds({
    required String userId,
    required String receiverId,
  }) async {
    try {
      await _chatRoomCollection
          .doc(userId)
          .collection('chats')
          .doc(receiverId)
          .set({"id": receiverId, "time": DateTime.now().millisecondsSinceEpoch});
      await _chatRoomCollection
          .doc(receiverId)
          .collection('chats')
          .doc(userId)
          .set({"id": userId, "time": DateTime.now().millisecondsSinceEpoch});
      /*await _usersCollection.doc(userId).update({
        "chatIds": FieldValue.arrayUnion([receiverId]),
      });

      await _usersCollection.doc(receiverId).update({
        'chatIds': FieldValue.arrayUnion([userId]),
      });*/
    } on PlatformException catch (e) {
      throw DatabaseApiException(
        title: 'Failed to update data',
        message: e.message,
      );
    }
  }

  // * Delete

  Future<bool> deleteService(String serviceId) async {
    try {
      bool result = false;

      _servicesCollection.doc(serviceId).delete().whenComplete(() => result = true);

      return result;
    } on PlatformException catch (e) {
      throw DatabaseApiException(
        title: 'Failed to delete service',
        message: e.message,
      );
    }
  }

  // * Listen

  /// Fetch realtime data of single User
  Stream<AppUser> listenUser(String userId) {
    _usersCollection.doc(userId).snapshots().listen((doc) {
      final user = AppUser.fromJson(
        doc.data()! as Map<String, dynamic>,
      );

      _userController.add(user);
    }, onError: (error) {});

    return _userController.stream;
  }

  Stream<List<AppUser>> listenUsers() {
    _usersCollection.snapshots().listen(
      (usersSnapshots) {
        if (usersSnapshots.docs.isNotEmpty) {
          final users = usersSnapshots.docs
              .map(
                (snapshot) => AppUser.fromJson(snapshot.data()! as Map<String, dynamic>),
              )
              .toList();

          _usersController.add(users);
        }
      },
    );

    return _usersController.stream;
  }

  Stream<List<AppUser>> listenChatUsers(List<String> chatIds) {
    _usersCollection.snapshots().listen(
      (usersSnapshots) {
        if (usersSnapshots.docs.isNotEmpty) {
          final users = usersSnapshots.docs
              .map(
                (snapshot) => AppUser.fromJson(snapshot.data()! as Map<String, dynamic>),
              )
              .where((user) => chatIds.contains(user.id))
              .toList();

          _usersChatsController.add(users);
        }
      },
    );

    return _usersChatsController.stream;
  }

  Stream<List<AppUser>> sortChatUsersID(AppUser chatIds) {
    StreamController<List<AppUser>> uniqueMessageID = StreamController<List<AppUser>>.broadcast();
    List<String> sortedMessageID = [];
    List<AppUser> usersList = [];

    _chatRoomCollection
        .doc(chatIds.id)
        .collection('chats')
        .orderBy('time', descending: true)
        //.where('senderId', isEqualTo: chatIds.id)
        .snapshots()
        .listen((chatSnapshot) async {
      usersList.clear();
      sortedMessageID.clear();
      chatSnapshot.docs.forEach((element) {
        sortedMessageID.add(jsonDecode(jsonEncode(element.data()))['id'].toString());
      });

      for (var item in sortedMessageID.toSet()) {
        QuerySnapshot userRaw = await _usersCollection.where('id', isEqualTo: item).get();
        usersList.add(AppUser.fromJson(userRaw.docs.first.data() as Map<String, dynamic>));
      }
      uniqueMessageID.add(usersList);
    });

    /*_chatsCollection
        .orderBy(
      'createdAt',
      descending: true,
    )
        .where('senderId', isEqualTo: chatIds.id)
    .snapshots().listen((chatSnapshot) async {
      usersList.clear();
      sortedMessageID.clear();
      chatSnapshot.docs.forEach((element) {
        sortedMessageID.add(jsonDecode(jsonEncode(element.data()))['receiverId'].toString());
        //print(jsonDecode(jsonEncode(element.data()))['receiverId'].toString());
      });

      print('final list: '+sortedMessageID.toSet().toString());
      for(var item in sortedMessageID.toSet()){
        print('Item: ' + item);
        QuerySnapshot userRaw = await _usersCollection.where('id', isEqualTo: item).get();
        usersList.add(AppUser.fromJson(userRaw.docs.first.data() as Map<String, dynamic>));
      }
      uniqueMessageID.add(usersList);
    });*/
    return uniqueMessageID.stream;
  }

  /*Stream<List<String>> sortChatUsersID(AppUser chatIds)  {
    StreamController<List<String>> uniqueMessageID = StreamController<List<String>>.broadcast();
    List<String> sortedMessageID = [];
    _chatsCollection
        .orderBy(
      'createdAt',
      descending: true,
    ).where('senderId', isEqualTo: chatIds.id)
        .snapshots().listen((chatSnapshot) {
      sortedMessageID.clear();
      chatSnapshot.docs.forEach((element) {
        sortedMessageID.add(jsonDecode(jsonEncode(element.data()))['receiverId'].toString());
        //print(jsonDecode(jsonEncode(element.data()))['receiverId'].toString());
      });
      print('final list: '+sortedMessageID.toSet().toString());
      uniqueMessageID.add(sortedMessageID.toSet().toList());
    });
    return uniqueMessageID.stream;

  }*/

  Stream<Shop> listenShop(String shopId) {
    _shopsCollection.doc(shopId).snapshots().listen(
      (doc) {
        final shop = Shop.fromJson(doc.data()! as Map<String, dynamic>);
        _shopController.add(shop);
      },
    );

    return _shopController.stream;
  }

  Stream<List<Shop>> listenShops() {
    _shopsCollection.snapshots().listen(
      (shopsSnapshots) {
        if (shopsSnapshots.docs.isNotEmpty) {
          final shops = shopsSnapshots.docs
              .map(
                (snapshot) => Shop.fromJson(snapshot.data()! as Map<String, dynamic>),
              )
              .where((shop) => shop.hasService && shop.isBestSeller == 1)
              .toList();
          final mshops = shopsSnapshots.docs
              .map(
                (snapshot) => Shop.fromJson(snapshot.data()! as Map<String, dynamic>),
              )
              .where((shop) => shop.hasService && shop.isBestSeller != 1)
              .toList();
              List<Shop> all_shops = [];
          all_shops = shops + mshops;
          _shopsController.add(all_shops);
        }
      },
    );

    return _shopsController.stream;
  }

  Future<List<Shop>> getFeaturedShops() async {
    final result = await _shopsCollection.get();
    final shops = result.docs
        .map(
          (e) => Shop.fromJson(e.data()! as Map<String, dynamic>),
        )
        .where((shop) => shop.hasService && shop.isFeatured == 1)
        .toList();
    return shops;

    /*_shopsCollection.snapshots().listen(
          (shopsSnapshots) {
        if (shopsSnapshots.docs.isNotEmpty) {
          final shops = shopsSnapshots.docs
              .map(
                (snapshot) =>
                Shop.fromJson(snapshot.data()! as Map<String, dynamic>),
          )
              .where((shop) => shop.hasService && shop.isFeatured == 1)
              .toList();

          _shopsController.add(shops);
        }
      },
    );

    return _shopsController.stream;*/
  }

  Future<List<Shop>> getBestSellers() async {
    final result = await _shopsCollection.get();
    final shops = result.docs
        .map(
          (e) => Shop.fromJson(e.data()! as Map<String, dynamic>),
        )
        .where((shop) => shop.hasService && shop.isBestSeller == 1)
        .toList();
    return shops;
  }

  Future<List<Shop>> getShops() async {
    final result = await _shopsCollection.get();

    final shops = result.docs
        .map(
          (e) => Shop.fromJson(e.data()! as Map<String, dynamic>),
        )
        .where((shop) => shop.hasService)
        .toList();

    return shops;
  }

  Stream<List<Follow>> listenFollowings(String userId) {
    _followCollection.doc(userId).collection('following').snapshots().listen(
      (followingSnapshots) {
        if (followingSnapshots.docs.isNotEmpty) {
          final shops = followingSnapshots.docs
              .map(
                (snapshot) => Follow.fromJson(snapshot.data()),
              )
              .toList();

          _followController.add(shops);
        }
      },
    );

    return _followController.stream;
  }

  Stream<List<AppUser>> listenShopOwners() {
    _usersCollection.snapshots().listen(
      (usersSnapshots) {
        if (usersSnapshots.docs.isNotEmpty) {
          final users = usersSnapshots.docs
              .map(
                (snapshot) => AppUser.fromJson(snapshot.data()! as Map<String, dynamic>),
              )
              .where((item) => item.userType == "seller")
              .where((item) => item.shopId.isNotEmpty)
              .toList();
          _shopOwnersController.add(users);
        }
      },
    );

    return _shopOwnersController.stream;
  }

  Future<List<AppUser>> getShopOwners() async {
    final result = await _usersCollection.get();

    final users = result.docs
        .map(
          (e) => AppUser.fromJson(e.data()! as Map<String, dynamic>),
        )
        .where((item) => item.userType == "seller")
        .where((item) => item.shopId.isNotEmpty)
        .toList();

    return users;
  }

  Stream<List<ShopService>> listenShopServices(String shopId) {
    _servicesCollection.orderBy('time',descending: true).snapshots().listen(
      (servicesSnapshots) {
        if (servicesSnapshots.docs.isNotEmpty) {
          final services = servicesSnapshots.docs
              .map(
                (snapshot) => ShopService.fromJson(
                  snapshot.data()! as Map<String, dynamic>,
                ),
              )
              .where((item) => item.shopId == shopId)
              .toList();

          _servicesController.add(services);
        }
      },
    );

    return _servicesController.stream;
  }

  Stream<List<ShopService>> listenAllServices() {
    _servicesCollection.orderBy('time',descending: true).snapshots().listen(
      (servicesSnapshots) {
        if (servicesSnapshots.docs.isNotEmpty) {
          final services = servicesSnapshots.docs
              .map(
                (snapshot) => ShopService.fromJson(snapshot.data()! as Map<String, dynamic>),
              )
              .toList();

          _allServicesController.add(services);
        }
      },
    );

    return _allServicesController.stream;
  }

  Future<List<ShopService>> getAllServices() async {
    final result = await _servicesCollection.orderBy('time',descending: true).get();

    final services = result.docs
        .map(
          (e) => ShopService.fromJson(e.data()! as Map<String, dynamic>),
        )
        .toList();

    return services;
  }

  Future createMessage(Chat chat) async {
    try {
      await _chatsCollection.doc().set(chat.toJson());
    } on PlatformException catch (e) {
      throw DatabaseApiException(
        title: 'Error Sending message',
        message: e.message,
      );
    }
  }

  Stream<List<Notification>> listenNotifications(String userId) {
    final StreamController<List<Notification>> _notificationsController =
        StreamController<List<Notification>>.broadcast();

    final _notificationCollection = _firestore.collection("users").doc(userId).collection('notifications').limit(50);
    final _notificationSnapshot = _notificationCollection.orderBy('time', descending: true);
    _notificationSnapshot.snapshots().listen((snapShot) {
      final notifications = snapShot.docs.map((doc) => Notification.fromJson(doc.data())).toList();
      _notificationsController.add(notifications);
    });
    return _notificationsController.stream;
  }

  ///New Notifications
  Stream<List<NotificationModel>> listenNewNotifications(String userId) {
    final StreamController<List<NotificationModel>> _notificationsController =
        StreamController<List<NotificationModel>>.broadcast();

    final _notificationCollection = _firestore.collection("users").doc(userId).collection('notifications').limit(50);
    final _notificationSnapshot = _notificationCollection.orderBy('time', descending: true);
    _notificationSnapshot.snapshots().listen((snapShot) {
      final notifications = snapShot.docs.map((doc) => NotificationModel.fromMap(doc.data())).toList();
      _notificationsController.add(notifications);
    });
    return _notificationsController.stream;
  }

  Stream<List<Chat>> listenChats(
    String currentUserId,
    String receiverId,
  ) {
    // Register the handler for when the posts data changes
    _requestMessages(currentUserId, receiverId);

    return _chatsController.stream;
  }

  void _requestMessages(
    String currentUserId,
    String receiverId,
  ) {
    final messagesQuerySnapshot = _chatsCollection.orderBy(
      'createdAt',
      descending: true,
    );

    messagesQuerySnapshot.snapshots().listen(
      (messageSnapshot) {
        if (messageSnapshot.docs.isNotEmpty) {
          final messages = messageSnapshot.docs
              .map(
                (snapshot) => Chat.fromJson(snapshot.data()! as Map<String, dynamic>),
              )
              .where(
                (chat) =>
                    (chat.receiverId == receiverId && chat.senderId == currentUserId) ||
                    (chat.receiverId == currentUserId && chat.senderId == receiverId),
              )
              .toList();

          _chatsController.add(messages);
        }
      },
    );
  }

  Stream<List<Chat>> listenCurrentUserChats(
    String currentUserId,
  ) {
    final messagesQuerySnapshot = _chatsCollection.orderBy(
      'createdAt',
      descending: true,
    );

    messagesQuerySnapshot.snapshots().listen(
      (messageSnapshot) {
        if (messageSnapshot.docs.isNotEmpty) {
          final messages = messageSnapshot.docs
              .map(
                (snapshot) => Chat.fromJson(
                  snapshot.data()! as Map<String, dynamic>,
                ),
              )
              .where(
                (chat) => chat.receiverId == currentUserId,
              )
              .toList();

          _currentUserChatsController.add(messages);
        }
      },
    );

    return _currentUserChatsController.stream;
  }

  CollectionReference<BookkingService> getBookingStream({required String placeId}) {
    return _bookingsCollection.doc(placeId).collection('bookings').withConverter<BookkingService>(
          fromFirestore: (snapshots, _) => BookkingService.fromJson(snapshots.data()!),
          toFirestore: (snapshots, _) => snapshots.toJson(),
        );
  }

  Stream<dynamic>? getBookingStreamFirebase(
    {required DateTime end, required DateTime start}) {
       return getBookingStream(placeId: '54a61c34-22d5-47de-be22-7094697e7741')
                        .where('bookingStart', isGreaterThanOrEqualTo: start)
                        .where('bookingStart', isLessThanOrEqualTo: end)
                        .snapshots();
  }

  Future<void> readChats({
    required String currentUserId,
  }) async {
    await _chatsCollection
        .orderBy(
          'createdAt',
          descending: true,
        )
        .where('receiverId', isEqualTo: currentUserId
            //(chat) => chat.recieverId == currentUserId,
            )
        .get()
        .then(
      (snapshot) {
        snapshot.docs.forEach(
          (doc) {
            doc.reference.update({
              'read': true,
            });
          },
        );
      },
    );
  }

  Future<Order> getOrder(String orderId) {
    return _ordersCollection.doc(orderId).get().then((value) => Order.fromJson(value.data()! as Map<String, dynamic>));
  }

  Future getToken(String userId) async {
    try {
      final userDoc = await _usersCollection.doc(userId).get();

      if (!userDoc.exists) {
        return null;
      } else {
        final userData = userDoc.data()! as Map<String, dynamic>;
        return AppUser.fromJson(userData).token;
      }
    } on PlatformException catch (e) {
      throw DatabaseApiException(
        title: 'Failed to get User Data',
        message: e.message,
      );
    }
  }

  Future createOrder(Order order) async {
    return _ordersCollection.doc(order.orderId).set(order.toJson());
  }

  Future<dynamic> uploadBookingFirebase(
    {required BookingService newBooking}) async {
    await _bookingsCollection
        .doc(newBooking.userId)
        .set(newBooking.toJson())
        .then((value) => log("Booking Added"))
        .catchError((error) => log("Failed to add booking: $error"));
    }
  
  
  Future postNotification(
      {required String orderID,
      required String title,
      required String body,
      required String forRole,
      required String userID,
      required String receiverToken}) async {
    String url = 'https://fcm.googleapis.com/fcm/send';
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization":
          "key=AAAAsZibog4:APA91bFpSsLKvXsI_kyDwl_0p7mQen5ND53PJaHpFOtPGfpCiWr6-Ui7D9UIsouXizHMFtvIeQrTGJmr0KKfSoF_L3WTet_Sic0y9jzCulsTSBba11wZdM4IBm9QdNuQCUyYU1g1_VAz"
    };
    var json = jsonEncode({
      "notification": {
        "body": body,
        "title": title,
        "sound": "default",
        "color": "#990000",
      },
      "priority": "high",
      "data": {
        "clickaction": "FLUTTERNOTIFICATIONCLICK",
        "forRole": forRole,
        "userID": userID,
        "orderId": orderID,
        "status": "done"
      },
      "to": receiverToken,
    });
    var response = await http.post(Uri.parse(url), headers: headers, body: json);
    return true;
  }

  Future updateTotalSaleCount(String userID) async {
    final userDoc = await _usersCollection.doc(userID).get();

    if (!userDoc.exists) {
      return null;
    }

    final userData = userDoc.data()! as Map<String, dynamic>;
    var previousTotalCount = userData['purchases'];
    int newCount = int.parse(previousTotalCount.toString()) + 1;
    await _usersCollection.doc(userID).update({'purchases': newCount});
  }

  Future bookOrder(Order order, String paymentId, String captureId, int time) async {
    return _ordersCollection
        .doc(order.orderId)
        .update({'status': OrderStatus.progress.index, 'paymentId': paymentId, 'captureId': captureId, 'time': time});
  }

  Future<void> refundOrder(Order order, int time) async {
    return _ordersCollection.doc(order.orderId).update({'status': OrderStatus.refunded.index, 'time': time});
  }

  Future<void> sendContactMessage(String message, String userID) {
    return _contactMessages
        .doc(userID)
        .set({'userID': userID, 'message': message, 'time': DateTime.now().millisecondsSinceEpoch});
  }

  Future<void> refundCaseOpen(String reason, Order order, int time) async {
    AppUser seller;
    AppUser buyer;

    buyer = await getUser(order.userId);
    seller = await getUser(order.service.ownerId);

    _ordersCollection
        .doc(order.orderId)
        .update({'status': OrderStatus.refundRequested.index, 'time': time}).then((value) {
      _disputesCollection.doc(order.orderId).set({
        'orderID': order.orderId,
        'captureID': order.captureId,
        'buyerID': order.userId,
        'buyerName': buyer.fullName,
        'sellerID': order.service.ownerId,
        'sellerName': seller.fullName,
        'orderType': order.service.type,
        'price': order.service.price.toString(),
        'status': 'open',
        'reason': reason,
        'openTime': time,
        'closeTime': 0000
      });
    });
  }

  Future<void> refundCaseClose(Order order, int time) async {
    return _ordersCollection
        .doc(order.orderId)
        .update({'status': OrderStatus.refundCaseClosed.index, 'time': time}).then((value) {
      _disputesCollection.doc(order.orderId).update({'status': 'close', 'closeTime': time});
    });
  }

  Future<void> completeOrder(Order order, int time) async {
    return _ordersCollection.doc(order.orderId).update({'status': OrderStatus.completed.index, 'time': time});
  }

  Future<void> rateShop(double rating, int ratingCount, Order order) async {
    return _shopsCollection.doc(order.shopId).update({'rating': rating, 'ratingCount': ratingCount});
  }

  Future<void> rateOrder(int rating, Order order) async {
    return _ordersCollection.doc(order.orderId).update({'rate': rating});
  }

  Future<void> approveAppointment(Order order, int time) async {
    return _ordersCollection.doc(order.orderId).update({'status': OrderStatus.bookApproved.index, 'time': time});
  }

  Future<void> cancelOrder(Order order, int time) async {
    return _ordersCollection.doc(order.orderId).update({'status': OrderStatus.bookCancelled.index, 'time': time});
  }

  Future<void> requestRefundOrder(Order order, int time) async {
    return _ordersCollection.doc(order.orderId).update({'status': OrderStatus.refundRequested.index, 'time': time});
  }

  Stream<List<Order>> listenOrdersByUserId(String userId) {
    _ordersCollection.where('userId', isEqualTo: userId).orderBy('time', descending: true).snapshots().listen((event) {
      if (event.docs.isNotEmpty) {
        final orders = event.docs
            .map((e) => Order.fromJson(
                  e.data()! as Map<String, dynamic>,
                ))
            .toList();
        _boughtOrder.add(orders);
      } else {
        _boughtOrder.add([]);
      }
    });
    return _boughtOrder.stream;
  }

  Stream<List<Order>> listenOrdersByShopId(String shopId) {
    _ordersCollection.where('shopId', isEqualTo: shopId).orderBy('time', descending: true).snapshots().listen((event) {
      if (event.docs.isNotEmpty) {
        final orders = event.docs
            .map((e) => Order.fromJson(
                  e.data()! as Map<String, dynamic>,
                ))
            .toList();
        _soldOrder.add(orders);
      } else {
        _soldOrder.add([]);
      }
    });
    return _soldOrder.stream;
  }

  void readNotification(String uid, String id) {
    _usersCollection.doc(uid).collection('notifications').doc(id).update({'read': 'true'});
  }

  void  postNotificationCollection(String userId, Map<String, dynamic> postCollection) {
    _usersCollection.doc(userId).collection('notifications').doc(postCollection['id'].toString()).set(postCollection);
  }
}
