import 'package:animez_world/models/anime_model.dart';
import 'package:animez_world/services/animez_api.dart';
import 'package:animez_world/video_payer/mmm.dart';
import 'package:animez_world/video_payer/web_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_user_agentx/flutter_user_agent.dart';

class EpisodePlayer extends StatefulWidget {
  final AnimeModel animeDetails;
  final episodeNo;
  const EpisodePlayer({Key? key, required this.animeDetails, required this.episodeNo}) : super(key: key);

  @override
  State<EpisodePlayer> createState() => _EpisodePlayerState();
}

class _EpisodePlayerState extends State<EpisodePlayer> {
  var userAgent = "";
  var webUserAgent = "";
  var data={};
  var finalLinks = {};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getBody()
    );
  }

  // Get In App webview and others
  Widget getBody(){
    if(data.isEmpty || webUserAgent == ""){
      return Container();
    }else{
      if(finalLinks.isEmpty){
        return WebView(type: data, userAgent: webUserAgent,);
      }else{
        return Text("video");
      }
    }
  }

  Future<void> initUserAgentState() async{
    String _userAgent, webViewUserAgent;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      // _userAgent = await FlutterUserAgent.getPropertyAsync('userAgent');
      await FlutterUserAgent.init();
      webViewUserAgent = FlutterUserAgent.webViewUserAgent!;
    } on PlatformException {
      _userAgent = webViewUserAgent = '<error>';
    }

    if (!mounted) return;

    setState(() {
      // userAgent = _userAgent;
      webUserAgent = webViewUserAgent;
    });
  }

//  Get Data of the anime streams
  void streamData() async{
    var res = await AnimezApi().getAnimeStreams(widget.animeDetails.link, widget.episodeNo);
    if(res.containsKey('anime')){
      var download = "https:"+res['anime'].replaceAll("streaming.php", "download");
      res['download'] = download;
    }
    setState((){
      data = res;
    });
    print(data);
  }

//  init State
  @override
  void initState(){
    super.initState();
    initUserAgentState();
    streamData();
  }
}
