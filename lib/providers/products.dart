import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttershop/models/product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty Red',
    //   price: 29.99,
    //   imageURL:
    //       'https://images.bewakoof.com/t320/pink-cotton-melange-shirt-men-s-slim-fit-cotton-melange-shirts-298454-1609301623.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageURL:
    //       'https://images.bewakoof.com/t320/light-grey-newmen-s-casual-shorts-with-zipper-nr-plain-men-s-casual-shorts-with-zipper-nr-plain-321149-1614176305.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly ehat you need for ath winter.',
    //   price: 19.99,
    //   imageURL:
    //       'https://images.bewakoof.com/t320/mimosa-fleece-sweater-men-s-plain-fleece-sweater-306800-1608025703.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageURL:
    //       'https://images.bewakoof.com/t320/global-lightweight-adjustable-strap-men-slider-men-s-printed-velcro-sliders-lightweight-333612-1617979943.jpg',
    // ),
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

  Future<void> fetchAndSetProducts() async {
    const urlData =
        'https://flutter-update-3ae26-default-rtdb.firebaseio.com/products.json';
    try {
      final response = await http.get(Uri.parse(urlData));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(
          Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            price: prodData['price'],
            isFavourite: prodData['isFavourite'],
            imageURL: prodData['imageURL'],
          ),
        );
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    const urlData =
        'https://flutter-update-3ae26-default-rtdb.firebaseio.com/products.json';

    try {
      final response = await http.post(
        Uri.parse(urlData),
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageURL': product.imageURL,
          'price': product.price,
          'isFavourite': product.isFavourite,
        }),
      );

      final newProduct = Product(
        title: product.title,
        description: product.description,
        price: product.price,
        imageURL: product.imageURL,
        id: json.decode(response.body)['name'],
      );

      // _items.add(newProduct);
      _items.insert(0, newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final urlData =
          'https://flutter-update-3ae26-default-rtdb.firebaseio.com/products/$id.json';
      await http.patch(
        Uri.parse(urlData),
        body: json.encode({
          'title': newProduct.title,
          'description': newProduct.description,
          'price': newProduct.price,
          'imageURL': newProduct.imageURL,
        }),
      );
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('product doesn\'t exist');
    }
  }

  void deleteProduct(String id) {
    final urlData =
        'https://flutter-update-3ae26-default-rtdb.firebaseio.com/products/$id.json';
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];
    http.delete(Uri.parse(urlData)).then((response) {
      print(response.statusCode);
      existingProduct = null;
    }).catchError((_) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
    });
    _items.removeAt(existingProductIndex);
    notifyListeners();
  }
}
