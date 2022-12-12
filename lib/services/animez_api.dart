import 'dart:convert';

import 'package:http/http.dart';

class AnimezApi{
  late final Client client;
  late final String apiLink;
  AnimezApi(){
    client = Client();
    apiLink = "https://20221027t230457-dot-psyched-equator-362305.uc.r.appspot.com/";
  }

  //search?search=name of anime(string)
  Future<List<dynamic>> getSearchResult(String anime) async{
    String searchEndpoint = "${apiLink}search?search=$anime";
    var response = await client.get(Uri.parse(searchEndpoint));
    List<dynamic> jsonResponse;
    if(response.statusCode == 200){
      jsonResponse = jsonDecode(response.body) as List<dynamic>;
    }else{
      jsonResponse = [];
    }
    return jsonResponse;
  }

  //anime?anime=title of the anime for now
  Future<Map<String, dynamic>> getAnimeDetails(String anime) async{
    String animeDetailsEndPoint = "${apiLink}anime?anime=$anime";
    var response = await client.get(Uri.parse(animeDetailsEndPoint));
    var jsonResponse;
    if(response.statusCode == 200) {
      jsonResponse = jsonDecode(response.body)[0];
    }else{
      jsonResponse = {};
    }
    return jsonResponse;
  }

  //Streaming links
  //episode?episode=<episode number>&link=<This has to be same link as in search result>
  Future<Map<String, dynamic>> getAnimeStreams(String link, int episodeNo) async{
    String animeStreamEndPoint = "${apiLink}episode?episode=$episodeNo&link=$link";
    var response = await client.get(Uri.parse(animeStreamEndPoint));
    Map<String, dynamic> jsonResponse;
    if(response.statusCode == 200){
      jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
    }else{
      jsonResponse = {};
    }
    return jsonResponse;
  }
}

// void main() async{
//   AnimezApi api = AnimezApi();
//   print(await api.getSearchResult("naruto"));
// }