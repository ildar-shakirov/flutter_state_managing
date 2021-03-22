import 'package:flutter/material.dart';

import '../screens/edit_product_screen.dart';

class UserProduct extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  const UserProduct({Key key, this.title, this.imageUrl, this.id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditProductScreen.routeName, arguments: id);
              },
              icon: Icon(Icons.edit, color: Theme.of(context).primaryColor),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.delete, color: Theme.of(context).errorColor),
            ),
          ],
        ),
      ),
    );
  }
}
