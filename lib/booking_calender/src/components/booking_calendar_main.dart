import 'package:intl/intl.dart';
import 'package:mipromo/booking_calender/src/components/booking_dialog.dart';
import 'package:mipromo/booking_calender/src/components/booking_slot.dart';
import 'package:mipromo/booking_calender/src/components/common_button.dart';
import 'package:mipromo/booking_calender/src/components/common_card.dart';
import 'package:mipromo/booking_calender/src/util/booking_util.dart';

import 'package:flutter/material.dart';
import 'package:mipromo/booking_calender/booking_calendar.dart';
import 'package:mipromo/booking_calender/src/core/booking_controller.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:velocity_x/velocity_x.dart';

class BookingCalendarMain extends StatefulWidget {
  const BookingCalendarMain({
    Key? key,
    required this.getBookingStream,
    required this.convertStreamResultToDateTimeRanges,
    required this.uploadBooking,
    required this.bookingService,
    this.bookingExplanation,
    this.bookingGridCrossAxisCount,
    this.bookingGridChildAspectRatio,
    this.formatDateTime,
    this.docId,
    this.excludedDays,
    this.unavailableDays,
    this.unavailableSlots,
    this.bookingButtonText,
    this.bookingButtonColor,
    this.showData,
    this.bookedSlotColor,
    this.selectedSlotColor,
    this.availableSlotColor,
    this.bookedSlotText,
    this.selectedSlotText,
    this.availableSlotText,
    this.gridScrollPhysics,
    this.loadingWidget,
    this.errorWidget,
    this.uploadingWidget,
    this.pauseSlotColor,
    this.pauseSlotText,
    this.hideBreakTime = false,
    this.locale,
  }) : super(key: key);

  final Stream<dynamic>? Function(
      {required DateTime start, required DateTime end}) getBookingStream;
  final Future<dynamic> Function({required BookingService newBooking})
      uploadBooking;
  final List<DateTimeRange> Function({required dynamic streamResult})
      convertStreamResultToDateTimeRanges;

  ///Customizable
  final BookingService bookingService;
  final Widget? bookingExplanation;

  final int? bookingGridCrossAxisCount;

  final List<int>? excludedDays;
  final List? unavailableDays;
  final List? unavailableSlots;

  final double? bookingGridChildAspectRatio;
  final String Function(DateTime dt)? formatDateTime;
  final String? bookingButtonText;
  final String? docId;
  final Color? bookingButtonColor;
  final Color? bookedSlotColor;
  final Color? selectedSlotColor;
  final Color? availableSlotColor;
  final Color? pauseSlotColor;
  final bool? showData;

  final String? bookedSlotText;
  final String? selectedSlotText;
  final String? availableSlotText;
  final String? pauseSlotText;

  final ScrollPhysics? gridScrollPhysics;
  final Widget? loadingWidget;
  final Widget? errorWidget;
  final Widget? uploadingWidget;

  final bool? hideBreakTime;

  final String? locale;

  @override
  State<BookingCalendarMain> createState() => _BookingCalendarMainState();
}

class _BookingCalendarMainState extends State<BookingCalendarMain> {
  late BookingController controller;
  final now = DateTime.now();
  bool enableButton = false;
  @override
  void initState() {
    super.initState();
    controller = context.read<BookingController>();
    startOfDay = now.startOfDayService(controller.serviceOpening!);
    endOfDay = now.endOfDayService(controller.serviceClosing!);
    _focusedDay = now;
    _selectedDay = now;
    controller.daytoAvail = now;
  }

  CalendarFormat _calendarFormat = CalendarFormat.month;

  late DateTime _selectedDay;
  late DateTime _focusedDay;
  late DateTime startOfDay;
  late DateTime endOfDay;

  void selectNewDateRange() {
    startOfDay = _selectedDay.startOfDayService(controller.serviceOpening!);
    endOfDay = _selectedDay
        .add(const Duration(days: 1))
        .endOfDayService(controller.serviceClosing!);

    controller.base = startOfDay;
    controller.resetSelectedSlot();
  }

