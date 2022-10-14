import 'package:admin_school_link/All%20Screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:route_transitions/route_transitions.dart';
import 'login_screen.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class StartScreen extends StatelessWidget {
  static const String idScreen = "start";

  const StartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 50,
        backgroundColor: Colors.grey[800],
      ),
      body: Container(
        // color: Colors.yellow[400],
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
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
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    // width: 250.0,
                    child: DefaultTextStyle(
                      style: GoogleFonts.lexendMega(
                        fontSize: 20.0,
                      ),
                      child: AnimatedTextKit(
                        isRepeatingAnimation: false,
                        pause: Duration(seconds: 2),
                        animatedTexts: [
                          TypewriterAnimatedText('Simple yet EFFECTIVE'),
                        ],
                        // onTap: () {
                        //   print("Tap Event");
                        // },
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Navigator.pushNamed(
                          //   context,
                          //   LoginScreen.idScreen,
                          // );
                          slideLeftWidget(
                              newPage: LoginScreen(), context: context);
                        },
                        child: Text(
                          "Sign In",
                          style: GoogleFonts.lexendMega(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.black, backgroundColor: Colors.tealAccent[400],
                          shadowColor: Colors.transparent,
                          elevation: 1,
                        ),
                      )
                    ],
                  ),
                  // Text(
                  //   "Don't have an account?",
                  //   style: GoogleFonts.lexendMega(
                  //       color: Colors.black, fontSize: 12),
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Navigator.pushNamed(
                          //   context,
                          //   SignUpScreen.idScreen,
                          // );
                          slideLeftWidget(
                              newPage: SignUpScreen(), context: context);
                        },
                        child: Text(
                          "Sign Up",
                          style: GoogleFonts.lexendMega(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.black, backgroundColor: Colors.tealAccent[400],
                          shadowColor: Colors.transparent,
                          elevation: 1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
