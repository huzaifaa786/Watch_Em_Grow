import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:mipromo/app/app.locator.dart';
import 'package:mipromo/booking_calender/booking_calendar.dart';
import 'package:mipromo/api/database_api.dart';

import 'package:mipromo/booking_calender/src/util/booking_util.dart';
import 'package:table_calendar/table_calendar.dart';

class BookingController extends ChangeNotifier {
  BookingService bookingService;
  final _databaseApi = locator<DatabaseApi>();

  BookingController({required this.bookingService, this.pauseSlots}) {
    serviceOpening = bookingService.bookingStart;
    serviceClosing = bookingService.bookingEnd;
    pauseSlots = pauseSlots;
    if (serviceOpening!.isAfter(serviceClosing!)) {
      throw "Service closing must be after opening";
    }
    base = serviceOpening!;
    _generateBookingSlots();
  }

  late DateTime base;

  DateTime? serviceOpening;
  DateTime? serviceClosing;
  DateTime? daytoAvail;
  DateTime? slottoAvail;

  List<DateTime> _allBookingSlots = [];
  List<DateTime> get allBookingSlots => _allBookingSlots;

  List<DateTimeRange> bookedSlots = [];
  List<DateTimeRange>? pauseSlots = [];
  List<DateTimeRange>? copiedSlots = [];

  int _selectedSlot = (-1);
  bool _isUploading = false;

  int get selectedSlot => _selectedSlot;
  bool get isUploading => _isUploading;

  void _generateBookingSlots() {
    allBookingSlots.clear();
    _allBookingSlots = List.generate(
        _maxServiceFitInADay(),
        (index) => base
            .add(Duration(minutes: bookingService.serviceDuration) * index));
  }

  int _maxServiceFitInADay() {
    ///if no serviceOpening and closing was provided we will calculate with 00:00-24:00
    int openingHours = 24;
    if (serviceOpening != null && serviceClosing != null) {
      openingHours = DateTimeRange(start: serviceOpening!, end: serviceClosing!)
          .duration
          .inHours;
    }

    ///round down if not the whole service would fit in the last hours
    return ((openingHours * 60) / bookingService.serviceDuration).floor();
  }

  bool isSlotBooked(int index) {
    DateTime checkSlot = allBookingSlots.elementAt(index);
    bool result = false;
    for (var slot in bookedSlots) {
      if (BookingUtil.isOverLapping(slot.start, slot.end, checkSlot,
          checkSlot.add(Duration(minutes: bookingService.serviceDuration)))) {
        result = true;
        break;
      }
    }
    return result;
  }

  List<DateTimeRange>? copyPauseSlots(DateTime day) {
    if (pauseSlots == null) {}
    copiedSlots = [];
    for (var pauseSlot in pauseSlots!) {
      if (DateFormat.yMMMd().format(day) ==
          DateFormat.yMMMd().format(pauseSlot.start)) {
        copiedSlots!.add(pauseSlot);
      }
    }

    if (copiedSlots != []) {
      return copiedSlots;
    } else {
      return copiedSlots;
    }
  }

  pastePauseSlots(List<DateTimeRange> slots, DateTime dayy,
      List<dynamic> unavailble, ownerId) async {
    List<DateTimeRange> list = [];
  
    for (var slot in slots) {
      DateTime start = DateTime(dayy.year, dayy.month, dayy.day,
          slot.start.hour, slot.start.minute, slot.start.second);
      DateTime end = DateTime(dayy.year, dayy.month, dayy.day, slot.end.hour,
          slot.end.minute, slot.end.second);

      DateTimeRange x = DateTimeRange(start: start, end: end);
      list.add(x);
      pauseSlots!.add(x);
    }

    for (var item in list) {
      unavailble.add(item.start);
    }

    Map<String, dynamic> postMap = {'unavailableSlots': unavailble};

    await _databaseApi.changeAvailabilty(
        userId: ownerId.toString(), availabilty: postMap);
    Fluttertoast.showToast(msg: 'Done');
  }

  void selectSlot(int idx) {
    _selectedSlot = idx;
    notifyListeners();
  }

  void resetSelectedSlot() {
    _selectedSlot = -1;
    notifyListeners();
  }

  void toggleUploading() {
    _isUploading = !_isUploading;
    notifyListeners();
  }

  Future<void> generateBookedSlots(List<DateTimeRange> data) async {
    bookedSlots.clear();
    _generateBookingSlots();

    for (var i = 0; i < data.length; i++) {
      final item = data[i];
      bookedSlots.add(item);
    }
  }

  BookingService generateNewBookingForUploading() {
    final bookingDate = allBookingSlots.elementAt(selectedSlot);
    bookingService
      ..bookingStart = (bookingDate)
      ..bookingEnd =
          (bookingDate.add(Duration(minutes: bookingService.serviceDuration)));
    return bookingService;
  }

  bool isSlotInPauseTime(DateTime slot) {
    bool result = false;
    if (pauseSlots == null) {
      return result;
    }
    for (var pauseSlot in pauseSlots!) {
      if (BookingUtil.isOverLapping(pauseSlot.start, pauseSlot.end, slot,
          slot.add(Duration(minutes: bookingService.serviceDuration)))) {
        result = true;
        break;
      }
    }
    return result;
  }

  markDayUnavailable(List unavailableDays, ownerId) async {
    final bookingDate = allBookingSlots.elementAt(0);
    unavailableDays.add(bookingDate);
    Map<String, dynamic> postMap = {'unavailableDays': unavailableDays};

    await _databaseApi.changeAvailabilty(
        userId: ownerId.toString(), availabilty: postMap);

    Fluttertoast.showToast(msg: 'Done');
  }

  markDayAvailable(List unavailableDays, ownerId) async {
    final bookingDate = allBookingSlots.elementAt(0);

    var dayToMarkAvailable = unavailableDays.singleWhere((day) {
      DateTime parsedDate = DateTime.fromMicrosecondsSinceEpoch(
          day.microsecondsSinceEpoch as int);
      return isSameDay(daytoAvail, parsedDate);
    });

    unavailableDays.remove(dayToMarkAvailable);

    Map<String, dynamic> postMap = {'unavailableDays': unavailableDays};

    await _databaseApi.changeAvailabilty(
        userId: ownerId.toString(), availabilty: postMap);

    Fluttertoast.showToast(msg: 'Done');
  }

  markSlotUnavailable(List unavailableSlots, ownerId) async {
    final bookingDate = allBookingSlots.elementAt(selectedSlot);

    unavailableSlots.add(bookingDate);

    Map<String, dynamic> postMap = {'unavailableSlots': unavailableSlots};

    await _databaseApi.changeAvailabilty(
        userId: ownerId.toString(), availabilty: postMap);

    Fluttertoast.showToast(msg: 'Done');
  }

  markSlotavailable(List unavailableSlots, ownerId) async {
    final bookingDate = allBookingSlots.elementAt(selectedSlot);
    print(bookingDate);
    unavailableSlots.remove(Timestamp.fromDate(bookingDate));

    Map<String, dynamic> postMap = {'unavailableSlots': unavailableSlots};

    await _databaseApi.changeAvailabilty(
        userId: ownerId.toString(), availabilty: postMap);

    Fluttertoast.showToast(msg: 'Done');
  }
}
