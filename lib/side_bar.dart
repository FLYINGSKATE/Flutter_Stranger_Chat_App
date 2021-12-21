import 'package:flutter/material.dart';
import 'package:whosapp/services/auth.dart';
import 'package:whosapp/services/AshrafDatabaseController.dart';
import 'models/user.dart';

class SideDrawer extends StatelessWidget {

  final AuthService _auth = AuthService();
  UserData _userData;

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(future: AshDBController().getUserData(),
        builder: (BuildContext context, AsyncSnapshot<UserData> snapshot){
          if (snapshot.connectionState == ConnectionState.done) {
            // YOUR CUSTOM CODE GOES HERE
            _userData = snapshot.data;
            print("Mera User name "+_userData.userName);
            return Container(
              child: SafeArea(
                child: Drawer(
                    child:ListView(
                  children: <Widget>[
                    ///Add Profile here name and dp
                    GestureDetector(
                      onTap:()=>Navigator.pushNamed(context, 'profile',arguments: {"userData":_userData}),
                      child: UserAccountsDrawerHeader(
                        accountEmail: Text(_userData.age.toString()+','+_userData.gender),
                        accountName: Text(_userData.userName,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25.0),),
                        currentAccountPicture: CircleAvatar(
                          backgroundImage: NetworkImage(_userData.profilePhoto),),
                      ),
                    ),
                    ListTile(title: Text('Home'),
                      leading: Icon(Icons.home),
                      onTap: ()=>Navigator.pushReplacementNamed(context, 'home'),
                    ),
                    ListTile(title: Text('Create Group'),
                      leading: Icon(Icons.group_add),
                      onTap: ()=>Navigator.pushNamed(context, 'creategroup'),
                    ),
                    ListTile(title: Text('Block List'),
                      leading: Icon(Icons.block),
                      onTap: ()=>Navigator.pushNamed(context, 'blocklist'),
                    ),
                    //Draw a line here please
                    ListTile(title: Text('Settings'),
                      leading: Icon(Icons.settings),
                      onTap: ()=>Navigator.pushNamed(context, 'settings'),
                    ),
                    ListTile(title: Text('Share'),
                      leading: Icon(Icons.share),
                      //onTap: ()=>Navigator.pushNamed(context, 'settings'),
                    ),
                    ListTile(title: Text('Rate Me'),
                      leading: Icon(Icons.star),
                      //onTap: ()=>Navigator.pushNamed(context, 'settings'),
                    ),
                    ListTile(title: Text('Logout'),
                      leading: Icon(Icons.exit_to_app),
                      onTap: () async{
                        //Clear SharedPreferences here
                        await _auth.LogOut();
                        Navigator.pushReplacementNamed(context, 'signin');
                      },
                    ),
                  ],
                )),
              ),
            );
          } else {
            return  Container(
              child: SafeArea(
                child: Drawer(child:ListView(
                  children: <Widget>[
                    GestureDetector(
                      child: UserAccountsDrawerHeader(
                        accountEmail: Text("Loading"),
                        accountName: Text("Loading.."),
                        currentAccountPicture: CircleAvatar(backgroundImage:NetworkImage('https://drive.google.com/uc?export=view&id=1OwD8qaIKqTO-BkY7rvL-n6yPkKmo1EEA')),
                      ),
                    ),
                    ListTile(title: Text('Home'),
                      leading: Icon(Icons.home),
                      onTap: ()=>Navigator.pushReplacementNamed(context, 'home'),
                    ),
                    ListTile(title: Text('Create Group'),
                      leading: Icon(Icons.group_add),
                      onTap: ()=>Navigator.pushNamed(context, 'creategroup'),
                    ),
                    //Draw a line here please
                    ListTile(title: Text('Settings'),
                      leading: Icon(Icons.settings),
                      onTap: ()=>Navigator.pushNamed(context, 'settings'),
                    ),
                    ListTile(title: Text('Share'),
                      leading: Icon(Icons.share),
                      //onTap: ()=>Navigator.pushNamed(context, 'settings'),
                    ),
                    ListTile(title: Text('Rate Me'),
                      leading: Icon(Icons.star),
                      //onTap: ()=>Navigator.pushNamed(context, 'settings'),
                    ),
                    ListTile(title: Text('Logout'),
                      leading: Icon(Icons.exit_to_app),
                      onTap: () async{
                        //Clear SharedPreferences here
                        await _auth.LogOut();
                      },
                    ),
                  ],
                )),
              ),
            );
          }
        });
  }
}
