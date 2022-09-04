import 'package:admin_school_link/All%20Screens/login_screen.dart';
import 'package:admin_school_link/All%20Widgets/progress_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:route_transitions/route_transitions.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

import '../main.dart';

// ignore: must_be_immutable
class SignUpScreen extends StatefulWidget {
  static const String idScreen = "SignUp";

  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  TextEditingController schoolNameTextEditingController =
      TextEditingController();

  final databaseReference = FirebaseDatabase.instance.reference();

  bool _isObscure = true;
  List schoolList = [];
  late String schoolName;

  String validateBeforeSending() {
    if (nameTextEditingController.text.isEmpty ||
        phoneTextEditingController.text.isEmpty ||
        emailTextEditingController.text.isEmpty ||
        passwordTextEditingController.text.isEmpty ||
        schoolNameTextEditingController.text.isEmpty) {
      return "empty";
    } else {
      return "not empty";
    }
  }

  void registerNewUser(BuildContext context) async {
    showDialog(
      // this displays the message shown below under the circular progress bar.
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Material(
          color: Colors.transparent,
          child: ProgressDialog(
            message: "Setting you up 🐳",
          ),
        );
      },
    );

    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

    final User? user = (await _firebaseAuth
            .createUserWithEmailAndPassword(
      // create a user account with given emaill and password.
      email: emailTextEditingController.text,
      password: passwordTextEditingController.text,
    )
            .catchError(
      (e) {
        // if error occurs, catch it, and display error message
        Navigator.pop(context);
        displayToastMessage("Error: " + e.toString(), context);
        print(e);
      },
    ))
        .user;
    // password;
    if (user!.emailVerified != true) {
      user.sendEmailVerification();
      // user created successfully.
      // save user info to database
      // removes accidental spaces before or after a string.

      Map userDataMapDeep = {
        "name": nameTextEditingController.text.trim(),
        "phone": phoneTextEditingController.text.trim(),
        "email": emailTextEditingController.text.trim(),
        "school": schoolNameTextEditingController.text.trim(),
        "user uid": user.uid,
        "Arrival Time": "00:00",
        "Departed Time": "00:00",
        "token": "No Token"
      };

      Map userDataMapShallow = {
        "name": nameTextEditingController.text.trim(),
        "email": emailTextEditingController.text.trim(),
        "school": schoolNameTextEditingController.text.trim(),
        "user uid": user.uid,
      };

      userReference
          .child(schoolNameTextEditingController.text)
          .child("Admin")
          .child(user.uid)
          .set(
            userDataMapDeep,
          );

      userReference.child("Admin").child(user.uid).set(
            userDataMapShallow,
          ); // sets the user data in the database in the form it was given in the map

      displayToastMessage(
        "Please verify your email adress.\nCheck SPAM Folder if you don't recieve an Email.",
        context,
      );
      // Navigator.pushNamedAndRemoveUntil(
      //     context, LoginScreen.idScreen, (route) => false);
      slideLeftWidget(newPage: LoginScreen(), context: context);
    } else {
      // if user not created dispaly toast message.
      Navigator.pop(context);
      // Error occured, display error message.
      displayToastMessage(
        "Account has been created, You may now log in.",
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      appBar: AppBar(
        toolbarHeight: 50,
        elevation: 0,
        shadowColor: Colors.grey,
        backgroundColor: Colors.grey[800],
        leading: GestureDetector(
          onTap: () {
            Navigator.pushNamedAndRemoveUntil(
                context, MyApp.idScreen, (route) => false);
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 30,
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Text(
            //   "School Link",
            //   style: GoogleFonts.lexendMega(
            //       fontWeight: FontWeight.bold,
            //       fontSize: 16,
            //       color: Colors.white),
            // ),
          ],
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 25,
                ),
                GradientText(
                  "School Link",
                  style: GoogleFonts.lexendMega(
                    fontWeight: FontWeight.bold,
                    fontSize: 36,
                  ),
                  colors: [
                    Colors.blueAccent,
                    Colors.redAccent,
                    Colors.greenAccent,
                  ],
                ),
                SizedBox(
                  height: 35,
                ),
                Text(
                  "Admin Signup Screen",
                  style: GoogleFonts.lexendMega(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      TextField(
                        controller: nameTextEditingController,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blueGrey,
                              style: BorderStyle.solid,
                              width: 0.5,
                            ),
                          ),
                          labelText: "Name",
                          labelStyle: TextStyle(
                            fontSize: 12,
                            color: Colors.white70,
                          ),
                          hintStyle: GoogleFonts.lexendMega(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                        style: GoogleFonts.lexendMega(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextField(
                        controller: emailTextEditingController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blueGrey,
                              style: BorderStyle.solid,
                              width: 0.5,
                            ),
                          ),
                          labelText: "Email",
                          labelStyle: TextStyle(
                            fontSize: 12,
                            color: Colors.white70,
                          ),
                          hintStyle: GoogleFonts.lexendMega(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                        style: GoogleFonts.lexendMega(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextField(
                        controller: phoneTextEditingController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black,
                              style: BorderStyle.solid,
                              width: 1,
                            ),
                          ),
                          labelText: "Phone",
                          labelStyle: TextStyle(
                            fontSize: 12,
                            color: Colors.white70,
                          ),
                          hintStyle: GoogleFonts.lexendMega(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                        style: GoogleFonts.lexendMega(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextField(
                        onChanged: (val) {
                          schoolName = val;
                        },
                        controller: schoolNameTextEditingController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black,
                              style: BorderStyle.solid,
                              width: 1,
                            ),
                          ),
                          labelText: "School Name",
                          labelStyle: TextStyle(
                            fontSize: 12,
                            color: Colors.white70,
                          ),
                          hintStyle: GoogleFonts.lexendMega(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                        style: GoogleFonts.lexendMega(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextField(
                        controller: passwordTextEditingController,
                        obscureText: _isObscure,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isObscure
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _isObscure = !_isObscure;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black,
                              style: BorderStyle.solid,
                              width: 0.5,
                            ),
                          ),
                          labelText: "Password",
                          labelStyle: TextStyle(
                            fontSize: 12,
                            color: Colors.white70,
                          ),
                          hintStyle: GoogleFonts.lexendMega(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                        style: GoogleFonts.lexendMega(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          String validator = validateBeforeSending();
                          if (validator != "empty") {
                            registerNewUser(context);
                          } else {
                            Fluttertoast.showToast(
                              msg: "Please Fill all the required fields above.",
                              gravity: ToastGravity.CENTER,
                              backgroundColor: Colors.black,
                              timeInSecForIosWeb: 4,
                            );
                          }
                        },
                        child: Text(
                          "Sign Up",
                          style: GoogleFonts.lexendMega(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.tealAccent[400],
                          elevation: 1,
                          shadowColor: Colors.transparent,
                          primary: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, LoginScreen.idScreen, (route) => false);
                  },
                  child: Text(
                    "Already have an account? Click to Sign in",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lexendMega(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.yellow[300]!.withOpacity(0.1),
                    primary: Colors.redAccent,
                    onSurface: Colors.cyanAccent,
                    elevation: 0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

displayToastMessage(String message, BuildContext context) {
  // create the displayToastMessage method.
  // giveit a parameter that will be a message.

  Fluttertoast.showToast(
      msg: (message),
      backgroundColor: Colors.black,
      gravity: ToastGravity.CENTER);
}
