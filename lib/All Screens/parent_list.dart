import 'package:admin_school_link/All%20Screens/announcement_Screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class ParentsList extends StatefulWidget {
  const ParentsList({key}) : super(key: key);
  static const String idScreen = "ParentsListScreen";

  @override
  State<ParentsList> createState() => _ParentsListState();
}

class _ParentsListState extends State<ParentsList> {
  TextEditingController feesPaymentUpdate = TextEditingController();
  TextEditingController totalFeesToBePaid = TextEditingController();
  final databaseReference = FirebaseDatabase.instance.reference();
  FirebaseAuth auth = FirebaseAuth.instance;
  // ignore: unused_field
  static var driverRandomId;
  List<Parents> parentList = [];

  late int totalFeesToBePaidToInt;
  late int updatedItemAmountToInt;
  late int totalPaid;
  late int totalBalance;

  late String schlName;
  late String schoolName;

  late String loading;

  int acumulativeTotalSchoolFees = 0;

  List<String> parentNotificationTOkens = [];

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

  int calculateTotalPaidSchoolFees(totalPaidFees) {
    setState(() {
      acumulativeTotalSchoolFees += int.parse(totalPaidFees);
    });
    return acumulativeTotalSchoolFees;
  }

  Future<List> getParentDetails() async {
    schoolName = await getSchoolName();
    print(schoolName);
    print("Already Got School Name");

    var ref = databaseReference.child("users/$schoolName/Parents");
    var snapshot = await ref.get();
    if (snapshot.exists) {
      // print(snapshot.value[0]);
      setState(() {
        var value = snapshot.value;
        parentList = Map.from(value)
            .values
            .map((e) => Parents.fromJson(Map.from(e)))
            .toList();
      });
      loading = "loading Data";
    } else {
      print("No Data Exists");
    }
    return parentList;
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
      total_fees, paid_fees, balance_fees, new_fees_payment, parent_uid) {
    try {
      setState(() {
        // updatedItem = int.parse(updatedItem);
        print(paid_fees);
        print(new_fees_payment);

        totalPaid = paid_fees + new_fees_payment;
        print(totalPaid);

        totalBalance = total_fees - totalPaid;
        print(totalBalance);
      });
      try {
        databaseReference
            .child("users")
            .child(schoolName)
            .child("Parents")
            .child("$parent_uid")
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

  resetSchoolFees(parent_uid) {
    print(schoolName);
    print(parent_uid);
    try {
      databaseReference
          .child("users")
          .child(schoolName)
          .child("Parents")
          .child("$parent_uid")
          .update({
        "Paid": 0,
        "Balance": 0,
        // "Total": 0,
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getParentDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(10),
        child: FloatingActionButton(
          backgroundColor: Colors.blueAccent,
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => AnnouncmentScreen(),
                settings: RouteSettings(
                  arguments: parentNotificationTOkens,
                ),
              ),
            );
          },
          child: Icon(
            Icons.message_outlined,
            color: Colors.white,
            size: 30,
          ),
        ),
      ),
      backgroundColor: Colors.grey[800],
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.grey[800],
        title: Text(
          "Parent List",
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
                    "NO PARENTS",
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
                  // SizedBox(
                  //   height: 15,
                  // ),
                  // Text(
                  //   "Total Fees Paid: $acumulativeTotalSchoolFees",
                  //   style: GoogleFonts.lexendMega(
                  //     fontSize: 14,
                  //     color: Colors.black,
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: 8,
                  // ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: parentList.length,
                    itemBuilder: (context, int index) {
                      final Parents parents = parentList[index];
                      final String driverEmail = parents.email;
                      final String driverName = parents.name;
                      final String driverPhone = parents.phone;
                      final String childName = parents.childName;
                      final totalSchoolFees = parents.totalSchoolFees;
                      final paidSchoolFees = parents.paidSchoolFees;
                      final balanceSchoolFees = parents.balanceSchoolFees;
                      // ignore: unused_local_variable
                      final String parentUserUid = parents.parenUseruid;
                      // calculateTotalPaidSchoolFees(totalSchoolFees);
                      final String notifiacationToken = parents.token;
                      if (notifiacationToken != "No Token") {
                        parentNotificationTOkens.add(notifiacationToken);
                      }
                      // print(parentNotificationTOkens);
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          color: Colors.green,
                          elevation: 0.2,
                          child: ExpansionTile(
                            // collapsedBackgroundColor: Colors.grey,
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
                              SingleChildScrollView(
                                physics: ScrollPhysics(),
                                child: Column(
                                  children: [
                                    Text(
                                      "Child Name: $childName",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.lexendMega(
                                        fontSize: 12,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      driverEmail,
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.lexendMega(
                                        fontSize: 12,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      driverPhone,
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.lexendMega(
                                        fontSize: 12,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      "Total School Fees: $totalSchoolFees",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.lexendMega(
                                        fontSize: 12,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "Paid School Fees: $paidSchoolFees",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.lexendMega(
                                        fontSize: 12,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "Balance School Fees: $balanceSchoolFees",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.lexendMega(
                                        fontSize: 12,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          right: 50, left: 50),
                                      child: TextField(
                                        controller: feesPaymentUpdate,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          enabledBorder: OutlineInputBorder(),
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.black,
                                              style: BorderStyle.solid,
                                              width: 2,
                                            ),
                                          ),
                                          label: Text(
                                            "Enter Paid Fees",
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.lexendMega(
                                              fontSize: 12,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        style: GoogleFonts.lexendMega(
                                          fontSize: 12,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            setState(() {
                                              updatedItemAmountToInt = int.parse(
                                                  feesPaymentUpdate.text);
                                            });
                                            updateSchoolFeesPayment(
                                              totalSchoolFees,
                                              paidSchoolFees,
                                              balanceSchoolFees,
                                              updatedItemAmountToInt,
                                              parentUserUid,
                                            );
                                            feesPaymentUpdate.clear();
                                            getParentDetails();
                                            Fluttertoast.showToast(
                                              msg:
                                                  "Total paid fees has been updated.\n$driverName will be able to see the update on their app.",
                                              backgroundColor: Colors.black,
                                              gravity: ToastGravity.CENTER,
                                              textColor: Colors.white,
                                              timeInSecForIosWeb: 5,
                                              fontSize: 16,
                                            );
                                          },
                                          child: Text(
                                            "Add",
                                            style: GoogleFonts.lexendMega(
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            resetSchoolFees(parentUserUid);
                                            Fluttertoast.showToast(
                                              msg: "School Fees for $driverName has been Reset",
                                              backgroundColor: Colors.black,
                                              gravity: ToastGravity.CENTER,
                                              textColor: Colors.white,
                                              timeInSecForIosWeb: 4,
                                            );
                                          },
                                          child: Text(
                                            "Reset",
                                            style: GoogleFonts.lexendMega(
                                                fontSize: 12),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 20),
                                    totalSchoolFees == 0
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                right: 50, left: 50),
                                            child: TextField(
                                              controller: totalFeesToBePaid,
                                              keyboardType: TextInputType.number,
                                              decoration: InputDecoration(
                                                enabledBorder:
                                                    OutlineInputBorder(),
                                                border: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Colors.black,
                                                    style: BorderStyle.solid,
                                                    width: 2,
                                                  ),
                                                ),
                                                label: Text(
                                                  "Enter TOTAL School Fees",
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.lexendMega(
                                                    fontSize: 12,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                              style: GoogleFonts.lexendMega(
                                                fontSize: 12,
                                                color: Colors.white,
                                              ),
                                            ),
                                          )
                                        : SizedBox(
                                            height: 0,
                                          ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    totalSchoolFees == 0
                                        ? ElevatedButton(
                                            onPressed: () {
                                              setState(() {
                                                totalFeesToBePaidToInt =
                                                    int.parse(
                                                        totalFeesToBePaid.text);
                                              });
                                              totalSchoolFeesToBePaid(
                                                  totalFeesToBePaidToInt,
                                                  parentUserUid);
                                              totalFeesToBePaid.clear();
                              
                                              getParentDetails();
                                              Fluttertoast.showToast(
                                                msg:
                                                    "TOTAL amount of school fees the parent needs to pay has been updated!",
                                                backgroundColor: Colors.black,
                                                gravity: ToastGravity.CENTER,
                                                textColor: Colors.white,
                                                timeInSecForIosWeb: 5,
                                                fontSize: 16,
                                              );
                                            },
                                            child: Text(
                                              "Submit",
                                              style: GoogleFonts.lexendMega(
                                                fontSize: 12,
                                              ),
                                            ),
                                          )
                                        : SizedBox(
                                            height: 0,
                                          ),
                                  ],
                                ),
                              )
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

class Parents {
  final String name;
  final String token;
  final String email;
  final String phone;
  final String childName;
  final int paidSchoolFees;
  final int totalSchoolFees;
  final String parenUseruid;
  final int balanceSchoolFees;

  Parents({
    required this.name,
    required this.token,
    required this.email,
    required this.phone,
    required this.childName,
    required this.parenUseruid,
    required this.paidSchoolFees,
    required this.totalSchoolFees,
    required this.balanceSchoolFees,
  });

  static Parents fromJson(Map<String, dynamic> json) {
    return Parents(
      name: json['name'],
      token: json["token"],
      email: json['email'],
      phone: json['phone'],
      childName: json['child'],
      paidSchoolFees: json['Paid'],
      totalSchoolFees: json['Total'],
      parenUseruid: json['user uid'],
      balanceSchoolFees: json['Balance'],
    );
  }
}
