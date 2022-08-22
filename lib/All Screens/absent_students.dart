// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:async';
import "package:flutter/material.dart";
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class AbsentStudentListScreen extends StatefulWidget {
  const AbsentStudentListScreen({key}) : super(key: key);
  static const String idScreen = "AbsentStudentListScreen";

  @override
  _AbsentStudentListScreenState createState() =>
      _AbsentStudentListScreenState();
}

class _AbsentStudentListScreenState extends State<AbsentStudentListScreen> {
  final databaseReference = FirebaseDatabase.instance.reference();
  FirebaseAuth auth = FirebaseAuth.instance;
  late String formattedDate;
  // List<Driver> driverList = [];
  List<Children> childrenList = [];
  var schlName;
  var schlNameUpperCae;
  late int absentStudents;
  late String schoolName;

  List<String> tokenList = [];

  getSchoolName() async {
    // ignore: unused_local_variable
    // final ref = FirebaseDatabase.instance.reference();
    User? user = auth.currentUser;
    String adminUID = user!.uid.toString();
    if (kDebugMode) {
      print("Getting School Name");
    }
    // ignore: unused_local_variable
    var myRef = databaseReference.child("users").child("Admin").child(adminUID);
    var snapshot = await myRef.get();
    if (snapshot.exists) {
      // var value = snapshot.value;
      setState(() {
        schlName = snapshot.value["school"];
      });
      if (kDebugMode) {
        print(schlName);
      }
    } else {
      if (kDebugMode) {
        print("No Data Exists");
      }
    }
    return schlName;
  }

  Future<List> getListOfChildren() async {
    schoolName = await getSchoolName();
    if (kDebugMode) {
      print("Getting Children");
    }
    var ref = databaseReference
        .child("users/$schoolName/Absent_Children/$formattedDate");
    // .child(schoolName)
    // .child("Absent_Children")
    // .child(formattedDate);
    // .child("18-8-2021");
    var snapshot = await ref.get();
    if (snapshot.exists) {
      var value = snapshot.value;
      setState(
        () {
          childrenList = Map.from(value)
              .values
              .map((e) => Children.fromJson(Map.from(e)))
              .toList();
          setState(() {
            absentStudents = childrenList.length;
          });
          if (kDebugMode) {
            print(childrenList.length);
          }
        },
      );
    } else {
      if (kDebugMode) {
        print("No Data Exists");
      }
    }

    return childrenList;
  }

  getTodaysDate() {
    setState(
      () {
        var now = DateTime.now().toString();
        var date = DateTime.parse(now);
        formattedDate = "${date.day}-${date.month}-${date.year}";
        if (kDebugMode) {
          print(formattedDate);
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getSchoolName();
    getTodaysDate();
    getListOfChildren();
    if (kDebugMode) {
      print("Entering Scafold");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0.2,
        centerTitle: true,
        backgroundColor: Colors.grey[800],
        title: Text(
          "Absent Students",
          style: GoogleFonts.lexendMega(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
      body: childrenList.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "NO ABSENT CHILDREN",
                    style: GoogleFonts.lexendMega(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              physics: ScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    "No. of Absent Students Today: " + "$absentStudents",
                    style: GoogleFonts.lexendMega(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: childrenList.length,
                    itemBuilder: (context, int index) {
                      final Children child = childrenList[index];
                      final String childName = child.childName;
                      final String parentName = child.parentName;
                      final String token = child.token;
                      tokenList.add(token);
                      return Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Card(
                          color: Colors.deepPurpleAccent,
                          elevation: 0,
                          child: ExpansionTile(
                            // backgroundColor: Colors.black54,
                            title: Text(
                              childName.toUpperCase(),
                              style: GoogleFonts.lexendMega(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            children: [
                              Column(
                                // mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Parent: " + parentName,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.lexendMega(
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }
}

class Children {
  final String childName;
  final String parentName;
  final String token;

  Children({
    required this.childName,
    required this.parentName,
    required this.token,
  });

  static Children fromJson(Map<dynamic, dynamic> json) {
    return Children(
      childName: json["Child_Name"].toString(),
      parentName: json["Parent_Name"].toString(),
      token: json["token"].toString(),
    );
  }
}
