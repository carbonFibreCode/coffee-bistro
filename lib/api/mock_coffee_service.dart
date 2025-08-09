import 'package:koffee_bistro/api/allproducts.dart';

import '../models/product.dart';
import '../models/user.dart'; // You'll create this model

class MockCoffeeService {
  // simulate fetching all coffee products
  Future<List<Product>> getCoffeeProducts() async {
    await Future.delayed(const Duration(milliseconds: 1500)); //network delay
    
    //simulation json parsing
    return allProducts.map((data) => Product.fromJson(data)).toList(); 
  }

  // simulate fetching products by category
  Future<List<Product>> getProductsByCategory(String category) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (category == 'All') {
      return getCoffeeProducts();
    }
    final products = allProducts
        .where((data) => data['category'] == category) 
        .map((data) => Product.fromJson(data))
        .toList();
    return products;
  }

  // simulate a login request
  Future<User?> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 2));
    if (email == 'test@user.com' && password == '1234') {
      // Return a mock user on success
      return User(id: 'user_123', name: 'Arun', email: email);
    } else {
      // return null on failure
      return null;
    }
  }
}