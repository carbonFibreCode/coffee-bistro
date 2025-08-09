import 'package:flutter/material.dart';
import 'package:koffee_bistro/models/product.dart';
import 'package:koffee_bistro/routes/App_routes.dart';
import 'package:koffee_bistro/state/app_state.dart';
import 'package:koffee_bistro/theme/app_theme.dart';
import 'package:koffee_bistro/widgets/app_snackbar.dart';

class CoffeeCard extends StatelessWidget {
  const CoffeeCard({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    // Access the cart state to add items
    final cartState = AppState.instance.cartState;

    return Stack(
      children: [
        // --- Layer 1: The main card content (for navigation) ---
        // GestureDetector for navigating to the product detail page.
        GestureDetector(
          onTap: () {
            Navigator.of(
              context,
            ).pushNamed(AppRoutes.productDetail, arguments: product);
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppTheme.radius),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top part with image and rating
                Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(AppTheme.radius),
                        child: Hero(
                          tag: 'coffee_${product.id}',
                          flightShuttleBuilder: (
                            BuildContext flightContext,
                            Animation<double> animation,
                            HeroFlightDirection flightDirection,
                            BuildContext fromHeroContext,
                            BuildContext toHeroContext,
                          ) {
                            return ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(AppTheme.radius),
                              child: toHeroContext.widget,
                            );
                          },
                          child: Image.asset(
                            product.imageUrl,
                            height: 120,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 16,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.4),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              product.rating.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                // Bottom part with text and price
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        product.category,
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                      const SizedBox(height: 12),
                      // The price is still here, but the button is moved to the Stack
                      Text(
                        '\$ ${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // --- Layer 2: The "Add to Cart" button with size selection ---
        // Positioned on top of the main card.
        Positioned(
          bottom: 16,
          right: 16,
          child: PopupMenuButton<String>(
            color: AppTheme.lightGrey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            onSelected: (String size) {
              cartState.addItemToCart(product, size);
              AppSnackbar.show(
                context,
                '${product.name} ($size) added to cart!',
                const Duration(seconds: 1),
              );
            },
            // The items to show in the dropdown menu
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(value: 'S', child: Text('Small')),
              const PopupMenuItem<String>(value: 'M', child: Text('Medium')),
              const PopupMenuItem<String>(value: 'L', child: Text('Large')),
            ],
            // The button that the user taps to open the menu
            child: Container(
              height: 32,
              width: 32,
              decoration: const BoxDecoration(
                color: AppTheme.primary,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 18),
            ),
          ),
        ),
      ],
    );
  }
}
