import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:whosapp/models/friendListInfo.dart';
import 'package:whosapp/services/AshrafDatabaseController.dart';

class Groups extends StatefulWidget {
  const Groups({Key key}):super(key:key);
  @override
  _GroupsState createState() => _GroupsState();
}

class _GroupsState extends State<Groups> {

  List<GroupListInfo> groupList = List<GroupListInfo>();

  bool isNotSearching=true;

  @override
  Widget build(BuildContext context) {
    isNotSearching = true;
    return Column(
      children: <Widget>[
        SizedBox(height: 10,),
        SearchBar(),
        //Future Builder with grouplist
        isNotSearching?FutureBuilder(future: AshDBController().getGroupList(),
             builder: (BuildContext context,AsyncSnapshot<List<GroupListInfo>>snapshot){
    if (snapshot.connectionState == ConnectionState.done) {
    // YOUR CUSTOM CODE GOES HERE
    //friendList = snapshot.data;
    print("Snapshot data"+snapshot.toString());
    groupList= snapshot.data;print("Length of groupList"+groupList.length.toString());
    return ListView(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
    children: <Widget>[
    for(GroupListInfo group in groupList)
    Column(
    children: <Widget>[
    ListTile(
    leading: CircleAvatar(backgroundImage: NetworkImage(group.profilePhoto),),
    title: Text(group.groupName),
    subtitle: Text(
    group.groupDesc
    ),
      onTap: ()=> Navigator.pushNamed(this.context, 'chatscreen',arguments: {"profilePhoto":group.profilePhoto,"userName":group.groupName,"groupDesc":group.groupDesc}),
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
    return Column(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      SizedBox(height: 80,),
      SpinKitCircle(color: Colors.black87),
    SizedBox(height: 40,),
    Text("Loading Groups..."),
    ],
    );
    }
    }):
            ///Get all the groups in here
        FutureBuilder(future: AshDBController().getAllGroups(),
            builder: (BuildContext context,AsyncSnapshot<List<GroupListInfo>>snapshot){
              if (snapshot.connectionState == ConnectionState.done) {
                // YOUR CUSTOM CODE GOES HERE
                //friendList = snapshot.data;
                print("Snapshot data"+snapshot.toString());
                groupList= snapshot.data;print("Length of groupList"+groupList.length.toString());
                return ListView(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  children: <Widget>[
                    for(GroupListInfo group in groupList)
                      Column(
                        children: <Widget>[
                          ListTile(
                            leading: CircleAvatar(backgroundImage: NetworkImage(group.profilePhoto),),
                            title: Text(group.groupName),
                            subtitle: Text(
                                group.groupDesc
                            ),
                            onTap: ()=> Navigator.pushNamed(this.context, 'chatscreen',arguments: {"profilePhoto":group.profilePhoto,"userName":group.groupName,"groupDesc":group.groupDesc}),
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
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(height: 80,),
                    CircularProgressIndicator(),
                    SizedBox(height: 40,),
                    Text("Loading Groups..."),
                  ],
                );
              }
            })
    ]
    );
  }

  Widget SearchBar() {
    TextEditingController searchTextController = TextEditingController();
    return Container(
      padding: EdgeInsets.only(left: 10.0,right: 10.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black12,
          borderRadius:  BorderRadius.circular(10),
        ),
        child: TextField(
          onEditingComplete: (){
            setState(() {
              isNotSearching=false;
            });
          },
          controller: searchTextController,
          decoration: InputDecoration(
            hintStyle: TextStyle(fontSize: 17),
            hintText: 'Search Groups',
            prefixIcon: Icon(Icons.search),
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(20),
          ),
        ),
      ),
    );
  }
}



