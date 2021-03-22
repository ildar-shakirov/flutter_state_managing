import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/edit_product_screen.dart';
import '../providers/products.dart';
import '../widgets/user_product_item.dart';
import '../widgets/app_drawer.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsProvider>(context);

    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        // backgroundColor: Theme.of(context).primaryColor,
        title: Text('Your products'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(
                EditProductScreen.routeName,
              );
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: ListView.builder(
            itemCount: productsData.items.length,
            itemBuilder: (_, i) {
              return Column(
                children: [
                  UserProduct(
                    imageUrl: productsData.items[i].imageUrl,
                    title: productsData.items[i].title,
                    id: productsData.items[i].id,
                  ),
                  Divider(),
                ],
              );
            }),
      ),
    );
  }
}
