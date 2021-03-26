import 'dart:async';
import '../../core/models/user.dart';
import '../../core/services/api.dart';
import '../../locator.dart';

class AuthenticationService {
  StreamController<User> userController = StreamController<User>();
  // Inject our Api
  Api _api = locator<Api>();
  Future<bool> login(int userId) async {
    // Get the user profile for id
    var fetcheduser = await _api.getUserProfile(userId);
    var hasUser = fetcheduser != null;
    if (hasUser) {
      userController.add(fetcheduser);
    }
    return hasUser;
  }
}
