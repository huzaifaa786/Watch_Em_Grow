import 'package:mipromo/api/database_api.dart';
import 'package:mipromo/app/app.locator.dart';
import 'package:mipromo/app/app.router.dart';
import 'package:mipromo/models/app_user.dart';
import 'package:mipromo/models/follow.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class FollowersViewModel extends BaseViewModel {
  final _databaseApi = locator<DatabaseApi>();
  final _navigationService = locator<NavigationService>();

  List<Follow> _follows = [];
  List<String> ids = [];
  List<AppUser> users = [];

  Future<void> init(String sellerId) async {
    setBusy(true);

    _follows = await _databaseApi.getFollowers(sellerId);

    if (_follows.isNotEmpty) {
      ids = _follows.map((e) => e.id).toList();

      _databaseApi.listenChatUsers(ids).listen(
        (usersData) {
          users = usersData;
          notifyListeners();
          setBusy(false);
        },
      );
    } else {
      setBusy(false);
    }
  }

  Future navigateToShopView({
    required AppUser owner,
  }) async {
    await _navigationService.navigateTo(
      Routes.sellerProfileView,
      arguments: SellerProfileViewArguments(
        seller: owner,
        viewingAsProfile: false
      ),
    );
  }

  Future navigateToBuyerView({
    required AppUser owner,
  }) async {
    await _navigationService.navigateTo(
      Routes.buyerProfileView,
      arguments: BuyerProfileViewArguments(
        user: owner,
      ),
    );
  }
}
