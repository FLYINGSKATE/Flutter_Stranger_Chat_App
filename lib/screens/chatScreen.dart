import 'dart:async';
import 'package:time_formatter/time_formatter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:whosapp/models/user.dart';
import 'package:whosapp/services/AshrafDatabaseController.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();

  final Map<String, Object>  arguments;

  ChatScreen(this.arguments, {Key key}) : super(key: key);

}

class _ChatScreenState extends State<ChatScreen> {

  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  String chatRecieverName;

  //To recieve chat messages
  List<ChatMessage> items;


  StreamSubscription<QuerySnapshot> chatSub;



  @override
  void initState() {
    super.initState();

    items = new List<ChatMessage>();

    final  Map<String, Object> args = widget.arguments;

    print("MAPPPPPP: "+args.toString());

    chatRecieverName = args["userName"];

    //chatRecieverName = args["userName"];

    chatSub?.cancel();
    chatSub = AshDBController().getChatMessages(recieverName: chatRecieverName).listen((QuerySnapshot snapshot) {
      final List<ChatMessage> chatMessages = snapshot.documents
          .map((documentSnapshot) => ChatMessage.fromMap(documentSnapshot.data))
          .toList();

      setState(() {
        this.items = chatMessages;
      });
    });


  }






  @override
  Widget build(BuildContext context) {

    //Get all the Info for heading from previous screen no need to fetch again from internet

    return Scaffold(
      appBar: CustomAppBar(),
      body: Container(
        color: Colors.black26,
        padding: EdgeInsets.all(16),
        child: Center(
          child: Stack(
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: 66.0),
                child: Center(
                  child: ListView.builder(
                      itemCount: items.length,
                      padding: const EdgeInsets.all(15.0),
                      itemBuilder: (context, position) {
                        return Column(
                          children: <Widget>[
                            ChatBubble('${items[position].message}',items[position].timeStamp.millisecondsSinceEpoch,items[position].senderName),
                            SizedBox(height: 10,),
                          ],
                        );
                      }),
                ),
              ),
              Align(
                alignment: FractionalOffset.bottomCenter,
                child: Padding(
                    padding: EdgeInsets.only(bottom: 2.0),
                    child: ChatInput(),//Your widget here,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget CustomAppBar(){
    final  Map<String, Object> args = ModalRoute.of(context).settings.arguments;
    bool isGroup = false;
    print("MAPPPPPP: "+args.toString());

    chatRecieverName = args["userName"];

    print("Contains isOnline Key :? "+args.containsKey("isOnline").toString());
    if(!args.containsKey("isOnline")){
      isGroup= true;
    }
    print(args.toString());
    print("Is a grroup : "+isGroup.toString());

    return PreferredSize(
      preferredSize: Size.fromHeight(65.0),
      child: AppBar(title: PreferredSize(
        child: isGroup?ListTile(
          onTap: (){Navigator.pushNamed(context, 'visitprofile',arguments: {"profilePhoto":args["profilePhoto"],"userName":args["userName"],"groupDesc":args["groupDesc"]});},
          leading: CircleAvatar(backgroundImage: NetworkImage(args["profilePhoto"]),radius: 25,),
          title: Text(args["userName"],style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
          subtitle: Text(args["groupDesc"],style: TextStyle(color: Colors.white),),
          trailing:Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[

                Icon(Icons.flight_land),
                IconButton(icon: Icon(Icons.account_box,color: Colors.white),
                onPressed: (){Navigator.pushNamed(context, 'visitprofile',arguments: {"profilePhoto":args["profilePhoto"],"userName":args["userName"],"groupDesc":args["groupDesc"]});},),
                IconButton(icon:Icon(Icons.exit_to_app,color: Colors.white,),
                  onPressed: (){
                    showExitAlertDialog(context,args["userName"]);
                  },),

              ]),
        ):ListTile(
          leading: CircleAvatar(backgroundImage: NetworkImage(args["profilePhoto"]),radius: 25,),
          onTap: (){Navigator.pushNamed(context, 'visitprofile',arguments: {"profilePhoto":args["profilePhoto"],"userName":args["userName"],"isOnline":args["isOnline"]});},
          subtitle: Text(args["isOnline"]?"Online":"Offline",style: TextStyle(color: Colors.white),),
          title: Text(args["userName"],style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
          trailing:Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(icon:Icon(Icons.block,color: Colors.white,),
                  onPressed: (){
                    showBlockAlertDialog(context,args["userName"]);
                  },),
                Icon(Icons.flight_land),
                IconButton(icon: Icon(Icons.account_box,color: Colors.white),
                onPressed: (){
                  Navigator.pushNamed(context, 'visitprofile',arguments: {"profilePhoto":args["profilePhoto"],"userName":args["userName"],"isOnline":args["isOnline"]});
                },),
              ]),
        ),
      ),
        titleSpacing: -10.0,
      ),
    );
  }

  final TextEditingController textEditingController = TextEditingController();

  Widget ChatInput(){
    return Container(
      padding: EdgeInsets.only(top:5,bottom: 5),
      decoration: new BoxDecoration(
          borderRadius: BorderRadius.circular(100.0),
          color: Colors.white),
      child: Row(
        children: <Widget>[
          Material(
            borderRadius: BorderRadius.circular(100.0),
            child: new Container(
              margin: new EdgeInsets.symmetric(horizontal: 1.0),
              child: new IconButton(
                icon: new Icon(Icons.insert_emoticon),
                color: Colors.black,
              ),
            ),
            color: Colors.white,
          ),
          // Text input
          Flexible(
            child: Container(
              child: TextField(
                maxLines: null,
                style: TextStyle(color: Colors.black, fontSize: 15.0),
                controller: textEditingController,
                decoration: InputDecoration.collapsed(
                  hintText: 'Type a message',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ),
          SendBtn(),
        ],
      ),
      width: double.infinity,
    );
  }

  Widget ChatBubble(String message,int timeStampInMilliSeconds,String senderName){
    if (senderName != chatRecieverName) {
      print("Incoming Message");
      ///Incoming Message
      return DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          children: [
            Text(
              message,
              style: TextStyle(
                fontSize: 22.0,
                color: Colors.white,
              ),
            ),

            Text(formatTime(timeStampInMilliSeconds),
              style: TextStyle(
                fontSize: 22.0,
                color: Colors.white,
              ),
            ),
          ],
        ),
      );
    }
    else{
      print("Outgoing Message");
      return DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          children: [
            Text(
              message,
              style: TextStyle(
                fontSize: 22.0,
                color: Colors.black,
              ),
            ),

            Text(formatTime(timeStampInMilliSeconds),
              style: TextStyle(
                fontSize: 22.0,
                color: Colors.black,
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    textEditingController.dispose();
    chatSub?.cancel();
    super.dispose();
  }

  Widget SendBtn(){
    return GestureDetector(
      onTap: () {
        SendChatToDB(textEditingController.text);
      },

      child: Material(
        borderRadius: BorderRadius.circular(100.0),
        child: new Container(
          height: 50,
          child: new IconButton(
            icon: new Icon(Icons.send,color: Colors.white,),
            //onPressed:SendChatToDB(textEditingController.text),
            //onPressed: _insert,
            color: Colors.red,
          ),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(100),
          ),
        ),
        color: Colors.transparent,
      ),
    );
  }

  SendChatToDB(String message) async {
    print("KSALASLA"+message);
    DateTime currentPhoneDate = DateTime.now(); //DateTime
    Timestamp myTimeStamp = Timestamp.fromDate(currentPhoneDate);
    ChatMessage chatMessage = new ChatMessage(senderName:await AshDBController().getUserNameFromSF(),recieverName: chatRecieverName,message: message,timeStamp: myTimeStamp);
    ///Send this chat object to the Database
    AshDBController().addMessage(chatMessage);
  }
}

showBlockAlertDialog(BuildContext context,String userName) {

  AshDBController ashDBController = AshDBController();

  // set up the buttons
  Widget cancelButton = FlatButton(
    child: Text("NO"),
    onPressed:  () {},
  );
  Widget continueButton = FlatButton(
    child: Text("BLOCK"),
    onPressed:  () {
      print("BLOCKED USER 1:"+ashDBController.blockUser(userName).toString());
      ashDBController.blockUser(userName).then((connectionResult) {
        print("BLOCKED USER 2 :"+ashDBController.blockUser(userName).toString());
        Navigator.pushNamed(context, 'home');
      });
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Block "+userName+"?"),
    content: Text("Would you like to Block "+userName+"?"),
    actions: [
      cancelButton,
      continueButton,
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

showExitAlertDialog(BuildContext context,String userName) {
  // set up the buttons
  Widget cancelButton = FlatButton(
    child: Text("NO"),
    onPressed:  () {},
  );
  Widget continueButton = FlatButton(
    child: Text("LEAVE"),
    onPressed:  () {},
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Leave "+userName+"?"),
    content: Text("Would you like to Leave the group "+userName+"?"),
    actions: [
      cancelButton,
      continueButton,
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





