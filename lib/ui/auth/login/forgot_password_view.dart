import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mipromo/ui/auth/login/login_viewmodel.dart';
import 'package:mipromo/ui/shared/helpers/validators.dart';
import 'package:mipromo/ui/shared/widgets/scrollable_body.dart';
import 'package:mipromo/ui/auth/widgets/auth_button.dart';
import 'package:mipromo/ui/auth/widgets/auth_header.dart';
import 'package:mipromo/ui/shared/helpers/constants.dart';
import 'package:mipromo/ui/shared/widgets/busy_loader.dart';
import 'package:mipromo/ui/shared/widgets/inputfield.dart';
import 'package:stacked/stacked.dart';

class ForgotPasswordView extends HookWidget {
  const ForgotPasswordView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final focusNode = useFocusNode();

    return ViewModelBuilder<LoginViewModel>.reactive(
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
                const AuthHeader(
                  label: Constants.forgotPasswordLabel,
                ),

                const Spacer(),

                InputField(
                  focusNode: focusNode,
                  hintText: Constants.emailLabel,
                  validate: model.validateForm,
                  textInputType: TextInputType.emailAddress,
                  onChanged: (email) {
                    model.forgotPasswordEmail = email;
                  },
                  validator: (email) => Validators.emailValidator(email),
                ),
                AuthButton(
                  label: Constants.nextLabel,
                  onPressed: () {
                    focusNode.unfocus();
                    model.forgotPassword();
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
      viewModelBuilder: () => LoginViewModel(),
    );
  }
}
