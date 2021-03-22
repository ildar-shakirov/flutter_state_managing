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

  void addProduct(Product product) {
    final newProduct = Product(
      description: product.description,
      title: product.title,
      price: product.price,
      imageUrl: product.imageUrl,
      id: DateTime.now().toString(),
    );
    _items.add(newProduct);
    notifyListeners();
  }

  void updateProduct(String id, Product newProduct) {
    final productIndex = _items.indexWhere((prod) => prod.id == id);
    if (productIndex >= 0) {
      _items[productIndex] = newProduct;
      notifyListeners();
    } else {
      print('....');
    }
  }

  void deleteProduct(String id) {
    _items.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  Product findById(id) {
    return _items.firstWhere((item) => item.id == id);
  }
}
