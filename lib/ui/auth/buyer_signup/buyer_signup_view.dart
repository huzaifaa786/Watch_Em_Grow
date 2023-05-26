import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mipromo/ui/auth/buyer_signup/buyer_signup_viewmodel.dart';
import 'package:mipromo/ui/auth/widgets/auth_button.dart';
import 'package:mipromo/ui/auth/widgets/auth_header.dart';
import 'package:mipromo/ui/auth/widgets/auth_sub_header.dart';
import 'package:mipromo/ui/auth/widgets/auth_terms_footer.dart';
import 'package:mipromo/ui/auth/widgets/input_lable_mobile.dart';
import 'package:mipromo/ui/auth/widgets/lnput_lable.dart';
import 'package:mipromo/ui/shared/helpers/constants.dart';
import 'package:mipromo/ui/shared/helpers/validators.dart';
import 'package:mipromo/ui/shared/widgets/busy_loader.dart';
import 'package:mipromo/ui/shared/widgets/inputfield.dart';
import 'package:mipromo/ui/shared/widgets/scrollable_body.dart';
import 'package:stacked/stacked.dart';

class BuyerSignupView extends HookWidget {
  const BuyerSignupView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final emailFocusNode = useFocusNode();
    final passwordFocusNode = useFocusNode();
    Brightness brightness = Theme.of(context).brightness;
    bool darkModeOn = brightness == Brightness.dark;
    return ViewModelBuilder<BuyerSignupViewModel>.reactive(
      builder: (context, model, child) => Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              iconTheme: IconThemeData(
                color: darkModeOn ? Colors.white : Colors.black,
              ),
            ),
            body: ScrollableBody(
              children: [
                // Heading
                const AuthHeader(
                  label: Constants.signupTitle,
                ),
               const AuthSubHeader(
                  label: Constants.signupSubTitle,
                ),
                const SizedBox(height:20,),
                // Form
                _SignUpForm(
                  emailFocusNode: emailFocusNode,
                  passwordFocusNode: passwordFocusNode,
                ),
                const SizedBox(height: 20,),
                AuthButton(
                  label: Constants.signupLabel,
                  onPressed: () {
                    emailFocusNode.unfocus();
                    passwordFocusNode.unfocus();
                    model.signUp();
                  },
                ),

                // const Spacer(flex: 3),
              ],
            ),
            bottomNavigationBar: AuthTermsFooter(
              value: model.termsCheckBoxValue,
              onChanged: (v) {
                model.toggleTermsCheckBoxValue(value: v!);
              },
            ),
            
          ),

          // Loading Widget
          BusyLoader(busy: model.isBusy),
        ],
      ),
      viewModelBuilder: () => BuyerSignupViewModel(),
    );
  }
}

class _SignUpForm extends ViewModelWidget<BuyerSignupViewModel> {
  const _SignUpForm({
    required this.emailFocusNode,
    required this.passwordFocusNode,
  });

  final FocusNode emailFocusNode;
  final FocusNode passwordFocusNode;

  @override
  Widget build(
    BuildContext context,
    BuyerSignupViewModel model,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Email Field
        // InputField(
        //   focusNode: emailFocusNode,
        //   hintText: Constants.emailLabel,
        //   validate: model.validateForm,
        //   textInputType: TextInputType.emailAddress,
        //   onChanged: (email) {
        //     model.email = email;
        //   },
        //   validator: (email) => Validators.emailValidator(email),
        //   onEditingComplete: () => emailFocusNode.nextFocus(),
        // ),
     const  InputLable(label:Constants.firstName ),
 InputField(
          // focusNode: emailFocusNode,
          hintText: Constants.hintFirstName,
          validate: model.validateForm,
          textInputType: TextInputType.name,
          // onChanged: (email) {
          //   model.email = email;
          // },
          // validator: (email) => Validators.emailValidator(email),
          // onEditingComplete: () => emailFocusNode.nextFocus(),
        ),
     const  InputLable(label:Constants.lastName ),

        InputField(
          // focusNode: emailFocusNode,
          hintText: Constants.hintLastName,
          validate: model.validateForm,
          textInputType: TextInputType.name,
          // onChanged: (email) {
          //   model.email = email;
          // },
          // validator: (email) => Validators.emailValidator(email),
          // onEditingComplete: () => emailFocusNode.nextFocus(),
        ),
        // Password Field
     const  InputLable(label:Constants.passwordLabel ),

        InputField(
          focusNode: passwordFocusNode,
          validate: model.validateForm,
          hintText: Constants.hintPasswordLabel,
          onChanged: (password) {
            model.password = password;
          },
          validator: (password) => Validators.passwordValidator(password),
          isPassword: !model.isPasswordVisible,
          suffixIcon: IconButton(
            splashColor: Colors.transparent,
            icon: model.isPasswordVisible
                ? const Icon(
                    Icons.visibility,
                  )
                : const Icon(
                    Icons.visibility_off,
                    color: Colors.grey,
                  ),
            onPressed: () {
              model.togglePasswordVisibility();
            },
          ),
        ),
     const  InputLableMobile(label:Constants.mobileNumberLabel),
         InputField(
          // focusNode: phoneNumberFocusNode,
          validate: model.validateForm,
          hintText: Constants.hintMobileNumberLabel,
          textInputType: TextInputType.number,
          // onChanged: (phoneNumber) {
          //   model.phoneNumber = phoneNumber;
          // },
          // validator: (phoneNumber) => Validators.emptyStringValidator(
          //   phoneNumber,
          //   'Phone Number',
          // ),
        ),
      ],
    );
  }
}
