import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:mipromo/models/app_user.dart';
import 'package:mipromo/ui/shared/helpers/constants.dart';
import 'package:mipromo/ui/shared/helpers/swiper_controller_hook.dart';
import 'package:mipromo/ui/shared/helpers/validators.dart';
import 'package:mipromo/ui/shared/widgets/busy_loader.dart';
import 'package:mipromo/ui/shared/widgets/inputfield.dart';
import 'package:mipromo/ui/shop/create_shop_viewmodel.dart';
import 'package:mipromo/ui/subscription/subscription_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class SubscriptionView extends StatelessWidget {
  const SubscriptionView({
    Key? key,
    required this.user,
  }) : super(key: key);

  final AppUser user;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SubscriptionViewModel>.reactive(
      onModelReady: (model) => model.init(user),
      builder: (context, model, child) {
        return Stack(
          children: [
            Scaffold(
              appBar: AppBar(
                backgroundColor: Color(model.selectedTheme),
                title: Text('Payment Screen'),
                centerTitle: true,
                actions: [],
              ),
              body: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.all(16),
                child: Form(
                  key: model.formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                            decoration: InputDecoration(
                              labelText: "Card number",
                            ),
                            keyboardType: TextInputType.number,
                            controller: model.cardNumberController,
                            validator: (value) {
                              // Remove any spaces or dashes from the card number
                              value = value!;

                              // Check if the card number is empty or not numeric
                              if (value.isEmpty || value.length < 16) {
                                return "Please enter a valid card number";
                              }

                              // Check if the card number is valid using the Luhn algorithm

                              return null;
                            }),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: "Expiry date",
                          ),
                          keyboardType: TextInputType.datetime,
                          controller: model.expiryDateController,
                          validator: (value) {
                            // Regular expression pattern to match the expiry date format
                            if (value!.isEmpty) {
                              return "Please enter a expiry date";
                            }

                            return null;
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: "CVV",
                          ),
                          keyboardType: TextInputType.number,
                          controller: model.cvvController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter CVV";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 32.0),
                        RaisedButton(
                          child: Text("Pay now (23.99£)"),
                          onPressed: () {
                            if (model.formKey.currentState!.validate()) {
                              model.subscriptions();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            BusyLoader(busy: model.isBusy),
          ],
        );
      },
      viewModelBuilder: () => SubscriptionViewModel(),
    );
  }
}
