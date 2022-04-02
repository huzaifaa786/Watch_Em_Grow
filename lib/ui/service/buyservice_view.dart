import 'package:mipromo/models/shop_service.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:mipromo/models/app_user.dart';
import 'package:mipromo/ui/service/buyservice_viewmodel.dart';
import 'package:mipromo/ui/shared/widgets/basic_loader.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BuyServiceView extends StatelessWidget { ///Product
  final AppUser user;
  final ShopService service;
  final int? selectedSize;

  const BuyServiceView({
    Key? key,
    required this.user,
    required this.service,
    this.selectedSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BuyServiceViewModel>.reactive(
      onModelReady: (model) => model.init(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: const Text('Buy Product'),
        ),
        body: model.isBusy
            ? const BasicLoader()
            : Stack(
                children: [
                  WebView(
                    initialUrl: model.checkoutUrl,
                    javascriptMode: JavascriptMode.unrestricted,
                    navigationDelegate: (NavigationRequest request) {
                      return model.handleWebViewUrlProduct(request);
                    },
                    onProgress: (_) {
                      model.setIsWebviewLoading(loading: true);
                    },
                    onPageFinished: (_) {
                      model.setIsWebviewLoading(loading: false);
                    },
                  ),
                  if (model.isWebviewLoading) const BasicLoader()
                ],
              ),
      ),
      viewModelBuilder: () => BuyServiceViewModel(user, service, selectedSize),
    );
  }
}
