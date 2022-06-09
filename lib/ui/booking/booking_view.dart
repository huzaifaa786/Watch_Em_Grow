import 'package:booking_calendar/booking_calendar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mipromo/ui/booking/booking_viewmodel.dart';
import 'package:mipromo/ui/shared/widgets/basic_loader.dart';
import 'package:mipromo/ui/shared/widgets/busy_loader.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_themes/stacked_themes.dart';
import 'package:velocity_x/velocity_x.dart';

class BookingView extends StatelessWidget {
  const BookingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //final focusNode = useFocusNode();
    // var size = MediaQuery.of(context).size;
    return ViewModelBuilder<BookingViewModel>.reactive(
      onModelReady: (model) => model.init(
        isDark: getThemeManager(context).selectedThemeMode == ThemeMode.dark,
      ),
      builder: (context, model, child) => model.isBusy
          ? const BasicLoader()
          : Scaffold(
              appBar: AppBar(
                title: "Edit Booking Calendar".text.make(),
              ),
              body: Stack(
                children: [
                  SingleChildScrollView(
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width*0.9,
                      child: BookingCalendar(
                        bookingService: model.mockBookingService,
                        getBookingStream: model.getBookingStreamMock,
                        uploadBooking: model.uploadBookingMock,
                        convertStreamResultToDateTimeRanges:
                            model.convertStreamResultMock,
                        pauseSlots: model.pauseSlots,
                        pauseSlotText: 'LUNCH',
                        hideBreakTime: false,
                        loadingWidget: Text('Lunch'),
                      ),
                    ),
                  ),
                  if (model.isSending) const BusyLoader(busy: true)
                ],
              )),
      viewModelBuilder: () => BookingViewModel(),
    );
  }
}
