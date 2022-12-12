import 'dart:io';
import 'package:animez_world/models/anime_model.dart';
import 'package:animez_world/models/member_profile.dart';
import 'package:animez_world/services/app_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class Database{
  final CollectionReference collection = FirebaseFirestore.instance.collection("users");
  final uid;
  final appStorage = AppStorage();
  Database({required this.uid});

//  update to the database
  Future updateDatabase({required MemberProfileData memberProfileData}) async{
    return await collection.doc(uid).set(transformMemberProfile(memberProfileData));
  }

//  update image of the user
  Future updateImg(File image) async{
    var imageUrl = await appStorage.uploadImg(image, uid.toString());
    await collection.doc(uid).update({"profilePic": imageUrl});
  }

  //  Favorites update
  Future addToFavorites(AnimeModel favAnime) async{
    return await collection.doc(uid).update(
      {
        "favorites": FieldValue.arrayUnion([
          transformAnimeToMap(favAnime)
        ])
      }
    );
  }
  Future removeFromFavorites(dynamic anime) async{
    if(anime is AnimeModel){
      return await collection.doc(uid).update(
          {
            "favorites": FieldValue.arrayRemove([
              transformAnimeToMap(anime)
            ])
          }
      );
    }else{
      return await collection.doc(uid).update({
        "favorites": FieldValue.arrayRemove([
          anime
        ])
      });
    }
  }



//  Stream for the user data
  Stream<MemberProfileData?> get userProfile{
    return collection.doc(uid).snapshots().map(profileData);
  }

//  Member profile data
  MemberProfileData? profileData(DocumentSnapshot docSnap){
    dynamic data = docSnap.data();
    return MemberProfileData(username: data['username'], phone: data['phone'], profilePic: data['profilePic'], favorites: data['favorites']);
  }

// From MemberProfileData to a Map
  Map<String, dynamic> transformMemberProfile(MemberProfileData memberProfileData){
    return {
      "username": memberProfileData.username,
      "phone": memberProfileData.phone,
      "profilePic": memberProfileData.profilePic,
      "favorites": memberProfileData.favorites
    };
  }

//  From AnimeModel to Map
  Map<String, dynamic> transformAnimeToMap(AnimeModel? favAnime){
    if(favAnime == null){
      return {};
    }
    return {
      "name": favAnime.name,
      "link": favAnime.link,
      "episodes": favAnime.episodes,
      "released": favAnime.released,
      "score": favAnime.score,
      "animeType": favAnime.animeType,
      "image": favAnime.image
    };
  }
}