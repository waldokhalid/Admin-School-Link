import 'package:admin_school_link/All%20Screens/updateInventory.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({key}) : super(key: key);
  static const String idScreen = "InventoryScreen";

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  TextEditingController updatedItemAmount = TextEditingController();

  final databaseReference = FirebaseDatabase.instance.reference();
  FirebaseAuth auth = FirebaseAuth.instance;

  List<Map<String, dynamic>> files = [];

  List<Driver> driverList = [];
  late String schlName;
  late String schoolName;
  late String schlNameUpperCae;

  late int newAmount;
  late int updatedItemAmountToInt;

  itemPositiveIncrement(item, itemAmount, updatedItem) {
    setState(() {
      // updatedItem = int.parse(updatedItem);
      newAmount = itemAmount + updatedItem;
    });
    try {
      databaseReference
          .child("users")
          .child(schoolName)
          .child("Inventory")
          .child("$item")
          .update({
        "Item Amount": newAmount,
      });
    } catch (e) {
      print("Increment Error: $e");
    }
    updatedItem = 0;
  }

  ItemNegativeIncrement(item, itemAmount, updatedItem) {
    setState(() {
      // updatedItem = int.parse(updatedItem);
      newAmount = itemAmount - updatedItem;
    });

    try {
      databaseReference
          .child("users")
          .child(schoolName)
          .child("Inventory")
          .child("$item")
          .update({
        "Item Amount": newAmount,
      });
    } catch (e) {
      print("Decrement Error: $e");
    }
    updatedItem = 0;
  }

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

  String validateBeforeSubmit() {
    if (updatedItemAmount.text.isEmpty) {
      return "empty";
    } else {
      return "not empty";
    }
  }

  Future<List> getDriverDetails() async {
    schoolName = await getSchoolName();
    print("Getting details!!");
    try {
      var ref = databaseReference
          .child("users")
          .child("$schoolName")
          .child("Inventory");
      var snapshot = await ref.get();
      if (snapshot.exists) {
        print(snapshot.exists);
        setState(() {
          // var value = snapshot.value;
          driverList = Map.from(snapshot.value)
              .values
              .map(
                (e) => Driver.fromJson(
                  Map.from(e),
                ),
              )
              .toList();
          print(driverList.length);
        });
      } else {
        print("No Data Exists");
      }
      return driverList;
    } catch (e) {
      print("$e");
    }
    return driverList;
  }

  @override
  void initState() {
    super.initState();
    getDriverDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(10),
        child: FloatingActionButton(
          backgroundColor: Colors.blueAccent,
          onPressed: () {
            Navigator.pushNamed(
              context,
              UpdateInventory.idScreen,
            );
          },
          child: Icon(
            Icons.add_rounded,
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
          "NO INVENTORY",
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
                    "INVENTORY IS EMPTY",
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
                final String items = driver.items;
                final int itemAmount = driver.itemAmount;
                // final String driverPhone = driver.phone;
                // final driverRandomId = driver.randomId;
                // final String driverUID = driver.uid;
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    color: Colors.brown,
                    elevation: 0.2,
                    child: ExpansionTile(
                      // collapsedBackgroundColor: Colors.grey,
                      title: Text(
                        items.toUpperCase(),
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
                              "Number of $items: $itemAmount",
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
                              padding:
                                  const EdgeInsets.only(right: 50, left: 50),
                              child: TextField(
                                controller: updatedItemAmount,
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
                                    "Update amount of $items",
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
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    String validator = validateBeforeSubmit();
                                    if(validator != "empty"){
                                      setState(() {
                                      updatedItemAmountToInt =
                                          int.parse(updatedItemAmount.text);
                                    });
                                    itemPositiveIncrement(items, itemAmount,
                                        updatedItemAmountToInt);
                                    updatedItemAmount.clear();
                                    getDriverDetails();
                                    Fluttertoast.showToast(
                                      msg:
                                          "Number of $items has been updated in the inventory.",
                                      backgroundColor: Colors.black,
                                      gravity: ToastGravity.CENTER,
                                      textColor: Colors.white,
                                      timeInSecForIosWeb: 5,
                                      fontSize: 16,
                                    );
                                    }else{
                                      Fluttertoast.showToast(
                                      msg:
                                          "Please enter the amount to be added.",
                                      backgroundColor: Colors.black,
                                      gravity: ToastGravity.CENTER,
                                      textColor: Colors.white,
                                      timeInSecForIosWeb: 5,
                                      fontSize: 16,
                                    );
                                    }

                                    
                                  },
                                  child: Text("Add"),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    String validator = validateBeforeSubmit();
                                    if (validator != "empty") {
                                      setState(() {
                                      updatedItemAmountToInt =
                                          int.parse(updatedItemAmount.text);
                                    });
                                    ItemNegativeIncrement(items, itemAmount,
                                        updatedItemAmountToInt);
                                    updatedItemAmount.clear();
                                    getDriverDetails();
                                    Fluttertoast.showToast(
                                      msg:
                                          "Number of $items has been updated in the inventory.",
                                      backgroundColor: Colors.black,
                                      gravity: ToastGravity.CENTER,
                                      textColor: Colors.white,
                                      timeInSecForIosWeb: 5,
                                      fontSize: 16,
                                    );
                                    } else {
                                      Fluttertoast.showToast(
                                      msg:
                                          "Please enter the amount to be subtracted.",
                                      backgroundColor: Colors.black,
                                      gravity: ToastGravity.CENTER,
                                      textColor: Colors.white,
                                      timeInSecForIosWeb: 5,
                                      fontSize: 16,
                                    );
                                    }
                                    
                                  },
                                  child: Text("Subtract"),
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

class Driver {
  final String items;
  final int itemAmount;

  Driver({
    required this.items,
    required this.itemAmount,
  });

  static Driver fromJson(Map<String, dynamic> json) {
    return Driver(
      items: json['Item'].toString(),
      itemAmount: json['Item Amount'],
    );
  }
}

// class Driver {
//   final String email;
//   final String name;
//   final String phone;
//   final String randomId;
//   final String uid;

//   Driver({
//     this.email,
//     this.name,
//     this.phone,
//     this.randomId,
//     this.uid,
//   });

//   static Driver fromJson(Map<String, dynamic> json) {
//     return Driver(
//       email: json['email'],
//       name: json['name'],
//       phone: json['phone'],
//       randomId: json['random id'],
//       uid: json['user uid'],
//     );
//   }
// }
