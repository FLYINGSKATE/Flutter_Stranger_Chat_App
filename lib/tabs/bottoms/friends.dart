import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:whosapp/models/friendListInfo.dart';
import 'package:whosapp/services/AshrafDatabaseController.dart';


class Friends extends StatefulWidget {
  const Friends({Key key}):super(key:key);
  @override
  _FriendsState createState() => _FriendsState();
}

class _FriendsState extends State<Friends> {

  List<FriendListInfo> friendList=List<FriendListInfo>();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: AshDBController().getFriendList(),
        builder: (BuildContext context,AsyncSnapshot<List<FriendListInfo>>snapshot){
          if (snapshot.connectionState == ConnectionState.done) {
            // YOUR CUSTOM CODE GOES HERE
            //friendList = snapshot.data;
            print("Snapshot data"+snapshot.toString());
            friendList = snapshot.data;
            print("Length of FriendList"+friendList.length.toString());
            return ListView(
              children: <Widget>[
                for(FriendListInfo friend in friendList)
                Column(
                  children: <Widget>[
                    ListTile(
                      leading: CircleAvatar(backgroundImage: NetworkImage(friend.profilePhoto),),
                      title: Text(friend.userName),
                      subtitle: Text(
                          'Last Chat Message to be displayed here...'
                      ),
                      trailing:friend.isOnline?Icon(Icons.fiber_manual_record, color: Colors.green,):Icon(Icons.fiber_manual_record, color: Colors.red,),
                      isThreeLine: true,
                      onTap: ()=>Navigator.pushNamed(context, 'chatscreen',arguments: {"profilePhoto":friend.profilePhoto,"userName":friend.userName,"isOnline":friend.isOnline}),
                    ),
                    Padding(
                      padding:EdgeInsets.symmetric(horizontal:10.0),
                      child:Container(
                        height:1.0,
                        width:MediaQuery. of(context).size.width-30,
                        color:Colors.black12,),),
                  ],
                ),

              ],
            );
                    ///Add Profile here name and dp

          } else {
            return  Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SpinKitCircle(color: Colors.black87),
                SizedBox(height: 40,),
                Text("Loading Friends..."),
              ],
            );
          }
        });
  }
}
