import 'package:flutter/material.dart';
import 'package:whosapp/screens/sign_in.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  bool isNewUser;

  @override
  Widget build(BuildContext context) {
    return SignIn();
  }
}
