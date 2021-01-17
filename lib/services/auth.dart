import 'package:firebase_auth/firebase_auth.dart';
import 'package:whosapp/models/user.dart';

class AuthService{

  final FirebaseAuth _auth = FirebaseAuth.instance;

  //Create user object based on FirebaseUser
  User _userFromFirebaseUser(FirebaseUser user){
    return user!=null?User(uid:user.uid):null;
  }

  //Auth Change user stream
  Stream<User> get user{
    return _auth.onAuthStateChanged
        .map(_userFromFirebaseUser);
  }

  //Sign in anonymously
  Future signInAnon() async{
    try{
      AuthResult  result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    }
    catch(e){
      return null;
    }
  }

  //Sign Out
  Future LogOut() async{
    try{
      return await _auth.signOut();
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }
}