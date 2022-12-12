import 'dart:io';

import 'package:animez_world/anime/anime_details.dart';
import 'package:animez_world/models/anime_model.dart';
import 'package:animez_world/models/member.dart';
import 'package:animez_world/models/member_profile.dart';
import 'package:animez_world/services/database.dart';
import 'package:animez_world/styles/common_styles.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Member?>(context);
    final Database db = Database(uid: user!.uid);
    final userProfile = Provider.of<MemberProfileData?>(context);
    Widget netImage = (userProfile?.profilePic == null)?Text("No Image"):Text("");
    File? image;

    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(right: 20.0),
                child: CircleAvatar(
                  maxRadius: 100.0,
                  backgroundImage: (image == null)?NetworkImage(userProfile?.profilePic??""):Image.file(image).image,
                  child: netImage,
                ),
              ),
              Column(
                children: [
                  const Text("Change Profile pic:"),
                  TextButton(onPressed: ()async{
                    final ImagePicker picker = ImagePicker();
                    final XFile? photo = await picker.pickImage(source: ImageSource.camera);
                    setState((){
                      image = File(photo!.path);
                    });
                    db.updateImg(image!);
                  }, child: Text("From Camera")),
                  TextButton(onPressed: ()async{
                    final ImagePicker picker = ImagePicker();
                    final XFile? xFileImage = await picker.pickImage(source: ImageSource.gallery);
                    setState((){
                      image = File(xFileImage!.path);
                    });
                    await db.updateImg(image!);
                  }, child: const Text("From Storage")),
                ],
              )
            ],
          ),
          const SizedBox(height: 20.0,),
          ListView(
            primary: false,
            shrinkWrap: true,
            children: (userProfile?.favorites != null)?[
              ...?userProfile?.favorites?.map((val)=>ListTile(
                onTap: ()=>{
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>MaterialApp(home: Scaffold(appBar: AppBar(title: Text("Animez World"),),body: AnimeDetails(animeDetails: AnimeModel(episodes: val['episodes'], score: val['score'], isFav: true, image: val['image'], link: val['link'], name: val['name'], released: val['released'], animeType: val['animeType']))))))
                },
                contentPadding: const EdgeInsets.symmetric(vertical: 2.0),
                leading: Image.network(val["image"]),
                title: CommonStyles.CardText(val["name"], 18.0),
                subtitle: CommonStyles.AnimeDetailText("Total Episodes: ${val['episodes']} \t Rating:${val['score']}", 16.0),
                trailing: IconButton(onPressed: () async{
                  await db.removeFromFavorites(val);
                }, icon: Icon(Icons.delete)),
              )).toList()
            ]:[],
          )
        ],
      ),
    );
  }
}

