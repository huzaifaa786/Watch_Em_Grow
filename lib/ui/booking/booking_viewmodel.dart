import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mipromo/booking_calender/src/model/booking_service.dart';
import 'package:mipromo/ui/profile/buyer/editProfile/buyer_edit_profile_viewmodel.dart';
import 'package:mipromo/ui/shared/widgets/busy_loader.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:stacked_themes/stacked_themes.dart';

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
import 'package:mipromo/ui/shared/widgets/basic_loader.dart';
import 'package:velocity_x/velocity_x.dart';

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
  String paymentIntent = '';

  List? unavailableDays = [];
  List? unavailableSlots = [];
  List? extraService = [];
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
  late Availability availability;

  late List<int> excludedDays = [];
  TextEditingController depositAmountController = new TextEditingController();
  var mcontext;
  List<BookkingService> userBookings = [];
  List<DateTimeRange> userReservedBookings = [];
  List<DateTime> unavailableBookings = [];

  late StreamSubscription<List<BookkingService>> _bookings;
  AppUser user;
  final ShopService service;
  BookingViewModel(
    this.user,
    this.service,
  );
  Future<void> init({
    required bool isDark,
    required var context,
  }) async {
    setBusy(true);
    await _databaseApi.getAvailabilty(userId: service.ownerId).then((value) {
      availability = value;
    });
    unavailableDays = availability.unavailableDays ?? [];
    unavailableSlots = availability.unavailableSlots ?? [];
    var check = await _databaseApi.getExtraServices(shopId: service.shopId);
    extraService = check;
    print(extraService);

    setDays();
    await convertStreamResultMock();
    await _userService.syncUser();
    _currentUser = _userService.currentUser;
    isDarkMode = isDark;
    mockBookingService = BookingService(
        serviceName: service.name,
        serviceDuration: 30,
        servicePrice: service.price.toInt(),
        bookingEnd:
            DateTime(now.year, now.month, now.day, availability.endHour!, 0),
        serviceId: service.id,
        userEmail: user.email,
        userName: user.fullName,
        userId: service.ownerId,
        depositAmount: service.depositAmount,
        bookingStart:
            DateTime(now.year, now.month, now.day, availability.startHour!, 0));

    await _databaseApi
        .getUserBookingStreamFirebase(userId: service.ownerId)
        .then((bookings) {
      userBookings = bookings;
    });

    for (var i = 0; i < userBookings.length; i++) {
      final start = userBookings[i].bookingStart;
      final end = userBookings[i].bookingEnd;
      print(start?.minute);
      print(end);
      userReservedBookings.add(DateTimeRange(
          start: (DateTime(start!.year, start.month, start.day, start.hour,
              start.minute, 0)),
          end: (DateTime(
              end!.year, end.month, end.day, end.hour, end.minute, 0))));
    }
    print(userReservedBookings);
    for (var i = 0; i < unavailableSlots!.length; i++) {
      var datesahab = DateTime.fromMicrosecondsSinceEpoch(
          unavailableSlots![i].microsecondsSinceEpoch as int);

      userReservedBookings.add(DateTimeRange(
          start: (DateTime(datesahab.year, datesahab.month, datesahab.day,
              datesahab.hour, datesahab.minute, 0)),
          end: (DateTime(datesahab.year, datesahab.month, datesahab.day,
              datesahab.hour, datesahab.minute + availability.duration!, 0))));
    }
    userReservedBookings.add(DateTimeRange(
        start: DateTime(now.year, now.month, now.day, 0, 0),
        end: DateTime(now.year, now.month, now.day, now.hour + 1, 0)));
    mcontext = context;
    notifyListeners();

    setBusy(false);
  }

  void setDays() {
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

  Stream<dynamic>? getBookingStreamMock(
      {required DateTime end, required DateTime start}) {
    return Stream.value([]);
  }

  Future<dynamic> uploadBookingMock(
      {required BookingService newBooking,
      required List selextraService}) async {

    Duration d = Duration(minutes: service.duration!);

    DateTimeRange time = DateTimeRange(
        start: newBooking.bookingStart, end: newBooking.bookingStart.add(d));

    final result = await _databaseApi.checkbooking(
        ServiceId: service.ownerId, start: time.start, end: time.end);

    // for (var avail in availability.unavailableSlots!) {
    //   unavailableBookings.add(DateTime.fromMicrosecondsSinceEpoch(
    //       int.parse(avail.microsecondsSinceEpoch.toString())));
    // }
    // unavailableBookings = unavailableBookings
    //     .where((e) => e.isAfter(time.start))
    //     .where((e) => e.isBefore(time.end))
    //     .toList();

    if (result) {
      final dialogResponse = await _dialogService.showConfirmationDialog(
        title: 'Please select another time slot',
        description:
            'The duration of this service overslaps with another booked slot.',
        cancelTitle: 'Close',
      );
      return;
    }

    final dialogResponse = await _dialogService.showConfirmationDialog(
      title: 'Deposit Amount Policy',
      description:
          'Please ensure that the remaining balance is paid directly to the seller when you are at your appointment. Only the Deposit will be taken through MiyPromo',
      confirmationTitle: 'Proceed',
      cancelTitle: 'Close',
    );
    final String bookingId = DateTime.now().microsecondsSinceEpoch.toString();
    final StripeId = await _databaseApi.getSellerStripe(service.ownerId);
    if (dialogResponse?.confirmed ?? false) {
      if (StripeId == '') {
        if (await _navigationService.navigateTo(Routes.inputAddressView) ==
            true) {
          await _navigationService.navigateTo(
            Routes.bookServiceView,
            arguments: BookServiceViewArguments(
                user: user,
                service: service,
                bookingservice: BookkingService(
                    id: bookingId,
                    email: newBooking.userEmail,
                    bookingStart: newBooking.bookingStart,
                    bookingEnd: newBooking.bookingStart
                        .add(Duration(minutes: service.duration!)),
                    userId: newBooking.userId,
                    ownerId: service.ownerId,
                    userName: newBooking.userName,
                    serviceId: newBooking.serviceId,
                    depositAmount: service.depositAmount,
                    serviceName: newBooking.serviceName,
                    servicePrice: newBooking.servicePrice,
                    extraServ: extraService,
                    // extraServPrice: int.parse(ourService!.price.toString()),
                    serviceDuration: newBooking.serviceDuration)),
          );
        }
      } else if (StripeId != '') {
        final response = await _dialogService.showCustomDialog(
          variant: AlertType.custom,
          title: 'Choose Payment Method',
        );

        if (response != null && response.confirmed) {
          if (await _navigationService.navigateTo(Routes.inputAddressView) ==
              true) {
            await _navigationService.navigateTo(
              Routes.bookServiceView,
              arguments: BookServiceViewArguments(
                  user: user,
                  service: service,
                  bookingservice: BookkingService(
                      id: bookingId,
                      email: newBooking.userEmail,
                      bookingStart: newBooking.bookingStart,
                      bookingEnd: newBooking.bookingEnd,
                      userId: newBooking.userId,
                      userName: newBooking.userName,
                      serviceId: newBooking.serviceId,
                      serviceName: newBooking.serviceName,
                      servicePrice: newBooking.servicePrice,
                      extraServ: extraService,
                      // extraServPrice: int.parse(extraService),
                      serviceDuration: newBooking.serviceDuration)),
            );
          }
        } else if (response != null && !response.confirmed) {
          await initPaymentSheet();
          if (await confirmPayment()) {
            final bookservice = BookkingService(
                id: bookingId,
                email: newBooking.userEmail,
                bookingStart: newBooking.bookingStart,
                bookingEnd: newBooking.bookingEnd,
                userId: newBooking.userId,
                userName: newBooking.userName,
                serviceId: newBooking.serviceId,
                serviceName: newBooking.serviceName,
                servicePrice: newBooking.servicePrice,
                extraServ: extraService,
                // extraServPrice: int.parse(ourService!.price.toString()),
                serviceDuration: newBooking.serviceDuration);
            await _databaseApi.uploadBookingFirebase(newBooking: bookservice);
            await addOrder(
                newBooking.bookingStart, newBooking.bookingEnd, bookservice.id);
          }
        }
      }
    }

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
    _bookings = _databaseApi
        .getBookingStreamFirebase(ServiceId: service.id)
        .listen((event) {
      bookings = event;
    });

    List<DateTimeRange> converted = [];
    for (var i = 0; i < bookings.length; i++) {
      final item = bookings[i];
      converted.add(
          DateTimeRange(start: (item.bookingStart!), end: (item.bookingEnd!)));
    }
    return converted;
  }

  List<DateTimeRange> generatePauseSlots() {
    return userReservedBookings;
  }

  sendMessage() async {
    setIsSending(loading: true);
    await _databaseApi.sendContactMessage(
        messageController.text, _currentUser.id);
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

  addOrder(DateTime start, DateTime end, String? id) {
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
      bookkingId: id,
      bookingStart: start.microsecondsSinceEpoch,
      bookingEnd: end.microsecondsSinceEpoch,
      userId: user.id,
      status: OrderStatus.bookRequested,
      rate: 0,
      name: user.fullName,
      paymentIntent: paymentIntent,
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
            body:
                '${order.name} has booked ${order.service.name}(£${order.service.price}) from ${shopDetails.name}',
            forRole: 'order',
            userID: '',
            receiverToken: token.toString());

        Map<String, dynamic> postMap = {
          "userId": user.id,
          "orderID": order.orderId,
          "title": 'New Booking',
          "body":
              '${order.name} has booked ${order.service.name}(£${order.service.price})',
          "id": DateTime.now().millisecondsSinceEpoch.toString(),
          "read": false,
          "image": user.imageUrl,
          "time": DateTime.now().millisecondsSinceEpoch.toString(),
          "sound": "default"
        };

        _databaseApi.postNotificationCollection(shopDetails.ownerId, postMap);
      }

      if (await _navigationService.navigateTo(Routes.orderSuccessView) ==
          true) {
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
    final url =
        Uri.parse('http://tritec.store/mipromo/public/api/create/intent');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'a': 'a',
        'price': service.depositAmount,
        'connected_account': 'acct_1M7iQrRTmuR2qUZU'
      }),
    );
    final body = json.decode(response.body);
    final data = jsonDecode(body['intent'].toString());

    paymentIntent = data['intent']['id'].toString();

    return data;
  }

  Future<void> initPaymentSheet() async {
    // try {
    // 1. create payment intent on the server

    final data = await _createTestPaymentSheet();

    // create some billingdetails
    // final billingDetails = BillingDetails(
    //   name: 'Flutter Stripe',
    //   email: 'email@stripe.com',
    //   phone: '+48888000888',
    //   address: Address(
    //     city: 'Houston',
    //     country: 'US',
    //     line1: '1459  Circle Drive',
    //     line2: '',
    //     state: 'Texas',
    //     postalCode: '77063',
    //   ),
    // ); // mocked data for tests

    // 2. initialize the payment sheet
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        // Main params
        paymentIntentClientSecret: data['paymentIntent'].toString(),
        merchantDisplayName: 'Miypromo',
        // Customer params
        customerId: data['customer'].toString(),
        customerEphemeralKeySecret: data['ephemeralKey'].toString(),
        // Extra params
        applePay: true,
        googlePay: true,
        style: ThemeMode.dark,
        // billingDetails: billingDetails,
        testEnv: true,
        merchantCountryCode: 'GBP',
      ),
    );
    step = 1;
    // } catch (e) {
    //   Fluttertoast.showToast(msg: 'Error: $e');
    //   rethrow;
    // }
  }

  Future<bool> confirmPayment() async {
    print("Asdfasdfsdfasfd");
    final x;
    try {
      // 3. display the payment sheet.
      await Stripe.instance.presentPaymentSheet();

      step = 0;

      Fluttertoast.showToast(msg: 'Payment succesfully completed');
      return true;
    } on Exception catch (e) {
      if (e is StripeException) {
        Fluttertoast.showToast(
            msg: 'Error from Stripe: ${e.error.localizedMessage}');
        return false;
      } else {
        Fluttertoast.showToast(msg: 'Unforeseen error: ${e}');
        return false;
      }
    }
  }
}

