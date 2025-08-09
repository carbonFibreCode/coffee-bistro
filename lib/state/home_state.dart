import 'package:koffee_bistro/api/allproducts.dart';
import 'package:koffee_bistro/api/mock_coffee_service.dart';
import 'package:koffee_bistro/models/product.dart';
import 'package:koffee_bistro/state/value_notifier.dart';


class HomeState {
  final MockCoffeeService _coffeeService = MockCoffeeService();

  // state Notifiers
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(true);
  final ValueNotifier<List<Product>> products = ValueNotifier<List<Product>>([]);
  final ValueNotifier<String> selectedCategory = ValueNotifier<String>('All Coffee');
  final ValueNotifier<List<String>> categories = ValueNotifier<List<String>>([]);

  /// Initializes the home state by fetching all products and categories.
  Future<void> initialize() async {
    // get all categories from the product list
    final allCats = ['All Coffee', ...allProducts.map((p) => p['category'] as String).toSet()];
    categories.value = allCats;

    // initially fetching all products
    await filterByCategory('All Coffee');
  }

  /// Fetches products based on a category and updates the state.
  Future<void> filterByCategory(String category) async {
    isLoading.value = true;
    selectedCategory.value = category;

    if (category == 'All Coffee') {
      final allProds = await _coffeeService.getCoffeeProducts();
      products.value = allProds;
    } else {
      final filteredProds = await _coffeeService.getProductsByCategory(category);
      products.value = filteredProds;
    }

    isLoading.value = false;
  }
}