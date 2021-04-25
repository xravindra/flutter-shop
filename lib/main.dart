import 'package:flutter/material.dart';
import 'package:fluttershop/providers/cart.dart';
import 'package:fluttershop/providers/products.dart';
import 'package:fluttershop/screens/cart_screen.dart';
import 'package:fluttershop/screens/product_detail_screen.dart';
import 'package:fluttershop/screens/product_overview_screen.dart';
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
          create: (c) => Products(),
        ),
        ChangeNotifierProvider(
          create: (c) => Cart(),
        )
      ],
      child: MaterialApp(
        title: 'My Shop',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
        ),
        home: ProductOverviewScreen(),
        // home: SamplePlayer(),
        routes: {
          CartScreen.routeName: (c) => CartScreen(),
          ProductDetailScreen.routeName: (c) => ProductDetailScreen(),
        },
      ),
    );
  }
}