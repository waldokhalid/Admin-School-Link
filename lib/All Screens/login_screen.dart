import 'package:admin_school_link/All%20Screens/dashBoard.dart';
import 'package:admin_school_link/All%20Screens/signup_screen.dart';
import 'package:admin_school_link/All%20Widgets/progress_dialog.dart';
import 'package:admin_school_link/main.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:route_transitions/route_transitions.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'reset_password.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// ignore: must_be_immutable
class LoginScreen extends StatefulWidget {
  // route for teh login screen
  static const String idScreen = "login";

  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  TextEditingController schoolNameTextEditingController =
      TextEditingController();

  final databaseReference = FirebaseDatabase.instance.reference();

  bool _isObscure = true;
  late String schoolName;

  late String schoolChecker;

  @override
  void dispose() {
    emailTextEditingController.dispose();
    passwordTextEditingController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 50,
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
            //   style: GoogleFonts.robotoMono(
            //       fontWeight: FontWeight.bold,
            //       fontSize: 26,
            //       color: Colors.white),
            // ),
          ],
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: AutofillGroup(
            child: SingleChildScrollView(
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
                    "Admin Login Screen",
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
                          height: 20,
                        ),
                        TextField(
                          autofillHints: [AutofillHints.email],
                          controller: emailTextEditingController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                                style: BorderStyle.solid,
                                width: 1,
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
                            autofillHints: [AutofillHints.password],
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
                                  width: 1,
                                ),
                              ),
                              labelText: "password",
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
                            )),
                        SizedBox(
                          height: 15,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            print("Login button pressed");
                            loginUser(context);
                            // checkIfSchoolExists();
                          },
                          child: Text(
                            "Sign In",
                            style: GoogleFonts.lexendMega(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.tealAccent[400],
                            shadowColor: Colors.transparent,
                            elevation: 1,
                            primary: Colors.black,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamedAndRemoveUntil(context,
                                ResetPasswordScreen.idScreen, (route) => false);
                          },
                          child: Text(
                            "Forgot Password?",
                            style: GoogleFonts.lexendMega(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                            context, SignUpScreen.idScreen, (route) => false);
                      },
                      child: Text(
                        "Don't have an account? Click to Sign Up.",
                        style: GoogleFonts.lexendMega(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.yellow[300]?.withOpacity(0.1),
                        primary: Colors.redAccent,
                        onSurface: Colors.cyanAccent,
                        elevation: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Future checkIfSchoolExists() async {
  //   Fluttertoast.showToast(
  //     msg: "Checking If School Exists in Our Database",
  //     backgroundColor: Colors.black,
  //     textColor: Colors.white,
  //   );
  //   print("\n\n\n Checking Schools \n\n\n");

  //   try {
  //     // ignore: unused_local_variable
  //     var ref = await databaseReference.child("users").child("schools");

  //     print(schoolNameTextEditingController.text.trim());

  //     var snapshot = await ref.get();
  //     if (snapshot.exists) {
  //       print(snapshot.exists);

  //       try {
  //         schoolChecker =
  //             snapshot.value[schoolNameTextEditingController.text.trim()];
  //       } catch (e) {
  //         print(e);
  //       }

  //       print("\n\n\n\n\n$schoolChecker\n\n\n\n\n");

  //       Future.delayed(Duration(seconds: 5));

  //       if (schoolChecker != "false") {
  //         loginUser(context);
  //         print("DONE!!");
  //       } else {
  //         Fluttertoast.showToast(
  //           msg:
  //               "Looks like payments haven't been made. Please Contact School Link Platform.",
  //           backgroundColor: Colors.black,
  //           textColor: Colors.white,
  //           timeInSecForIosWeb: 20,
  //         );
  //       }
  //     } else {
  //       // Fluttertoast.showToast(
  //       //   msg:
  //       //       "School Does Not Exist in Our Database.\nContact limeappdevs@gmail.com to get you  on our Platform.",
  //       //   backgroundColor: Colors.black,
  //       //   textColor: Colors.white,
  //       //   timeInSecForIosWeb: 20,
  //       // );
  //     }
  //   } catch (e) {
  //     // Fluttertoast.showToast(
  //     //   msg:
  //     //       "School Does Not Exist in Our Database.\nContact limeappdevs@gmail.com to get you  on our Platform.",
  //     //   backgroundColor: Colors.black,
  //     //   textColor: Colors.white,
  //     //   timeInSecForIosWeb: 20,
  //     // );
  //     print(schoolNameTextEditingController.text.trim());
  //     print(
  //         "Error: School or Driver Does Not Exist in Our Database. Contact the School or Driver.");
  //     print("$e");
  //   }
  // }

  void loginUser(BuildContext context) async {
    print("Inside login function");
    showDialog(
      // this displays the message shown below under the circular progress bar.
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Material(
          color: Colors.transparent,
          elevation: 10,
          child: ProgressDialog(
            message: "Signing you in!",
          ),
        );
      },
    );

    final user = (await _firebaseAuth
            .signInWithEmailAndPassword(
      // this will attempt to sign in the user using the given cridentials.
      email: emailTextEditingController.text.trim(),
      password: passwordTextEditingController.text.trim(),
    )
            .catchError((e) {
      // if there is an error, catch it
      Navigator.pop(context);
      displayToastMessage(
          "Error: " + e.toString(), context); // diplay the error to the user
    }))
        .user;

    if (user!.emailVerified) {
      // if user login successful
      userReference.child("Admin").child(user.uid).once().then(
        (snap) {
          // variable "snap" is of type DataSnapshot. Everytime you read data from database, you recieve data as Datasnapshot.
          if (snap.value != null) {
            //  if snap value not equal to  null, login user and procceed to "MainScreen". Show toast meessage below.
            // Navigator.pushNamedAndRemoveUntil(
            //     context, DashBoard.idScreen, (route) => false);
            slideLeftWidget(newPage: DashBoard(), context: context);
            displayToastMessage("Login Successful", context);
          } else {
            // if snap value is equal to null, dont sign in and display toast mesage
            Navigator.pop(context);
            _firebaseAuth.signOut();
            displayToastMessage("Account does NOT exist", context);
          }
        },
      );
    } else {
      // if login in not successful display toast message
      Navigator.pop(context);
      // displayToastMessage("Login Not Successful", context);
      Fluttertoast.showToast(
        msg:
            "Login Not Successful. Either Provided credentials are wrong or Email has not been verified.",
        gravity: ToastGravity.CENTER,
      );
    }
  }

  displayToastMessage(String message, BuildContext context) {
    // create the displayToastMessage method.
    // giveit a parameter that will be a message.
    Fluttertoast.showToast(msg: (message));
  }
}
