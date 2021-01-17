import 'package:flutter/material.dart';
import 'package:whosapp/side_bar.dart';
import 'package:whosapp/tabs/bottoms/findnew.dart';
import 'package:whosapp/tabs/bottoms/friends.dart';
import 'package:whosapp/tabs/bottoms/groups.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 2,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Stranger Friends"),
          bottom: TabBar(
            indicatorSize: TabBarIndicatorSize.label,
            indicatorColor: Colors.white,
            indicatorWeight: 4,
            tabs: <Widget>[
              Tab(
                text: 'Groups',
              ),
              Tab(
                text: 'Friends',
              ),
              Tab(
                text: 'Find New',
              )
            ],
          ),
        ),
        drawer: SideDrawer(),
        body: TabBarView(
          children: <Widget>[
            Groups(),Friends(),FindNew()
          ],
        ),
      ),
    );
  }
}
