import 'package:flutter/material.dart';
import '../mocks/products.dart';
import './product.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _items = MOCKED_PRODUCT_LIST;

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((element) => element.isFavorite).toList();
  }

  void addProduct(value) {
    _items.add(value);
    notifyListeners();
  }

  Product findById(id) {
    return _items.firstWhere((item) => item.id == id);
  }
}
