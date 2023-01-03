import 'dart:developer';
import 'dart:math';

import 'package:intl/intl.dart';
import 'package:mipromo/booking_calender/src/components/booking_dialog.dart';
import 'package:mipromo/booking_calender/src/components/booking_slot.dart';
import 'package:mipromo/booking_calender/src/components/common_button.dart';
import 'package:mipromo/booking_calender/src/components/common_card.dart';
import 'package:mipromo/booking_calender/src/util/booking_util.dart';

import 'package:flutter/material.dart';
import 'package:mipromo/booking_calender/booking_calendar.dart';
import 'package:mipromo/booking_calender/src/core/booking_controller.dart';
import 'package:mipromo/models/extra_services.dart';
import 'package:mipromo/models/shop_service.dart';
import 'package:mipromo/ui/shared/helpers/constants.dart';
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
    this.service,
    this.extraService,
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
  final Future<dynamic> Function({required BookingService newBooking,required String selextraService})
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
  final List? extraService;
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
  final ShopService? service;

  @override
  State<BookingCalendarMain> createState() => _BookingCalendarMainState();
}

class _BookingCalendarMainState extends State<BookingCalendarMain> {
  late BookingController controller;
  final now = DateTime.now();
  bool enableButton = false;
  bool enableslotbutton = false;
  bool enablecopybutton = false;
  bool enablepastebutton = false;
  var selectedExtraService;


  @override
  void initState() {
    super.initState();
    print(widget.unavailableSlots);
    // log(widget.extraService!.price.toString());
    controller = context.read<BookingController>();
    startOfDay = now.startOfDayService(controller.serviceOpening!);
    endOfDay = now.endOfDayService(controller.serviceClosing!);
    _focusedDay = now;
    _selectedDay = now;
    copiedDay = now;
    controller.daytoAvail = now;
  }

  CalendarFormat _calendarFormat = CalendarFormat.month;

  late DateTime _selectedDay;
  late DateTime _focusedDay;
  late DateTime startOfDay;
  late DateTime endOfDay;
  late DateTime copiedDay;
  List<DateTimeRange>? pauseslots = [];

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

  enableSlot(DateTime date, int idx) {
    controller.selectSlot(idx);
    setState(() {
      enableslotbutton = true;
      controller.slottoAvail = date;
    });
  }

  disableSlot(int index) {
    controller.selectSlot(index);
    setState(() {
      enableslotbutton = false;
    });
  }

  enablecopy() {
    pauseslots = controller.copyPauseSlots(_selectedDay);
    if (pauseslots!.isNotEmpty) {
      setState(() {
        enablecopybutton = true;
      });
    } else {
      setState(() {
        enablecopybutton = false;
      });
    }
  }

  enablepaste() {
    if (pauseslots!.isNotEmpty) {
      setState(() {
        copiedDay = _selectedDay;
        enablepastebutton = true;
        enablecopybutton = false;
      });
    }
  }

