import 'package:koffee_bistro/state/value_notifier.dart';

class NavigationState {
  /// notifier for the currently selected index of the BottomNavigationBar.
  final ValueNotifier<int> currentIndex = ValueNotifier<int>(0);
}