import 'package:admin_school_link/All%20Screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// ignore: unused_import

// In this class, our users can reset their passwords.

class ResetPasswordScreen extends StatefulWidget {
  static const String idScreen = "ResetPasswordScreen";

  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  late String _email;
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.yellow[400],
        title: Text(
          "Reset Password",
          style: GoogleFonts.lexendMega(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
      ),
      body: Container(
        color: Colors.yellow[400],
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Enter Email. We will send you a PASSWORD reset email.",
                style: GoogleFonts.lexendMega(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
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
                    labelStyle: GoogleFonts.lexendMega(
                      fontSize: 12,
                      color: Colors.black,
                    ),
                    hintStyle: GoogleFonts.lexendMega(
                      color: Colors.black,
                      fontSize: 12,
                    ),
                    hintText: "Email",
                  ),
                  style: GoogleFonts.lexendMega(
                    fontSize: 12,
                    color: Colors.black,
                  ),
                  onChanged: (value) {
                    setState(
                      () {
                        _email = value;
                      },
                    );
                  },
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      auth.sendPasswordResetEmail(email: _email);
                      Navigator.pushNamedAndRemoveUntil(
                          context, LoginScreen.idScreen, (route) => false);
                    },
                    child: Text(
                      "Send Request",
                      style: GoogleFonts.lexendMega(
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, LoginScreen.idScreen, (route) => false);
                },
                child: Text(
                  "Cancel",
                  style: GoogleFonts.lexendMega(
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
