import 'package:mipromo/app/app.locator.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:mipromo/ui/shared/helpers/enums.dart';

class Alerts {
  Alerts._();

  static final DialogService _dialogService = locator<DialogService>();
  static final SnackbarService _snackbarService = locator<SnackbarService>();

  static Future<void> showServerErrorDialog(String description) async {
    await _dialogService.showCustomDialog(
      variant: AlertType.error,
      title: 'Server Error',
      description: description,
    );
  }

  static Future<void> showBasicFailureDialog(
    String title,
    String? description,
  ) async {
    await _dialogService.showCustomDialog(
      variant: AlertType.warning,
      title: title,
      description: description,
    );
  }

  static void showErrorSnackbar(String message) {
    _snackbarService.showCustomSnackBar(
      variant: AlertType.error,
      title: "Error!",
      message: message,
    );
  }
}
