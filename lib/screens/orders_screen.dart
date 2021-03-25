import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart' show OrdersProvider;
import '../widgets/order_item.dart';
import '../widgets/app_drawer.dart';

class OrdersScreen extends StatefulWidget {
  static const String routeName = '/orders';
  const OrdersScreen({Key key}) : super(key: key);

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  Future _ordersFuture;

  @override
  void initState() {
    _ordersFuture =
        Provider.of<OrdersProvider>(context, listen: false).fetchAndSetOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: AppDrawer(),
        appBar: AppBar(
          title: Text('Orders history'),
        ),
        body: FutureBuilder(
          builder: (ctx, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              if (dataSnapshot.error != null) {
                // error handling
              } else {
                return Consumer<OrdersProvider>(
                    builder: (ctx, ordersContainer, child) => ListView.builder(
                          itemCount: ordersContainer.orders.length,
                          itemBuilder: (_, i) {
                            return OrderItem(ordersContainer.orders[i]);
                          },
                        ));
              }
            }
            return null;
          },
          future: _ordersFuture,
        ));
  }
}
