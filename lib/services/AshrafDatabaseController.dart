import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whosapp/models/friendListInfo.dart';

import 'package:whosapp/models/user.dart';
import 'package:whosapp/services/auth.dart';

class AshDBController {

  final AuthService _auth = AuthService();

  final CollectionReference usersCollection = Firestore.instance.collection(
      'users');

  final CollectionReference groupCollection = Firestore.instance.collection(
      'Groups');

  final CollectionReference chatCollection = Firestore.instance.collection(
      "chats\\");

  Firestore db = Firestore.instance;

  UserData myData;

  //Loading the default Profile Image
  final ref = FirebaseStorage.instance.ref().child('/profile-default_0.jpg');

  Future<bool> userExist(String username) async {
    print("Check kr ta hu "+username+" hai ya nahi");
    bool exists = false;
    try {
      await Firestore.instance.document("users/$username").get().then((doc) {
        if (doc.exists)
          exists = true;
        else
          exists = false;
      });
      return exists;
    } catch (e) {
      return false;
    }
  }

  Future<bool> isPasswordCorrect(String password, String username) async {
    bool exists = false;
    try {
      await Firestore.instance.document("users/$username").get().then((doc) {
        if (doc.data.containsValue(password)) {
          print('Correct Password');
          exists = true;
        }
        else {
          print('Incorrect Password');
          exists = false;
        }
      });
      print("The value of exists =" + exists.toString());
      return exists;
    }
    catch (e) {
      return false;
    }
  }

  Future<String> LogSignUp(String username, String password) async {
    //Check if user exists if not then create one
    if (await userExist(username) == true) {
      print("User hai database mien");
      //Check if the password is correct ; if not then don't login else log in
      if (await isPasswordCorrect(password, username) == true) {
        //Login
        //Signin and download user
        //Continue to sign in annoymously by saving the password
        print("Ab hai toh download kar raha hu user data");
        dynamic result = await _auth.signInAnon();
        if (result == null) {
          print('Error sign in');
          return 'An Error occured ! Please try later :(';
        }
        else {
          print('Signed in :');
          print(result.uid);
          print("Download kar liya ab save kar leta hu Shared Preference mien");
          //Use SharedPreferences to store username
          addUserNameToSF(username);

          ///ADD USER ONLINE HERE AS WELL
          return 'Welcome back! ' + username + " :)";
        }
      }
      else if (await isPasswordCorrect(password, username) == false) {
        return 'User Already exists with different password!';
      }
    }
    else if (await userExist(username) == false) {
      //Sign in and create user
      //Continue to sign in annoymously by saving the password
      print("aisa koi user nahi hai! Bana ta hu new user");
      dynamic result = await _auth.signInAnon();
      if (result == null) {
        print('Error sign in');
        return 'An Error occured ! Please try later :(';
      }
      else {
        print('Signed in :');
        print(result.uid);
        //Create new user
        await Firestore.instance.collection("users").document(username).setData(
            {
              'userName': username,
              'password': password,
              'age': 0,
              'blockList':new List<String>(),
              'gender': 'Unknown',
              'groupsList': new List<String>(),
              'friendList': new List<String>(),
              'profilePhoto': await ref.getDownloadURL(),
              'isOnline': true,
              'About me': "Hello I'm " + username + " nice to meet you!",
            });
        print("Naya user create kar liya ab ussey add kar leta hu! SharedPref  mien");
        //Use SharedPreferences to store username
        addUserNameToSF(username);

        return 'New User Created as :' + username;
      }
    }
  }

  addUserNameToSF(String username) async {
    print("Adding "+username+"To Shared Preferences");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('USERNAME', username);
    print(prefs.getString('USERNAME'));
  }

  getUserNameFromSF() async {
    print("am I Executing");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("Udername:"+prefs.getString('USERNAME'));
    return prefs.getString('USERNAME');
  }

