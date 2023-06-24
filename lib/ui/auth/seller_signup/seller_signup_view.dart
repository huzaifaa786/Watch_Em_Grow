import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:mipromo/models/app_user.dart';
import 'package:mipromo/ui/auth/seller_signup/seller_signup_viewmodel.dart';
import 'package:mipromo/ui/auth/widgets/auth_button.dart';
import 'package:mipromo/ui/auth/widgets/auth_header.dart';
import 'package:mipromo/ui/shared/helpers/constants.dart';
import 'package:mipromo/ui/shared/helpers/validators.dart';
import 'package:mipromo/ui/shared/widgets/busy_loader.dart';
import 'package:mipromo/ui/shared/widgets/inputfield.dart';
import 'package:mipromo/ui/shared/widgets/scrollable_body.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_hooks/stacked_hooks.dart';

class SellerSignupView extends StatelessWidget {
  const SellerSignupView({
    Key? key,
    required this.user,
  }) : super(key: key);

  final AppUser user;

  @override
  Widget build(BuildContext context) {
    Brightness brightness = Theme.of(context).brightness;
    bool darkModeOn = brightness == Brightness.dark;
    return ViewModelBuilder<SellerSignupViewModel>.reactive(
      onModelReady: (model) => model.init(user),
      builder: (context, model, child) => Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            ),
            body: ScrollableBody(
              children: [
                // Heading
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     GestureDetector(
                //         onTap: () {
                //           Navigator.pop(context);
                //         },
                //         child: Icon(
                //           Icons.arrow_back_rounded,
                //           size: 33,
                //           color: darkModeOn ? Colors.white : Colors.black,
                //         )),
                //     AuthHeader(
                //       label: Constants.createSellerLabel,
                //     ),
                //     // Icon(
                //     //   Icons.arrow_back,
                //     // color: darkModeOn ? Colors.white : Colors.black,
                //     // ),
                //   ],
                // ),
                AuthHeader(
                  label: Constants.createSellerLabel,
                ),
                const Spacer(),

                // Form
                _SignUpForm(),

                AuthButton(
                  label: Constants.createLabel,
                  onPressed: () {
                    model.signUp();
                  },
                ),

                const Spacer(flex: 3),
              ],
            ),
          ),

          // Loading Widget
          BusyLoader(busy: model.isBusy),
        ],
      ),
      viewModelBuilder: () => SellerSignupViewModel(),
    );
  }
}

class _SignUpForm extends HookViewModelWidget<SellerSignupViewModel> {
  @override
  Widget buildViewModelWidget(
    BuildContext context,
    SellerSignupViewModel model,
  ) {
    final dobController = useTextEditingController();

    final nameFocusNode = useFocusNode();

    final dobFocusNode = useFocusNode();
    dobFocusNode.addListener(() {
      model.notifyListeners();
    });

    final phoneNumberFocusNode = useFocusNode();
    phoneNumberFocusNode.addListener(() {
      model.notifyListeners();
    });

    final mailFocusNode = useFocusNode();
    mailFocusNode.addListener(() {
      model.notifyListeners();
    });

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        InputField(
          focusNode: nameFocusNode,
          validate: model.validateForm,
          hintText: Constants.fullNameLabel,
          onChanged: (name) {
            model.name = name;
          },
          validator: (name) => Validators.emptyStringValidator(name, 'Name'),
        ),
        InputField(
          controller: dobController,
          validate: model.validateForm,
          focusNode: dobFocusNode,
          readOnly: true,
          hintText: Constants.dobLabel,
          helperText: dobFocusNode.hasFocus
              ? model.selectedDate == null
                  ? Constants.dobHelperTextLabel
                  : null
              : null,
          suffixIcon: IconButton(
            icon: const Icon(
              Icons.calendar_today_rounded,
            ),
            onPressed: () async {
              final pickedDate = showDatePicker(
                initialDate: DateTime.now(),
                context: context,
                firstDate: DateTime(1950, 8),
                lastDate: DateTime(2101),
              );

              await model.selectDate(pickedDate);

              if (model.selectedDate != null) {
                dobController.text =
                    DateFormat.yMMMd().format(model.selectedDate!).toString();
              }
            },
          ),
          validator: (dob) => Validators.dobValidator(
            dob: dob,
            age: model.selectedDate == null
                ? 17
                : DateTime.now().year - model.selectedDate!.year,
          ),
        ),
        InputField(
          focusNode: phoneNumberFocusNode,
          validate: model.validateForm,
          hintText: Constants.mobileNumberLabel,
          textInputType: TextInputType.number,
          onChanged: (phoneNumber) {
            model.phoneNumber = phoneNumber;
          },
          validator: (phoneNumber) => Validators.emptyStringValidator(
            phoneNumber,
            'Phone Number',
          ),
        ),
        // InputField(
        //   focusNode: mailFocusNode,
        //   validate: model.validateForm,
        //   hintText: 'Mail Id (PayPal)',
        //   helperText: mailFocusNode.hasFocus
        //       ? 'Please provide your PayPal registered Mail Id to recieve payments.'
        //       : null,
        //   textInputType: TextInputType.emailAddress,
        //   onChanged: (mail) {
        //     model.paypalMail = mail;
        //   },
        //   validator: (mail) => Validators.emptyStringValidator(
        //     mail,
        //     'Mail Id',
        //   ),
        // ),
     
     
      ],
    );
  }
}
