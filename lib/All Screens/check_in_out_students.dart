import 'dart:convert';

import 'package:admin_school_link/services/local_push_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class StudentCheckinOut extends StatefulWidget {
  const StudentCheckinOut({key}) : super(key: key);
  static const String idScreen = "StudentCheckinOut";

  @override
  State<StudentCheckinOut> createState() => _StudentCheckinOutState();
}

class _StudentCheckinOutState extends State<StudentCheckinOut> {
  TextEditingController feesPaymentUpdate = TextEditingController();
  TextEditingController totalFeesToBePaid = TextEditingController();
  final databaseReference = FirebaseDatabase.instance.reference();
  FirebaseAuth auth = FirebaseAuth.instance;
  // ignore: unused_field
  static var driverRandomId;
  List<Parents> parentList = [];
  late String schlName;
  late String schoolName;

  late int totalFeesToBePaidToInt;
  late int updatedItemAmountToInt;
  late int totalPaid;
  late int totalBalance;

  dynamic arrived;
  dynamic departed;

  late String currentTimeOnUserDeivce;
  List<String> parentNotificationTOkens = [];

  late String adminUID;

  void setArrivalTime(parentUID) {
    // final databaseReference = FirebaseDatabase.instance.reference();
    setState(() {
      arrived = getTime();
    });
    print("Inside getUserUID");
    print(schoolName);
    print(parentUID);
    // User user = auth.currentUser;
    // final driverUID = user.uid.toString();
    try {
      databaseReference
          .child("users")
          .child(schoolName)
          .child("Parents")
          .child(parentUID)
          .update({
        "Arrived": arrived,
      });
    } catch (e) {}
  }

  void SetDepartedTime(parentUID) {
    // final databaseReference = FirebaseDatabase.instance.reference();
    print("Inside getUserUID");
    setState(() {
      departed = getTime();
    });
    // User user = auth.currentUser;
    // final driverUID = user.uid.toString();
    databaseReference
        .child("users")
        .child(schoolName)
        .child("Parents")
        .child(parentUID)
        .update({
      "Departed": departed,
    });
  }

  String getTime() {
    DateTime now = DateTime.now();
    setState(() {
      currentTimeOnUserDeivce =
          "${now.hour.toString()}:${now.minute.toString()}";
    });
    return currentTimeOnUserDeivce;
  }

  getSchoolName() async {
    // ignore: unused_local_variable
    // final ref = FirebaseDatabase.instance.reference();
    User? user = auth.currentUser;
    setState(() {
      adminUID = user!.uid.toString();
    });
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

  // storeNotificationToken(schoolName) async {
  //   String token = await FirebaseMessaging.instance.getToken();
  //   print(token);
  //   print(schoolName);
  //   print(adminUID);
  //   databaseReference
  //       .child("users")
  //       .child(schoolName)
  //       .child("Admin")
  //       .child(adminUID)
  //       .update(
  //     {"token": token},
  //   );
  // }

  sendNotifiaction(String title, String token, notifyParent) async {
    final data = {
      "click_ation": "FLUTTER_NOTIFICATION_CLICK",
      "id": "1",
      "status": "done",
      "message": title,
    };

    try {
      http.Response response =
          await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
              headers: <String, String>{
                'Content-Type': 'application/json',
                'Authorization':
                    'key=AAAAMVGDYWc:APA91bEVdCn70Z5hXiVpybPRSOq0_wQIq89sJ6KXQTSOAiurbdhTeTr_rMBUaEd1TKHX7Ljn2wu0lkFBiDE2d5f0vqqEPVDV_lZIL2u3ETsQzazWMAXsTNlpOULzKYxutrG--kS3itxY'
              },
              body: jsonEncode(<String, dynamic>{
                'notification': <String, dynamic>{
                  'title': title,
                  'body': notifyParent,
                },
                'priority': 'High',
                'data': data,
                'to': token,
              }));

      if (response.statusCode == 200) {
        print("Notification Sent!");
      } else {
        print("Error");
      }
    } catch (e) {}
  }

  Future<List> getParentDetails() async {
    schoolName = await getSchoolName();
    print(schoolName);
    print("Already Got School Name");

    var ref = databaseReference.child("users/$schoolName/Parents");
    var snapshot = await ref.get();
    if (snapshot.exists) {
      setState(() {
        var value = snapshot.value;
        parentList = Map.from(value)
            .values
            .map((e) => Parents.fromJson(Map.from(e)))
            .toList();
      });
    } else {
      print("No Data Exists");
    }
    // storeNotificationToken(schoolName);
    return parentList;

    // databaseReference
    //     .child("users")
    //     .child("Highway Secondary School")
    //     .child("parents")
    //     .onValue
    //     .listen(
    //   (event) {
    //     if (event.snapshot.exists) {
    //       setState(
    //         () {
    //           var value = event.snapshot.value;
    //           print(value);
    //           parentList = Map.from(value)
    //               .values
    //               .map((e) => Parents.fromJson(Map.from(e)))
    //               .toList();
    //         },
    //       );
    //     } else {
    //       print("No Data Exists");
    //     }
    //   },
    // );
    // return parentList;
  }

