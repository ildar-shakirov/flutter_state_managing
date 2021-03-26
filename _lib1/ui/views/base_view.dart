import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../locator.dart';

import '../../core/view-models/base_model.dart';

class BaseView<T extends BaseModel> extends StatefulWidget {
  final Widget Function(BuildContext context, T value, Widget child) builder;
  final Function onModeReady;
  BaseView({this.builder, this.onModeReady});

  @override
  _BaseViewState<T> createState() => _BaseViewState<T>();
}

class _BaseViewState<T extends BaseModel> extends State<BaseView<T>> {
  T model = locator<T>();
  @override
  void initState() {
    if (widget.onModeReady != null) {
      widget.onModeReady(model);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => locator<T>(),
      child: Consumer<T>(builder: widget.builder),
    );
  }
}
