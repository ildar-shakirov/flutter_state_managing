import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'locator.dart';

import 'core/services/auth_service.dart';
import 'ui/views/login_view.dart';
import 'core/models/user.dart';

import 'ui/router.dart' as appRouter;

void main() {
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider(
      create: (_) => locator<AuthenticationService>().userController.stream,
      initialData: User.initial(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(),
        home: LoginView(),
        onGenerateRoute: (settings) => appRouter.Router.generateRoute(settings),
      ),
    );
  }
}
