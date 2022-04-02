import 'package:mipromo/models/order.dart';
import 'package:mipromo/models/shop_service.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:mipromo/models/app_user.dart';
import 'package:mipromo/ui/service/bookservice_viewmodel.dart';
import 'package:mipromo/ui/shared/widgets/basic_loader.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BookServiceView extends StatelessWidget { ///service
  final AppUser user;
  //final Order order;
  final ShopService service;

  const BookServiceView({
    Key? key,
    required this.user,
    //required this.order,
    required this.service,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BookServiceViewModel>.reactive(
      onModelReady: (model) => model.init(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: const Text('Book Service'),
        ),
        body: model.isBusy
            ? const BasicLoader()
            : Stack(
                children: [
                  WebView(
                    initialUrl: model.checkoutUrl,
                    javascriptMode: JavascriptMode.unrestricted,
                    navigationDelegate: (NavigationRequest request) {
                      return model.handleWebViewUrlAService(request);
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
      viewModelBuilder: () => BookServiceViewModel(user, service),
    );
  }
}
