import 'package:flutter/material.dart';

class VisitProfile extends StatefulWidget {
  @override
  _VisitProfileState createState() => _VisitProfileState();
}

class _VisitProfileState extends State<VisitProfile> {

  @override
  Widget build(BuildContext context) {

    final  Map<String, Object> args = ModalRoute.of(context).settings.arguments;
    bool isGroup = false;
    print("MAPPPPPP: "+args.toString());
    print("Contains isOnline Key :? "+args.containsKey("isOnline").toString());
    if(!args.containsKey("isOnline")){
      isGroup= true;
    }
    print(args.toString());
    print("Is a grroup : "+isGroup.toString());

    return Scaffold(
      backgroundColor: Colors.black,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 300.0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                  title: Text(args["userName"],
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.0,
                      )),
                  background: Stack(
                    children: <Widget>[
                      Image.network(
                        args["profilePhoto"],
                        fit: BoxFit.cover,
                        height: 400.0,
                      ),
                      isGroup?Positioned(
                        bottom: 25, left: 15, //give the values according to your requirement
                        child: Icon(Icons.group,color: Colors.white,),
                      ):Positioned(
                        bottom: 25, left: 15, //give the values according to your requirement
                        child: Icon(Icons.fiber_manual_record,color: args["isOnline"]?Colors.green:Colors.red,),
                      ),
                    ],
                  ),
              )
            ),
          ];
        },
        body: Column(
          children: <Widget>[
            Container(
              color: Colors.blueGrey,
              child: ListTile(
                leading: Icon(Icons.account_box,color: Colors.white,size: 50,),
                title: isGroup?Text("About Us",style:TextStyle(color: Colors.white)):Text("About Me",style:TextStyle(color: Colors.white)),
                subtitle:isGroup?Text(args["groupDesc"],style:TextStyle(color: Colors.white)):Text("I'm Awesome and I Know it",style:TextStyle(color: Colors.white)) ,
              ),
            )
          ],
        )
      ),
    );
  }



}