class DepositSheet extends StatelessWidget {
  const DepositSheet({Key? key, required this.user, required this.service})
      : super(key: key);
  final ShopService service;

  final AppUser user;

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    double height = media.height;
    double width = media.width;
    final _navigationService = locator<NavigationService>();

    return ViewModelBuilder<BookingViewModel>.reactive(
      builder: (context, model, child) => model.isBusy
          ? const BasicLoader()
          : Stack(
              children: [
                Wrap(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15)),
                      ),
                      child: Stack(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Container(
                                    height: height * 0.05,
                                    width: width * 0.08,
                                    //color: Colors.red,
                                    margin: EdgeInsets.only(
                                        top: height * 0.005,
                                        right: width * 0.01),
                                    child: Icon(Icons.clear, size: 19)),
                              )
                            ],
                          ),
                          Padding(
                            padding:
                                EdgeInsets.symmetric(horizontal: width * 0.03),
                            child: Column(
                              //crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding:
                                          EdgeInsets.only(top: height * 0.02),
                                      child: 'Enter Deposit Amount'
                                          .text
                                          .bold
                                          .size(20)
                                          .make(),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  height: height * 0.06,
                                  width: width,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: TextFormField(
                                    style: TextStyle(
                                      fontSize: height * 0.019,
                                      color: Colors.black,
                                    ),
                                    controller: model.depositAmountController,
                                    textInputAction: TextInputAction.next,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.grey)),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0xffEEEEEE))),
                                      disabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0xffEEEEEE))),
                                      hintText: 'Enter Deposit Amount',
                                      hintStyle: TextStyle(
                                          fontSize: height * 0.019,
                                          color: Colors.black54),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Container(
                                  height: height * 0.055,
                                  width: width * 0.95,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: MaterialButton(
                                    color: Color(4286745852),
                                    onPressed: () {
                                      if (model.depositAmountController.text
                                              .isNotEmpty &&
                                          int.parse(model
                                                  .depositAmountController
                                                  .text) >=
                                              15 &&
                                          int.parse(model
                                                  .depositAmountController
                                                  .text) <
                                              45) {
                                        FocusScope.of(context).unfocus();
                                        _navigationService.back(result: true);
                                      } else {
                                        Fluttertoast.showToast(
                                            msg:
                                                'deposit must be greater than 15 and less then',
                                            toastLength: Toast.LENGTH_SHORT,
                                            backgroundColor: Colors.black87,
                                            textColor: Colors.white,
                                            fontSize: 16.0);
                                      }
                                    },
                                    child: const Text(
                                      'Confirm',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 16),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: height * 0.015,
                                ),
                                Padding(
                                    padding: EdgeInsets.only(
                                        bottom: MediaQuery.of(context)
                                            .viewInsets
                                            .bottom))
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                BusyLoader(busy: model.isBusy),
              ],
            ),
      viewModelBuilder: () => BookingViewModel(user, service),
    );
  }
}
