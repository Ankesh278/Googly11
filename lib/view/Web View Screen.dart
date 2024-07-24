import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';


class WebViewScreen extends StatefulWidget {
  final url,appBarName;
  const WebViewScreen({super.key,this.url,this.appBarName});

  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.appBarName,style: TextStyle(
          fontWeight: FontWeight.w400,
          color: Colors.white,
        ),
        ),
        automaticallyImplyLeading: false, // Set this to false to hide the default back button
        backgroundColor: Color(0xff780000),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Add your back button functionality here
            Navigator.of(context).pop(); // This example assumes you want to navigate back
          },
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: WebView(
              backgroundColor: Colors.white,
              initialUrl: widget.url,
              javascriptMode: JavascriptMode.unrestricted,
              onPageFinished: (String url) {
                setState(() {
                  _isLoading = false;
                });
              },
            ),
          ),
          if (_isLoading)
            Center(
              child:  SpinKitFadingCircle(
          color: Colors.redAccent,
          size: 50.0,
        ),
            ),
        ],
      ),
    );
  }
}
