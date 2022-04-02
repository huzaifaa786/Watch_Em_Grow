import 'package:flutter/material.dart';
import 'package:mipromo/ui/settings/about/about_view_model.dart';
import 'package:mipromo/ui/shared/widgets/basic_loader.dart';
import 'package:stacked/stacked.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AboutView extends StatelessWidget {
  final String url;
  const AboutView({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AboutViewModel>.reactive(
      onModelReady: (model) => model.init(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: const Text('About'),
        ),
        body: model.isBusy
            ? const BasicLoader()
            : Stack(
          children: [
            WebView(
              initialUrl: url,
              javascriptMode: JavascriptMode.unrestricted,
              onProgress: (_) {
                //model.setIsWebviewLoading(loading: true);
              },
              onPageFinished: (_) {
                model.setIsWebviewLoading(loading: false);
              },
            ),
            if (model.isWebviewLoading) const BasicLoader()
          ],
        ),
      ),
      viewModelBuilder: () => AboutViewModel(),
    );
  }
}
