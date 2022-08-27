import 'package:flutter/material.dart';
import 'package:mipromo/ui/service/inputaddress_viewmodel.dart';
import 'package:mipromo/ui/shared/helpers/constants.dart';
import 'package:mipromo/ui/shared/helpers/validators.dart';
import 'package:mipromo/ui/shared/widgets/busy_loader.dart';
import 'package:mipromo/ui/shared/widgets/inputfield.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class InputAddressView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<InputAddressViewModel>.reactive(
      onModelReady: (model) => model.init(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: const Text('Checkout'),
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
                      InputField(
                        labelText: Constants.fullNameLabel,
                        initialValue: model.fullName,
                        maxLength: 70,
                        counter: "",
                        onChanged: (name) {
                          model.setName(name);
                        },
                        validator: (name) => Validators.emptyStringValidator(
                          name,
                          'Name',
                        ),
                      ),
                      InputField(
                        labelText: Constants.addressLabel,
                        initialValue: model.address,
                        maxLength: 70,
                        counter: "",
                        onChanged: (address) {
                          model.setAddress(address);
                        },
                        validator: (address) => Validators.emptyStringValidator(
                          address,
                          'Address',
                        ),
                      ),
                      InputField(
                        labelText: Constants.postCodeLabel,
                        initialValue: model.postCode,
                        onChanged: (postCode) {
                          model.setPostCode(postCode);
                        },
                        validator: (postCode) => Validators.emptyStringValidator(
                          postCode,
                          'Postcode',
                        ),
                      ),
                      MaterialButton(
                        color: Color(4286745852),
                        onPressed: (model.address.isNotEmpty &&
                                model.postCode.isNotEmpty)
                            ? () {
                                model.updateAddress();
                              }
                            : null,
                        child: const Text(
                          'Confirm',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                          ),
                        ),
                      ),
                      20.heightBox,
                      Container(
                        height: 50,
                          child: Image.asset('assets/images/paypal_logo.png')),
                      150.heightBox,
                      Container(
                          height: 70,
                          child: Image.asset('assets/images/logo_new.png')),
                      Container(
                          height: 30,
                          child: Image.asset('assets/icon/shield.png')),
                      10.heightBox,
                      "We'll keep your funds safe until you confirm that you've received the service".text.center.color(Colors.grey).make()

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
