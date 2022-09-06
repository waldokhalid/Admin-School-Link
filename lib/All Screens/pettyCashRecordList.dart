import 'package:admin_school_link/All%20Screens/pettCash.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:route_transitions/route_transitions.dart';

class PettyCashRecordList extends StatefulWidget {
  PettyCashRecordList({Key? key}) : super(key: key);
  static const String idScreen = "PettyCashRecordList";

  @override
  State<PettyCashRecordList> createState() => _PettyCashRecordListState();
}

class _PettyCashRecordListState extends State<PettyCashRecordList> {
  final databaseReference = FirebaseDatabase.instance.reference();
  FirebaseAuth auth = FirebaseAuth.instance;

  late String adminUID;
  late String schoolName;
  late String schlName;
  late String formattedDate;

  int totalAmount = 0;

  String? selectVal;

  List<PettyCash> pettycashRecord = [];

  Future<String> getUID() async {
    // This method returns the current logged in users UID
    // ignore: unused_local_variable
    // final ref = FirebaseDatabase.instance.reference();
    User? user = auth.currentUser;
    adminUID = user!.uid.toString();

    await Future.delayed(
      const Duration(milliseconds: 200),
    );
    getInfo(adminUID);
    return adminUID;
  }

  Future<dynamic> getInfo(adminUID) async {
    databaseReference.child("users").child("Admin").child(adminUID).once().then(
      (snapshot) async {
        setState(() {
          schoolName = snapshot.value["school"];
          // print(schoolName);
        });
      },
    );
  }

  getSchoolName() async {
    // ignore: unused_local_variable
    // final ref = FirebaseDatabase.instance.reference();
    User? user = auth.currentUser;
    String adminUID = user!.uid.toString();
    // print("Getting School Name");
    // ignore: unused_local_variable
    var myRef = databaseReference.child("users").child("Admin").child(adminUID);
    var snapshot = await myRef.get();
    if (snapshot.exists) {
      // var value = snapshot.value;
      setState(() {
        schlName = snapshot.value["school"];
      });
      // print(schlName);
    } else {
      if (kDebugMode) {
        print("No Data Exists");
      }
    }
    return schlName;
  }

  String getMonthAndWWeek() {
    setState(
      () {
        var now = DateTime.now().toString();
        var date = DateTime.parse(now);
        formattedDate = "${date.day}-${date.month}-${date.year}";
        if (kDebugMode) {
          // print(formattedDate);
        }
      },
    );
    return formattedDate;
  }

  Future<List> getPettyCashRecords(selectVal) async {
    schoolName = await getSchoolName();
    // print("Getting Petty Cash Records");
    try {
      var ref = databaseReference
          .child("users")
          .child(schoolName)
          .child("Petty Cash")
          .child("Week $selectVal");
      var snapshot = await ref.get();
      if (snapshot.exists) {
        // print("Gotten Snapshot");
        // print(snapshot.exists);
        // print(snapshot.value);
        setState(() {
          // var value = snapshot.value;
          pettycashRecord = Map.from(snapshot.value)
              .values
              .map(
                (e) => PettyCash.fromJson(
                  Map.from(e),
                ),
              )
              .toList();
          // print("Gotten Petty Cash Records");
        });
      } else {
        print("No Data Exists");
      }
      return pettycashRecord;
    } catch (e) {
      print("Error: $e");
    }

    return pettycashRecord;
  }

  void dropDownCallBak(selectedValue) {
    setState(() {
      selectVal = selectedValue;
    });
    getPettyCashRecords(selectVal);
  }

  // calculateTotalAmount(itemPrice) {
  //   print("Total: $totalAmount");
  //   print("Item Prices: $itemPrice");

  //   totalAmount = totalAmount + int.parse(itemPrice);

  //   print(totalAmount);
  // }

