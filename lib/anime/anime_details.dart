import 'package:animez_world/models/anime_model.dart';
import 'package:animez_world/models/member.dart';
import 'package:animez_world/models/member_profile.dart';
import 'package:animez_world/services/animez_api.dart';
import 'package:animez_world/services/database.dart';
import 'package:animez_world/styles/common_styles.dart';
import 'package:animez_world/video_payer/episode_player.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AnimeDetails extends StatefulWidget {
  final AnimeModel animeDetails;

  const AnimeDetails({Key? key, required this.animeDetails}) : super(key: key);

  @override
  State<AnimeDetails> createState() => _AnimeDetailsState();
}

class _AnimeDetailsState extends State<AnimeDetails> {
  List<String> list = [];
  List<List<int>> episodeList = [];
  List<Widget> episodeNo = [];
  bool isChanged = false;
  String dropdownValue = "";
  @override
  Widget build(BuildContext context) {
    final profileDetails = Provider.of<MemberProfileData?>(context);
    final user = Provider.of<Member?>(context);
    final Database db = Database(uid: user?.uid);
    if(isChanged){
      if(profileDetails?.favorites == null){
        setState((){
          isChanged = false;
        });
      }else{
        checkIfFavorite(profileDetails?.favorites);
      }
    }
    return SingleChildScrollView(
      child: Column(
        children: [
          AspectRatio(
              aspectRatio: 1.3,
              child: Image.network(
                widget.animeDetails.image,
                fit: BoxFit.fitWidth,
                alignment: Alignment.center,
              )),
          CommonStyles.AnimeDetailText(widget.animeDetails.name, 27.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CommonStyles.AnimeDetailText(widget.animeDetails.released, 18.0),
              CommonStyles.AnimeDetailText(
                  "Total Episodes: ${widget.animeDetails.episodes}", 18.0),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CommonStyles.AnimeDetailText(
                  "Rating: ${widget.animeDetails.score}", 16.0),
              CommonStyles.AnimeDetailText(
                  "Type: ${widget.animeDetails.animeType}", 16.0),
              TextButton.icon(
                onPressed: () async{
                  if(!check()){
                    await db.removeFromFavorites(widget.animeDetails);
                    setState((){
                      widget.animeDetails.isFav = false;
                    });
                  }else{
                    await db.addToFavorites(widget.animeDetails);
                    setState((){
                      widget.animeDetails.isFav = true;
                    });
                  }
                },
                icon: (check())?Icon(Icons.favorite):Icon(Icons.remove),
                label: Text(
                  (check())?
                  "Add to Favorites":"Remove",
                  style: TextStyle(fontSize: 18.0),
                ),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith(
                        (states) => (check())?Colors.pinkAccent[100]:Colors.red)),
              )
            ],
          ),
          Container(
            child: DropdownButton<String>(
              value: dropdownValue,
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              style: const TextStyle(color: Colors.deepPurple),
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              onChanged: (String? value) {
                // This is called when the user selects an item.
                setState(() {
                  dropdownValue = value!;
                });
              },
              items: list.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 3.0),
            child: GridView.count(crossAxisCount: 3, shrinkWrap: true, primary: false,
            mainAxisSpacing: 15.0,
            childAspectRatio: 1.7,
            crossAxisSpacing: 10.0,
            children: getEpisodeNumbers(),)
          )
        ],
      ),
    );
  }

  // check if fav
  bool check(){
    if(widget.animeDetails.isFav == null || !widget.animeDetails.isFav){
      return true;
    }
    return false;
  }

  Future<void> fillAnimeDetails() async {
    AnimezApi api = AnimezApi();
    var res = await api.getAnimeDetails(widget.animeDetails.name);
    widget.animeDetails.episodes = res["total_episodes"];
    widget.animeDetails.score = res["score"];
    widget.animeDetails.animeType = res["anime_type"];
    setState(() {
      widget.animeDetails;
    });
    createDropDownList();
  }

  // Create Drop Down list
  void createDropDownList(){
    int episodes = int.parse(widget.animeDetails.episodes);
    int maxLength = episodes~/5;
    if(maxLength < 25){
      maxLength = episodes;
    }
    int low = 1;
    int high = maxLength;
    while(low <= episodes){
      list.add("$low-$high");
      episodeList.add([low, high]);
      low = high+1;
      high += maxLength;
      if(high >= episodes){
        high = episodes;
      }
    }
    setState((){
      dropdownValue = list.first;
    });

    for (var item in episodeList){
      for (var i=item[0]; i<= item[1]; i++){
        episodeNo.add(TextButton(onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>EpisodePlayer(animeDetails: widget.animeDetails, episodeNo: i,)));
        }, child: Text("${i}", style: TextStyle(fontSize: 21.0, fontWeight: FontWeight.w700),),
        style: ButtonStyle(backgroundColor: MaterialStateColor.resolveWith((states) => Colors.greenAccent)),));
      }
    }
    setState((){
      episodeNo;
    });
  }

  // Get Episode Numbers
  List<Widget> getEpisodeNumbers(){
    if(episodeNo.isEmpty || episodeList.isEmpty){
      return [];
    }else{
      var index = list.indexOf(dropdownValue);
      return episodeNo.sublist(episodeList[index][0]-1, episodeList[index][1]);
    }
  }

  // Check if the anime is favorite
  void checkIfFavorite(List<dynamic> profileData){
    for(dynamic fav in profileData){
      if(fav["name"] == widget.animeDetails.name){
        widget.animeDetails.isFav = true;
        break;
      }
    }
    setState((){
      isChanged = false;
    });
  }

  @override
  initState() {
    super.initState();
    fillAnimeDetails();
    isChanged = true;
  }
}
