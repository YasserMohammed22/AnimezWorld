import 'package:animez_world/anime/anime_details.dart';
import 'package:animez_world/models/anime_model.dart';
import 'package:animez_world/services/animez_api.dart';
import 'package:animez_world/styles/authstyles.dart';
import 'package:animez_world/styles/common_styles.dart';
import 'package:flutter/material.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var searchQuery="";
  late AnimeModel selected;
  List<AnimeModel> animeSearchResult=[];
  dynamic pagesRoute;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop: () {
      setState((){
        pagesRoute = 0;
      });
      return Future(() => false);
    },
    child: getPage(pagesRoute));
  }

  // Get the pages
  Widget getPage(int pageRoute){
    switch(pageRoute){
      case 0: return SearchPage();
      case 1: return AnimeDetails(animeDetails: selected);
      default: return SearchPage();
    }
  }

  // HomePage
  Widget SearchPage(){
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            Text("Searching Now!"),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  width: MediaQuery.of(context).size.width*.8,
                  child: TextField(
                    onSubmitted: handleSearch,
                    style: AuthStyle().textStyle(),
                    decoration: AuthStyle().textInput(text: "Search Anime"),
                    onChanged: (val)=>{
                      setState((){
                        searchQuery = val;
                      })
                    },
                  ),
                ),
                TextButton(onPressed: ()=>handleSearch(searchQuery), child: Text("GO", style: AuthStyle().textStyle(),))
              ],
            ),
            const SizedBox(height: 20.0),
            GridView.count(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              crossAxisCount: 2,
              crossAxisSpacing: 25.0,
              mainAxisSpacing: 10.0,
              childAspectRatio: 0.55,
            shrinkWrap: true,
            primary: false,
              children: [
              ...animeSearchResult.map((animeDetails) => GestureDetector(
                onTap: (){
                  setState((){
                    selected = animeDetails;
                    pagesRoute = 1;
                  });
                },
                child: Card(
                  color: Colors.grey[200],
                  elevation: 5.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Image.network(animeDetails.image, height: 230.0, width: 160.0,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          CommonStyles.CardText(animeDetails.name, 16.0),
                          CommonStyles.CardText(animeDetails.released, 12.0),
                          CommonStyles.CardText(animeDetails.episodes, 12.0)
                        ],
                      )
                    ],
                  ),
                ),
              ))
            ],)
          ],
        ),
      ),
    );
  }

  // On searching
  void handleSearch(String name) async{
    animeSearchResult.clear();
    AnimezApi api = AnimezApi();
    var res = await api.getSearchResult(name);
    for (var element in res) {
      animeSearchResult.add(AnimeModel(name: element["title"], link: element["link"].substring(1), released: element["release"], image: element["img"]));
    }
    setState((){
      animeSearchResult;
    });
  }

  @override
  initState(){
    super.initState();
    pagesRoute = 0;
  }
}
