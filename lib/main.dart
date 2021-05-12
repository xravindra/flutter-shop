import 'package:flutter/material.dart';
import 'package:fluttershop/helpers/custom_route.dart';
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
import 'package:fluttershop/screens/splash_screen.dart';
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
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          update: (ctx, auth, previousProducts) => Products(
            auth.token,
            previousProducts == null ? [] : previousProducts.items,
          ),
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        ChangeNotifierProvider(
          create: (c) => Orders(),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'My Shop',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato',
            pageTransitionsTheme: PageTransitionsTheme(builders: {
              TargetPlatform.android: CustomPageTransitionBuilder(),
              TargetPlatform.iOS: CustomPageTransitionBuilder(),
              TargetPlatform.macOS: CustomPageTransitionBuilder(),
            }),
          ),
          home: auth.isAuth
              ? ProductOverviewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnamshop) =>
                      authResultSnamshop.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
          // home: SamplePlayer(),
          routes: {
            CartScreen.routeName: (c) => CartScreen(),
            ProductDetailScreen.routeName: (c) => ProductDetailScreen(),
            OrdersScreen.routeName: (c) => OrdersScreen(),
            UserProductsScreen.routeName: (c) => UserProductsScreen(),
            EditProductScreen.routeName: (c) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}
