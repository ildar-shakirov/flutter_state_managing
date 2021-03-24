import 'package:flutter/foundation.dart';
import 'package:flutter_manage_state/models/http_exception.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../api/constants.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.price,
      @required this.imageUrl,
      this.isFavorite = false});

  Future toggleStatus() async {
    final oldStatus = isFavorite;
    final uri = Uri.https(API_URL, '/products/$id.json');
    isFavorite = !isFavorite;
    notifyListeners();
    try {
      final response = await http.patch(
        uri,
        body: json.encode({'isFavorite': isFavorite}),
      );
      if (response.statusCode >= 400) {
        throw HttpException('Error ocurred in http request');
      }
    } catch (err) {
      isFavorite = oldStatus;
      notifyListeners();
    }
  }
}
