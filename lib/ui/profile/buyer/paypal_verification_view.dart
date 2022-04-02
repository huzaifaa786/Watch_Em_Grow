import 'package:mipromo/models/shop_service.dart';
import 'package:mipromo/ui/profile/buyer/paypal_verification_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:mipromo/models/app_user.dart';
import 'package:mipromo/ui/service/buyservice_viewmodel.dart';
import 'package:mipromo/ui/shared/widgets/basic_loader.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaypalVerificationView extends StatelessWidget { ///paypal verify webview
  final String email;

  const PaypalVerificationView({
    Key? key,
    required this.email,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<paypalVerificationViewModel>.reactive(
      onModelReady: (model) => model.init(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: const Text('Account verification'),
        ),
        body: model.isBusy
            ? const BasicLoader()
            : Stack(
          children: [
            WebView(
              initialUrl: model.verifyUrl,
              javascriptMode: JavascriptMode.unrestricted,
              navigationDelegate: (NavigationRequest request) {
                return model.handleWebViewVerification(request);
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
      viewModelBuilder: () => paypalVerificationViewModel(email),
    );
  }
}
