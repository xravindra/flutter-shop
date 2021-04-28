import 'package:flutter/material.dart';
import 'package:fluttershop/providers/products.dart';
import 'package:fluttershop/widgets/app_drawer.dart';
import 'package:fluttershop/widgets/user_product_item.dart';
import 'package:provider/provider.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Products'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              //...
            },
          ),
        ],
        
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: ListView.builder(
          itemCount: productsData.items.length,
          itemBuilder: (_, i) => Column(
            children: [
              UserProductItem(
                title: productsData.items[i].title,
                imageURL: productsData.items[i].imageURL,
              ),
              Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
