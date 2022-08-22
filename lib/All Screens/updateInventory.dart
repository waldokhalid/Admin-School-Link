import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class UpdateInventory extends StatefulWidget {
  const UpdateInventory({key}) : super(key: key);
  static const String idScreen = "UpdateInventory";

  @override
  State<UpdateInventory> createState() => _UpdateInventoryState();
}

class _UpdateInventoryState extends State<UpdateInventory> {
  TextEditingController itemAmount = TextEditingController();
  TextEditingController items = TextEditingController();

  final databaseReference = FirebaseDatabase.instance.reference();
  FirebaseAuth auth = FirebaseAuth.instance;

  late int itemAmmountToInt;

  late String schlName;
  late String schoolName;

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

  void updateInventory() async {
    schoolName = await getSchoolName();

    print(schoolName);

    print("Inside getUserUID");

    setState(() {
      itemAmmountToInt = int.parse(itemAmount.text.trim());
      // print("$itemAmmountToInt: $itemAmmountToInt.runtimeType");
    });

    // User user = auth.currentUser;
    // final driverUID = user.uid.toString();
    try {
      await databaseReference
          .child("users")
          .child("$schoolName")
          .child("Inventory")
          .child(items.text.trim())
          .update({
        "Item": items.text.trim(),
        "Item Amount": itemAmmountToInt,
      });
    } catch (e) {
      print("$e");
    }
    print("Items Updated!");
  }

  String validateBeforeSubmit() {
    if (items.text.isEmpty || itemAmount.text.isEmpty) {
      return "empty";
    } else {
      return "not empty";
    }
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
          "Add or Update Inventory List",
          style: GoogleFonts.lexendMega(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: items,
                keyboardType: TextInputType.text,
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
                    "Enter Item Name",
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
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: itemAmount,
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
                    "Enter Item Amount",
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
            ElevatedButton(
              onPressed: () {
                String validator = validateBeforeSubmit();

                if (validator != "empty") {
                  updateInventory();
                  Fluttertoast.showToast(
                    msg: "New Item added to inventory",
                    gravity: ToastGravity.CENTER,
                    backgroundColor: Colors.black,
                    timeInSecForIosWeb: 3,
                  );
                } else {
                  Fluttertoast.showToast(
                    msg: "Please fill the required information before submitting to inventory.",
                    gravity: ToastGravity.CENTER,
                    backgroundColor: Colors.black,
                    timeInSecForIosWeb: 3,
                  );
                }

                // updateInventory();
                // itemAmount.clear();
                // items.clear();
              },
              child: Text(
                "Update Inventory",
                style: GoogleFonts.lexendMega(
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
