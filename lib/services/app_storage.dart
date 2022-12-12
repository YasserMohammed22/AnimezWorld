import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
class AppStorage{
  final storageReference = FirebaseStorage.instance.ref();

//  Storage
//  Upload Image in storage
  Future<String> uploadImg(File image, String name) async {
    UploadTask uploadTask = storageReference.child(name).putFile(image);
    await uploadTask.whenComplete(() => null);
    print("Completed");
    String outputUrl = await storageReference
        .child(name)
        .getDownloadURL()
        .then((fileUrl) => fileUrl);
    return outputUrl;
  }

//  delete image from storage
  Future<void> deleteImg(String name) async{
    await storageReference.child(name).delete();
    print("deleted");
  }
}