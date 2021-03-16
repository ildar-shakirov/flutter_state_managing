import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';

class ProductDetailScreen extends StatelessWidget {
  static const String routeName = '/product-detail';

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context).settings.arguments;
    final item =
        Provider.of<ProductsProvider>(context, listen: false).findById(id);

    return Scaffold(
      appBar: AppBar(
        title: Text(item.title),
      ),
    );
  }
}