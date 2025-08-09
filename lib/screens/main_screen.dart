import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:koffee_bistro/my_icons_icons.dart';
import 'package:koffee_bistro/screens/cart_screen.dart';
import 'package:koffee_bistro/screens/home.dart';
import 'package:koffee_bistro/state/app_state.dart';
import 'package:koffee_bistro/theme/app_theme.dart';
import 'package:koffee_bistro/widgets/value_builder.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  final List<Widget> _pages = const [
    HomeScreen(), // Index 0
    CartScreen(), // Index 1
  ];

  @override
  Widget build(BuildContext context) {
    final navState = AppState.instance.navigationState;

    return ValueBuilder<int>(
      notifier: navState.currentIndex,
      builder: (context, index) {
        return Scaffold(
          body: IndexedStack(index: index, children: _pages),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.white,
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            currentIndex: index,
            // The onTap callback is clean and simply updates the state.
            onTap: (newIndex) {
              navState.currentIndex.value = newIndex;
            },
            items: <BottomNavigationBarItem>[
              // Use the helper method to build the Home button
              _buildNavItem(
                inactiveIcon: SvgPicture.asset('assets/icons/Home.svg'),
                activeIcon: const Icon(MyIcons.home_filled, color: AppTheme.primary,),
                isSelected: index == 0,
              ),
              // Use the helper method to build the Cart button
              _buildNavItem(
                inactiveIcon: SvgPicture.asset('assets/icons/Bag.svg'),
                activeIcon: const Icon(MyIcons.bag_filled, color: AppTheme.primary,),
                isSelected: index == 1,
              ),
            ],
          ),
        );
      },
    );
  }

  /// It handles the logic for showing the correct active or inactive icon.
  BottomNavigationBarItem _buildNavItem({
    required Widget inactiveIcon,
    required Widget activeIcon,
    required bool isSelected,
  }) {
    return BottomNavigationBarItem(
      label: '',//no label required
      // Use the isSelected flag to determine which icon to display.
      icon: isSelected ? activeIcon : inactiveIcon,
    );
  }
}