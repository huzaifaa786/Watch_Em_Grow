import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:mipromo/ui/startup/startup_viewmodel.dart';
import 'package:mipromo/ui/startup/widgets/splash_screen.dart';
import 'package:stacked/stacked.dart';

class StartUpView extends StatelessWidget {
  const StartUpView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      ViewModelBuilder<StartUpViewModel>.reactive(
        builder: (context, model, child) => const SplashScreen(),
        onModelReady: (model) =>
            SchedulerBinding.instance?.addPostFrameCallback((_) {
          model.runStartupLogic();
        }),
        viewModelBuilder: () => StartUpViewModel(),
      );
}
