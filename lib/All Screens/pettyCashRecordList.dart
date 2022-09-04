import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
          print(formattedDate);
        }
      },
    );
    return formattedDate;
  }

  getPettyCashRecords() async {
    schoolName = await getSchoolName();
    try {
      var ref = databaseReference
          .child("users")
          .child(schoolName)
          .child("Petty Cash");
      var snapshot = await ref.get();
      if (snapshot.exists) {
        List termWeekNum = [];

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
          // print(announcementList.length);
        });
      } else {
        print("No Data Exists");
      }
      return pettycashRecord;
    } catch (e) {
      print("$e");
    }

    return pettycashRecord;
  }

  @override
  void initState() {
    super.initState();
    getUID();
    getPettyCashRecords();
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
          "Petty Cash",
          style: GoogleFonts.lexendMega(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
      body: Center(
          child: Column(
        children: [

          Divider(),
          if (pettycashRecord.isEmpty)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "INVENTORY IS EMPTY",
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
                  final int itemPrice = records.itemPrice;
                  final String week = records.week;

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      color: Colors.orange[800],
                      elevation: 0.2,
                      child: ExpansionTile(
                        // collapsedBackgroundColor: Colors.grey,
                        title: Text(
                          "$item + $itemPrice",
                          style: GoogleFonts.lexendMega(
                            fontSize: 12,
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
                                  fontSize: 16,
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
      )),
    );
  }
}

class PettyCash {
  final String item;
  final int itemPrice;
  final String mpesaMessage;
  final String week;

  PettyCash({
    required this.item,
    required this.itemPrice,
    required this.mpesaMessage,
    required this.week
  });

  static PettyCash fromJson(Map<dynamic, dynamic> json) {
    return PettyCash(
      item: json['title'].toString(),
      itemPrice: json['body'],
      mpesaMessage: json['date'].toString(),
      week: json['week'].toString(),
    );
  }
}
