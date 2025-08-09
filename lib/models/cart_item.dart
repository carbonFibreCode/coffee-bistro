
class CartItem {
  final String productId;
  final String name;
  final String imageUrl;
  final double price;
  final String size;
  int quantity; // Quantity is mutable

  CartItem({
    required this.productId,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.size,
    this.quantity = 1,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      productId: json['productId'],
      name: json['name'],
      imageUrl: json['imageUrl'],
      price: json['price'],
      size: json['size'],
      quantity: json['quantity'] ?? 1, // Default quantity to 1 if not present
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'name': name,
      'imageUrl': imageUrl,
      'price': price,
      'size': size,
      'quantity': quantity,
    };
  }
}