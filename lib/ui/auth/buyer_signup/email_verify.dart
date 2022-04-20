import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mipromo/ui/auth/buyer_signup/buyer_signup_viewmodel.dart';
import 'package:mipromo/ui/auth/widgets/auth_button.dart';
import 'package:mipromo/ui/auth/widgets/auth_header.dart';
import 'package:mipromo/ui/shared/widgets/busy_loader.dart';
import 'package:mipromo/ui/shared/widgets/inputfield.dart';
import 'package:mipromo/ui/shared/widgets/scrollable_body.dart';
import 'package:stacked/stacked.dart';

class EmailVerify extends HookWidget {
  const EmailVerify({Key? key,this.code,this.email}) : super(key: key);
final code;
final email;
  @override
  Widget build(BuildContext context) {
    final veifyemail = useFocusNode();
    
    return ViewModelBuilder<BuyerSignupViewModel>.reactive(
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
                  label: 'Verify Email',
                ),

                const Spacer(),

                // Form
                _SignUpForm(
                  verifyemailFocusNode: veifyemail,
                ),

                AuthButton(
                  label: 'Verify',
                  onPressed: () {
                    model.verify(code,email);
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
      viewModelBuilder: () => BuyerSignupViewModel(),
    );
  }
}

class _SignUpForm extends ViewModelWidget<BuyerSignupViewModel> {
  const _SignUpForm({
    required this.verifyemailFocusNode,
  });

  final FocusNode verifyemailFocusNode;

  @override
  Widget build(
    BuildContext context,
    BuyerSignupViewModel model,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Email Field
        InputField(
          focusNode: verifyemailFocusNode,
          hintText: 'Enter 6-digit code from mail',
          textInputType: TextInputType.number,
          onChanged: (code) {
            model.code1 = code;
          },
        ),

        // Password Field
       
      
      ],
    );
  }
}