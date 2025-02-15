import 'file:///C:/Users/This%20PC/Desktop/Flutter/user_app/lib/components/RoundButton.dart';
import 'package:crypto_notifier/components/progressDialog.dart';
import 'package:crypto_notifier/constants.dart';
import 'package:crypto_notifier/helper/subScribed_coins.dart';
import 'package:crypto_notifier/screens/RegistrationScreen.dart';
import 'package:crypto_notifier/screens/mainScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.white,
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Let's sign you in.",
                  style: TextStyle(
                      fontSize: 40.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "Welcome Back.",
                  style: TextStyle(
                      fontSize: 30.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "You've been missed!",
                  style: TextStyle(
                      fontSize: 25.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 1.0,
                  ),
                  TextField(
                    controller: emailTextEditingController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: "Email",
                      prefixIcon:
                          Icon(Icons.email_rounded, color: Colors.white),
                      labelStyle:
                          TextStyle(fontSize: 14.0, color: Colors.white),
                      hintText: "Enter your email",
                      hintStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 15.0,
                      ),
                    ),
                    style: TextStyle(fontSize: 14.0, color: Colors.white),
                  ),
                  SizedBox(
                    height: 1.0,
                  ),
                  TextField(
                    controller: passwordTextEditingController,
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon:
                          Icon(Icons.password_rounded, color: Colors.white),
                      labelText: "Password",
                      labelStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 14.0,
                      ),
                      hintText: "Enter your password",
                      hintStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 15.0,
                      ),
                    ),
                    style: TextStyle(fontSize: 14.0, color: Colors.white),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  RaisedButton(
                    color: Colors.yellow,
                    textColor: Colors.white,
                    child: Container(
                      height: 50.0,
                      child: Center(
                        child: Text(
                          "Login",
                          style: TextStyle(
                              fontSize: 18.0, fontFamily: "Brand Bold"),
                        ),
                      ),
                    ),
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(24.0),
                    ),
                    onPressed: () {
                      if (!emailTextEditingController.text.contains("@")) {
                        displayToastMessage(
                            "Email address is not Valid.", context);
                      } else if (passwordTextEditingController.text.isEmpty) {
                        displayToastMessage("Password is mandatory.", context);
                      } else {
                        loginAndAuthenticateUser(context);
                      }
                    },
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegisterationScreen()),
                          (route) => false);
                    },
                    child: Text(
                      "Do not have an Account? Register Here",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void loginAndAuthenticateUser(BuildContext context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return ProgressDialog(
            message: "Authenticating, Please wait...",
          );
        });

    final User firebaseUser = (await _firebaseAuth
            .signInWithEmailAndPassword(
                email: emailTextEditingController.text,
                password: passwordTextEditingController.text)
            .catchError((errMsg) {
      Navigator.pop(context);
      displayToastMessage("Error: " + errMsg.toString(), context);
    }))
        .user;

    if (firebaseUser != null) {
      Navigator.push(
          context, CupertinoPageRoute(builder: (context) => MainScreen()));
      displayToastMessage("you are logged-in now.", context);
    } else {
      Navigator.pop(context);
      _firebaseAuth.signOut();
      displayToastMessage(
          "No record exists for this user. Please create new account.",
          context);
    }
  }
}
