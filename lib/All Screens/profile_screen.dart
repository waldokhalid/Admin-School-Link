// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// // Users will be basle to see details about themselves that we store.
// // By default the details are not visible, up a press of a button,
// // they appear. On anoother press, the dissapear.

// class ProfileScreen extends StatefulWidget {
//   static const String idScreen = "ProfileScreen";

//   @override
//   _ProfileScreenState createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   String randomUserUid = "---";

//   String adminUID;

//   String name = "    ";

//   String phone = "    ";

//   String email = "    ";

//   String schoolName = "     ";

//   final FirebaseAuth auth = FirebaseAuth.instance;

//   final databaseReference = FirebaseDatabase.instance.reference();

//   Future<dynamic> getInfo(adminUID) async {
//     // This method grabs Admin details
//     // final x = await getParentUID();
//     databaseReference.child("users").child("admin").child(adminUID).once().then(
//       (DataSnapshot snapshot) {
//         randomUserUid = snapshot.value.toString();
//         setState(
//           () {
//             name = snapshot.value["name"];
//             email = snapshot.value["email"];
//             phone = snapshot.value["phone"];
//             schoolName = snapshot.value["school"];
//           },
//         );
//       },
//     );
//   }

//   Future<String> getUID() async {
//     // This method returns the current logged in users UID
//     // ignore: unused_local_variable
//     final ref = FirebaseDatabase.instance.reference();
//     User user = auth.currentUser;
//     adminUID = user.uid.toString();
//     print(adminUID);
//     await Future.delayed(
//       Duration(milliseconds: 200),
//     );
//     getInfo(adminUID);
//     return adminUID;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: IconThemeData(color: Colors.black),
//         backgroundColor: Colors.white,
//         centerTitle: true,
//         elevation: 0,
//         title: Text(
//           "School Link",
//           style: GoogleFonts.lexendMega(
//             color: Colors.black,
//             fontSize: 16,
//           ),
//         ),
//       ),
//       body: Container(
//         color: Colors.white,
//         child: Center(
//           child: SingleChildScrollView(
//             scrollDirection: Axis.vertical,
//             child: Column(
//               children: [
//                 SizedBox(
//                   height: 50,
//                 ),
//                 Text(
//                   "Your Profile Data",
//                   style: GoogleFonts.lexendMega(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 16,
//                     color: Colors.black,
//                   ),
//                 ),
//                 SizedBox(
//                   height: 50,
//                 ),
//                 Text(
//                   "$name",
//                   style: GoogleFonts.lexendMega(
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black,
//                     fontSize: 12,
//                   ),
//                 ),
//                 SizedBox(
//                   height: 15,
//                 ),
//                 Text(
//                   "$schoolName",
//                   style: GoogleFonts.lexendMega(
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black,
//                     fontSize: 12,
//                   ),
//                 ),
//                 SizedBox(
//                   height: 15,
//                 ),
//                 Text(
//                   "$phone",
//                   style: GoogleFonts.lexendMega(
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black,
//                     fontSize: 12,
//                   ),
//                 ),
//                 SizedBox(
//                   height: 15,
//                 ),
//                 Text(
//                   "$email",
//                   style: GoogleFonts.lexendMega(
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black,
//                     fontSize: 12,
//                   ),
//                 ),
//                 SizedBox(
//                   height: 45,
//                 ),
//                 ElevatedButton(
//                   onPressed: () {
//                     print(schoolName);
//                     getUID();
//                   },
//                   child: Text(
//                     "Show Info",
//                   ),
//                   style: TextButton.styleFrom(
//                     backgroundColor: Colors.tealAccent[400],
//                     primary: Colors.black,
                    
//                   ),
//                 ),
//                 SizedBox(
//                   height: 15,
//                 ),
//                 ElevatedButton(
//                   onPressed: () {
//                     setState(
//                       () {
//                         randomUserUid = "     ";
//                         email = "     ";
//                         name = "     ";
//                         phone = "     ";
//                         schoolName = "     ";
//                       },
//                     );
//                   },
//                   child: Text(
//                     "Hide Info",
//                   ),
//                   style: TextButton.styleFrom(
//                     backgroundColor: Colors.tealAccent[400],
//                     primary: Colors.black,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
