import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StaffScreen extends StatefulWidget {
  const StaffScreen({key}) : super(key: key);
  static const String idScreen = "StaffScreen";

  @override
  State<StaffScreen> createState() => _StaffScreenState();
}

class _StaffScreenState extends State<StaffScreen> {
  final databaseReference = FirebaseDatabase.instance.reference();
  FirebaseAuth auth = FirebaseAuth.instance;
  // ignore: unused_field
  static var driverRandomId;
  List<Driver> driverList = [];
  late String schlName;
  late String schoolName;
  late String schlNameUpperCae;
  var formattedDate;

  getSchoolName() async {
    // ignore: unused_local_variable
    final ref = FirebaseDatabase.instance.reference();
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
    print(schoolName);

    // var ref =
    //     await databaseReference.child("users").child("$schoolName").child("Staff");
    var ref = databaseReference.child("users/$schoolName/Staff");
    var snapshot = await ref.get();
    if (snapshot.exists) {
      setState(() {
        // var value = snapshot.value;
        driverList = Map.from(snapshot.value)
            .values
            .map((e) => Driver.fromJson(Map.from(e)))
            .toList();
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
          "STAFF",
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
                    "NO STAFF",
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
                final String checkout = driver.checkout;
                final String checkin = driver.checkin;
                // final String salary = driver.salary;
                // final String driverUID = driver.uid;
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    color: Colors.indigoAccent,
                    elevation: 0.2,
                    child: ExpansionTile(
                      // collapsedBackgroundColor: Colors.red,
                      // backgroundColor: Colors.grey[850],
                      title: Text(
                        driverName.toUpperCase(),
                        style: GoogleFonts.lexendMega(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      children: [
                        Column(
                          children: [
                            Text(
                              driverEmail,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.lexendMega(fontSize: 12,color: Colors.white,),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              driverPhone,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.lexendMega(fontSize: 12,color: Colors.white,),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              "Checked in: $checkin",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.lexendMega(fontSize: 12,color: Colors.white,),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Checked out: $checkout",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.lexendMega(fontSize: 12,color: Colors.white,),
                            ),
                            SizedBox(
                              height: 15,
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
  final String checkin;
  final String checkout;
  // final String salary;

  Driver({
    required this.email,
    required this.name,
    required this.phone,
    required this.checkin,
    required this.checkout,
    // this.salary,
  });

  static Driver fromJson(Map<String, dynamic> json) {
    return Driver(
      email: json['email'].toString(),
      name: json['name'].toString(),
      phone: json['phone'],
      checkin: json['Checkin Time'],
      checkout: json['Checkout Time'],
      // salary: json['Salary']
    );
  }
}
