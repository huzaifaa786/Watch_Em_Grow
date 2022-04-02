import 'package:stacked/stacked.dart';

class CategoryFilterViewModel extends BaseViewModel {
  int selectedIndex = 0;
  String selectedCity = "";

  void onDestinationSelected(int currentIndex) {
    selectedIndex = currentIndex;
    notifyListeners();
  }

  List<String> filters = [
    "Location",
    "Price Range",
    "Rating",
  ];
}
