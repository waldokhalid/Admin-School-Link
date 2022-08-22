// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase/firebase.dart';
import 'package:admin_school_link/All%20Screens/absent_students.dart';
import 'package:admin_school_link/All%20Screens/announcementsListScreen.dart';
import 'package:admin_school_link/All%20Screens/check_in_out_students.dart';
import 'package:admin_school_link/All%20Screens/inventory_screen.dart';
import 'package:admin_school_link/All%20Screens/parent_list.dart';
import 'package:admin_school_link/All%20Screens/staff_screen.dart';
import 'package:admin_school_link/All%20Screens/start_screen.dart';
import 'package:admin_school_link/services/local_push_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_fonts/google_fonts.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({key}) : super(key: key);
  static const String idScreen = "DashBoard";

  @override
  _DashBoardState createState() => _DashBoardState();
}

final databaseReference = FirebaseDatabase.instance.reference();
final FirebaseAuth auth = FirebaseAuth.instance;

late String schoolName = "     ";
late String adminUID;
dynamic arrived = "-";
dynamic left = "-";
late String formattedDate;

late String token;

class _DashBoardState extends State<DashBoard> {
  Future<String> getUID() async {
    // This method returns the current logged in users UID
    // ignore: unused_local_variable
    final ref = FirebaseDatabase.instance.reference();
    User? user = auth.currentUser;
    setState(() {
      adminUID = user!.uid.toString();
    });
    await Future.delayed(
      Duration(milliseconds: 200),
    );
    getInfo(adminUID);
    return adminUID;
  }

  Future<dynamic> getInfo(adminUID) async {
    // This method grabs Admin details
    // final x = await getParentUID();
    await databaseReference
        .child("users")
        .child("Admin")
        .child(adminUID)
        .once()
        .then(
      (snapshot) async {
        setState(() {
          schoolName = snapshot.value["school"].toString();
          // print(schoolName);
        });
      },
    );
    // getStudentTimes(schoolName);
    storeNotificationToken(schoolName);
  }

  getTodaysDate() {
    setState(
      () {
        var now = DateTime.now().toString();
        var date = DateTime.parse(now);
        formattedDate = "${date.day}-${date.month}-${date.year}";
        // print(formattedDate);
      },
    );
  }

  deleteNotificationToken() async {
    print("Deleting token");
    await FirebaseMessaging.instance.deleteToken();
    print(schoolName);
    print(adminUID);
    try {
      await databaseReference
          .child("users")
          .child(schoolName)
          .child("Admin")
          .child(adminUID)
          .update(
        {"token": "No Token"},
      );
    } catch (e) {
      print(e);
    }
    FirebaseAuth.instance.signOut();
  }

  storeNotificationToken(schoolName) async {
    token = (await FirebaseMessaging.instance.getToken())!;
    // print(token);
    // print(schoolName);
    // print(adminUID);

    databaseReference
        .child("users")
        .child(schoolName)
        .child("Admin")
        .child(adminUID)
        .update(
      {"token": token},
    );
  }

