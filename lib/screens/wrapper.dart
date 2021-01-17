import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whosapp/authentication/authenticate.dart';
import 'package:whosapp/models/user.dart';
import 'package:whosapp/screens/home.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);
    print(user);

    //return either home or authenticate widget
    // Push Navigation Here later instead of returning the WidgetS!
    if(user==null){
      return Authenticate();
    }
    else{
      return Home();
    }
  }
}
