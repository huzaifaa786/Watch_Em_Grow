import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:mipromo/booking_calender/booking_calendar.dart';
import 'package:mipromo/models/shop.dart';
import 'package:mipromo/ui/availlability/availability_viewmodel.dart';
import 'package:mipromo/ui/service/create_service_view.dart';
import 'package:mipromo/ui/shared/helpers/validators.dart';
import 'package:mipromo/ui/shared/widgets/basic_loader.dart';
import 'package:mipromo/ui/shared/widgets/inputfield.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_themes/stacked_themes.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:weekday_selector/weekday_selector.dart';

class AvailabilityView extends StatelessWidget {
  final Shop shop;
  const AvailabilityView({Key? key, required this.shop}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);

    return ViewModelBuilder<SetAvailabilityViewModel>.reactive(
      onModelReady: (model) => model.init(
          mshop: shop,
          isDark: getThemeManager(context).selectedThemeMode == ThemeMode.dark,
          context: context),
      builder: (context, model, child) => model.isBusy
          ? const BasicLoader()
          : Scaffold(
              appBar: AppBar(
                title: Text('Set Availability'),
                leading: const BackButton(),
                actions: const [
                  SizedBox.shrink(),
                ],
              ),
              body: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(left: 15, right: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      10.heightBox,
                      "Mark your Availability".text.bold.make(),
                      10.heightBox,
                      WeekdaySelector(
                        firstDayOfWeek: 1,
                        onChanged: (int day) {
                          final index = day % 7;
                          model.selection(index);
                          model.init(
                              mshop: shop,
                              isDark:
                                  getThemeManager(context).selectedThemeMode ==
                                      ThemeMode.dark,
                              context: context);
                        },
                        values: model.values,
                      ),
                      Row(
                        children: [
                          Text('Booking slots from'),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            width: 60,
                            child: GestureDetector(
                              onTap: () {
                                DatePicker.showPicker(context,
                                    showTitleActions: true,
                                    onChanged: (date) {}, onConfirm: (time) {
                                  model.startController.text =
                                      time.hour.toString() + ":00";
                                },
                                    pickerModel: CustomPicker(
                                        currentTime: DateTime.now()),
                                    locale: LocaleType.en);
                                currentFocus.unfocus();
                              },
                              child: InputField(
                                hintText: "Select",
                                maxLength: 24,
                                counter: "",
                                readOnly: true,
                                enable: false,
                                controller: model.startController,
                                textInputType: TextInputType.number,
                                validate: model.autoValidate,
                                validator: (startHour) =>
                                    Validators.emptyStringValidator(
                                  startHour,
                                  'Bookings available from',
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text('till'),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            width: 60,
                            child: GestureDetector(
                              onTap: () {
                                DatePicker.showPicker(context,
                                    showTitleActions: true,
                                    onChanged: (date) {}, onConfirm: (time) {
                                  model.endController.text =
                                      time.hour.toString() + ":00";
                                  ;
                                },
                                    pickerModel: CustomPicker(
                                        currentTime: DateTime.now()),
                                    locale: LocaleType.en);
                                currentFocus.unfocus();
                              },
                              child: InputField(
                                hintText: "Select",
                                maxLength: 24,
                                counter: "",
                                readOnly: true,
                                enable: false,
                                controller: model.endController,
                                textInputType: TextInputType.number,
                                validate: model.autoValidate,
                                validator: (endHour) =>
                                    Validators.emptyStringValidator(
                                  endHour,
                                  'Booking available till',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              model.updateTime();
                              currentFocus.unfocus();
                              model.init(
                                  mshop: shop,
                                  isDark: getThemeManager(context)
                                          .selectedThemeMode ==
                                      ThemeMode.dark,
                                  context: context);
                            },
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<OutlinedBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                            child: Text('Update'),
                          ),
                        ],
                      ),
                      BookingCalendar(
                        bookingGridCrossAxisCount: 1,
                        bookingGridChildAspectRatio: 0.75,
                        bookingService: model.mockBookingService,
                        getBookingStream: model.getBookingStreamMock,
                        uploadBooking: model.uploadBookingMock,
                        unavailableDays: model.unavailableDays,
                        unavailableSlots: model.unavailableSlots,
                        convertStreamResultToDateTimeRanges:
                            model.convertStreamResultMock,
                        excludedDays: model.excludedDays,
                        pauseSlots: model.generatePauseSlots(),
                        pauseSlotText: 'LUNCH',
                        showData: false,
                        availableSlotColor:
                            model.isDarkMode ? Colors.black : Colors.white,
                        hideBreakTime: model.isDarkMode ? true : false,
                        bookedSlotColor: Color(4286745852).withOpacity(0.3),
                        selectedSlotColor: Color(4286745852),
                        bookingButtonColor: Color(4286745852),
                        // bookingButtonText: ,
                        uploadingWidget: Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(top: 20),
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.grey,
                              color: Color(4286745852),
                              strokeWidth: 10,
                            )),
                      ),
                    ],
                  ),
                ),
              )),
      viewModelBuilder: () => SetAvailabilityViewModel(),
    );
  }
}
