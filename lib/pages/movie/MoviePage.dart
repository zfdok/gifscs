import 'dart:io';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MoviePage extends StatelessWidget {
  final String movieURL;
  MoviePage({Key key, @required this.movieURL}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(child: WebViewExample(url: movieURL));
  }
}

class WebViewExample extends StatefulWidget {
  final String url;
  WebViewExample({Key key, @required this.url}) : super(key: key);
  @override
  WebViewExampleState createState() => WebViewExampleState();
}

class WebViewExampleState extends State<WebViewExample> {
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl: widget.url,
      javascriptMode: JavascriptMode.unrestricted,
    );
  }
}