  totalSchoolFeesToBePaid(totalFeesToBePaidToInt, parentUserUid) {
    databaseReference
        .child("users")
        .child(schoolName)
        .child("Parents")
        .child(parentUserUid)
        .update({
      "Total": totalFeesToBePaidToInt,
      "Paid": 0,
      "Balance": 0,
    });
  }

  updateSchoolFeesPayment(
      totalFees, paidFees, balanceFees, newFeesPayment, parentUid) {
    try {
      setState(() {
        // updatedItem = int.parse(updatedItem);
        print(paidFees);
        print(newFeesPayment);

        totalPaid = paidFees + newFeesPayment;
        print(totalPaid);

        totalBalance = totalFees - totalPaid;
        print(totalBalance);
      });
      try {
        databaseReference
            .child("users")
            .child(schoolName)
            .child("Parents")
            .child("$parentUid")
            .update({
          "Paid": totalPaid,
          "Balance": totalBalance,
        });
      } catch (e) {
        print("Decrement Error: ");
        print("$e");
      }
    } catch (e) {
      print("$e");
    }
    // updatedItem = 0;
  }

  @override
  void initState() {
    super.initState();
    getParentDetails();
    FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.onMessage.listen((event) {
      LocalNotificationService.display(event);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.grey[800],
        title: Text(
          "Student List",
          style: GoogleFonts.lexendMega(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
      body: parentList.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "NO STUDENTS",
                    style: GoogleFonts.lexendMega(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: parentList.length,
              itemBuilder: (context, int index) {
                final Parents parents = parentList[index];
                final String parentName = parents.name.toUpperCase();
                final String childName = parents.childName;
                final String parentUserUid = parents.parenUseruid;
                final String token = parents.token;
                // parentNotificationTOkens.add(token);
                // print(parentNotificationTOkens);
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    color: Colors.lime[800],
                    elevation: 0.2,
                    child: ExpansionTile(
                      // collapsedBackgroundColor: Colors.grey,
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
                          children: [
                            Text(
                              "Tap one of the below options to notify\n$parentName\nthat their child has either:",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.lexendMega(fontSize: 12,color: Colors.white,),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    print(token);
                                    setArrivalTime(parentUserUid);
                                    Fluttertoast.showToast(
                                      msg:
                                          "$parentName has been notified that their child has arrived at school",
                                      backgroundColor: Colors.black,
                                      gravity: ToastGravity.CENTER,
                                      textColor: Colors.white,
                                      timeInSecForIosWeb: 5,
                                      fontSize: 16,
                                    );
                                    String notifyParent =
                                        "$childName arrived at school at $arrived";
                                    sendNotifiaction("Your child has Arrived",
                                        token, notifyParent);
                                  },
                                  child: Text(
                                    "Arrived",
                                    style: GoogleFonts.lexendMega(fontSize: 12),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    SetDepartedTime(parentUserUid);
                                    Fluttertoast.showToast(
                                      msg:
                                          "$parentName has been notified that their child has left the school",
                                      backgroundColor: Colors.black,
                                      gravity: ToastGravity.CENTER,
                                      textColor: Colors.white,
                                      timeInSecForIosWeb: 5,
                                      fontSize: 16,
                                    );
                                    String notifyParent =
                                        "$childName left school at $departed";
                                    sendNotifiaction("Your child has Left",
                                        token, notifyParent);
                                  },
                                  child: Text(
                                    "Departed",
                                    style: GoogleFonts.lexendMega(fontSize: 12),
                                  ),
                                ),
                              ],
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

class Parents {
  final String email;
  final String name;
  final String phone;
  final String childName;
  final int paidSchoolFees;
  final int totalSchoolFees;
  final int balanceSchoolFees;
  final String parenUseruid;
  final String token;

  Parents({
    required this.email,
    required this.name,
    required this.phone,
    required this.childName,
    required this.paidSchoolFees,
    required this.totalSchoolFees,
    required this.balanceSchoolFees,
    required this.parenUseruid,
    required this.token,
  });

  static Parents fromJson(Map<String, dynamic> json) {
    return Parents(
      email: json['email'].toString(),
      name: json['name'].toString(),
      phone: json['phone'].toString(),
      childName: json['child'].toString(),
      totalSchoolFees: json['Total'],
      paidSchoolFees: json['Paid'],
      balanceSchoolFees: json['Balance'],
      parenUseruid: json['user uid'].toString(),
      token: json['token'].toString(),
    );
  }
}
