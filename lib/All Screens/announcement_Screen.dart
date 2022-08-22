import 'dart:convert';
import 'package:admin_school_link/services/local_push_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class AnnouncmentScreen extends StatefulWidget {
  static const String idScreen = "AnnouncmentScreen";
  // List<String> parentNotificationTOkens;

  const AnnouncmentScreen({
    key,
    // @required this.parentNotificationTOkens,
  }) : super(key: key);

  @override
  State<AnnouncmentScreen> createState() => _AnnouncmentScreenState();
}

class _AnnouncmentScreenState extends State<AnnouncmentScreen> {
  TextEditingController announcementTitle = TextEditingController();
  TextEditingController announcementBody = TextEditingController();

  final databaseReference = FirebaseDatabase.instance.reference();
  FirebaseAuth auth = FirebaseAuth.instance;

  var color = Colors.black;

  List<String> listOfUrls = [];
  List<Widget> listOfPics = [];

  List<Announcement> announcementList = [];

  List<dynamic> notificationsList = [];

  int token = 0;
  late String schoolName;
  late String adminUID;

  var getDate;

  var formattedDate;

  late String sendTOken;

  late String path;

  late String completePath;

  List<Map<String, dynamic>> files = [];

  late String getPath;
  late String schlName;

  getTodaysDate() async {
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

  Future<List> getAnnouncements() async {
    schoolName = await getSchoolName();

    // print("Getting details!!");
    // print(notificationsList);

    try {
      var ref = databaseReference
          .child("users")
          .child(schoolName)
          .child("Announcements")
          .child(formattedDate);
      var snapshot = await ref.get();
      if (snapshot.exists) {
        // print(snapshot.exists);
        // print(snapshot.value);
        setState(() {
          // var value = snapshot.value;
          announcementList = Map.from(snapshot.value)
              .values
              .map(
                (e) => Announcement.fromJson(
                  Map.from(e),
                ),
              )
              .toList();
          // print(announcementList.length);
        });
      } else {
        print("No Data Exists");
      }
      return announcementList;
    } catch (e) {
      print("$e");
    }

    return announcementList;
  }

  void sendAnnouncement() async {
    schoolName = await getSchoolName();
    try {
      await databaseReference
          .child("users")
          .child("$schoolName")
          .child("Announcements")
          .child(formattedDate)
          .child(announcementTitle.text.toUpperCase())
          .set({
        "title": announcementTitle.text.toUpperCase().trim(),
        "body": announcementBody.text.trim(),
        "date": formattedDate,
      });
    } catch (e) {
      print("$e");
    }
    if (kDebugMode) {
      print("Items Updated!");
    }
    announcementBody.clear();
    announcementTitle.clear();
    sendNotifiaction();
    // loopThroughNotificationTokensToSendNotificaitons();
  }

  sendNotifiaction() async {
    for (token = 0;
        token < notificationsList.length;
        setState(() {
      token = token + 1;
    })) {
      String title = "NEW ANNOUNCEMENT";
      String notifyParent =
          "Please check announcement tab on you School Link Dashboard";

      if (notificationsList[0].isNotEmpty) {
        setState(
          () {
            if (kDebugMode) {
              print(notificationsList.length);
            }
            sendTOken = notificationsList[0][token].toString();
            if (kDebugMode) {
              print(notificationsList[0][token].toString());
            }
            if (sendTOken == "No Token") {
              notificationsList[0].remove(sendTOken);
              sendNotifiaction();
            }
          },
        );
      } else {
        return;
      }

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
                  'to': sendTOken,
                }));

        if (response.statusCode == 200) {
          print("Notification Sent!");
          setState(() {
            notificationsList[0].remove(sendTOken);
          });
          sendNotifiaction();
        } else {
          print("Notification Not Sent");
          print(response.body);
        }
      } catch (e) {
        print("Error!");
        print(e);
      }
    }
    // print(notificationsList);
    return;
  }

  String validateBeforeSubmit() {
    if (announcementTitle.text.isEmpty || announcementBody.text.isEmpty) {
      return "empty";
    } else {
      return "not empty";
    }
  }

  @override
  void initState() {
    super.initState();
    getTodaysDate();
    getUID();
    getAnnouncements();
    // _load_Images();

    FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.onMessage.listen((event) {
      LocalNotificationService.display(event);
    });
  }

  @override
  Widget build(BuildContext context) {
    notificationsList.clear();
    final Object? parentNotificationTOkens =
        ModalRoute.of(context)?.settings.arguments;
    notificationsList.add(parentNotificationTOkens);
    // print(parentNotificationTOkens);
    return Scaffold(
      backgroundColor: Colors.grey[800],
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.grey[800],
        title: Text(
          "Announcments",
          style: GoogleFonts.lexendMega(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextField(
                controller: announcementTitle,
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
                    "Title",
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
              padding: const EdgeInsets.all(15.0),
              child: TextField(
                controller: announcementBody,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  // contentPadding: EdgeInsets.symmetric(vertical: 20,),
                  enabledBorder: const OutlineInputBorder(),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                      style: BorderStyle.solid,
                      width: 2,
                    ),
                  ),
                  label: Text(
                    "Message",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lexendMega(
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                  ),
                ),
                maxLines: 5,
                minLines: 1,
                style: GoogleFonts.lexendMega(
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: ElevatedButton(
                onPressed: () {
                  String validator = validateBeforeSubmit();

                  if (validator != "empty") {
                    Fluttertoast.showToast(
                      msg:
                          "Please Wait..",
                          gravity: ToastGravity.CENTER,
                          backgroundColor: Colors.black,
                          timeInSecForIosWeb: 15,
                    );
                    sendAnnouncement();
                    Fluttertoast.showToast(
                      msg:
                          "DONE!\nAnnouncement has been sent.\nParents will recieve a notification.\nParents will be able to see teh announcement from the bulleitn tab on their dashboard.",
                          gravity: ToastGravity.CENTER,
                          backgroundColor: Colors.black,
                          timeInSecForIosWeb: 7,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // InkWell(
                //   onTap: null,
                //   child: Icon(
                //     Icons.arrow_back,
                //     color: Colors.black,
                //   ),
                // ),
                Text(
                  "TODAY",
                  style: GoogleFonts.lexendMega(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            if (announcementList.isEmpty)
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
                  itemCount: announcementList.length,
                  itemBuilder: (context, int index) {
                    final Announcement driver = announcementList[index];
                    final String title = driver.title;
                    final String body = driver.body;
                    // final String date = driver.date;
                    // final String driverPhone = driver.phone;
                    // final driverRandomId = driver.randomId;
                    // final String driverUID = driver.uid;
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        color: Colors.orange[800],
                        elevation: 0.2,
                        child: ExpansionTile(
                          // collapsedBackgroundColor: Colors.grey,
                          title: Text(
                            title.toUpperCase(),
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
                                  title.toUpperCase(),
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.lexendMega(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  body,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.lexendMega(
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(
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
              ),
          ],
        ),
      ),
    );
  }
}

class Announcement {
  final String title;
  final String body;
  final String date;

  Announcement({
    required this.title,
    required this.body,
    required this.date,
  });

  static Announcement fromJson(Map<String, String> json) {
    return Announcement(
      title: json['title'].toString(),
      body: json['body'].toString(),
      date: json['date'].toString(),
    );
  }
}
