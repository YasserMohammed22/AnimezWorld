import 'package:flutter/material.dart';
import 'package:better_player/better_player.dart';

class VideoPlayer extends StatefulWidget {
  final deviceAgent;
  final userAgent;
  final Map links;
  final xlinks;

  const VideoPlayer(
      {Key? key,
        this.userAgent,
        this.deviceAgent,
        required this.links,
        required this.xlinks})
      : super(key: key);

  @override
  _VideoPlayerState createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  late String userAgent;
  late BetterPlayerController _betterPlayerController;
  late bool nextVideo = false;
  bool x = false;
  var c = 0;

  @override
  void initState() {
    super.initState();
    userAgent = widget.userAgent;
    mainVideoSource();
    _betterPlayerController.videoPlayerController!.addListener(checkVideo);
    _betterPlayerController.videoPlayerController!
        .addListener((addResolutions));
    _betterPlayerController.videoPlayerController!
        .addListener((xstream));
  }
  void mainVideoSource(){
    print("Video Player Here!");
    print(widget.xlinks);
    BetterPlayerDataSource betterPlayerDataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.network, widget.xlinks[0]["file"],
        resolutions: {
          "High": widget.xlinks[0]['file']
        },
        headers: {
          "User-Agent": userAgent,
        });
    _betterPlayerController = BetterPlayerController(
        const BetterPlayerConfiguration(
          autoPlay: true,
          aspectRatio: 16 / 9,
          controlsConfiguration: BetterPlayerControlsConfiguration(
            loadingWidget: CircularProgressIndicator(
              color: Colors.redAccent,
            ),
          ),
        ),
        betterPlayerDataSource: betterPlayerDataSource);
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          BetterPlayer(
            controller: _betterPlayerController,
          ),
        ],
      ),
    );
  }

  void checkVideo() {
    if (_betterPlayerController.videoPlayerController!.value.position >=
        Duration(seconds: 17, minutes: 0, hours: 0) &&
        !nextVideo) {
      print(
          'Video is at ${_betterPlayerController.videoPlayerController!.value.position}');
      nextVideo = true;
    }
  }

  void addResolutions() {
    if(c == 0){
      var decrease = (widget.links.length) -
          _betterPlayerController.betterPlayerDataSource!.resolutions!.length;
      if (decrease > 0) {
        // for (int i = 1; i <= decrease; i++) {
        //   int index = widget.links.length - i;
        //   String key = widget.links.keys.elementAt(index);
        //   String value = widget.links.values.elementAt(index);
        //   _betterPlayerController.betterPlayerDataSource!.resolutions!
        //       .addAll({key: value});
        // }
      }
    }
  }

  void xstream() {
    if (widget.xlinks.isNotEmpty && x == false) {
      x = true;
      setState(() {
      });
    }
  }
}