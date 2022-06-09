import 'package:booking_calendar/booking_calendar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mipromo/app/app.locator.dart';
import 'package:mipromo/models/app_user.dart';
import 'package:mipromo/services/user_service.dart';
import 'package:mipromo/api/auth_api.dart';
import 'package:mipromo/api/database_api.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class BookingViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _authApi = locator<AuthApi>();
  final _userService = locator<UserService>();
  final _databaseApi = locator<DatabaseApi>();

  late AppUser _currentUser;
  AppUser get currentUser => _currentUser;
  late bool isDarkMode;
  bool isSending = false;
  TextEditingController messageController = TextEditingController();
  final now = DateTime.now();
  late BookingService mockBookingService;
  List<DateTimeRange> converted = [];


  Future<void> init({
    required bool isDark,
  }) async {
    setBusy(true);
    await _userService.syncUser();
    _currentUser = _userService.currentUser;
    isDarkMode = isDark;
    mockBookingService = BookingService(
        serviceName: 'Mock Service',
        serviceDuration: 60,
        bookingEnd: DateTime(now.year, now.month, now.day, 18, 0),
        bookingStart: DateTime(now.year, now.month, now.day, 8, 0));
        print('hello');
    notifyListeners();

    setBusy(false);
  }
  Stream<dynamic>? getBookingStreamMock(
      {required DateTime end, required DateTime start}) {
    return Stream.value([]);
  }

  Future<dynamic> uploadBookingMock(
      {required BookingService newBooking}) async {
    await Future.delayed(const Duration(seconds: 1));
    converted.add(DateTimeRange(
        start: newBooking.bookingStart, end: newBooking.bookingEnd));
        notifyListeners();
    print('${newBooking.toJson()} has been uploaded');
  }


  List<DateTimeRange> convertStreamResultMock({required dynamic streamResult}) {
    ///here you can parse the streamresult and convert to [List<DateTimeRange>]
    // DateTime first = now;
    // DateTime second = now.add(const Duration(minutes: 55));
    // DateTime third = now.subtract(const Duration(minutes: 240));
    // DateTime fourth = now.subtract(const Duration(minutes: 500));
    // converted.add(
    //     DateTimeRange(start: first, end: now.add(const Duration(minutes: 60))));
    // converted.add(DateTimeRange(
    //     start: second, end: second.add(const Duration(minutes: 60))));
    // converted.add(DateTimeRange(
    //     start: third, end: third.add(const Duration(minutes: 60))));
    // converted.add(DateTimeRange(
    //     start: fourth, end: fourth.add(const Duration(minutes: 60))));
    // return converted;
    return converted;
  }

  List<DateTimeRange> pauseSlots = [
    DateTimeRange(
        start: DateTime.now().add(const Duration(minutes: 5)),
        end: DateTime.now().add(const Duration(minutes: 60)))
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
