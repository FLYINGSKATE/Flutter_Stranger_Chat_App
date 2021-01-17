import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whosapp/models/friendListInfo.dart';

class User{
  final String uid;

  User({this.uid});
}

class UserData{
  final String userName;
  String profilePhoto;
  String aboutMe;
  int age;
  final List<dynamic> friendList;
  final String gender;
  final List<dynamic> groupsList;
  String password;
  bool isOnline;
  final List<dynamic> blockList;

  UserData({this.blockList,this.userName, this.aboutMe, this.profilePhoto, this.age, this.friendList, this.gender, this.groupsList, this.password,this.isOnline});

}

class RandomUser{
  final String userName;
  String profilePhoto;
  String aboutMe;
  int age;
  bool isOnline;

  RandomUser({this.profilePhoto,this.userName,this.age,this.aboutMe,this.isOnline});
}

class ChatMessage{
  String senderName;
  String recieverName;
  String message;
  Timestamp timeStamp;

  ChatMessage({this.senderName,this.message,this.recieverName,this.timeStamp});

  ChatMessage.map(dynamic obj) {
    this.senderName = obj['senderID'];
    this.recieverName = obj['recieverName'];
    this.timeStamp = obj['timeStamp'];
    this.message = obj['Message'];

  }

  String get id =>senderName ;
  String get title => recieverName;
  String get Message => message;
  Timestamp get TimeStamp => timeStamp;


  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    if (message != null) {
      map['Message'] = message;
    }
    map['senderID'] = senderName;
    map['recieverName'] = recieverName;
    map['timeStamp'] = timeStamp;

    return map;
  }

  ChatMessage.fromMap(Map<String, dynamic> map) {
    this.message = map['Message'];
    this.timeStamp = map['timeStamp'];
  }

}