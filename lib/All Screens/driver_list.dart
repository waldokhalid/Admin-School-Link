import 'dart:async';
import 'package:admin_school_link/All%20Screens/main_screen.dart';
import "package:flutter/material.dart";
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';


class DriverListScreen extends StatefulWidget {
  const DriverListScreen({key}) : super(key: key);
  static const String idScreen = "DriverListScreen";

  @override
  _DriverListScreenState createState() => _DriverListScreenState();
}

class _DriverListScreenState extends State<DriverListScreen> {
  final databaseReference = FirebaseDatabase.instance.reference();
  FirebaseAuth auth = FirebaseAuth.instance;

  List<Driver> driverList = [];

  late String schlName;
  late String schoolName;

  // ignore: unused_field
  // static var driverRandomId;
  // String schlNameUpperCae;
  // var formattedDate;

  getSchoolName() async {
    // ignore: unused_local_variable
    // final ref = FirebaseDatabase.instance.reference();
    User? user = auth.currentUser;
    String adminUID = user!.uid.toString();
    print("Getting School Name");
    // ignore: unused_local_variable
    var myRef = databaseReference.child("users").child("Admin").child(adminUID);
    var snapshot = await myRef.get();
    if (snapshot.exists) {
      // var value = snapshot.value;
      setState(() {
        schlName = snapshot.value["school"];
      });
      print(schlName);
    } else {
      print("No Data Exists");
    }
    return schlName;
  }

  Future<List> getDriverDetails() async {
    schoolName = await getSchoolName();

    var ref =
        databaseReference.child("users").child("$schoolName").child("Drivers");
    var snapshot = await ref.get();
    if (snapshot.exists) {
      setState(() {
        // var value = snapshot.value;
        driverList = Map.from(snapshot.value)
            .values
            .map((e) => Driver.fromJson(Map.from(e)))
            .toList();
        print(driverList.length);
      });
    } else {
      print("No Data Exists");
    }
    return driverList;
  }

  @override
  void initState() {
    super.initState();
    getDriverDetails();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.grey[800],
        title: Text(
          "Driver List",
          style: GoogleFonts.lexendMega(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
      body: driverList.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "NO DRIVERS",
                    style: GoogleFonts.lexendMega(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: driverList.length,
              itemBuilder: (context, int index) {
                final Driver driver = driverList[index];
                final String driverEmail = driver.email;
                final String driverName = driver.name;
                final String driverPhone = driver.phone;
                final driverRandomId = driver.randomId;
                // final String driverUID = driver.uid;
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    color: Colors.redAccent,
                    elevation: 0.2,
                    child: ExpansionTile(
                      // collapsedBackgroundColor: Colors.grey,
                      title: Text(
                        driverName.toUpperCase(),
                        style: GoogleFonts.lexendMega(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      children: [
                        Column(
                          children: [
                            Text(
                              driverEmail,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.lexendMega(fontSize: 12),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              driverPhone,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.lexendMega(fontSize: 12),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => MainScreen(
                                      name: driverName,
                                      phone: driverRandomId,
                                    ),
                                  ),
                                );
                              },
                              child: Text("TRACK"),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class Driver {
  final String email;
  final String name;
  final String phone;
  final String randomId;
  final String uid;

  Driver({
    required this.email,
    required this.name,
    required this.phone,
    required this.randomId,
    required this.uid,
  });

  static Driver fromJson(Map<String, dynamic> json) {
    return Driver(
      email: json['email'].toString(),
      name: json['name'].toString(),
      phone: json['phone'].toString(),
      randomId: json['random id'].toString(),
      uid: json['user uid'].toString(),
    );
  }
}
