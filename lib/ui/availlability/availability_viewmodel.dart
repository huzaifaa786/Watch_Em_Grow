import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mipromo/api/database_api.dart';
import 'package:mipromo/app/app.locator.dart';
import 'package:mipromo/booking_calender/booking_calendar.dart';
import 'package:mipromo/models/availability.dart';
import 'package:mipromo/models/shop.dart';
import 'package:mipromo/models/shop_service.dart';
import 'package:mipromo/services/user_service.dart';
import 'package:stacked/stacked.dart';

class SetAvailabilityViewModel extends BaseViewModel {
  final _userService = locator<UserService>();
  final _databaseApi = locator<DatabaseApi>();
  late List<int> excludedDays = [];
  List<DateTimeRange> userReservedBookings = [];
  late bool isDarkMode;
  final now = DateTime.now();

  var values = List.filled(7, true);
  late Availability availability;
  late Shop shop;
  List? unavailableDays = [];
  List? unavailableSlots = [];
  late BookingService mockBookingService;

  TextEditingController durationController = new TextEditingController();
  TextEditingController startController = new TextEditingController();
  TextEditingController endController = new TextEditingController();
  late ShopService service;

  bool autoValidate = false;

  void showErrors() {
    autoValidate = true;
    notifyListeners();
  }

  Stream<dynamic>? getBookingStreamMock(
      {required DateTime end, required DateTime start}) {
    return Stream.value([]);
  }

  Future<dynamic> uploadBookingMock(
      {required BookingService newBooking}) async {}

  List<DateTimeRange> convertStreamResultMock({dynamic streamResult}) {
    return [];
  }

  List<DateTimeRange> generatePauseSlots() {
    return userReservedBookings;
  }

  updateTime() async {
    Map<String, dynamic> postMap = {
      'duration': int.parse(durationController.text),
      'startHour': int.parse(startController.text.replaceAll(':00', '')),
      'endHour': int.parse(endController.text.replaceAll(':00', ''))
    };

    await _databaseApi.changeAvailabilty(
        userId: shop.ownerId, availabilty: postMap);

    Fluttertoast.showToast(msg: 'Updated');
  }

  Future<void> init(
      {required Shop mshop, required bool isDark, required var context}) async {
    setBusy(true);
    notifyListeners();
    shop = mshop;
    isDarkMode = isDark;

    notifyListeners();
    await _databaseApi.getAvailabilty(userId: shop.ownerId).then((value) {
      availability = value;
    });
    unavailableDays = availability.unavailableDays ?? [];
    unavailableSlots = availability.unavailableSlots ?? [];
    durationController.text = availability.duration.toString() ;
    startController.text = availability.startHour.toString() + ':00';
    endController.text = availability.endHour.toString()+ ':00';
    values = converToArray(availability);
    setDays();

    mockBookingService = BookingService(
        serviceName: 'service.name',
        serviceDuration: availability.duration!,
        servicePrice: 30,
        bookingEnd:
            DateTime(now.year, now.month, now.day, availability.endHour!, 0),
        serviceId: '2',
        userEmail: 'user.email',
        userName: 'user.fullName',
        userId: shop.ownerId,
        depositAmount: 20,
        bookingStart:
            DateTime(now.year, now.month, now.day, availability.startHour!, 0));
    for (var i = 0; i < unavailableSlots!.length; i++) {
      var datesahab = DateTime.fromMicrosecondsSinceEpoch(
          unavailableSlots![i].microsecondsSinceEpoch as int);

      userReservedBookings.add(DateTimeRange(
          start: (DateTime(datesahab.year, datesahab.month, datesahab.day,
              datesahab.hour,datesahab.minute, 0)),
          end: (DateTime(datesahab.year, datesahab.month, datesahab.day,
              datesahab.hour, datesahab.minute + availability.duration!, 0))));
    }
    print("user reserved *************");
    print(userReservedBookings);
    notifyListeners();

    setBusy(false);
  }

  selection(int index) {
    values[index] = !values[index];
    notifyListeners();

    Map<String, dynamic> postMap = {
      for (var i = 0; i <= 6; i++) intDayToEnglish(i): values[i]
    };

    _databaseApi.changeAvailabilty(userId: shop.ownerId, availabilty: postMap);
  }

  void setDays() {
    !availability.Monday! ? excludedDays.add(DateTime.monday) : null;
    !availability.Tuesday! ? excludedDays.add(DateTime.tuesday) : null;
    !availability.Wednesday! ? excludedDays.add(DateTime.wednesday) : null;
    !availability.Thursday! ? excludedDays.add(DateTime.thursday) : null;
    !availability.Friday! ? excludedDays.add(DateTime.friday) : null;
    !availability.Saturday! ? excludedDays.add(DateTime.saturday) : null;
    !availability.Sunday! ? excludedDays.add(DateTime.sunday) : null;

    notifyListeners();
  }

  List<bool> converToArray(Availability availability) {
    return [
      availability.Sunday!,
      availability.Monday!,
      availability.Tuesday!,
      availability.Wednesday!,
      availability.Thursday!,
      availability.Friday!,
      availability.Saturday!,
    ];
  }

  String intDayToEnglish(int day) {
    if (day % 7 == DateTime.monday % 7) return 'Monday';
    if (day % 7 == DateTime.tuesday % 7) return 'Tuesday';
    if (day % 7 == DateTime.wednesday % 7) return 'Wednesday';
    if (day % 7 == DateTime.thursday % 7) return 'Thursday';
    if (day % 7 == DateTime.friday % 7) return 'Friday';
    if (day % 7 == DateTime.saturday % 7) return 'Saturday';
    if (day % 7 == DateTime.sunday % 7) return 'Sunday';
    throw '🐞 This should never have happened: $day';
  }
}
