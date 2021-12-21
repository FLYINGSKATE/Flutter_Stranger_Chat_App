import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:whosapp/services/AshrafDatabaseController.dart';


///Don't Forget to disable the button initially for registration and after validation turn it back on

class SignIn extends StatefulWidget {

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final _globalKey = GlobalKey<ScaffoldState>();

  final _formKey = GlobalKey<FormState>();

  final AshDBController fireBaseDB = AshDBController();

  bool isNotLoading = true;

  // Initially password is obscure
  bool _obscureText = true;

  String _password;

  String username = '';
  String password='';


  // Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(title: Text('Login/Sign up'),centerTitle: true,),
      body: Container(
        padding: new EdgeInsets.all(30.0),
           child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 20.0,),
                  TextFormField(
                    decoration: new InputDecoration(
                      labelText: "Enter Username",
                      fillColor: Colors.white,
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(25.0),
                        borderSide: new BorderSide(
                        ),
                      ),
                      //fillColor: Colors.green
                    ),
                    validator: (val)=> val.isEmpty?'Enter username':null,
                    onChanged: (val){
                      setState(() {
                        username = val;
                      });
                    },
                  ),
                  SizedBox(height: 20.0,),
                  TextFormField(
                    decoration: new InputDecoration(
                      labelText: "Enter Password",
                      fillColor: Colors.white,
                      //fillColor: Colors.green
                    ),
                    obscureText: _obscureText,
                    validator: (val){
                      val.length<6?'Enter 6+ Characters':null;
                      isNotLoading = true;
                      setState(() {

                      });
                    },
                    onChanged: (val){
                      setState(() {
                        password = val;
                      });
                    },
                  ),
                  SizedBox(height: 20.0,),
                  IconButton(
                      iconSize: 40.0,
                      onPressed: _toggle,
                      icon: Icon(_obscureText ? Icons.remove_red_eye : Icons.highlight_off)),
                  SizedBox(height: 20.0,),
                  isNotLoading?RaisedButton(
                    padding: EdgeInsets.all(10.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100.0),
                    ),
                    color: Colors.black,
                    child: Text(
                      'Start Chatting!',
                      style: TextStyle(color: Colors.white,fontSize: 30.0,),
                    ),
                    onPressed: ()async{
                      setState(() {
                        isNotLoading = false;
                      });
                        if(_formKey.currentState.validate()){
                          String snackbarText = await fireBaseDB.LogSignUp(username, password);
                          print(snackbarText);
                          setState(() {
                            isNotLoading = true;
                          });
                          final snackBar = SnackBar(content: Text(snackbarText));
                          // Find the Scaffold in the widget tree and use it to show a SnackBar.
                          _globalKey.currentState.showSnackBar(snackBar);
                        }
                    },
                  ):CircularProgressIndicator()
                ],
              ),
            ),
         ),
    );
  }
}
