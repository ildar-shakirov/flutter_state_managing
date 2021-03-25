import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../api/constants.dart';
import '../models/http_exception.dart';
import './product.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((element) => element.isFavorite).toList();
  }

  String _authToken;

  void updateToken(String token) {
    if (token != null) {
      _authToken = token;
      notifyListeners();
    }
  }

  Future<void> fetchAndSetProducts() async {
    final uri = Uri.https(API_URL, '/products.json', {'auth': _authToken});
    try {
      final response = await http.get(uri);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(
          Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            imageUrl: prodData['imageUrl'],
            price: prodData['price'],
          ),
        );
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future addProduct(Product product) async {
    final url = Uri.https('flutter-learning-36ca3-default-rtdb.firebaseio.com',
        '/products.json', {'auth': _authToken});

    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'price': product.price,
          'imageUrl': product.imageUrl,
          'description': product.description,
          'isFavorite': product.isFavorite,
        }),
      );

      final newProduct = Product(
        description: product.description,
        title: product.title,
        price: product.price,
        imageUrl: product.imageUrl,
        id: json.decode(response.body)['name'],
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future updateProduct(String id, Product newProduct) async {
    final productIndex = _items.indexWhere((prod) => prod.id == id);
    final updateProductUri =
        Uri.https(API_URL, '/products/$id.json', {'auth': _authToken});
    if (productIndex >= 0) {
      try {
        final response = await http.patch(
          updateProductUri,
          body: json.encode({
            'title': newProduct.title,
            'price': newProduct.price,
            'imageUrl': newProduct.imageUrl,
            'description': newProduct.description,
            'isFavorite': newProduct.isFavorite,
          }),
        );
        if (response.statusCode != 200) {
          throw Error();
        }
        _items[productIndex] = newProduct;
        notifyListeners();
      } catch (error) {
        print(error);
      }
    } else {
      print('....');
    }
  }

  Future deleteProduct(String id) async {
    final deleteProductUri =
        Uri.https(API_URL, '/products/$id', {'auth': _authToken});

    final existingProductIndex =
        _items.indexWhere((element) => element.id == id);
    Product existingProduct = _items[existingProductIndex];

    _items.removeAt(existingProductIndex);
    notifyListeners();

    final response = await http.delete(deleteProductUri);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException("Couln't delete product");
    }
    existingProduct = null;
  }

  Product findById(id) {
    return _items.firstWhere((item) => item.id == id);
  }
}
