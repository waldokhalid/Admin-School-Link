import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'All Screens/absent_students.dart';
import 'All Screens/announcement_Screen.dart';
import 'All Screens/announcementsListScreen.dart';
import 'All Screens/check_in_out_students.dart';
import 'All Screens/dashBoard.dart';
import 'All Screens/driver_list.dart';
import 'All Screens/inventory_screen.dart';
import 'All Screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'All Screens/login_screen.dart';
import 'All Screens/parent_list.dart';
import 'All Screens/reset_password.dart';
import 'All Screens/staff_screen.dart';
import 'All Screens/start_screen.dart';
import 'All Screens/signup_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'All Screens/updateInventory.dart';
import 'services/local_push_notifications.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  /// On click listener
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  LocalNotificationService.initialize();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(
    MyApp(),
  );
}

DatabaseReference userReference =
    FirebaseDatabase.instance.reference().child("users");

class MyApp extends StatelessWidget {
  static const String idScreen = "MyApp";

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'School Link Admin',
      // initial route is the page the app will initially open in when initialized
      // initialRoute: StartScreen.idScreen,
      initialRoute: SplashScreen.idScreen,
      // page routes for the page.
      routes: {
        MyApp.idScreen: (context) => MyApp(),
        DashBoard.idScreen: (context) => DashBoard(),
        ParentsList.idScreen: (context) => ParentsList(),
        MainScreen.idScreen: (context) => MainScreen(
              name: '',
              phone: '',
            ),
        LoginScreen.idScreen: (context) => LoginScreen(),
        StartScreen.idScreen: (context) => StartScreen(),
        SignUpScreen.idScreen: (context) => SignUpScreen(),
        ResetPasswordScreen.idScreen: (context) => ResetPasswordScreen(),
        SplashScreen.idScreen: (context) => SplashScreen(),
        DriverListScreen.idScreen: (context) => DriverListScreen(),
        AbsentStudentListScreen.idScreen: (context) =>
            AbsentStudentListScreen(),
        AnnouncmentScreen.idScreen: (context) => AnnouncmentScreen(),
        StaffScreen.idScreen: (context) => StaffScreen(),
        InventoryScreen.idScreen: (context) => InventoryScreen(),
        UpdateInventory.idScreen: (context) => UpdateInventory(),
        StudentCheckinOut.idScreen: (context) => StudentCheckinOut(),
        AnnouncmentListScreen.idScreen: (context) => AnnouncmentListScreen(),
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({key}) : super(key: key);
  static const String idScreen = "SplashScreen";

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[400],
      
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return DashBoard();
          } else if (snapshot.hasError) {
            return SnackBar(
              backgroundColor: Colors.black,
              content: Text(
                "Something Went Wrong",
                style: GoogleFonts.lexendMega(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return StartScreen();
          }
        },
      ),
    );
  }
}
