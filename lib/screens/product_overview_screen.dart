import 'package:flutter/material.dart';
import 'package:fluttershop/providers/cart.dart';
import 'package:fluttershop/providers/products.dart';
import 'package:fluttershop/screens/cart_screen.dart';
import 'package:fluttershop/widgets/app_drawer.dart';
import 'package:fluttershop/widgets/badge.dart';
import 'package:fluttershop/widgets/products_grid.dart';
import 'package:provider/provider.dart';

enum FilterOptions {
  Favourites,
  All,
}

class ProductOverviewScreen extends StatefulWidget {
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _showOnlyFav = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Shop'),
        actions: [
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Favourites) {
                  _showOnlyFav = true;
                } else {
                  _showOnlyFav = false;
                }
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Only Favourites.'),
                value: FilterOptions.Favourites,
              ),
              PopupMenuItem(
                child: Text('All Products.'),
                value: FilterOptions.All,
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
              child: ch,
              value: cart.itemCount.toString(),
              color: Colors.black54,
            ),
            child: IconButton(
              icon: Icon(
                Icons.shopping_cart,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
          Icon(Icons.tonality_outlined),
          Icon(Icons.tonality_outlined),
        ],
      ),
      drawer: AppDrawer(),
      body: ProductsGrid(_showOnlyFav),
    );
  }
}
