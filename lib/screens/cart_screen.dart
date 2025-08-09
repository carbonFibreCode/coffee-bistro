import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:koffee_bistro/models/cart_item.dart';
import 'package:koffee_bistro/state/app_state.dart';
import 'package:koffee_bistro/theme/app_theme.dart';
import 'package:koffee_bistro/widgets/glassmorphism_dialog.dart';
import 'package:koffee_bistro/widgets/value_builder.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final cartState = AppState.instance.cartState;

  @override
  void initState() {
    super.initState();
    // Load fresh cart data every time the screen is viewed
    cartState.loadCartItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(195, 249, 242, 237),
      body: SafeArea(
        child: Column(
          children: [
            const _AppBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: ValueBuilder<bool>(
                  notifier: cartState.isLoading,
                  builder: (context, isLoading) {
                    if (isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),
                        const _DeliveryToggle(),
                        const SizedBox(height: 24),
                        const _AddressSection(),
                        const SizedBox(height: 16),
                        const Divider(color: AppTheme.lightGrey),
                        const _CartItemsList(),
                        const SizedBox(height: 24),
                        const _DiscountSection(),
                        const SizedBox(height: 24),
                        const _PaymentSummary(),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const _BottomBar(),
    );
  }
}

// --- Private Helper Widgets for OrderScreen ---

class _AppBar extends StatelessWidget {
  const _AppBar();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 16, 24, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Order',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class _DeliveryToggle extends StatelessWidget {
  const _DeliveryToggle();
  @override
  Widget build(BuildContext context) {
    final cartState = AppState.instance.cartState;

    return ValueBuilder<String>(
      notifier: cartState.deliveryType,
      builder: (context, type) {
        return Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: const Color(0xFFF2F2F2),
            borderRadius: BorderRadius.circular(AppTheme.radius),
          ),
          child: Row(
            children: [
              Expanded(
                child: _ToggleButton(
                  text: 'Deliver',
                  isSelected: type == 'Deliver',
                  onTap: () => cartState.deliveryType.value = 'Deliver',
                ),
              ),
              Expanded(
                child: _ToggleButton(
                  text: 'Pick Up',
                  isSelected: type == 'Pick Up',
                  onTap: () => cartState.deliveryType.value = 'Pick Up',
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ToggleButton extends StatelessWidget {
  const _ToggleButton({
    required this.text,
    required this.isSelected,
    required this.onTap,
  });
  final String text;
  final bool isSelected;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.white : AppTheme.dark,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _AddressSection extends StatelessWidget {
  const _AddressSection();
  @override
  Widget build(BuildContext context) {
    final cartState = AppState.instance.cartState;
    return ValueBuilder<String>(
      notifier: cartState.deliveryType,
      builder: (context, type) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // AnimatedSwitcher handles the transition between the two titles.
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              // The custom transition builder creates the slide and fade effect.
              transitionBuilder: (Widget child, Animation<double> animation) {
                // animate the new widget sliding in from the left.
                final inAnimation =
                    Tween<Offset>(
                      begin: const Offset(-1.0, 0.0),
                      end: Offset.zero,
                    ).animate(
                      CurvedAnimation(parent: animation, curve: Curves.easeOut),
                    );

                // animate the old widget sliding out to the right.
                final outAnimation =
                    Tween<Offset>(
                      begin: const Offset(1.0, 0.0),
                      end: Offset.zero,
                    ).animate(
                      CurvedAnimation(parent: animation, curve: Curves.easeIn),
                    );

                if (child.key == ValueKey(type)) {
                  return ClipRect(
                    child: SlideTransition(
                      position: inAnimation,
                      child: FadeTransition(opacity: animation, child: child),
                    ),
                  );
                } else {
                  return ClipRect(
                    child: SlideTransition(
                      position: outAnimation,
                      child: FadeTransition(opacity: animation, child: child),
                    ),
                  );
                }
              },
              child: Text(
                type == 'Deliver' ? 'Delivery Address' : 'Pick Up Address',
                key: ValueKey<String>(type),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ValueBuilder<String>(
              notifier: cartState.address,
              builder: (context, address) {
                return Text(
                  address,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                );
              },
            ),
            ValueBuilder<String>(
              notifier: cartState.address,
              builder: (context, value) => Text(
                cartState.address.value,
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _ActionButton(
                  icon: 'assets/icons/Edit Square.svg',
                  label: 'Edit Address',
                ),
                const SizedBox(width: 16),
                _ActionButton(
                  icon: 'assets/icons/Document.svg',
                  label: 'Add Note',
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.icon, required this.label});
  final String icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final cartState = AppState.instance.cartState;
    return GestureDetector(
      onTap: () {
        showGeneralDialog(
          context: context,
          transitionDuration: const Duration(milliseconds: 300),
          barrierColor: Colors.black.withOpacity(0.3),
          barrierDismissible: true,
          barrierLabel: '',
          pageBuilder: (context, animation, secondaryAnimation) {
            if (label == 'Edit Address') {
              return GlassmorphismDialog(
                title: 'Edit Delivery Address',
                hintText: 'Enter new address',
                initialValue: cartState.address.value,
                onSave: (newValue) {
                  cartState.saveAddress(newValue);
                },
              );
            } else {
              return GlassmorphismDialog(
                title: 'Add a Note',
                hintText: 'Enter your note (e.g., no sugar)',
                initialValue: cartState.note.value,
                onSave: (newValue) {
                  cartState.saveNote(newValue);
                },
              );
            }
          },
          // using the transitionBuilder creates the fade animation
          transitionBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurvedAnimation(parent: animation, curve: Curves.easeIn),
              child: child,
            );
          },
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          border: Border.all(color: const Color.fromARGB(146, 49, 49, 49)),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              icon,
              color: const Color.fromARGB(216, 49, 49, 49),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Color.fromARGB(216, 49, 49, 49),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CartItemsList extends StatelessWidget {
  const _CartItemsList();
  @override
  Widget build(BuildContext context) {
    final cartState = AppState.instance.cartState;
    return ValueBuilder<List<CartItem>>(
      notifier: cartState.cartItems,
      builder: (context, items) {
        if (items.isEmpty) {
          return const Center(child: Text('Your cart is empty.'));
        }
        return ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: items.length,
          separatorBuilder: (context, index) =>
              const Divider(color: AppTheme.lightGrey, height: 32),
          itemBuilder: (context, index) {
            final item = items[index];
            return Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppTheme.radius),
                  child: Image.asset(
                    item.imageUrl,
                    width: 54,
                    height: 54,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Size: ${item.size}',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                _QuantityControl(item: item),
              ],
            );
          },
        );
      },
    );
  }
}

class _QuantityControl extends StatelessWidget {
  const _QuantityControl({required this.item});
  final CartItem item;
  @override
  Widget build(BuildContext context) {
    final cartState = AppState.instance.cartState;
    return Row(
      children: [
        GestureDetector(
          onTap: () => cartState.updateQuantity(item.productId, item.size, -1),
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppTheme.lightGrey),
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) =>
                  FadeTransition(
                    opacity: animation,
                    child: ScaleTransition(scale: animation, child: child),
                  ),
              child: Icon(
                item.quantity == 1 ? Icons.delete_outline : Icons.remove,
                key: ValueKey<bool>(item.quantity == 1),
                color: AppTheme.dark,
                size: 20,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) =>
                FadeTransition(
                  opacity: animation,
                  child: ScaleTransition(scale: animation, child: child),
                ),

            child: Text(
              key: ValueKey<int>(item.quantity),
              item.quantity.toString(),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        GestureDetector(
          onTap: () => cartState.updateQuantity(item.productId, item.size, 1),
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppTheme.lightGrey),
            ),
            child: Icon(Icons.add, color: AppTheme.dark, size: 20),
          ),
        ),
      ],
    );
  }
}

class _DiscountSection extends StatelessWidget {
  const _DiscountSection();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppTheme.radius),
        border: Border.all(color: AppTheme.lightGrey),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/icons/Discount.svg',
            color: AppTheme.primary,
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Text(
              '1 Discount is Applied',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          const Icon(Icons.arrow_forward_ios, color: AppTheme.dark, size: 16),
        ],
      ),
    );
  }
}

class _PaymentSummary extends StatelessWidget {
  const _PaymentSummary();
  @override
  Widget build(BuildContext context) {
    final cartState = AppState.instance.cartState;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Payment Summary',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ValueBuilder<double>(
          notifier: cartState.subtotal,
          builder: (context, subtotal) {
            return _SummaryRow(
              label: 'Price',
              value: '\$ ${subtotal.toStringAsFixed(2)}',
            );
          },
        ),
        const SizedBox(height: 12),
        ValueBuilder<double>(
          notifier: cartState.deliveryFee,
          builder: (context, fee) {
            return _SummaryRow(
              label: 'Delivery Fee',
              value: '\$ ${fee.toStringAsFixed(2)}',
            );
          },
        ),
        const SizedBox(height: 12),
        const Divider(color: AppTheme.lightGrey),
        const SizedBox(height: 12),
        ValueBuilder<double>(
          notifier: cartState.total,
          builder: (context, total) {
            return _SummaryRow(
              label: 'Total Payment',
              value: '\$ ${total.toStringAsFixed(2)}',
            );
          },
        ),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 16)),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar();

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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // This Row contains the payment method details
          Row(
            children: [
              SvgPicture.asset(
                'assets/icons/Wallet.svg',
                color: AppTheme.primary,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Cash/Wallet',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppTheme.dark,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    ValueBuilder<double>(
                      notifier: cartState.total,
                      builder: (context, total) {
                        return Text(
                          '\$ ${total.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: AppTheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const Icon(Icons.keyboard_arrow_down, color: AppTheme.dark),
            ],
          ),
          const SizedBox(height: 16),
          // This is the main action button
          ElevatedButton(
            onPressed: () {
              // Placeholder for order placement logic
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTheme.radius),
              ),
            ),
            child: const Text(
              'Order',
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
