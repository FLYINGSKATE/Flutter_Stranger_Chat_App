import 'package:flutter/material.dart';
import 'package:whosapp/models/friendListInfo.dart';
import 'package:whosapp/services/AshrafDatabaseController.dart';

class BlockList extends StatefulWidget {
  @override
  _BlockListState createState() => _BlockListState();
}

class _BlockListState extends State<BlockList> {

  List<FriendListInfo> friendList=List<FriendListInfo>();
  AshDBController ashDBController = AshDBController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Block List')),
      body: Container(

        child: FutureBuilder(future: AshDBController().getBlockList(),
            builder: (BuildContext context,AsyncSnapshot<List<FriendListInfo>> snapshot){
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
                            leading: CircleAvatar(backgroundImage: NetworkImage(friend.profilePhoto)),
                            title: Text(friend.userName,style: TextStyle(fontSize: 20.0),),
                            subtitle: Text(
                                'Tap to Unblock',style: TextStyle(fontStyle: FontStyle.italic,fontSize: 18.0),
                            ),
                            trailing:Icon(Icons.block, color: Colors.grey,),
                            onTap: (){
                              print("unblocking"+friend.userName);
                              ashDBController.unblockUser(friend.userName).then((connectionResult) {
                                Navigator.pushNamed(context, 'home');
                              });

                            },
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
                return  Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircularProgressIndicator(),
                      SizedBox(height: 40,),
                      Text("Loading block List..."),
                    ],
                  ),
                );
              }
            })
      ),
    );
  }
}
