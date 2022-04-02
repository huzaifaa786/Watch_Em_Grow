import 'package:firebase_auth/firebase_auth.dart';
import 'package:mipromo/api/database_api.dart';
import 'package:mipromo/app/app.locator.dart';
import 'package:mipromo/models/app_user.dart';
import 'package:stacked/stacked.dart';

class EarningsViewModel extends BaseViewModel {
  final _databaseApi = locator<DatabaseApi>();

  late AppUser user;
  late double allSales;

  Future<void> init(AppUser user) async {
    setBusy(true);
    this.user = user;
    allSales = await _databaseApi.getAllEarnings(user.shopId);
    setBusy(false);
  }
}