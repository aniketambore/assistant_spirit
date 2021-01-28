import 'package:easy_web_view/easy_web_view.dart';
import 'package:flutter/material.dart';

class UrlWebView extends StatefulWidget {
  final String barName;
  final String url;
  UrlWebView({this.barName, this.url});

  @override
  _UrlWebViewState createState() => _UrlWebViewState();
}

class _UrlWebViewState extends State<UrlWebView> {
  static ValueKey key = ValueKey('key_0');
  bool open = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("${widget.barName}"),
        ),
        body: Stack(
          children: <Widget>[
            EasyWebView(
              src: "${widget.url}",
              onLoaded: () {
                //print('$key: Loaded: ${widget.url}');
              },
              isHtml: false,
              isMarkdown: false,
              convertToWidgets: false,
              key: key,
              // width: 100,
              // height: 100,
            ),
          ],
        ));
  }
}