  @override
  void initState() {
    super.initState();
    getUID();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(10),
        child: FloatingActionButton(
          backgroundColor: Colors.blueAccent,
          onPressed: () {
            slideLeftWidget(newPage: PettyCashScreen(), context: context);
          },
          child: Icon(
            Icons.add_box_outlined,
            color: Colors.white,
            size: 30,
          ),
        ),
      ),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.grey[800],
        title: Text(
          "Petty Cash",
          style: GoogleFonts.lexendMega(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
      body: Center(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "Select Week -",
                  style: GoogleFonts.lexendMega(
                    fontSize: 16,
                    color: Colors.grey[200],
                  ),
                ),
                Container(
                  // width: (MediaQuery.of(context).size.width) / 3,
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
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
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      dropdownColor: Colors.grey[600],
                      icon: Icon(Icons.arrow_drop_down_circle_outlined),
                      iconSize: 20,
                      iconEnabledColor: Colors.blue,
                      value: selectVal,
                      items: const [
                        DropdownMenuItem(
                          child: Text("1"),
                          value: "1",
                        ),
                        DropdownMenuItem(
                          child: Text("2"),
                          value: "2",
                        ),
                        DropdownMenuItem(
                          child: Text("3"),
                          value: "3",
                        ),
                        DropdownMenuItem(
                          child: Text("4"),
                          value: "4",
                        ),
                        DropdownMenuItem(
                          child: Text("5"),
                          value: "5",
                        ),
                        DropdownMenuItem(
                          child: Text("6"),
                          value: "6",
                        ),
                        DropdownMenuItem(
                          child: Text("7"),
                          value: "7",
                        ),
                        DropdownMenuItem(
                          child: Text("8"),
                          value: "8",
                        ),
                        DropdownMenuItem(
                          child: Text("9"),
                          value: "9",
                        ),
                        DropdownMenuItem(
                          child: Text("10"),
                          value: "10",
                        ),
                        DropdownMenuItem(
                          child: Text("11"),
                          value: "11",
                        ),
                        DropdownMenuItem(
                          child: Text("12"),
                          value: "12",
                        ),
                      ],
                      onChanged: dropDownCallBak,
                      style: GoogleFonts.lexendMega(
                        fontSize: 20,
                        color: Colors.grey[200],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Divider(
                color: Colors.grey[200],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Amount Used: KSH $totalAmount",
                style: GoogleFonts.lexendMega(
                    fontSize: 16, color: Colors.grey[200]),
              ),
            ),
            if (pettycashRecord.isEmpty)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "No Records. Please select a week to get records.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lexendMega(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              )
            else
              Flexible(
                child: ListView.builder(
                  itemCount: pettycashRecord.length,
                  itemBuilder: (context, int index) {
                    final PettyCash records = pettycashRecord[index];
                    final String item = records.item;
                    final String mpesaMessage = records.mpesaMessage;
                    final String itemPrice = records.itemPrice;

                    // calculateTotalAmount(itemPrice);

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        color: Colors.orange[800],
                        elevation: 0.2,
                        child: ExpansionTile(
                          // collapsedBackgroundColor: Colors.grey,
                          title: Text(
                            "$item - KSH $itemPrice",
                            style: GoogleFonts.lexendMega(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          children: [
                            Column(
                              children: [
                                Text(
                                  mpesaMessage,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.lexendMega(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      )),
    );
  }

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: GoogleFonts.lexendMega(
            fontSize: 12,
            color: Colors.grey[200],
          ),
        ),
      );
}

class PettyCash {
  final String item;
  final String itemPrice;
  final String mpesaMessage;

  PettyCash({
    required this.item,
    required this.itemPrice,
    required this.mpesaMessage,
  });

  static PettyCash fromJson(Map<String, dynamic> json) {
    return PettyCash(
      item: json['item'].toString(),
      itemPrice: json['itemPrice'].toString(),
      mpesaMessage: json['mpesaMessage'].toString(),
    );
  }
}
