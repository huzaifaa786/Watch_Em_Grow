import 'dart:async';

import 'package:mipromo/ui/connect_stripe/stripe_viewmodel.dart';
import 'package:mipromo/ui/profile/buyer/paypal_verification_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:mipromo/ui/shared/widgets/basic_loader.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ConnectStripeView extends StatelessWidget {
  ///paypal verify webview

  const ConnectStripeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final Completer<WebViewController> _controller = Completer<WebViewController>();
    return Container();
    // ViewModelBuilder<connectStripeViewModel>.reactive(
    //   onModelReady: (model) => model.init(),
    //   builder: (context, model, child) => Scaffold(
    //     resizeToAvoidBottomInset: false,
    //     appBar: AppBar(
    //       title: const Text('Connect Stripe'),
    //     ),
    //     body: model.isBusy
    //         ? const BasicLoader()
    //         : Stack(
    //             children: [
    //               WebView(
    //                 initialUrl: model.connectUrl,
    //                 javascriptMode: JavascriptMode.unrestricted,
    //                 navigationDelegate: ( request) {
    //                   return model.handleWebViewVerification(request);
    //                 },
    //                 onWebViewCreated: (WebViewController webViewController) {
    //                   _controller.complete(webViewController);
    //                 },
    //                 onProgress: (_) {
    //                   model.setIsWebviewLoading(loading: true);
    //                 },
    //                 onPageFinished: (_) {
    //                   model.setIsWebviewLoading(loading: false);
                      
    //                 },
    //               ),
    //               if (model.isWebviewLoading) const BasicLoader()
    //             ],
    //           ),
    //   ),
    //   viewModelBuilder: () => connectStripeViewModel(),
    // );
  }
}
