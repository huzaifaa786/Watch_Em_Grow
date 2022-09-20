import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:mipromo/api/auth_api.dart';
import 'package:mipromo/api/database_api.dart';
import 'package:mipromo/app/app.locator.dart';
import 'package:mipromo/models/app_user.dart';

class UserService {
  final _authApi = locator<AuthApi>();
  final _databaseApi = locator<DatabaseApi>();    

  AppUser? _currentUser;

  AppUser get currentUser => _currentUser!;

  Future<bool> syncUser() async {
    final userId = _authApi.currentUser!.uid;
    final userAccount = await _databaseApi.getUserLogin(userId);

    if (userAccount.token != '123') {
      _currentUser = userAccount;
      return true;
    }
    return false;
  }

  Future<void> updateToken() async {
    final userId = _authApi.currentUser!.uid;
    final token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      await _databaseApi.updateUserToken(userId, token);
    }
  }

  Future<void> syncOrCreateUser({
    required AppUser user,
  }) async {
    await syncUser().then((value) async {
      if (/*_currentUser == null*/value == false) {
        await _databaseApi.createUser(user);

      } else {
      }
    });
  }
}
