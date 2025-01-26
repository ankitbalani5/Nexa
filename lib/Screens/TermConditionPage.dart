import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
// Import for iOS/macOS features.
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class TermConditionPage extends StatefulWidget {
  @override
  _TermConditionPageState createState() => _TermConditionPageState();
}

class _TermConditionPageState extends State<TermConditionPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..loadRequest(Uri.parse('https://urlsdemo.online/nexa/terms-condition'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Term & Condition'),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
