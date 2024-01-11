import 'package:flutter/material.dart';
import 'package:presentation_displays/display.dart';
import 'package:presentation_displays/displays_manager.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../components/button.dart';

/// Main Screen
class DisplayManagerScreen extends StatefulWidget {
  const DisplayManagerScreen({Key? key}) : super(key: key);

  @override
  _DisplayManagerScreenState createState() => _DisplayManagerScreenState();
}

class _DisplayManagerScreenState extends State<DisplayManagerScreen> {
  DisplayManager displayManager = DisplayManager();
  List<Display?> displays = [];

  final TextEditingController _indexToShareController = TextEditingController();
  final TextEditingController _dataToTransferController =
  TextEditingController();

  final TextEditingController _nameOfIdController = TextEditingController();
  String _nameOfId = "";
  final TextEditingController _nameOfIndexController = TextEditingController();
  String _nameOfIndex = "";

  WebViewController _controller = WebViewController();

  @override
  void initState() {
    displayManager.connectedDisplaysChangedStream?.listen(
          (event) {
        debugPrint("connected displays changed: $event");
      },
    );
    _controller.loadRequest(Uri.parse(dotenv.get("url")));
    Future.delayed(const Duration(seconds: 5)).then((value) => _gotoSecondaryScreen());
    super.initState();
  }

  void _gotoSecondaryScreen() async {
    final a = await displayManager.getDisplays();
    if ((a??[]).isNotEmpty) {
      displayManager.showSecondaryDisplay(
          displayId: a!.last.displayId!, routerName: "presentation");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }

  Widget widgetDisplay() {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _getDisplays(),
            _showPresentation(),
            _hidePresentation(),
            _transferData(),
            _getDisplayeById(),
            _getDisplayByIndex(),
          ],
        ),
      ),
    );
  }

  Widget _getDisplays() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Button(
            title: "Get Displays",
            onPressed: () async {
              final values = await displayManager.getDisplays();
              displays.clear();
              setState(() {
                displays.addAll(values!);
              });
            }),
        ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            padding: const EdgeInsets.all(8),
            itemCount: displays.length,
            itemBuilder: (BuildContext context, int index) {
              return SizedBox(
                height: 50,
                child: Center(
                    child: Text(
                        ' ${displays[index]?.displayId} ${displays[index]?.name}')),
              );
            }),
        const Divider()
      ],
    );
  }

  Widget _showPresentation() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _indexToShareController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Index to share screen',
            ),
          ),
        ),
        Button(
            title: "Show presentation",
            onPressed: () async {
              int? displayId = int.tryParse(_indexToShareController.text);
              if (displayId != null) {
                for (final display in displays) {
                  if (display?.displayId == displayId) {
                    displayManager.showSecondaryDisplay(
                        displayId: displayId, routerName: "presentation");
                  }
                }
              }
            }),
        const Divider(),
      ],
    );
  }

  Widget _hidePresentation() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _indexToShareController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Index to hide screen',
            ),
          ),
        ),
        Button(
            title: "Hide presentation",
            onPressed: () async {
              int? displayId = int.tryParse(_indexToShareController.text);
              if (displayId != null) {
                for (final display in displays) {
                  if (display?.displayId == displayId) {
                    displayManager.hideSecondaryDisplay(displayId: displayId);
                  }
                }
              }
            }),
        const Divider(),
      ],
    );
  }

  Widget _transferData() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _dataToTransferController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Data to transfer',
            ),
          ),
        ),
        Button(
            title: "TransferData",
            onPressed: () async {
              String data = _dataToTransferController.text;
              await displayManager.transferDataToPresentation(data);
            }),
        const Divider(),
      ],
    );
  }

  Widget _getDisplayeById() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _nameOfIdController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Id',
            ),
          ),
        ),
        Button(
            title: "NameByDisplayId",
            onPressed: () async {
              int? id = int.tryParse(_nameOfIdController.text);
              if (id != null) {
                final value = await displayManager
                    .getNameByDisplayId(displays[id]?.displayId ?? -1);
                setState(() {
                  _nameOfId = value ?? "";
                });
              }
            }),
        SizedBox(
          height: 50,
          child: Center(child: Text(_nameOfId)),
        ),
        const Divider(),
      ],
    );
  }

  Widget _getDisplayByIndex() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _nameOfIndexController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Index',
            ),
          ),
        ),
        Button(
            title: "NameByIndex",
            onPressed: () async {
              int? index = int.tryParse(_nameOfIndexController.text);
              if (index != null) {
                final value = await displayManager.getNameByIndex(index);
                setState(() {
                  _nameOfIndex = value ?? "";
                });
              }
            }),
        SizedBox(
          height: 50,
          child: Center(child: Text(_nameOfIndex)),
        ),
        const Divider(),
      ],
    );
  }
}
