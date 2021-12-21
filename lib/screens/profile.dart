import 'package:flutter/material.dart';
import 'package:whosapp/models/user.dart';
class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  bool _isEditingText = false;
  TextEditingController _editingController;
  String initialText = "Your Status Here";

  @override
  Widget build(BuildContext context) {

    //Get all the user data here
    final  Map<String, Object> args = ModalRoute.of(context).settings.arguments;
    print("USER PROFILE DATA : "+args.toString());

    UserData userData = args["userData"];
    if(userData.aboutMe!=null){
      initialText = userData.aboutMe;
    }

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
                    title: Text(userData.userName,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24.0,
                        )),
                    background: Stack(
                      children: <Widget>[
                        Image.network(
                          "https://drive.google.com/uc?export=view&id=1dBziVNMBLzUGXLo0loMWekO3TtpBhfD0",
                          fit: BoxFit.cover,
                          height: 400.0,
                          width: double.infinity,
                        ),
                        Positioned(
                          bottom: 25, left: 15, //give the values according to your requirement
                          child: Icon(Icons.fiber_manual_record,color: Colors.green,),
                        ),
                        Positioned(
                          bottom: 10, right: 2, //give the values according to your requirement
                          child: RawMaterialButton(
                            onPressed: () {},
                            elevation: 2.0,
                            fillColor: Colors.black,
                            child: Icon(
                              Icons.image,
                              color: Colors.white,
                              size: 35.0,
                            ),
                            padding: EdgeInsets.all(15.0),
                            shape: CircleBorder(),
                          )
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
                  title: Text("About Me",style:TextStyle(color: Colors.white)),
                  subtitle:_editTitleTextField(),
                  trailing: IconButton(icon: Icon(Icons.edit),color: Colors.white,onPressed: (){setState(() {
                    _isEditingText = true;
                  });},),
                ),
              )
            ],
          )
      ),
    );

  }

  Widget _editTitleTextField() {
    if (_isEditingText)
      return Center(
        child: TextField(
          onSubmitted: (newValue){
            setState(() {
              initialText = newValue;
              _isEditingText =false;
            });
          },
          autofocus: true,
          controller: _editingController,
        ),
      );
    return InkWell(
        onTap: () {
            setState(() {
              _isEditingText = true;
            });
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
                  initialText,
                  style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  ),
            ),
          ],
        ),
    );
  }

  @override
  void initState() {
    super.initState();
    _editingController = TextEditingController(text: initialText);
  }
  @override
  void dispose() {
    _editingController.dispose();
    super.dispose();
  }
}
