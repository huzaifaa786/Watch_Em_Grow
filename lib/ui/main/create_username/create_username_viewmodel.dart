import 'package:mipromo/api/database_api.dart';
import 'package:mipromo/app/app.locator.dart';
import 'package:mipromo/models/app_user.dart';
import 'package:mipromo/services/user_service.dart';
import 'package:mipromo/ui/shared/helpers/validators.dart';
import 'package:stacked/stacked.dart';

class CreateUsernameViewModel extends BaseViewModel {
  final _databaseApi = locator<DatabaseApi>();
  final _userService = locator<UserService>();

  late String currentUserId;

  String username = "";
  String firstName = '';
  String lastName = '';
  bool validate = false;

  bool contains = false;

  List<AppUser> users = [];
  List<String?> usernames = [];

  void listenUsers() {
    currentUserId = _userService.currentUser.id;

    _databaseApi.listenUsers().listen(
      (usersData) {
        users = usersData;
        notifyListeners();

        if (users.isNotEmpty) {
          usernames = users.map((user) => user.username).toList();
        }
      },
    );
  }

  Future<void> createUsername() async {
    if (username.isNotEmpty &&
        Validators.userNameValidator(
              username: username,
              alreadyExists: usernames.contains(
                username.toLowerCase(),
              ),
            ) ==
            null && firstName.isNotEmpty && lastName.isNotEmpty){
      await _databaseApi.createUserInfo(
        userId: currentUserId,
        username: username,
        firstName: firstName,
        lastName: lastName
      );
    } else {
      validate = true;
      notifyListeners();
    }
  }
}
