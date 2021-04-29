import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import './cart.dart';
import '../api/constants.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem(
      {@required this.id,
      @required this.amount,
      @required this.products,
      @required this.dateTime});
}

class OrdersProvider with ChangeNotifier {
  List<OrderItem> _orders = [];
  String _authToken;
  String _userId;

  void updateToken(String token, String userId) {
    if (token != null) {
      _authToken = token;
      _userId = userId;
      notifyListeners();
    }
  }

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    final uri =
        Uri.https(API_URL, '/orders/$_userId.json', {'auth': _authToken});
    final response = await http.get(uri);
    final List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(response.body);
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(
        OrderItem(
          id: orderData['id'],
          amount: orderData['amount'],
          products: (orderData['products'] as List<dynamic>)
              .map(
                (item) => CartItem(
                  id: item['id'],
                  title: item['title'],
                  quantity: item['quantity'],
                  price: double.parse(item['price'].toStringAsFixed(2)),
                ),
              )
              .toList(),
          dateTime: DateTime.parse(orderData['dateTime']),
        ),
      );
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future addOrder(List<CartItem> cartProducts, double total) async {
    final uri =
        Uri.https(API_URL, '/orders/$_userId.json', {'auth': _authToken});
    final timestamp = DateTime.now();

    try {
      final response = await http.post(uri,
          body: json.encode({
            'amount': total,
            'dateTime': timestamp.toIso8601String(),
            'products': cartProducts
                .map((item) => {
                      'id': item.id,
                      'title': item.title,
                      'quantity': item.quantity,
                      'price': item.price
                    })
                .toList(),
          }));

      final id = json.decode(response.body)['name'];
      _orders.insert(
        0,
        OrderItem(
          id: id,
          amount: total,
          products: cartProducts,
          dateTime: timestamp,
        ),
      );
    } catch (err) {}
    notifyListeners();
  }
}
