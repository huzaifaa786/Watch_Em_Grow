import 'dart:async';
import 'dart:developer';

import 'package:booking_calendar/booking_calendar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mipromo/app/app.locator.dart';
import 'package:mipromo/models/app_user.dart';
import 'package:mipromo/models/book_service.dart';
import 'package:mipromo/models/shop_service.dart';
import 'package:mipromo/services/user_service.dart';
import 'package:mipromo/api/auth_api.dart';
import 'package:mipromo/api/database_api.dart';
import 'package:mipromo/ui/shared/helpers/data_models.dart';
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
  TextEditingController messageController = TextEditingController();
  final now = DateTime.now();
  late BookingService mockBookingService;
  List<DateTimeRange> converted = [];
  List<BookkingService> bookings = [];
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
        bookingStart:
            DateTime(now.year, now.month, now.day, service.startHour!, 0));
    notifyListeners();

    setBusy(false);
  }

  Stream<dynamic>? getBookingStreamMock(
      {required DateTime end, required DateTime start}) {
    return Stream.value([]);
  }

  Future<dynamic> uploadBookingMock(
      {required BookingService newBooking}) async {
    await _databaseApi.uploadBookingFirebase(
        newBooking: BookkingService(
            email: newBooking.userEmail,
            bookingStart: newBooking.bookingStart,
            bookingEnd: newBooking.bookingEnd,
            userId: newBooking.userId,
            userName: newBooking.userName,
            serviceId: newBooking.serviceId,
            serviceName: newBooking.serviceName,
            servicePrice: newBooking.servicePrice,
            serviceDuration: newBooking.serviceDuration));
       
    // if (dialogResponse?.confirmed ?? false) {
      
    //   // if (await _navigationService.navigateTo(Routes.inputAddressView) == true) {
    //     await _navigationService.navigateTo(
    //       Routes.bookingView,
    //       arguments: BookingViewArguments(
    //         user: user,
    //         service: service,
    //       ),
    //     );
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
    _bookings =  _databaseApi.getBookingStreamFirebase(ServiceId: service.id).listen((event) {
            bookings = event;
        });

    List<DateTimeRange> converted = [];
    for (var i = 0; i < bookings.length; i++) {
      final item = bookings[i];
      converted.add(DateTimeRange(start: (item.bookingStart!), end: (item.bookingEnd!)));
    }
    return converted;
  }

  List<DateTimeRange> pauseSlots = [
    // DateTimeRange(
    //     start: DateTime.now().add(const Duration(minutes: 5)),
    //     end: DateTime.now().add(const Duration(minutes: 60)))
  ];

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
}