  //Shared Preferences clearer
  clearSharedPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('USERNAME');
  }


  ///A Method that downloads user data by taking username and returns a doc snapshot
  Future<UserData> getUserData() async {
    UserData userData;
    print("Getting Username from Shared Preferenxes bolte");
    String username = await getUserNameFromSF();
    print("Fetching data For : " + username);
    try {
      await usersCollection
          .document(username)
          .get()
          .then((DocumentSnapshot ds) {
        ///save user data here
        userData = UserData(isOnline: ds['isOnline'],
            gender: ds['gender'],
            userName: ds['userName'],
            aboutMe: ds['aboutMe'],
            profilePhoto: ds['profilePhoto'],
            age: ds['age'],
            blockList: ds['blockList'],
            friendList: ds['friendList'],
            password: ds['password'],
            groupsList: ds['groupList'],
            );
        print("Fetching Done for " + userData.userName);
        return userData;
      });
    } on Exception catch (e) {
      //
      print(e);
      return null;
    }
    return userData;
  }

  ///A Method that gets all the user's Friends Profile Photo , name and online or offline status and also
  ///Friend's last message (Last Message uhmmm.....when we have user name we can merge it together to get chat id and then we can get the
  ///chat document id and after getting that we can fetch as many chats as possible
  Future<List<FriendListInfo>> getFriendList() async {
    List<FriendListInfo> friendListInfo = List<FriendListInfo>();

    print("Getting Username from Shared Preferences");
    String username = await getUserNameFromSF();
    print("Fetching data For : " + username);
    try {
      await usersCollection
          .document(username)
          .get()
          .then((DocumentSnapshot ds) async {
        //friendList:ds['friendList']

        for (DocumentReference friend in ds['friendList']) {
          print(friend.documentID);
          await friend
              .get()
              .then((DocumentSnapshot ds){
                print(ds['profilePhoto']);
                FriendListInfo temp = FriendListInfo(userName:friend.documentID,profilePhoto: ds['profilePhoto'],LastMessage:"Last Messgae",isOnline:ds['isOnline']);
                friendListInfo.add(temp);
              });
        }
        print("FriendList : "+friendListInfo.length.toString());
        return friendListInfo;
      });
    } on Exception catch (e) {
      //
      print(e);
      return null;
    }
    return friendListInfo;
  }

  ///A Method to get group list of current user
  Future<List<GroupListInfo>> getGroupList() async {
    List<GroupListInfo> groupListInfo = List<GroupListInfo>();

    print("Yo!Getting Username from Shared Preferences");
    String username = await getUserNameFromSF();
    print("USERNAME NIKALfrom Shared Preferences");
    print("Fetching data For : " + username);
    try {
      await usersCollection
          .document(username)
          .get()
          .then((DocumentSnapshot ds) async {
        //friendList:ds['friendList']

        for (DocumentReference group in ds['groupsList']) {
          print(group.documentID);
          await group
              .get()
              .then((DocumentSnapshot ds){
            print(ds['profilePhoto']);
            GroupListInfo temp = GroupListInfo(groupName:group.documentID,profilePhoto: ds['profilePhoto'],groupDesc:ds['groupDesc']);
            groupListInfo.add(temp);
          });
        }
        print("GROUP LIST : "+groupListInfo.length.toString());
        return groupListInfo;
      });
    } on Exception catch (e) {
      //
      print(e);
      return null;
    }
    return groupListInfo;
  }

  ///A Method to Fetch Random User who is not in my block list
  Future<RandomUser> getRandomUser() async {
    Random random = new Random();
    int randomNumber;
    RandomUser randomUser = RandomUser();
    try {
      await usersCollection.getDocuments().then((value) async{
        randomNumber = random.nextInt(value.documents.length); // from 0 upto 99 included
        print(randomNumber);
        print("Selected Random User is :"+value.documents[randomNumber].documentID);
        //Check if the random user is in blocklist of our current user if not then allow it to display
        if(await isBlocked(value.documents[randomNumber].documentID)==true){
          ///rerun the function
          print("Execute Once More");
          return randomUser;
        }
        else{
          print('FETCHED UNBLOCK USER');
          print(value.documents[randomNumber].data.toString());
          print("Final User "+value.documents[randomNumber]['About Me'] );
          randomUser = RandomUser(userName:value.documents[randomNumber].documentID,profilePhoto: value.documents[randomNumber]['profilePhoto'] ,age: value.documents[randomNumber]['age'],aboutMe: value.documents[randomNumber]['aboutMe'],isOnline: value.documents[randomNumber]['isOnline']);
          print(randomUser.profilePhoto+" and this is my dp");
          return randomUser;
        }

      });
    } on Exception catch (e) {
      //
      print(e);
      return null;
    }
    return randomUser;
  }


  //A Method to get all the groups
  Future<List<GroupListInfo>> getAllGroups() async {
    List<GroupListInfo> groupListInfo = List<GroupListInfo>();
    try {
      await groupCollection.where('isPublic', isEqualTo: true).getDocuments().then((querySnapshot) async{
        print("ALL GROUPS : "+querySnapshot.documents.length.toString());
        for (int i = 0; i < querySnapshot.documents.length; i++) {
          var a = querySnapshot.documents[i];
          ///Add each GroupListInfo to a List of GroupListInfo
          GroupListInfo temp = GroupListInfo(groupName:a.documentID,profilePhoto: a['profilePhoto'],groupDesc:a['groupDesc']);
          groupListInfo.add(temp);
          print(a.documentID);
          return groupListInfo;
        }
      });
    } on Exception catch (e) {
      //
      print(e);
      return null;
    }
    return groupListInfo;
  }


  ////////BLOCK METHODS
  //A Method to block user - add user to blockList , remove user if is in friend list , and never fetch user as a random user from over data base
  /*Future<bool> blockUser(String userNameToBlock) async {

    bool isBlocked = false;

    print("Getting Username from Shared Preferences");
    String username = await getUserNameFromSF();

    print("Fetching Block List For : " + username);
    try {
      await usersCollection
          .document(username)
          .updateData({'blockList': FieldValue.arrayUnion([])})
          .then((DocumentSnapshot ds) async {
        //friendList:ds['friendList']


      });
    } on Exception catch (e) {
      //
      print(e);
      return null;
    }
    return groupListInfo;
  }*/

  //A Method to block user
  Future<bool> blockUser(String userNameToBlock) async {

    print("Getting Username from Shared Preferences");
    String username = await getUserNameFromSF();
    print("Fetching data For : " + username);

    bool isUserBlocked = false;

    //Add user to block list and also remove user from friend list
    await usersCollection.document(username).updateData({"blockList": FieldValue.arrayUnion([userNameToBlock])}).then((value) async{
      print("Done adding to block List");
      //Now Remove the same blocked user from friend list
      DocumentReference userDocToBlock = Firestore.instance.document("/users/"+userNameToBlock);
      await usersCollection.document(username).updateData({"friendList": FieldValue.arrayRemove([userDocToBlock])}).then((value) async{
        print("Done removing from friend List");
        //Now Remove the same blocked user from friend list
        isUserBlocked = true;
      });
    });
    return isUserBlocked;
  }


  //A Method to check if the user exists in the blocked list of our current user
  Future<bool> isBlocked(String randomUserName) async {

    print("Getting Username from Shared Preferences");
    String username = await getUserNameFromSF();
    print("Fetching data For : " + username);
    print(randomUserName+" Is Random User is blocked?");

    //Initially we are not allowed to text anyone
    bool isBlocked = true;

    List<dynamic> compareList = List<dynamic>();

    print("Fetching Block List For : " + username);
    //So we check are we in the random user's block list
    try {
      await usersCollection
          .document(username)
          .get()
          .then((DocumentSnapshot ds) {
        compareList = ds['blockList'];

        if(compareList.contains(randomUserName)){
          print("Yes , you are blocked by me");
          isBlocked = true;
        }
        else{
          print("No , you are not blocked "+randomUserName);
          isBlocked = false;
        }
      });
      return isBlocked;
    }
    catch(e){
      return isBlocked;
    }
  }



  //A Method to check am I Blocked by this random user?
  Future<bool> amIAllowed(String randomUserName) async {

    print("Getting Username from Shared Preferences");
    String username = await getUserNameFromSF();
    print("Fetching data For : " + username);
    print(randomUserName+" rando");

    //Initially we are not allowed to text anyone
    bool amIAllowed = false;

    List<dynamic> compareList = List<dynamic>();

    print("Fetching Block List For : " + randomUserName);
    //So we check are we in the random user's block list
    try {
      await usersCollection
          .document(randomUserName)
          .get()
          .then((DocumentSnapshot ds) {
            compareList = ds['blockList'];

            if(compareList.contains(username)){
              print("No , you are blocked by"+randomUserName);
              amIAllowed = false;
            }
            else{
              print("Yes , you are allowed to text"+randomUserName);
              amIAllowed = true;
            }
      });
      return amIAllowed;
    }
    catch(e){
      return amIAllowed;
    }
  }


  Future<List<FriendListInfo>> getBlockList() async {

    List<FriendListInfo> friendListInfo = List<FriendListInfo>();

    print("Getting Username from Shared Preferences");
    String username = await getUserNameFromSF();
    print("Fetching data For : " + username);
    try {
      await usersCollection
          .document(username)
          .get()
          .then((DocumentSnapshot ds) async {
        //friendList:ds['friendList']

        for (String friendString in ds['blockList']) {
          print("ONE OF THE BLOCKED USER :"+friendString);
          DocumentReference friend = Firestore.instance.document("/users/"+friendString);
          print(friend.documentID);
          await friend
              .get()
              .then((DocumentSnapshot ds){
            print(ds['profilePhoto']);
            FriendListInfo temp = FriendListInfo(userName:friend.documentID,profilePhoto: ds['profilePhoto'],LastMessage:"Last Messgae",isOnline:ds['isOnline']);
            friendListInfo.add(temp);
          });
        }
        print("FriendList : "+friendListInfo.length.toString());
        return friendListInfo;
      });
    } on Exception catch (e) {
      //
      print(e);
      return null;
    }
    return friendListInfo;
  }

  //A Method to Unblock user
  Future<bool> unblockUser(String userNameToUnblock) async {

    print("Getting Username from Shared Preferences");
    String username = await getUserNameFromSF();
    print("Fetching data For : " + username);

    bool isUserUnBlocked = false;

    //Add user to friend list and also remove user from friend list
    DocumentReference userDocToUnblock = Firestore.instance.document("/users/"+userNameToUnblock);
    await usersCollection.document(username).updateData({"friendList": FieldValue.arrayUnion([userDocToUnblock])}).then((value) async{
      print("Done adding to friend List");
      //Now Remove the same blocked user from friend list

      await usersCollection.document(username).updateData({"blockList": FieldValue.arrayRemove([userNameToUnblock])}).then((value) async{
        print("Done removing from block List");
        //Now Remove the same blocked user from friend list
        isUserUnBlocked = true;
      });
    });
    return isUserUnBlocked;
  }





  //////CHAT METHODS
  //A Method to get last chat
  //A Method to get all chats

  //USER INFO METHODS
  //WANNA CHAT METHOD -Add user to friend list if not there and also open chatscreen of that user


  ///A method to send chat message

  Future<void> addMessage(ChatMessage chatMessage) {
    // Call the user's CollectionReference to add a new user
    print("Message"+chatMessage.message);
    print("Username"+chatMessage.senderName);

    String chatID =getChatID(chatMessage.senderName,chatMessage.recieverName);


    Firestore.instance.collection(chatID).add({
      'Message':chatMessage.message,
      'senderID':chatMessage.senderName,
      'timeStamp':chatMessage.timeStamp,
      'recieverName':chatMessage.recieverName,//your data which will be added to the collection and collection will be created after this
    }).then((_){
      print("collection created");
    }).catchError((_){
      print("an error occured");
    });
  }


  String getChatID(String senderName,String recieverName){
    ///Send Alphatebically sorted ChatID
    List<String> senderAndRecieverName= [recieverName,senderName];
    senderAndRecieverName.sort();
    print(senderAndRecieverName.join());
    return senderAndRecieverName.join();
  }



  Stream<QuerySnapshot> getChatMessages({int offset, int limit,String recieverName}) {
    String senderName = getUserNameFromSF();
    String chatID = getChatID(senderName,recieverName);
    Stream<QuerySnapshot> snapshots = db.collection(chatID).snapshots();

    if (offset != null) {
      snapshots = snapshots.skip(offset);
    }

    if (limit != null) {
      snapshots = snapshots.take(limit);
    }
    return snapshots;
  }
}