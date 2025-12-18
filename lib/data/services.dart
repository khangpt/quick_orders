import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:quick_orders/domain/model/product.dart';

class Services {
  Services._();
  static final Services _services = Services._();

  factory Services() => _services;

  Future<List<Product>> fetchProducts() async {
    final data = await rootBundle.loadString('assets/data.json');
    final response = jsonDecode(data);
    if (response is List) {
      return response.map((e) => Product.fromJson(e)).toList();
    }
    return [];
  }
}
