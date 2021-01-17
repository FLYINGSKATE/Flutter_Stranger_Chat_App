import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whosapp/screens/blockUser.dart';
import 'package:whosapp/screens/chatScreen.dart';
import 'package:whosapp/screens/sign_in.dart';
import 'package:whosapp/screens/visitProfile.dart';
import 'package:whosapp/screens/wrapper.dart';
import 'package:whosapp/services/auth.dart';
import 'models/user.dart';
import 'screens/home.dart';
import 'screens/profile.dart';
import 'screens/settings.dart';
import 'screens/creategroup.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        title: 'Stranger Friends',
        theme: ThemeData(
          // This is the theme of your application
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primaryColor: Colors.black,
          // This makes the visual density adapt to the platform that you run
          // the app on. For desktop platforms, the controls will be smaller and
          // closer together (more dense) than on mobile platforms.
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: 'wrapper',
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case 'chatscreen': return MaterialPageRoute(
                builder: (context) => ChatScreen(settings.arguments as Map<String, Object>), // passing arguments
                settings: settings,
              );
              default: throw Exception('Unknown route');
            }
          },
        routes:{
          'wrapper':(context)=>Wrapper(),
          'home':(context)=>Home(),
          'profile':(context)=>Profile(),
          'creategroup':(context)=>CreateGroup(),
          'settings':(context)=>Settings(),
          'signin':(context)=>SignIn(),
          
          'visitprofile':(context)=>VisitProfile(),
          'blocklist':(context)=>BlockList(),
        }
      ),
    );
  }
}