  @override
  void initState() {
    super.initState();
    getUID();
    // getStudentTimes();
    getTodaysDate();
    FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.onMessage.listen((event) {
      LocalNotificationService.display(event);
    });
    // storeNotificationToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.grey[800],
        title: Text(
          "Dashboard",
          style: GoogleFonts.lexendMega(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Center(
            child: Container(
              child: Column(
                children: [
                  Text(
                    "$schoolName",
                    style: GoogleFonts.lexendMega(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    StudentCheckinOut.idScreen,
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.lime[800],
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 6,
                          blurRadius: 6,
                          offset: Offset(0, 0),
                          blurStyle:
                              BlurStyle.outer // changes position of shadow
                          ),
                    ],
                  ),
                  // color: Colors.greenAccent,
                  height: (MediaQuery.of(context).size.height) / 10,
                  width: (MediaQuery.of(context).size.width) / 3,
                  child: Center(
                    child: Text(
                      "Student\nCheckin/out",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lexendMega(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, ParentsList.idScreen);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 6,
                          blurRadius: 6,
                          offset: Offset(0, 0),
                          blurStyle:
                              BlurStyle.outer // changes position of shadow
                          ),
                    ],
                  ),
                  // color: Colors.greenAccent,
                  height: (MediaQuery.of(context).size.height) / 10,
                  width: (MediaQuery.of(context).size.width) / 3,
                  child: Center(
                    child: Text(
                      "Parents",
                      style: GoogleFonts.lexendMega(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () {
                  Navigator.pushNamed(
                      context, AbsentStudentListScreen.idScreen);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.deepPurpleAccent,
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 6,
                          blurRadius: 6,
                          offset: Offset(0, 0),
                          blurStyle:
                              BlurStyle.outer // changes position of shadow
                          ),
                    ],
                  ),
                  // color: Colors.amberAccent,
                  height: (MediaQuery.of(context).size.height) / 10,
                  width: (MediaQuery.of(context).size.width) / 3,
                  child: Center(
                    child: Text(
                      "Absentees",
                      style: GoogleFonts.lexendMega(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              InkWell(
                onTap: () {
                  // Navigator.pushNamed(context, DriverListScreen.idScreen);
                  Null;
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 6,
                          blurRadius: 6,
                          offset: Offset(0, 0),
                          blurStyle:
                              BlurStyle.outer // changes position of shadow
                          ),
                    ],
                  ),
                  // color: Colors.redAccent,
                  height: (MediaQuery.of(context).size.height) / 10,
                  width: (MediaQuery.of(context).size.width) / 3,
                  child: Center(
                    child: Text(
                      "Drivers",
                      style: GoogleFonts.lexendMega(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, StaffScreen.idScreen);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.indigoAccent,
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 6,
                          blurRadius: 6,
                          offset: Offset(0, 0),
                          blurStyle:
                              BlurStyle.outer // changes position of shadow
                          ),
                    ],
                  ),
                  // color: Colors.amberAccent,
                  height: (MediaQuery.of(context).size.height) / 10,
                  width: (MediaQuery.of(context).size.width) / 3,
                  child: Center(
                    child: Text(
                      "Staff",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lexendMega(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    // UpdateInventory.idScreen,
                    InventoryScreen.idScreen,
                  );
                  SnackBar(
                    content: Text("Comming Soon"),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.brown,
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 6,
                          blurRadius: 6,
                          offset: Offset(0, 0),
                          blurStyle:
                              BlurStyle.outer // changes position of shadow
                          ),
                    ],
                  ),
                  // color: Colors.amberAccent,
                  height: (MediaQuery.of(context).size.height) / 10,
                  width: (MediaQuery.of(context).size.width) / 3,
                  child: Center(
                    child: Text(
                      "Inventory",
                      style: GoogleFonts.lexendMega(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 10,
              ),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, AnnouncmentListScreen.idScreen);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.orangeAccent,
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 6,
                          blurRadius: 6,
                          offset: Offset(0, 0),
                          blurStyle:
                              BlurStyle.outer // changes position of shadow
                          ),
                    ],
                  ),
                  // color: Colors.redAccent,
                  height: (MediaQuery.of(context).size.height) / 10,
                  width: (MediaQuery.of(context).size.width) / 3,
                  child: Center(
                    child: Text(
                      "List of Bulletins",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lexendMega(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Center(
            child: Container(
              width: (MediaQuery.of(context).size.width) / 3,
              child: ElevatedButton(
                onPressed: () {
                  CircularProgressIndicator();
                  deleteNotificationToken();
                  Navigator.pushNamedAndRemoveUntil(
                      context, StartScreen.idScreen, (route) => false);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(Icons.arrow_back),
                    Text(
                      "LOGOUT",
                      style: GoogleFonts.lexendMega(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                style: ElevatedButton.styleFrom(
                  shadowColor: Colors.transparent,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Driver {
  final String arrivalTime;
  final String departedTime;

  Driver({
    required this.arrivalTime,
    required this.departedTime,
  });

  static Driver fromJson(Map<String, dynamic> json) {
    return Driver(
      arrivalTime: json['arrivalTime'].toString(),
      departedTime: json['departedTime'].toString(),
    );
  }
}
