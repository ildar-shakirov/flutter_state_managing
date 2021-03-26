import 'package:get_it/get_it.dart';

import 'core/view-models/homeview_model.dart';
import 'core/view-models/login_model.dart';
import 'core/view-models/comments_model.dart';
import 'core/services/auth_service.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => AuthenticationService());

  locator.registerLazySingleton(() => LoginModel());
  locator.registerLazySingleton(() => HomeModel());
  locator.registerLazySingleton(() => LoginModel());
  locator.registerLazySingleton(() => CommentsModel());
}
