// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:random_string/random_string.dart';
// import 'package:firebase_database/firebase_database.dart';

// // In this class, we accept feedback from our users. Both Parents and Drivers.

// // ignore: must_be_immutable
// class FeedbackScreen extends StatelessWidget {
//   static const String idScreen = "FeedBackScreen";
//   final databaseReference = FirebaseDatabase.instance.reference();
//   FirebaseAuth auth = FirebaseAuth.instance;
//   final feedbackID = randomNumeric(2);
//   String comments;
//   String signature;
//   final fieldTextFeedback = TextEditingController();
//   final fieldTextSignature = TextEditingController();

//   void submitFeedback() {
//     // ignore: unused_local_variable
//     User user = auth.currentUser;

//     databaseReference
//         .child("users")
//         .child("User Feedback")
//         .child(feedbackID)
//         .set(
//       {
//         "Name": signature,
//         "feedback": comments,
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//     iconTheme: IconThemeData(color: Colors.black),
//         backgroundColor: Colors.white,
//         centerTitle: true,
//         elevation: 0,
//         title: Text(
//           "School Link",
//           style: GoogleFonts.lexendMega(
//             color: Colors.black,
//           ),
//         ),
//       ),
//       body: Container(
//         color: Colors.white,
//         child: Padding(
//           padding: const EdgeInsets.all(12.0),
//           child: Center(
//             child: SingleChildScrollView(
//               scrollDirection: Axis.vertical,
//               child: Column(
//                 children: [
//                   SizedBox(
//                     height: 50,
//                   ),
//                   Text(
//                     "Leave us feedback",
//                     style: GoogleFonts.lexendMega(
//                       color: Colors.black,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 30,
//                     ),
//                   ),
//                   SizedBox(
//                     height: 50,
//                   ),
//                   TextField(
//                     onChanged: (val) {
//                       comments = val;
//                     },
//                     maxLines: 5,
//                     controller: fieldTextFeedback,
//                     keyboardType: TextInputType.text,
//                     decoration: InputDecoration(
//                       border: OutlineInputBorder(
//                         borderSide: BorderSide(
//                           color: Colors.black,
//                           style: BorderStyle.solid,
//                           width: 1,
//                         ),
//                       ),
//                       labelText: "Enter Feedback",
//                       labelStyle: TextStyle(
//                         fontSize: 14,
//                         color: Colors.black,
//                       ),
//                       hintStyle: GoogleFonts.lexendMega(
//                         color: Colors.grey,
//                         fontSize: 10,
//                       ),
//                     ),
//                     style: GoogleFonts.lexendMega(
//                       fontSize: 14,
//                       color: Colors.black,
//                     ),
//                   ),
//                   SizedBox(
//                     height: 20,
//                   ),
//                   TextField(
//                     onChanged: (val) {
//                       signature = val;
//                     },
//                     controller: fieldTextSignature,
//                     keyboardType: TextInputType.text,
//                     decoration: InputDecoration(
//                       border: OutlineInputBorder(
//                         borderSide: BorderSide(
//                             color: Colors.black,
//                             style: BorderStyle.solid,
//                             width: 1),
//                       ),
//                       labelText: "Signature (Enter full name)",
//                       labelStyle: TextStyle(
//                         fontSize: 14,
//                         color: Colors.black,
//                       ),
//                       hintStyle: GoogleFonts.lexendMega(
//                         color: Colors.grey,
//                         fontSize: 10,
//                       ),
//                     ),
//                     style: GoogleFonts.lexendMega(
//                       fontSize: 14,
//                       color: Colors.black,
//                     ),
//                   ),
//                   SizedBox(
//                     height: 20,
//                   ),
//                   ElevatedButton(
//                     onPressed: () {
//                       Fluttertoast.showToast(
//                         msg: "Thank you. Feedback Recieved.",
//                         backgroundColor: Colors.black,
//                         textColor: Colors.white,
//                         gravity: ToastGravity.CENTER,
//                       );
//                       submitFeedback();
//                       fieldTextFeedback.clear();
//                       fieldTextSignature.clear();
//                     },
//                     child: Text(
//                       "Submit",
//                       style: GoogleFonts.lexendMega(color: Colors.black),
//                     ),
//                     style: ElevatedButton.styleFrom(
//                       primary: Colors.purple[400],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
