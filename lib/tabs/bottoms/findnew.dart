import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:whosapp/models/user.dart';
import 'package:whosapp/services/AshrafDatabaseController.dart';

class FindNew extends StatefulWidget {

  const FindNew({Key key}):super(key:key);
  @override
  _FindNewState createState() => _FindNewState();

}

class _FindNewState extends State<FindNew> {
  double screenWidth;
  double screenHeight;


  @override
  Widget build(BuildContext context) {
    AshDBController ashDBController = AshDBController();
    RandomUser randomUser = RandomUser();
    screenWidth = MediaQuery. of(context).size.width;
    screenHeight = MediaQuery. of(context).size.height;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        FutureBuilder(future: AshDBController().getRandomUser(),
          builder: (BuildContext context,AsyncSnapshot<RandomUser> snapshot){
          if (snapshot.connectionState == ConnectionState.done) {
            randomUser = snapshot.data;
            print(snapshot.data.toString());
            if(!snapshot.hasData){
              return Container(child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Icon(Icons.sentiment_very_dissatisfied,size: 50.0,),
                  SizedBox(height: 20.0,),
                  Text('Error \nOccured',style: TextStyle(fontSize: 40.0),textAlign: TextAlign.center,),
                ],
              ),);
            }
            ///UI
            return Stack(
              children: <Widget>[
                ShaderMask(
                  blendMode: BlendMode.srcATop,  // Add this
                  shaderCallback: (Rect bounds) {
                    return LinearGradient(
                      begin: Alignment.bottomRight,
                      colors: <Color>[Colors.black, Colors.transparent],
                    ).createShader(bounds);
                  },
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                        color: Colors.blueGrey,
                        width: screenWidth-30,
                        height: screenHeight-400,
                        child: Image.network(randomUser.profilePhoto,fit: BoxFit.fill,)),
                  ),
                ),
                Positioned(
                    left: 30.0,
                    bottom: 10.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(randomUser.userName,
                            style: new TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 40.0,
                            )
                        ),
                        Text(randomUser.aboutMe,
                            style: new TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                            )
                        ),
                      ],
                    )
                ),
                Positioned(
                    right: 30.0,
                    top: 10.0,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        //Online Indicator Button
                        RawMaterialButton(
                          elevation: 2.0,
                          onPressed: () {},
                          shape: CircleBorder(),
                          fillColor: randomUser.isOnline?Colors.green:Colors.red,
                          padding: const EdgeInsets.all(1),
                        ),
                        Text(randomUser.age.toString(),style: TextStyle(fontSize: 40.0,color: Colors.white,fontWeight: FontWeight.bold),),
                      ],
                    )
                ),

              ],
            );
            print("SnapShot : "+snapshot.data.toString());
            print(randomUser.userName);
            return Container(width: 0.0, height: 0.0);
          }else{
            ///UI
            return  Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SpinKitRotatingPlain(color: Colors.black87,size: screenHeight-400,),
              ],
            );
            print("FETCHING");
            return Container(width: 0.0, height: 0.0);
          }

        }),

        Text("Wanna Chat ?",style: TextStyle(fontSize: 30.0),),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            ClipOval(
              child: Material(
                color: Colors.white, // button color
                child: InkWell(
                  splashColor: Colors.black, // inkwell color
                  child: SizedBox(width: 100, height: 100, child: Icon(Icons.check_circle,size: 100,color: Colors.green,)),
                  onTap: () async {
                    //OPEN A CHAT SCREEN
                    // check if current user is not blocked by the random user
                    if((await ashDBController.amIAllowed(randomUser.userName) )== true){
                      //also add user to my friend list
                      Navigator.pushNamed(context, 'chatscreen',arguments: {"profilePhoto":randomUser.profilePhoto,"userName":randomUser.userName,"isOnline":randomUser.isOnline});
                    }
                    else{
                      showAlertDialog(context, randomUser.userName);
                    }

                  },
                ),
              ),
            ),
            ClipOval(
              child: Material(
                color: Colors.white, // button color
                child: InkWell(
                  splashColor: Colors.black, // inkwell color
                  child:Icon(Icons.cancel,size: 100.0,color: Colors.red),
                  onTap: () {setState(() {
                    print("KA");
                  });},
                ),
              ),
            )
          ],
        )
      ],
    );
  }
}


showAlertDialog(BuildContext context,String randomUserName) {

  // set up the button
  Widget okButton = FlatButton(
    child: Text("OK"),
    onPressed: () { Navigator.pop(context); },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Not Allowed"),
    content: Text("You have been blocked by "+randomUserName),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}