  pasteslots() async {
    await controller.pastePauseSlots(pauseslots!, _selectedDay,
        widget.unavailableSlots!, widget.bookingService.userId);
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
                            if (!enablepastebutton) {
                              enablecopy();
                            }
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
                      List<DateTime> dataa = controller.allBookingSlots
                          .where((element) =>
                              controller.isSlotInPauseTime(element) == false)
                          .where((element) =>
                              controller.isSlotBooked(controller.allBookingSlots
                                  .indexOf(element)) ==
                              false)
                          .toList();

                      return Container(
                        height: 80,
                        width: MediaQuery.of(context).size.width,
                        child: GridView.builder(
                          padding: EdgeInsets.zero,
                          physics: widget.gridScrollPhysics ??
                              const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: widget.showData == true
                              ? dataa.length
                              : controller.allBookingSlots.length,
                          itemBuilder: (context, index) {
                            final slot = widget.showData == true
                                ? dataa.elementAt(index)
                                : controller.allBookingSlots.elementAt(index);
                            return widget.showData == true
                                ? BookingSlot(
                                    hidethisSlot: false,
                                    hideBreakSlot: false,
                                    sellerPauseTime: false,
                                    pauseSlotColor: widget.pauseSlotColor,
                                    availableSlotColor:
                                        widget.availableSlotColor,
                                    bookedSlotColor: widget.bookedSlotColor,
                                    selectedSlotColor: widget.selectedSlotColor,
                                    isPauseTime:
                                        controller.isSlotInPauseTime(slot),
                                    isBooked: controller.isSlotBooked(index),
                                    isSelected:
                                        index == controller.selectedSlot,
                                    onTap: () => controller.selectSlot(index),
                                    child: Center(
                                      child: Text(
                                        widget.formatDateTime?.call(slot) ??
                                            BookingUtil.formatDateTime(slot),
                                      ),
                                    ),
                                  )
                                : BookingSlot(
                                    hidethisSlot: false,
                                    hideBreakSlot: false,
                                    sellerPauseTime:
                                        controller.isSlotInPauseTime(slot) ==
                                                true
                                            ? true
                                            : false,
                                    pauseSlotColor: widget.pauseSlotColor,
                                    availableSlotColor:
                                        widget.availableSlotColor,
                                    bookedSlotColor: widget.bookedSlotColor,
                                    selectedSlotColor: widget.selectedSlotColor,
                                    isPauseTime:
                                        controller.isSlotInPauseTime(slot),
                                    isBooked: controller.isSlotBooked(index),
                                    isSelected:
                                        index == controller.selectedSlot,
                                    onTap: () =>
                                        controller.isSlotInPauseTime(slot)
                                            ? enableSlot(slot, index)
                                            : disableSlot(index),
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
                      padding: EdgeInsets.all(15),
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
                      padding: EdgeInsets.all(15),
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
                    Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Duration"),
                          widget.service!.duration != null
                              ? Text(widget.service!.duration.toString() + 'm')
                              : Text(""),
                        ],
                      ),
                    ),
                    if(widget.extraService!.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.only(left:12.0,right:12,top:8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('Select Add on service',
                          textAlign: TextAlign.left,
                          style: TextStyle(fontSize: 16),),
                        ],
                      ),
                    ),
                   Padding(
                      padding: const EdgeInsets.only(left:12.0,right:12),
                      child: DropdownButtonFormField<String>(
                        decoration: const InputDecoration.collapsed(
                          hintText: 'Select Add on service',
                        ),
                        onChanged: (type) {
                          setState(() {
                          selectedExtraService = type;
                            
                          });
                        },
                        items:
                        List<DropdownMenuItem<String>>.generate(
                                      widget.extraService!.length,
                                      (index) => DropdownMenuItem<String>(
                                        value: widget.extraService![index].name.toString(),
                                        child:
                                            Text( '£' + widget.extraService![index].price.toString()+ '- '+widget.extraService![index].name.toString()),
                                      ),
                                    ).toList(),
                      )
                          .p12()
                          .centered()
                          .box
                          .border(color: Colors.grey)
                          .height(55)
                          .withRounded(value: 12)
                          //.color(Colors.grey.shade800)
                          .make()
                          .pSymmetric(
                            v: 12,
                          ),
                    ),
                    ]
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
                                controller.generateNewBookingForUploading(),selextraService : selectedExtraService.toString());
                        controller.toggleUploading();
                        controller.resetSelectedSlot();
                      },
                      isDisabled: controller.selectedSlot == -1,
                      buttonActiveColor: widget.bookingButtonColor,
                    ),
                  if (widget.showData == false) ...[
                    !enablepastebutton
                        ? CommonButton(
                            text:
                                enablecopybutton ? "Copy slots" : "Copy slots",
                            onTap: () async {
                              if (enablecopybutton == true) {
                                enablepaste();
                              }
                            },
                            isDisabled: !enablecopybutton,
                            buttonActiveColor: widget.bookingButtonColor,
                          )
                        : CommonButton(
                            text: "Paste slots",
                            onTap: () async {
                              if (copiedDay != _selectedDay) {
                                pasteslots();
                              }
                            },
                            isDisabled: copiedDay == _selectedDay,
                            buttonActiveColor: widget.bookingButtonColor,
                          ),
                    const SizedBox(
                      height: 8,
                    ),
                    CommonButton(
                      text: enableslotbutton
                          ? 'Mark this slot as available(' +
                              BookingUtil.formatDateTime(
                                  controller.slottoAvail!) +
                              ') '
                          : "Remove time slot",
                      onTap: () async {
                        if (enableslotbutton == true) {
                          controller.markSlotavailable(widget.unavailableSlots!,
                              widget.bookingService.userId);
                        } else {
                          controller.markSlotUnavailable(
                              widget.unavailableSlots!,
                              widget.bookingService.userId);
                        }
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
