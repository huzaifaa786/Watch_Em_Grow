import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mipromo/ui/contact_us/contact_us_viewmodel.dart';
import 'package:mipromo/ui/settings/settings_viewmodel.dart';
import 'package:mipromo/ui/shared/helpers/constants.dart';
import 'package:mipromo/ui/shared/widgets/basic_loader.dart';
import 'package:mipromo/ui/shared/widgets/busy_loader.dart';
import 'package:mipromo/ui/shared/widgets/inputfield.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_themes/stacked_themes.dart';
import 'package:velocity_x/velocity_x.dart';

class ContactUsView extends StatelessWidget {
  const ContactUsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //final focusNode = useFocusNode();
    var size = MediaQuery.of(context).size;
    return ViewModelBuilder<ContactUsViewModel>.reactive(
      onModelReady: (model) => model.init(
        isDark: getThemeManager(context).selectedThemeMode == ThemeMode.dark,
      ),
      builder: (context, model, child) => model.isBusy
          ? const BasicLoader()
          : Scaffold(
        appBar: AppBar(
          title: "Contact Us".text.make(),
        ),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    30.heightBox,
                    Row(
                      children: [
                        "Full name".text.size(16).make(),
                      ],
                    ),
                    8.heightBox,
                    Container(
                      height: size.height * 0.05,
                      width: size.width,
                      padding: EdgeInsets.only(left: 5),
                      //margin: EdgeInsets.symmetric(horizontal: size.width * 0.01),
                      decoration: BoxDecoration(
                          color: Color(0xFFF4F4F4),
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Color(0xFFEEEEEE))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          "${model.currentUser.fullName}".text.size(16).gray400.make(),
                        ],
                      ),
                    ),
                    20.heightBox,
                    Row(
                      children: [
                        "Email".text.size(16).make(),
                      ],
                    ),
                    8.heightBox,
                    Container(
                      height: size.height * 0.05,
                      width: size.width,
                      padding: EdgeInsets.only(left: 5),
                      //margin: EdgeInsets.symmetric(horizontal: size.width * 0.01),
                      decoration: BoxDecoration(
                          color: Color(0xFFF4F4F4),
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Color(0xFFEEEEEE))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          "${model.currentUser.email}".text.size(16).gray400.make(),
                        ],
                      ),
                    ),
                    20.heightBox,
                    Row(
                      children: [
                        "Write message".text.size(16).make(),
                      ],
                    ),
                    8.heightBox,
                    Container(
                      height: size.height * 0.15,
                      width: size.width,
                      padding: EdgeInsets.only(left: 10),
                      //margin: EdgeInsets.symmetric(ho: width * 0.03, right: width * 0.03),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Color(0xFFEEEEEE))),
                      child: TextFormField(
                        controller: model.messageController,
                        maxLines: 5,
                        textInputAction: TextInputAction.done,
                        style: TextStyle(
                          color: Colors.black
                        ),
                        decoration: InputDecoration(
                            hintText: 'Write message',
                            hintStyle: TextStyle(fontSize: 16, color: Color(0xffB2B2B2)),
                            border: InputBorder.none),
                      ),
                    ),
                    20.heightBox,
                    Row(
                      children: [
                        Expanded(
                          child: MaterialButton(
                            color: Color(4291861070),
                            onPressed: (){
                              FocusScope.of(context).unfocus();
                              if(model.messageController.text.isNotEmpty){
                                model.sendMessage();
                              }else{
                                Fluttertoast.showToast(
                                    msg: "Please enter message",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    backgroundColor: Colors.black87,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              }
                            },
                            child: const Text(
                              'Send your message',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                  ],
                ),
              ),
            ),
            if (model.isSending) const BusyLoader(busy: true)
          ],
        )
      ),
      viewModelBuilder: () => ContactUsViewModel(),
    );
  }
}
