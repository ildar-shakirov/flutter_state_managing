import 'package:flutter/material.dart';
import '../mocks/products.dart';
import './product.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _items = MOCKED_PRODUCT_LIST;
  bool _showFavorites = false;

  List<Product> get items {
    if (_showFavorites) {
      return _items.where((item) => item.isFavorite).toList();
    }
    return [..._items];
  }

  void addProduct(value) {
    _items.add(value);
    notifyListeners();
  }

  Product findById(id) {
    return _items.firstWhere((item) => item.id == id);
  }

  void showFavoritesOnly() {
    _showFavorites = true;
    notifyListeners();
  }

  void showAll() {
    _showFavorites = false;
    notifyListeners();
  }
}
