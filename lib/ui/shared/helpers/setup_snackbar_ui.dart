import 'package:flutter/material.dart';
import 'package:mipromo/app/app.locator.dart';
import 'package:mipromo/ui/shared/helpers/enums.dart';
import 'package:stacked_services/stacked_services.dart';

void setupSnackbarUI() {
  final snackbarService = locator<SnackbarService>();

  snackbarService.registerCustomSnackbarConfig(
    variant: AlertType.error,
    config: SnackbarConfig(
      backgroundColor: Colors.red,
      borderRadius: 12,
      margin: const EdgeInsets.all(15),
    ),
  );
}
