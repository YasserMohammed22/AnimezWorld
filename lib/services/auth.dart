import 'package:animez_world/models/member.dart';
import 'package:animez_world/models/member_profile.dart';
import 'package:animez_world/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Auth{
  final FirebaseAuth auth = FirebaseAuth.instance;

//  user model for future user
  Member? userFromFirebase(User? user){
    return (user != null)? Member(uid: user.uid):null;
  }

//  Stream for checking state of the user
  Stream<Member?> get user{
    return auth.authStateChanges().map(userFromFirebase);
  }

//  register
  Future register(String email, String password, String name, String phone) async{
    try {
      UserCredential result = await auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      // Create a collection of the database using uid for the new user
      Database db = Database(uid: user!.uid);
      await db.updateDatabase(memberProfileData: MemberProfileData(username: name, phone: phone, favorites: []));
      return userFromFirebase(user);
    } catch (e) {
      print("Error while creating user");
      print(e.toString());
    }
  }

//  sign in
  Future signIn(String email, String password) async{
    try{
      UserCredential result = await auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return userFromFirebase(user);
    }catch(e){
      print("Error while signing in with this email id or password");
      print(e.toString());
    }
  }

// sign in anonymously for testing
  Future signInAnon() async{
    try {
      dynamic user = await auth.signInAnonymously();
      return user;
    }catch(e){
      print("Error while signing in as a Anonymous User");
      print(e.toString());
    }
  }

//  sign out
  Future<void> signOut() async{
    await auth.signOut();
  }

//  change password
  Future<void> changePassword() async{
  }
}