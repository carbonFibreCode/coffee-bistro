import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:koffee_bistro/models/product.dart';
import 'package:koffee_bistro/state/app_state.dart';
import 'package:koffee_bistro/theme/app_theme.dart';
import 'package:koffee_bistro/widgets/category_chip.dart';
import 'package:koffee_bistro/widgets/coffee_card.dart';
import 'package:koffee_bistro/widgets/glassmorphism_dialog.dart';
import 'package:koffee_bistro/widgets/value_builder.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final homeState = AppState.instance.homeState;
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                flex: 1, // 1/3 of the space
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      colors: [
                        Color(0xFF363233),
                        Color.fromARGB(255, 16, 16, 16),
                      ],
                    ),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                      child: Column(
                        children: [
                          _HeaderContent(),
                          const SizedBox(height: 20),
                          _SearchBar(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2, // 2/3 of the space
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppTheme.background,
                    borderRadius: BorderRadius.only(),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24.0, 100, 24.0, 0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          _CategoryFilter(),
                          const SizedBox(height: 20),
                          _ProductGrid(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          homeState.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : Positioned(
                  top:
                      MediaQuery.of(context).size.height *
                      0.215, // 40% of screen height
                  left: 0,
                  right: 0,
                  child: _PromoBanner(),
                ),
        ],
      ),
    );
  }
}

// --- Private Helper Widgets ---

class _HeaderContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartState = AppState.instance.cartState;
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Location',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 4),
            GestureDetector(
              onTap: () {
                showGeneralDialog(
                  context: context,
                  transitionDuration: const Duration(milliseconds: 300),
                  barrierColor: Colors.black.withOpacity(0.3),
                  barrierDismissible: true,
                  barrierLabel: '',
                  pageBuilder: (context, animation, secondaryAnimation) {
                    return GlassmorphismDialog(
                      title: 'Update Location',
                      hintText: 'Enter your location',
                      initialValue: cartState.address.value,
                      onSave: (String value) {
                        cartState.address.value = value;
                      },
                    );
                  },
                );
              },
              child: Row(
                children: [
                  ValueBuilder<String>(
                    notifier: cartState.address,
                    builder: (context, value) => Text(
                      cartState.address.value.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.white,
                    size: 20,
                  ),
                ],
              ),
            ),
          ],
        ),
        const Spacer(),
        IconButton(
          onPressed: () {
            AppState.instance.authState.logout();
            Navigator.pushReplacementNamed(context, '/login');
          },
          icon: SvgPicture.asset(
            'assets/icons/Logout.svg',
            colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
        ),
      ],
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar();
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            style: const TextStyle(color: AppTheme.background, fontSize: 14),
            decoration: InputDecoration(
              filled: true,
              fillColor: AppTheme.dark,
              hintText: 'Search coffee',
              hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
              prefixIcon: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SvgPicture.asset(
                  'assets/icons/Search.svg',
                  colorFilter: ColorFilter.mode(
                    AppTheme.lightGrey,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppTheme.radius),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          height: 52,
          width: 52,
          decoration: BoxDecoration(
            color: AppTheme.primary,
            borderRadius: BorderRadius.circular(AppTheme.radius),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SvgPicture.asset(
              'assets/icons/Filter.svg',
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

class _PromoBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Determine if the screen is wide.
        final bool isWideScreen = constraints.maxWidth > 500;

        return Center(
          child: Container(
            height: 160, // Keep a consistent height
            //  maximum width constraint only on wide screens.
            constraints: BoxConstraints(
              maxWidth: isWideScreen ? 500 : double.infinity,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppTheme.radius),
              child: Image.asset(
                'assets/images/Banner.png',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey,
                    child: const Center(child: Text('Banner.png not found')),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CategoryFilter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final homeState = AppState.instance.homeState;
    return SizedBox(
      height: 40,
      child: ValueBuilder<List<String>>(
        notifier: homeState.categories,
        builder: (context, cats) {
          return ListView.builder(
            padding: EdgeInsets.zero,
            scrollDirection: Axis.horizontal,
            itemCount: cats.length,
            itemBuilder: (context, index) {
              final category = cats[index];
              return ValueBuilder<String>(
                notifier: homeState.selectedCategory,
                builder: (context, selected) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: CategoryChip(
                      label: category,
                      isSelected: category == selected,
                      onTap: () => homeState.filterByCategory(category),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _ProductGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final homeState = AppState.instance.homeState;
    return ValueBuilder<bool>(
      notifier: homeState.isLoading,
      builder: (context, isLoading) {
        if (isLoading) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.only(top: 50),
              child: CircularProgressIndicator(color: AppTheme.primary),
            ),
          );
        }
        return ValueBuilder<List<Product>>(
          notifier: homeState.products,
          builder: (context, products) {
            // LayoutBuilder gives us the exact width available for the grid.
            return LayoutBuilder(
              builder: (context, constraints) {
                final double screenWidth = constraints.maxWidth;
                // we will determine the number of columns based on the screen width.
                final int crossAxisCount = screenWidth > 500 ? 4 : 2;
                
                //horizontal spacing between cards.
                const double spacing = 16.0;

                final double cardWidth = (screenWidth - (spacing * (crossAxisCount - 1))) / crossAxisCount;

                return Wrap(
                  spacing: spacing, // Horizontal space between cards
                  runSpacing: spacing, // Vertical space between rows
                  children: products.map((product) {
                    return SizedBox(
                      width: cardWidth,
                      child: CoffeeCard(product: product),
                    );
                  }).toList(),
                );
              },
            );
          },
        );
      },
    );
  }
}