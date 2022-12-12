import 'package:animez_world/video_payer/video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WebView extends StatefulWidget {
  final type;
  final userAgent;
  const WebView({Key? key, this.type, this.userAgent}) : super(key: key);

  @override
  State<WebView> createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {
  bool test = false;
  HeadlessInAppWebView? headlessWebView;
  Map type = {};
  var startUrl = "";
  var jsPath = "";
  var finalLinks = {};
  var xstream;
  var d = "";
  int count = 0;

  @override
  void initState() {
    super.initState();
    // if (type.containsKey('HDP')) {
    //   finalLinks['HD'] = type['HDP'];
    //   count++;
    // }
    type = widget.type;
    headlessWebView = HeadlessInAppWebView(
      initialUrlRequest: URLRequest(url: Uri.parse(startUrl)),
      onWebViewCreated: (controller) {},
      onConsoleMessage: (controller, consoleMessage) async {
        await getMedia(controller);
      },
      onLoadStart: (controller, url) async {
        await getMedia(controller);
      },
      onLoadStop: (controller, url) async {
        await getMedia(controller);
      },
    );
    if (count == 0) startHeadless();
  }

  void startHeadless() async {
    if (headlessWebView!.isRunning()) {
      await headlessWebView!.dispose();
      await headlessWebView!.run();
    } else {
      await headlessWebView!.run();
      // type.remove('HDP');
    }
  }

  @override
  void dispose() {
    super.dispose();
    headlessWebView?.dispose();
  }

  getMedia(controller) async {
    if (!test) {
      test = true;
      if (type.containsKey('anime')) {
        d = 'vidstream';
        startUrl = 'https:' + type['anime'];
        jsPath = d;
        type.remove('anime');
      }else if (type.containsKey('streamtape')) {
        d = 'streamtape';
        startUrl = type[d];
        jsPath = d;
        type.remove(d);
      }
      else if (type.containsKey('doodstream')) {
        d = 'doodstream';
        startUrl = type[d];
        jsPath = 'dood';
        type.remove(d);
      }
      else if (type.containsKey('xstreamcdn')) {
        d = 'xstreamcdn';
        startUrl = type[d];
        jsPath = 'xstream';
        type.remove(d);
      } else if(type.containsKey('download')){
        d = 'download';
        startUrl = type[d];
        jsPath = 'download';
        type.remove(d);
      }else {
        headlessWebView?.dispose();
        return;
      }
      if (d != 'HD') {
        await controller.loadUrl(
            urlRequest: URLRequest(url: Uri.parse(startUrl)));
      }
    } else {
      if (jsPath != "") {
        try {
          var result = await controller.injectJavascriptFileFromAsset(
              assetFilePath: "assets/js/$jsPath.js");
          print(result);
          setState(() {
            if (result != null) {
              if (d == "xstreamcdn") {
                xstream = result;
                print(result);
                // x.forEach((key, value) {
                //   finalLinks[key] = value;
                // });
                count++;
              } else {
                finalLinks[d] = result;
              }
              test = false;
            }
          });
        } catch (e) {
          print("Not found yet"+ e.toString());
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      count == 0
          ? CircularProgressIndicator()
          : VideoPlayer(
          userAgent:
          widget.userAgent,
          deviceAgent: 'unknown',
          links: finalLinks,
          xlinks: xstream)
    ]);
  }
}
