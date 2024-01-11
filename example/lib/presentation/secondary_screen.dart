import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:presentation_displays/secondary_display.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// UI of Presentation display
class SecondaryScreen extends StatefulWidget {
  const SecondaryScreen({Key? key}) : super(key: key);

  @override
  _SecondaryScreenState createState() => _SecondaryScreenState();
}

class _SecondaryScreenState extends State<SecondaryScreen> {
  String value = "init";
  WebViewController _controller = WebViewController();

  @override
  void initState() {
    value = dotenv.get("url");
    _controller.loadRequest(Uri.parse(value));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SecondaryDisplay(
          callback: (dynamic argument) {
            setState(() {
              value = argument;
            });
          },
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
                Text(value),
                Expanded(child: ColoredBox(color: Colors.amber, child: WebViewWidget(controller: _controller)),)
              ]
            ),
          ),
        ));
  }
}