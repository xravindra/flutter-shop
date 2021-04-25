import 'package:flutter/material.dart';
import 'package:fluttershop/models/product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty Red',
      price: 29.99,
      imageURL:
          'https://images.bewakoof.com/t320/pink-cotton-melange-shirt-men-s-slim-fit-cotton-melange-shirts-298454-1609301623.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageURL:
          'https://images.bewakoof.com/t320/light-grey-newmen-s-casual-shorts-with-zipper-nr-plain-men-s-casual-shorts-with-zipper-nr-plain-321149-1614176305.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly ehat you need for ath winter.',
      price: 19.99,
      imageURL:
          'https://images.bewakoof.com/t320/mimosa-fleece-sweater-men-s-plain-fleece-sweater-306800-1608025703.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageURL:
          'https://images.bewakoof.com/t320/global-lightweight-adjustable-strap-men-slider-men-s-printed-velcro-sliders-lightweight-333612-1617979943.jpg',
    ),
  ];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favouriteItems {
    return _items.where((item) => item.isFavourite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  void addProduct(value) {
    // _items.add(value);
    notifyListeners();
  }
}
