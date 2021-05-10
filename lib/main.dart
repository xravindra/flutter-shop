import 'package:flutter/material.dart';
import 'package:fluttershop/providers/auth.dart';
import 'package:fluttershop/providers/cart.dart';
import 'package:fluttershop/providers/orders.dart';
import 'package:fluttershop/providers/products.dart';
import 'package:fluttershop/screens/auth_screen.dart';
import 'package:fluttershop/screens/cart_screen.dart';
import 'package:fluttershop/screens/edit_product_screen.dart';
import 'package:fluttershop/screens/orders_screen.dart';
import 'package:fluttershop/screens/product_detail_screen.dart';
import 'package:fluttershop/screens/product_overview_screen.dart';
import 'package:fluttershop/screens/user_products_screen.dart';
import 'package:provider/provider.dart';
import 'package:fluttershop/widgets/new_video.dart';
import 'package:video_player/video_player.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (c) => Auth(),
        ),
        ChangeNotifierProvider(
          create: (c) => Products(),
        ),
        ChangeNotifierProvider(
          create: (c) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (c) => Orders(),
        ),
      ],
      child: MaterialApp(
        title: 'My Shop',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
        ),
        home: AuthScreen(),
        // home: SamplePlayer(),
        routes: {

          CartScreen.routeName: (c) => CartScreen(),
          ProductDetailScreen.routeName: (c) => ProductDetailScreen(),
          OrdersScreen.routeName: (c) => OrdersScreen(),
          UserProductsScreen.routeName: (c) => UserProductsScreen(),
          EditProductScreen.routeName: (c) => EditProductScreen(),
        },
      ),
    );
  }
}