  enableDay(DateTime date) {
    setState(() {
      enableButton = true;
      controller.daytoAvail = date;
    });
  }

  @override
  Widget build(BuildContext context) {
    controller = context.watch<BookingController>();

    return Consumer<BookingController>(
      builder: (_, controller, __) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: (controller.isUploading)
            ? widget.uploadingWidget ?? const BookingDialog()
            : Column(
                children: [
                  CommonCard(
                    color: widget.hideBreakTime == true
                        ? Colors.black
                        : Colors.white,
                    child: TableCalendar(
                        locale: widget.locale,
                        firstDay: DateTime.now(),
                        lastDay: DateTime.now().add(const Duration(days: 1000)),
                        focusedDay: _focusedDay,
                        availableCalendarFormats: const {
                          CalendarFormat.month: 'Month',
                        },
                        onDisabledDayTapped: enableDay,
                        calendarFormat: _calendarFormat,
                        calendarStyle: const CalendarStyle(
                          isTodayHighlighted: true,
                          outsideDaysVisible: false,
                        ),
                        selectedDayPredicate: (day) {
                          return isSameDay(_selectedDay, day);
                        },
                        onDaySelected: (selectedDay, focusedDay) {
                          if (!isSameDay(_selectedDay, selectedDay)) {
                            setState(() {
                              _selectedDay = selectedDay;
                              _focusedDay = focusedDay;
                              enableButton = false;
                            });
                            selectNewDateRange();
                          }
                        },
                        onFormatChanged: (format) {
                          if (_calendarFormat != format) {
                            setState(() {
                              _calendarFormat = format;
                            });
                          }
                        },
                        onPageChanged: (focusedDay) {
                          _focusedDay = focusedDay;
                        },
                        enabledDayPredicate: (date) {
                          bool flag = true;
                          for (var i = 0;
                              i <= widget.excludedDays!.length - 1;
                              i++) {
                            if (date.weekday == widget.excludedDays![i]) {
                              flag = false;
                            }
                          }

                          for (var i = 0;
                              i <= widget.unavailableDays!.length - 1;
                              i++) {
                            var datesahab = DateTime.fromMicrosecondsSinceEpoch(
                                widget.unavailableDays![i]
                                    .microsecondsSinceEpoch as int);
                            if (date.year == datesahab.year &&
                                date.month == datesahab.month &&
                                date.day == datesahab.day) {
                              flag = false;
                            }
                          }

                          return flag;
                        }),
                  ),

                  const SizedBox(height: 8),
                  // widget.bookingExplanation ??
                  // Wrap(
                  //   alignment: WrapAlignment.spaceAround,
                  //   spacing: 8.0,
                  //   runSpacing: 8.0,
                  //   direction: Axis.horizontal,
                  //   children: [
                  //     BookingExplanation(
                  //         color: widget.availableSlotColor ??
                  //             Colors.greenAccent,
                  //         text: widget.availableSlotText ?? "Available"),
                  //     BookingExplanation(
                  //         color: widget.selectedSlotColor ??
                  //             Colors.orangeAccent,
                  //         text: widget.selectedSlotText ?? "Selected"),
                  //     BookingExplanation(
                  //         color: widget.bookedSlotColor ?? Colors.redAccent,
                  //         text: widget.bookedSlotText ?? "Booked"),
                  //     if (widget.hideBreakTime != null &&
                  //         widget.hideBreakTime == false)
                  //       BookingExplanation(
                  //           color: widget.pauseSlotColor ?? Colors.grey,
                  //           text: widget.pauseSlotText ?? "Break"),
                  //   ],
                  // ),
                  StreamBuilder<dynamic>(
                    stream: widget.getBookingStream(
                        start: startOfDay, end: endOfDay),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return widget.errorWidget ??
                            Center(
                              child: Text(snapshot.error.toString()),
                            );
                      }

                      if (!snapshot.hasData) {
                        return widget.loadingWidget ??
                            const Center(child: CircularProgressIndicator());
                      }

                      ///this snapshot should be converted to List<DateTimeRange>
                      final data = snapshot.requireData;
                      controller.generateBookedSlots(
                          widget.convertStreamResultToDateTimeRanges(
                              streamResult: data));

                      return Container(
                        height: 80,
                        width: MediaQuery.of(context).size.width,
                        child: GridView.builder(
                          physics: widget.gridScrollPhysics ??
                              const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: controller.allBookingSlots.length,
                          itemBuilder: (context, index) {
                            final slot =
                                controller.allBookingSlots.elementAt(index);

                            return BookingSlot(
                              hideBreakSlot: false,
                              pauseSlotColor: widget.pauseSlotColor,
                              availableSlotColor: widget.availableSlotColor,
                              bookedSlotColor: widget.bookedSlotColor,
                              selectedSlotColor: widget.selectedSlotColor,
                              isPauseTime: controller.isSlotInPauseTime(slot),
                              isBooked: controller.isSlotBooked(index),
                              isSelected: index == controller.selectedSlot,
                              onTap: () => controller.selectSlot(index),
                              child: Center(
                                child: Text(
                                  widget.formatDateTime?.call(slot) ??
                                      BookingUtil.formatDateTime(slot),
                                ),
                              ),
                            );
                          },
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount:
                                widget.bookingGridCrossAxisCount ?? 1,
                            childAspectRatio:
                                widget.bookingGridChildAspectRatio ?? 0.75,
                            // maxCrossAxisExtent: 250,
                            // childAspectRatio: 1 / 2,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  if (widget.showData == true) ...[
                    Container(
                      padding: EdgeInsets.all(18),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(widget.bookingService.serviceName),
                          Text('£' +
                              widget.bookingService.servicePrice.toString()),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(18),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Deposit"),
                          widget.bookingService.depositAmount == null
                              ? Text("£15")
                              : Text("£" +
                                  widget.bookingService.depositAmount!
                                      .toStringAsFixed(2)),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(
                    height: 8,
                  ),
                  if (widget.showData == true)
                    CommonButton(
                      text: widget.bookingButtonText ?? 'BOOK',
                      onTap: () async {
                        controller.toggleUploading();
                        await widget.uploadBooking(
                            newBooking:
                                controller.generateNewBookingForUploading());
                        controller.toggleUploading();
                        controller.resetSelectedSlot();
                      },
                      isDisabled: controller.selectedSlot == -1,
                      buttonActiveColor: widget.bookingButtonColor,
                    ),
                  if (widget.showData == false) ...[
                    CommonButton(
                      text: "Remove time slot",
                      onTap: () async {
                        controller.markSlotUnavailable(widget.unavailableSlots!,
                            widget.bookingService.userId);
                      },
                      isDisabled: controller.selectedSlot == -1,
                      buttonActiveColor: widget.bookingButtonColor,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    CommonButton(
                      text: enableButton
                          ? 'Mark this day as "Available" (' +
                              DateFormat('dd-MM-yyyy')
                                  .format(controller.daytoAvail!) +
                              ')'
                          : 'Mark this day as "Unavailable"',
                      onTap: () async {
                        if (!enableButton) {
                          controller.markDayUnavailable(widget.unavailableDays!,
                              widget.bookingService.userId);
                          setState(() {
                            enableButton = true;
                          });
                        } else {
                          controller.markDayAvailable(widget.unavailableDays!,
                              widget.bookingService.userId);
                          setState(() {
                            enableButton = false;
                          });
                        }

                        controller.resetSelectedSlot();
                      },
                      isDisabled: false,
                      buttonActiveColor: widget.bookingButtonColor,
                    ),
                  ]
                ],
              ),
      ),
    );
  }
}
