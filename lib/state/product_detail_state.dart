
import 'package:koffee_bistro/state/value_notifier.dart';

class ProductDetailState {

  // Notifier for the selected coffee size. Defaults to 'M'.
  final ValueNotifier<String> selectedSize = ValueNotifier<String>('M');
  // Notifier to track if the description text is expanded.
    final ValueNotifier<bool> isDescriptionExpanded = ValueNotifier<bool>(
      false,
    );
  //loading notifier
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);
}
