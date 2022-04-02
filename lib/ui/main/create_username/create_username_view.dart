import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mipromo/ui/main/create_username/create_username_viewmodel.dart';
import 'package:mipromo/ui/shared/helpers/constants.dart';
import 'package:mipromo/ui/shared/helpers/validators.dart';
import 'package:mipromo/ui/shared/widgets/basic_loader.dart';
import 'package:mipromo/ui/shared/widgets/inputfield.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class CreateUsernameView extends StatelessWidget {
  const CreateUsernameView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CreateUsernameViewModel>.reactive(
      onModelReady: (model) => model.listenUsers(),
      builder: (context, model, child) =>
          model.isBusy || model.currentUserId.isEmpty
              ? const BasicLoader()
              : Material(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(),
                      Constants.createUsernameLabel.text.xl.bold.make(),
                      const Spacer(),
                      InputField(
                        hintText: 'Username',
                        inputFormatters: [
                          LowerCaseTextFormatter(),
                          FilteringTextInputFormatter.allow(
                            RegExp('[a-z0-9]|[.|_]'),
                          )
                        ],
                        validate: model.validate,
                        maxLength: 30,
                        onChanged: (value) {
                          model.username = value;
                        },
                        validator: (value) => Validators.userNameValidator(
                          username: value,
                          alreadyExists: model.usernames.contains(
                            value!.toLowerCase(),
                          ),
                        ),
                      ),
                      InputField(
                        maxLength: 15,
                        hintText: "First Name",
                        onChanged: (value) {
                          model.firstName = value;
                        },
                        validate: model.validate,
                        validator: (name) => Validators.emptyStringValidator(name, 'First name'),
                      ),
                      InputField(
                        maxLength: 15,
                        hintText: "Last Name",
                        onChanged: (value) {
                          model.lastName = value;
                        },
                        validate: model.validate,
                        validator: (name) => Validators.emptyStringValidator(name, 'Last name'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          model.createUsername();
                        },
                        child: "Done".text.make(),
                      ).objectCenterRight(),
                      const Spacer(
                        flex: 3,
                      ),
                    ],
                  ).p20(),
                ),
      viewModelBuilder: () => CreateUsernameViewModel(),
    );
  }
}
