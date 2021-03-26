import 'package:flutter/material.dart';

import '../../core/view-models/login_model.dart';

import '../shared/app_colors.dart';
import '../widgets/login_header.dart';
import './base_view.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BaseView<LoginModel>(
          builder: (context, model, child) => Scaffold(
            backgroundColor: backgroundColor,
            body: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LoginHeader(
                    validationMessage: model.errorMessage,
                    controller: controller),
                TextButton(
                  onPressed: () async {
                    var loginSuccess = await model.login(controller.text);
                    if (loginSuccess) {
                      Navigator.of(context).pushNamed('/');
                    }
                  },
                  child: Text(
                    'Login',
                    style: TextStyle(color: Colors.black),
                  ),
                )
              ],
            )),
    ),
  }
}
