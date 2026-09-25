import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../../extensions/context_extensions.dart';
import '../widgets/app_app_bar.dart';
import '../widgets/app_loader.dart';

class AppWebViewPage extends StatefulWidget {
  const AppWebViewPage({super.key, required this.url, this.title = ''});

  final String url;
  final String title;

  @override
  State<AppWebViewPage> createState() => _AppWebViewPageState();
}

class _AppWebViewPageState extends State<AppWebViewPage> {
  double _progress = 0;

  @override
  Widget build(BuildContext context) {
    final title = widget.title.isEmpty ? context.l10n.webViewDefaultTitle : widget.title;

    return Scaffold(
      appBar: AppAppBar(title: title, onBack: () => Navigator.of(context).pop()),
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(url: WebUri(widget.url)),
            initialSettings: InAppWebViewSettings(
              builtInZoomControls: false,
              displayZoomControls: false,
              supportZoom: false,
              javaScriptEnabled: true,
            ),
            onProgressChanged: (controller, progress) {
              setState(() => _progress = progress / 100);
            },
          ),
          if (_progress < 1.0) const AppLoader(),
        ],
      ),
    );
  }
}
