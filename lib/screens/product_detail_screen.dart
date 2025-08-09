import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:koffee_bistro/models/product.dart';
import 'package:koffee_bistro/state/app_state.dart';
import 'package:koffee_bistro/state/product_detail_state.dart';
import 'package:koffee_bistro/theme/app_theme.dart';
import 'package:koffee_bistro/widgets/app_snackbar.dart';
import 'package:koffee_bistro/widgets/value_builder.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {

    // Extract the arguments from the route settings.
    final product = ModalRoute.of(context)!.settings.arguments;

    // Check if the arguments exist and are of the correct type before proceeding.
    if (product is! Product) {
      // If arguments are missing or wrong, show a fallback UI instead of crashing.
      return const Scaffold(
        body: Center(
          child: Text('Error: Product data not found.'),
        ),
      );
    }
    //state manager instance for this screen.
    final detailState = ProductDetailState();
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        // The main layout is a Column, as requested.
        child: Column(
          children: [
            // This Expanded contains the main content that will scroll.
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- Header and Image ---
                    _TopBar(),
                    const SizedBox(height: 24),
                    _ProductImage(
                      imageUrl: product.imageUrl,
                      productId: product.id,
                    ),
                    const SizedBox(height: 24),

                    // --- Details, Description, and Size Selector ---
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _ProductInfo(product: product),
                          const SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: const Divider(color: AppTheme.lightGrey),
                          ),
                          const SizedBox(height: 16),
                          _Description(
                            description: product.description,
                            detailState: detailState,
                          ),
                          const SizedBox(height: 24),
                          _SizeSelector(detailState: detailState),
                          const SizedBox(height: 24), // Space at the bottom
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // The bottom bar is fixed at the bottom of the screen.
      bottomNavigationBar: _BottomBar(
        product: product,
        detailState: detailState,
      ),
    );
  }
}

// --- Private Helper Widgets ---

// The top bar with back button, title, and favorite icon.
class _TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final homeState = AppState.instance.homeState;
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 16, 24, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: AppTheme.dark),
            onPressed: () async {
              homeState.isLoading.value = true;
              Navigator.of(context).pop();
              await precacheImage(
                const AssetImage('assets/images/Banner.png'),
                context,
              );
              homeState.isLoading.value = false;
            },
          ),
          const Text(
            'Detail',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: SvgPicture.asset('assets/icons/Heart.svg'),
            onPressed: () {}, // Placeholder for favorite action
          ),
        ],
      ),
    );
  }
}

// The main product image.
class _ProductImage extends StatelessWidget {
  const _ProductImage({required this.imageUrl, required this.productId});
  final String imageUrl;
  final String productId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppTheme.radius),
        child: Hero(
          tag: 'coffee_${productId}',
          child: Image.asset(
            imageUrl,
            height: 300,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

// Product name, rating, and info icons.
class _ProductInfo extends StatelessWidget {
  const _ProductInfo({required this.product});
  final Product product;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.name,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              product.category,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            Row(
              children: [
                _InfoIcon(icon: Icons.coffee),
                const SizedBox(width: 12),
                _InfoIcon(icon: Icons.water_drop_outlined),
                const SizedBox(width: 12),
                _InfoIcon(icon: Icons.local_drink_outlined),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            const Icon(Icons.star, color: Colors.amber, size: 24),
            const SizedBox(width: 8),
            Text(
              product.rating.toString(),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            Text(
              '(230)',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
      ],
    );
  }
}

class _InfoIcon extends StatelessWidget {
  const _InfoIcon({required this.icon});
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color.fromARGB(92, 227, 227, 227),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: AppTheme.primary),
    );
  }
}

class _Description extends StatelessWidget {
  const _Description({required this.description, required this.detailState});
  final String description;
  final ProductDetailState detailState;

  @override
  Widget build(BuildContext context) {
    final bool isLongDescription = description.length > 150;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Description',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        // Use ValueBuilder to listen to the isDescriptionExpanded notifier
        ValueBuilder<bool>(
          notifier: detailState.isDescriptionExpanded,
          builder: (context, isExpanded) {
            return RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[700],
                  height: 1.5,
                ),
                children: [
                  // Display text based on the notifier's value
                  TextSpan(
                    text: (isLongDescription && !isExpanded)
                        ? '${description.substring(0, 150)}...'
                        : description,
                  ),
                  // Only show the link if the description is long
                  if (isLongDescription)
                    TextSpan(
                      text: isExpanded ? ' Read Less' : ' Read More',
                      style: const TextStyle(
                        color: AppTheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                      // The recognizer toggles the notifier's value on tap
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          detailState.isDescriptionExpanded.value = !isExpanded;
                        },
                    ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

// The size selector chips.
class _SizeSelector extends StatelessWidget {
  const _SizeSelector({required this.detailState});
  final ProductDetailState detailState;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Size',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ValueBuilder<String>(
          notifier: detailState.selectedSize,
          builder: (context, currentSize) {
            return Row(
              children: ['S', 'M', 'L'].map((size) {
                final isSelected = currentSize == size;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => detailState.selectedSize.value = size,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected ? AppTheme.secondary : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? AppTheme.primary
                              : AppTheme.lightGrey,
                          width: 1.5,
                        ),
                      ),
                      child: Text(
                        size,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? AppTheme.primary : AppTheme.dark,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}

// The fixed bottom bar with price and "Add to Cart" button.
class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.product, required this.detailState});

  final Product product;
  final ProductDetailState detailState;

  @override
  Widget build(BuildContext context) {
    final cartState = AppState.instance.cartState;
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Price',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 8),
              Text(
                '\$ ${product.price.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primary,
                ),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () async {
              final size = detailState.selectedSize.value;
              await cartState.addItemToCart(product, size);
              AppSnackbar.show(
                context,
                '${product.name} ($size) added to cart!',
                const Duration(seconds: 1),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTheme.radius),
              ),
            ),
            child: const Text(
              'Add to Cart',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
