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
  String _userId;

  void updateToken(String token, String userId) {
    if (token != null) {
      _authToken = token;
      _userId = userId;
      notifyListeners();
    }
  }

  Future<void> fetchAndSetProducts() async {
    final productsUri = Uri.https(
      API_URL,
      '/products.json',
      {
        'auth': _authToken,
        'orderBy': json.encode("creatorId"),
        'equalTo': json.encode(_userId),
      },
    );
    final favoritesUri = Uri.https(
        API_URL, '/userFavorites/$_userId.json', {'auth': _authToken});
    try {
      final favoritesResponse = await http.get(
        favoritesUri,
      );
      final productsResponse = await http.get(productsUri);
      final extractedFavorites =
          json.decode(favoritesResponse.body) as Map<String, dynamic>;

      final extractedProducts =
          json.decode(productsResponse.body) as Map<String, dynamic>;

      if (extractedProducts == null) {
        return;
      }

      final List<Product> loadedProducts = [];
      extractedProducts.forEach((prodId, prodData) {
        loadedProducts.add(
          Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            imageUrl: prodData['imageUrl'],
            price: double.parse(prodData['price'].toString()),
            isFavorite: extractedFavorites != null &&
                    extractedFavorites.containsKey(prodId)
                ? extractedFavorites[prodId]['isFavorite']
                : false,
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
          'creatorId': _userId,
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
    final updateProductUri = Uri.https(
      API_URL,
      '/products/$id.json',
    );
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
