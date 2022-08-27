import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mipromo/ui/auth/login/login_viewmodel.dart';
import 'package:mipromo/ui/shared/helpers/validators.dart';
import 'package:mipromo/ui/shared/widgets/scrollable_body.dart';
import 'package:mipromo/ui/auth/widgets/auth_button.dart';
import 'package:mipromo/ui/auth/widgets/auth_header.dart';
import 'package:mipromo/ui/auth/widgets/password_visibility_switcher.dart';
import 'package:mipromo/ui/shared/helpers/constants.dart';
import 'package:mipromo/ui/shared/widgets/busy_loader.dart';
import 'package:mipromo/ui/shared/widgets/inputfield.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class LoginView extends HookWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final emailFocusNode = useFocusNode();
    final passwordFocusNode = useFocusNode();
      Brightness brightness = Theme.of(context).brightness;
    bool darkModeOn = brightness == Brightness.dark;

    return ViewModelBuilder<LoginViewModel>.reactive(
      builder: (context, model, child) => Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              elevation: 0,
               iconTheme: IconThemeData(
                color: darkModeOn ? Colors.white : Colors.black,
              ),
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            ),
            body: ScrollableBody(
              children: [
                // Heading
                const AuthHeader(
                  label: Constants.loginLabel,
                ),

                const Spacer(),

                // Form
                _LoginForm(
                  emailFocusNode: emailFocusNode,
                  passwordFocusNode: passwordFocusNode,
                ),

                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    "${Constants.forgotPasswordLabel} ?"
                        .text
                        .color(Theme.of(context).primaryColor)
                        .make()
                        .click(
                      () {
                        model.navigateToForgotPasswordView();
                      },
                    ).make(),
                    AuthButton(
                      label: Constants.loginLabel,
                      onPressed: () {
                        emailFocusNode.unfocus();
                        passwordFocusNode.unfocus();
                        model.login();
                      },
                    ),
                  ],
                ),
                const Spacer(flex: 3),
              ],
            ),
          ),

          // Loading Widget
          BusyLoader(busy: model.isBusy),
        ],
      ),
      viewModelBuilder: () => LoginViewModel(),
    );
  }
}

class _LoginForm extends ViewModelWidget<LoginViewModel> {
  const _LoginForm({
    required this.emailFocusNode,
    required this.passwordFocusNode,
  });

  final FocusNode emailFocusNode;
  final FocusNode passwordFocusNode;

  @override
  Widget build(
    BuildContext context,
    LoginViewModel model,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Email Field
        InputField(
          focusNode: emailFocusNode,
          hintText: Constants.emailLabel,
          validate: model.validateForm,
          textInputType: TextInputType.emailAddress,
          onChanged: (email) {
            model.loginEmail = email;
          },
          validator: (email) => Validators.emailValidator(email),
          onFieldSubmitted: (_) {
            emailFocusNode.unfocus();
            passwordFocusNode.requestFocus();
          },
        ),

        // Password Field
        InputField(
          focusNode: passwordFocusNode,
          hintText: Constants.passwordLabel,
          validate: model.validateForm,
          onChanged: (password) {
            model.loginPassword = password;
          },
          validator: (password) => Validators.passwordValidator(password),
          onFieldSubmitted: (_) {
            passwordFocusNode.unfocus();
          },
          isPassword: !model.isPasswordVisible,
          suffixIcon: PasswordVisibilitySwitcher(
            visibility: model.isPasswordVisible,
            onPressed: () {
              model.togglePasswordVisibility();
            },
          ),
        ),
      ],
    );
  }
}
