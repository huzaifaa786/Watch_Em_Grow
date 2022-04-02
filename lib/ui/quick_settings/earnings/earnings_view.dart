import 'package:flutter/material.dart';
import 'package:mipromo/models/app_user.dart';
import 'package:mipromo/ui/quick_settings/earnings/earnings_viewmodel.dart';
import 'package:mipromo/ui/shared/helpers/constants.dart';
import 'package:mipromo/ui/shared/widgets/basic_loader.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class EarningsView extends StatelessWidget {
  const EarningsView({
    Key? key,
    required this.user,
  }) : super(key: key);

  final AppUser user;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<EarningsViewModel>.reactive(
      onModelReady: (model) => model.init(user),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: const Text('Earnings'),
        ),
        body: model.isBusy ? BasicLoader() :
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /*_Data(
              title: Constants.broughtLabel,
              value: user.purchases.toString(),
            ),
            _Data(
              title: Constants.referralsLabel,
              value: user.referrals.toString(),
            ),*/
            _Data(
              title: Constants.earnedLabel,
              value: "£${model.allSales.toStringAsFixed(2)}",
            ),
          ],
        ),
      ),
      viewModelBuilder: () => EarningsViewModel(),
    );
  }
}

class _Data extends StatelessWidget {
  final String title;
  final String value;

  const _Data({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        title.text.gray500.xl2.make().pOnly(
              bottom: 20,
            ),
        value.text.xl2.make(),
      ],
    );
  }
}
