import 'dart:convert';
import 'package:koffee_bistro/models/cart_item.dart';
import 'package:koffee_bistro/models/product.dart';
import 'package:koffee_bistro/state/value_notifier.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartState {
  static const String _cartKey = 'cartItems';
  static const String _addressKey = 'userAddress';
  static const String _noteKey = 'orderNote';

  // --- Notifiers for UI reactivity ---
  final ValueNotifier<List<CartItem>> cartItems = ValueNotifier<List<CartItem>>([]);
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(true);
  final ValueNotifier<String> deliveryType = ValueNotifier<String>('Deliver');
  final ValueNotifier<String> address = ValueNotifier<String>('');
  final ValueNotifier<String> note = ValueNotifier<String>('');
  final ValueNotifier<double> deliveryFee = ValueNotifier<double>(1.0);
  final ValueNotifier<double> subtotal = ValueNotifier<double>(0.0);
  final ValueNotifier<double> total = ValueNotifier<double>(0.0);

  /// Initializes the order screen by loading all necessary data.
  Future<void> initialize() async {
    isLoading.value = true;
    await _loadAddress();
    await _loadNote();
    await loadCartItems();
    isLoading.value = false;
  }

  /// Adds a product with a specific size to the local storage.
  Future<void> addItemToCart(Product product, String size) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> cartItemsString = prefs.getStringList(_cartKey) ?? [];

    final newItem = {
      'productId': product.id,
      'name': product.name,
      'imageUrl': product.imageUrl,
      'price': product.price,
      'size': size,
    };

    cartItemsString.add(jsonEncode(newItem));
    loadCartItems();
    await prefs.setStringList(_cartKey, cartItemsString);
  }

  /// Loads cart items from SharedPreferences and updates the state.
  Future<void> loadCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> cartItemsString = prefs.getStringList(_cartKey) ?? [];

    // Group items to handle quantities correctly
    final Map<String, CartItem> groupedItems = {};
    for (var itemString in cartItemsString) {
      final itemMap = jsonDecode(itemString) as Map<String, dynamic>;
      final key = '${itemMap['productId']}_${itemMap['size']}';
      if (groupedItems.containsKey(key)) {
        groupedItems[key]!.quantity++;
      } else {
        groupedItems[key] = CartItem.fromJson(itemMap);
      }
    }
    cartItems.value = groupedItems.values.toList();
    _calculateTotals();
  }

  /// Updates the quantity of a cart item or removes it if quantity is zero.
  Future<void> updateQuantity(String productId, String size, int change) async {
    final currentItems = List<CartItem>.from(cartItems.value);
    final itemIndex = currentItems.indexWhere(
        (item) => item.productId == productId && item.size == size);

    if (itemIndex != -1) {
      currentItems[itemIndex].quantity += change;
      if (currentItems[itemIndex].quantity <= 0) {
        currentItems.removeAt(itemIndex);
      }
    }
    cartItems.value = currentItems;
    await _saveCart();
    _calculateTotals();
  }

  /// Saves the current cart state back to SharedPreferences.
  Future<void> _saveCart() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> cartItemsString = [];
    for (var item in cartItems.value) {
      for (var i = 0; i < item.quantity; i++) {
        // Create a non-quantified version for saving
        final singleItem = {
          'productId': item.productId,
          'name': item.name,
          'imageUrl': item.imageUrl,
          'price': item.price,
          'size': item.size,
        };
        cartItemsString.add(jsonEncode(singleItem));
      }
    }
    await prefs.setStringList(_cartKey, cartItemsString);
  }

  /// Calculates the subtotal and total prices.
  void _calculateTotals() {
    double currentSubtotal = 0;
    for (var item in cartItems.value) {
      currentSubtotal += item.price * item.quantity;
    }
    subtotal.value = currentSubtotal;
    total.value = currentSubtotal + deliveryFee.value;
  }

  // --- Address and Note Logic ---
  Future<void> _loadAddress() async {
    final prefs = await SharedPreferences.getInstance();
    address.value = prefs.getString(_addressKey) ?? 'Jl. Kpg Sutoyo';
  }

  Future<void> saveAddress(String newAddress) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_addressKey, newAddress);
    address.value = newAddress;
  }

  Future<void> _loadNote() async {
    final prefs = await SharedPreferences.getInstance();
    note.value = prefs.getString(_noteKey) ?? '';
  }

  Future<void> saveNote(String newNote) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_noteKey, newNote);
    note.value = newNote;
  }
}