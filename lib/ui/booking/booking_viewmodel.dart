import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:booking_calendar/booking_calendar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

import 'package:fluttertoast/fluttertoast.dart';
import 'package:mipromo/app/app.locator.dart';
import 'package:mipromo/models/app_user.dart';
import 'package:mipromo/models/availability.dart';
import 'package:mipromo/models/book_service.dart';
import 'package:mipromo/models/order.dart';
import 'package:mipromo/models/shop.dart';
import 'package:mipromo/models/shop_service.dart';
import 'package:mipromo/services/user_service.dart';
import 'package:mipromo/api/auth_api.dart';
import 'package:mipromo/api/database_api.dart';
import 'package:mipromo/ui/shared/helpers/enums.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:mipromo/app/app.router.dart';

// final _dialogService = locator<DialogService>();
enum DialogType { basic, form }

class BookingViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _authApi = locator<AuthApi>();
  final _userService = locator<UserService>();
  final _dialogService = locator<DialogService>();
  static final SnackbarService _snackbarService = locator<SnackbarService>();
  final _databaseApi = locator<DatabaseApi>();

  late AppUser _currentUser;
  AppUser get currentUser => _currentUser;
  late bool isDarkMode;
  bool isSending = false;
  int step = 0;

  TextEditingController messageController = TextEditingController();
  final now = DateTime.now();
  late BookingService mockBookingService;
  List<DateTimeRange> converted = [];
  List<BookkingService> bookings = [];
  late List<int> excludedDays = [];

  List<BookkingService> userBookings = [];
  List<DateTimeRange> userReservedBookings = [];
  late Availability availability;

  late StreamSubscription<List<BookkingService>> _bookings;
  AppUser user;
  final ShopService service;
  BookingViewModel(
    this.user,
    this.service,
  );
  Future<void> init({
    required bool isDark,
  }) async {
    setBusy(true);
    await _databaseApi.getAvailabilty(userId: service.ownerId).then((value) {
      availability = value;
    });
    setDays();
    await convertStreamResultMock();
    await _userService.syncUser();
    _currentUser = _userService.currentUser;
    isDarkMode = isDark;
    mockBookingService = BookingService(
        serviceName: service.name,
        serviceDuration: service.duration!,
        servicePrice: service.price.toInt(),
        bookingEnd: DateTime(now.year, now.month, now.day, service.endHour!, 0),
        serviceId: service.id,
        userEmail: user.email,
        userName: user.fullName,
        userId: user.id,
        bookingStart: DateTime(now.year, now.month, now.day, service.startHour!, 0));

    await _databaseApi.getUserBookingStreamFirebase(userId: service.ownerId).then((bookings) {
      userBookings = bookings;
    });

    for (var i = 0; i < userBookings.length; i++) {
      final start = userBookings[i].bookingStart;
      final end = userBookings[i].bookingEnd;
      userReservedBookings.add(DateTimeRange(
          start: (DateTime(start!.year, start.month, start.day, start.hour, 0)),
          end: (DateTime(end!.year, end.month, end.day, end.hour, end.minute + userBookings[i].serviceDuration!, 0))));
    }
    userReservedBookings.add(DateTimeRange(
        start: DateTime(now.year, now.month, now.day, 0, 0),
        end: DateTime(now.year, now.month, now.day, now.hour + 1, 0)));

    notifyListeners();

    setBusy(false);
  }

  void setDays()  {
    print("called");
     !availability.Monday! ? excludedDays.add(DateTime.monday) : null;
    !availability.Tuesday! ? excludedDays.add(DateTime.tuesday) : null;
    !availability.Wednesday! ? excludedDays.add(DateTime.wednesday) : null;
    !availability.Thursday! ? excludedDays.add(DateTime.thursday) : null;
    !availability.Friday! ? excludedDays.add(DateTime.friday) : null;
    !availability.Saturday! ? excludedDays.add(DateTime.saturday) : null;
    !availability.Sunday! ? excludedDays.add(DateTime.sunday) : null;
    notifyListeners();
    print(excludedDays);
  }

  Stream<dynamic>? getBookingStreamMock({required DateTime end, required DateTime start}) {
    return Stream.value([]);
  }

  Future<dynamic> uploadBookingMock({required BookingService newBooking}) async {
    if (await _navigationService.navigateTo(Routes.inputAddressView) == true) {
      await _navigationService.navigateTo(
        Routes.bookServiceView,
        arguments: BookServiceViewArguments(
            user: user,
            service: service,
            bookingservice: BookkingService(
                email: newBooking.userEmail,
                bookingStart: newBooking.bookingStart,
                bookingEnd: newBooking.bookingEnd,
                userId: newBooking.userId,
                ownerId: service.ownerId,
                userName: newBooking.userName,
                serviceId: newBooking.serviceId,
                serviceName: newBooking.serviceName,
                servicePrice: newBooking.servicePrice,
                serviceDuration: newBooking.serviceDuration)),
      );
    }
    // final response = await _dialogService.showCustomDialog(
    //   variant: AlertType.custom,
    //   title: 'Choose Payment Method',
    // );

    // if (response != null && response.confirmed) {
    //   if (await _navigationService.navigateTo(Routes.inputAddressView) ==
    //       true) {
    //     await _navigationService.navigateTo(
    //       Routes.bookServiceView,
    //       arguments: BookServiceViewArguments(
    //           user: user, service: service, bookingservice: BookkingService(
    //         email: newBooking.userEmail,
    //         bookingStart: newBooking.bookingStart,
    //         bookingEnd: newBooking.bookingEnd,
    //         userId: newBooking.userId,
    //         userName: newBooking.userName,
    //         serviceId: newBooking.serviceId,
    //         serviceName: newBooking.serviceName,
    //         servicePrice: newBooking.servicePrice,
    //         serviceDuration: newBooking.serviceDuration)),
    //     );
    //   }
    // } else if (response != null && !response.confirmed) {
    //   await initPaymentSheet();
    //   if (await confirmPayment()) {
    //     await addOrder(newBooking.bookingStart,newBooking.bookingEnd);
    //     await _databaseApi.uploadBookingFirebase(
    //     newBooking: BookkingService(
    //         email: newBooking.userEmail,
    //         bookingStart: newBooking.bookingStart,
    //         bookingEnd: newBooking.bookingEnd,
    //         userId: newBooking.userId,
    //         userName: newBooking.userName,
    //         serviceId: newBooking.serviceId,
    //         serviceName: newBooking.serviceName,
    //         servicePrice: newBooking.servicePrice,
    //         serviceDuration: newBooking.serviceDuration));
    //   }

    // }

    // await Future.delayed(const Duration(seconds: 1));
    // if (await _navigationService.navigateTo(Routes.inputAddressView) == true) {
    //   await _navigationService.navigateTo(
    //     Routes.bookServiceView,
    //     arguments: BookServiceViewArguments(
    //       user: user,
    //       service: service,
    //     ),
    //   );
    // }
    // await Future.delayed(const Duration(seconds: 1));
    // converted.add(DateTimeRange(
    //     start: newBooking.bookingStart, end: newBooking.bookingEnd));
    notifyListeners();
    print('${newBooking.toJson()} has been uploaded');
  }

  List<DateTimeRange> convertStreamResultMock({dynamic streamResult}) {
    _bookings = _databaseApi.getBookingStreamFirebase(ServiceId: service.id).listen((event) {
      bookings = event;
    });

    List<DateTimeRange> converted = [];
    for (var i = 0; i < bookings.length; i++) {
      final item = bookings[i];
      converted.add(DateTimeRange(start: (item.bookingStart!), end: (item.bookingEnd!)));
    }
    return converted;
  }

  List<DateTimeRange> generatePauseSlots() {
    return userReservedBookings;
  }

  sendMessage() async {
    setIsSending(loading: true);
    await _databaseApi.sendContactMessage(messageController.text, _currentUser.id);
    messageController.clear();
    Fluttertoast.showToast(
        msg: "Thank you for contacting us",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        fontSize: 16.0);
    setIsSending(loading: false);
  }

  void pop() {
    _navigationService.back();
  }

  void setIsSending({required bool loading}) {
    isSending = loading;
    notifyListeners();
  }

  addOrder(DateTime start, DateTime end) {
    final String timeString = DateTime.now().toString();
    final String orderId = DateTime.now().microsecondsSinceEpoch.toString();
    final order = Order(
      type: OrderType.service,
      paymentMethod: MPaymentMethod.stripe,
      orderId: orderId,
      paymentId: 'paymentId',
      shopId: service.shopId,
      captureId: 'captureId',
      service: service,
      bookingStart: start.microsecondsSinceEpoch,
      bookingEnd: end.microsecondsSinceEpoch,
      userId: user.id,
      status: OrderStatus.bookRequested,
      rate: 0,
      name: user.fullName,
      address: user.address,
      postCode: user.postCode,
      time: DateTime.now().microsecondsSinceEpoch,
    );
    _databaseApi.createOrder(order).then((value) async {
      var token = await _databaseApi.getToken(order.service.ownerId);
      if (token != null) {
        Shop shopDetails = await _databaseApi.getShop(order.service.shopId);
        var test = _databaseApi.postNotification(
            orderID: order.orderId,
            title: 'New Booking',
            body: '${order.name} has booked ${order.service.name}(£${order.service.price}) from ${shopDetails.name}',
            forRole: 'order',
            userID: '',
            receiverToken: token.toString());

        Map<String, dynamic> postMap = {
          "userId": user.id,
          "orderID": order.orderId,
          "title": 'New Booking',
          "body": '${order.name} has booked ${order.service.name}(£${order.service.price})',
          "id": DateTime.now().millisecondsSinceEpoch.toString(),
          "read": false,
          "image": user.imageUrl,
          "time": DateTime.now().millisecondsSinceEpoch.toString(),
          "sound": "default"
        };

        _databaseApi.postNotificationCollection(shopDetails.ownerId, postMap);
      }

      if (await _navigationService.navigateTo(Routes.orderSuccessView) == true) {
        _navigationService.back();
        _navigationService.back();
        navigateToOrderDetailView(order);
      } else {
        _navigationService.back();
        _navigationService.back();
      }
    });
  }

  Future navigateToOrderDetailView(Order order) async {
    final shopId = order.service.shopId;
    if (shopId.isNotEmpty) {
      _databaseApi.getShop(shopId).then((shopData) {
        _navigationService.navigateTo(
          Routes.orderDetailView,
          arguments: OrderDetailViewArguments(
            order: order,
            color: shopData.color,
            currentUser: user,
            fontStyle: shopData.fontStyle,
          ),
        );
      });
    }
  }

  Future _createTestPaymentSheet() async {
    final url = Uri.parse('http://attn.tritec.store/api/create/intent');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({'a': 'a', 'price': service.price}),
    );
    final body = json.decode(response.body);

    // if (body['error'] != null) {
    //   throw Exception(body['error']);
    // }
    print(body);
    return body['intent'];
  }

  Future<void> initPaymentSheet() async {
    try {
      // 1. create payment intent on the server
      final data = await _createTestPaymentSheet();

      // create some billingdetails
      final billingDetails = BillingDetails(
        name: 'Flutter Stripe',
        email: 'email@stripe.com',
        phone: '+48888000888',
        address: Address(
          city: 'Houston',
          country: 'US',
          line1: '1459  Circle Drive',
          line2: '',
          state: 'Texas',
          postalCode: '77063',
        ),
      ); // mocked data for tests

      // 2. initialize the payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          // Main params
          paymentIntentClientSecret: data['client_secret'].toString(),
          merchantDisplayName: 'Flutter Stripe Store Demo',
          // Customer params
          customerId: data['customer'].toString(),
          customerEphemeralKeySecret: data['ephemeralKey'].toString(),
          // Extra params
          applePay: true,
          googlePay: true,
          style: ThemeMode.dark,
          // billingDetails: billingDetails,
          testEnv: true,
          merchantCountryCode: 'DE',
        ),
      );
      step = 1;
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error: $e');
      rethrow;
    }
  }

  Future<bool> confirmPayment() async {
    print("Asdfasdfsdfasfd");
    try {
      // 3. display the payment sheet.
      await Stripe.instance.presentPaymentSheet();

      step = 0;

      Fluttertoast.showToast(msg: 'Payment succesfully completed');
      return true;
    } on Exception catch (e) {
      if (e is StripeException) {
        Fluttertoast.showToast(msg: 'Error from Stripe: ${e.error.localizedMessage}');
        return false;
      } else {
        Fluttertoast.showToast(msg: 'Unforeseen error: ${e}');
        return false;
      }
    }
  }
}
