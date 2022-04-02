import 'package:stacked/stacked.dart';

class AboutViewModel extends BaseViewModel {

  bool isWebviewLoading = true;

  AboutViewModel();
  void init() {

  }

  void setIsWebviewLoading({required bool loading}) {
    isWebviewLoading = loading;
    notifyListeners();
  }
}
