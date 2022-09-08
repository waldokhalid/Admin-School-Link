import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class PettyCashScreen extends StatefulWidget {
  PettyCashScreen({Key? key}) : super(key: key);
  static const String idScreen = "PettyCashScreen";

  @override
  State<PettyCashScreen> createState() => _PettyCashScreenState();
}

class _PettyCashScreenState extends State<PettyCashScreen> {
  TextEditingController item = TextEditingController();
  TextEditingController itemPrice = TextEditingController();
  TextEditingController weekNumber = TextEditingController();
  TextEditingController mPesaMessage = TextEditingController();

  final databaseReference = FirebaseDatabase.instance.reference();
  FirebaseAuth auth = FirebaseAuth.instance;

  late String adminUID;
  late String schoolName;
  late String schlName;
  late String formattedDate;

  String? selectVal;

  List<PettyCash> pettycashRecord = [];

  String validateBeforeSubmit() {
    if (item.text.isEmpty ||
        itemPrice.text.isEmpty ||
        mPesaMessage.text.isEmpty ||
        selectVal == null
        ) {
      return "empty";
    } else {
      return "not empty";
    }
  }

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

  updatePettyCashInDB(selectVal) async {
    schoolName = await getSchoolName();
    try {
      await databaseReference
          .child("users")
          .child("$schoolName")
          .child("Petty Cash")
          .child("Week $selectVal")
          .child(item.text.trim())
          .update({
        "item": item.text.trim(),
        "itemPrice": itemPrice.text.trim(),
        "mpesaMessage": mPesaMessage.text.trim(),
      });
    } catch (e) {
      print("$e");
    }
  }

  // getPettyCashRecords() async{
  //   schoolName = await getSchoolName();
  //   try {
  //     var ref = databaseReference
  //         .child("users")
  //         .child(schoolName)
  //         .child("Petty Cash");
  //     var snapshot = await ref.get();
  //     if (snapshot.exists) {
  //       // print(snapshot.exists);
  //       // print(snapshot.value);
  //       setState(() {
  //         // var value = snapshot.value;
  //         pettycashRecord = Map.from(snapshot.value)
  //             .values
  //             .map(
  //               (e) => PettyCash.fromJson(
  //             Map.from(e),
  //           ),
  //         )
  //             .toList();
  //         // print(announcementList.length);
  //       });
  //     } else {
  //       print("No Data Exists");
  //     }
  //     return pettycashRecord;
  //   } catch (e) {
  //     print("$e");
  //   }
  //   return pettycashRecord;
  // }

  void dropDownCallBak(selectedValue) {
    setState(() {
      selectVal = selectedValue;
    });
    print(selectVal);
    // updatePettyCashInDB(selectVal);
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
          "Update Petty Cash Records",
          style: GoogleFonts.lexendMega(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Center(
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
                padding: const EdgeInsets.all(15),
                child: TextField(
                  controller: item,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    enabledBorder: const OutlineInputBorder(),
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                        style: BorderStyle.solid,
                        width: 2,
                      ),
                    ),
                    label: Text(
                      "Item Name",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lexendMega(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                  style: GoogleFonts.lexendMega(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: TextField(
                  controller: itemPrice,
                  keyboardType: TextInputType.number,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    enabledBorder: const OutlineInputBorder(),
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                        style: BorderStyle.solid,
                        width: 2,
                      ),
                    ),
                    label: Text(
                      "Item Price",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lexendMega(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                  style: GoogleFonts.lexendMega(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: TextField(
                  controller: mPesaMessage,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    enabledBorder: const OutlineInputBorder(),
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                        style: BorderStyle.solid,
                        width: 2,
                      ),
                    ),
                    label: Text(
                      "Paste Mpesa Message",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lexendMega(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                  style: GoogleFonts.lexendMega(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: ElevatedButton(
                  onPressed: () {
                    String validator = validateBeforeSubmit();
      
                    if (validator != "empty") {
                      Fluttertoast.showToast(
                        msg: "Please Wait..",
                        gravity: ToastGravity.CENTER,
                        backgroundColor: Colors.black,
                      );
                      updatePettyCashInDB(selectVal);
                      Fluttertoast.showToast(
                        msg: "Petty Cash Updated!",
                        gravity: ToastGravity.CENTER,
                        backgroundColor: Colors.black,
                      );
                    } else {
                      Fluttertoast.showToast(
                        msg:
                            "Please fill announcement Title and Anouncement body before sending.",
                        gravity: ToastGravity.CENTER,
                        backgroundColor: Colors.black,
                        timeInSecForIosWeb: 7,
                      );
                    }
      
                    // loopThroughNotificationTokensToSendNotificaitons();
                  },
                  child: Text(
                    "Send",
                    style: GoogleFonts.lexendMega(
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PettyCash {
  final String item;
  final int itemPrice;
  final String mpesaMessage;

  PettyCash({
    required this.item,
    required this.itemPrice,
    required this.mpesaMessage,
  });

  static PettyCash fromJson(Map<dynamic, dynamic> json) {
    return PettyCash(
      item: json['title'].toString(),
      itemPrice: json['body'],
      mpesaMessage: json['date'].toString(),
    );
  }
}
