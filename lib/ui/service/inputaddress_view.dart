import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mipromo/models/shop_service.dart';
import 'package:mipromo/ui/service/inputaddress_viewmodel.dart';
import 'package:mipromo/ui/shared/helpers/constants.dart';
import 'package:mipromo/ui/shared/helpers/validators.dart';
import 'package:mipromo/ui/shared/widgets/busy_loader.dart';
import 'package:mipromo/ui/shared/widgets/inputfield.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class InputAddressView extends StatelessWidget {
  final ShopService service;

  const InputAddressView({
    Key? key,
    required this.service,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<InputAddressViewModel>.reactive(
      onModelReady: (model) => model.init(service),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: const Text('Buy Subscription'),
        ),
        body: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Stack(
            children: [
              if (model.user != null)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 24,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        height: 50,
                      ),
                      Container(
                          height: 50,
                          child: Image.asset('assets/images/stripe_logo.png')),
                      20.heightBox,
                      InputField(
                        labelText: 'Card Number',
                        initialValue: model.cardNum,
                        maxLength: 16,
                        textInputType: TextInputType.number,
                        counter: "",
                        onChanged: (cardNumber) {
                          model.setcardNumber(cardNumber);
                        },
                        validator: (cardNumber) =>
                            Validators.emptyStringValidator(
                          cardNumber,
                          'Card Number',
                        ),
                      ),
                      Row(
                        children: [],
                      ),
                      InputField(
                        labelText: 'Month',
                        initialValue: model.expMonths,
                        textInputType: TextInputType.number,
                        maxLength: 2,
                        counter: "",
                        onChanged: (expMonth) {
                          model.setexpMonth(expMonth);
                        },
                        validator: (month) => Validators.emptyStringValidator(
                          month,
                          'Month',
                        ),
                      ),
                      InputField(
                        labelText: 'Year',
                        initialValue: model.expYears,
                        textInputType: TextInputType.number,
                        maxLength: 2,
                        counter: "",
                        onChanged: (expYear) {
                          model.setexpYear(expYear);
                        },
                        validator: (expYear) => Validators.emptyStringValidator(
                          expYear,
                          'Year',
                        ),
                      ),
                      InputField(
                        labelText: 'Cvc',
                        initialValue: model.cardCvc,
                        maxLength: 3,
                        counter: "",
                        textInputType: TextInputType.number,
                        onChanged: (cvc) {
                          model.setCvv(cvc);
                        },
                        validator: (cvc) => Validators.emptyStringValidator(
                          cvc,
                          'Cvc',
                        ),
                      ),
                      MaterialButton(
                        color: Color(4291861070),
                        onPressed: (model.cardNum.isNotEmpty &&
                                model.cardCvc.isNotEmpty &&
                                model.expMonths.isNotEmpty &&
                                model.expYears.isNotEmpty)
                            ? () {
                                model.subscriptions();
                              }
                            : null,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Color(4291861070),
                          ),
                          child: Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 10, bottom: 10),
                              child: const Text(
                                'Confirm',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                      50.heightBox,
                      Container(
                          height: 70,
                          child: Image.asset('assets/icon/app_icon.png')),
                      Container(
                          height: 30,
                          child: Image.asset('assets/icon/shield.png')),
                      10.heightBox,
                      "We'll keep your information Secure"
                          .text
                          .center
                          .color(Colors.grey)
                          .make()
                    ],
                  ),
                ),
              BusyLoader(busy: model.isBusy)
            ],
          ),
        ),
      ),
      viewModelBuilder: () => InputAddressViewModel(),
    );
  }
}
