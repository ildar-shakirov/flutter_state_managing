import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart' show OrdersProvider;
import '../widgets/order_item.dart';
import '../widgets/app_drawer.dart';

class OrdersScreen extends StatelessWidget {
  static const String routeName = '/orders';
  const OrdersScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ordersContainer = Provider.of<OrdersProvider>(context);

    return Scaffold(
        drawer: AppDrawer(),
        appBar: AppBar(
          title: Text('Orders history'),
        ),
        body: ListView.builder(
          itemCount: ordersContainer.orders.length,
          itemBuilder: (_, i) {
            return OrderItem(ordersContainer.orders[i]);
          },
        ));
  }
}
