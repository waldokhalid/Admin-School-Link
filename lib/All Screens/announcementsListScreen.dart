import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class AnnouncmentListScreen extends StatefulWidget {
  static const String idScreen = "AnnouncmentListScreen";
  // List<String> parentNotificationTOkens;

  const AnnouncmentListScreen({
    key,
    // @required this.parentNotificationTOkens,
  }) : super(key: key);

  @override
  State<AnnouncmentListScreen> createState() => _AnnouncmentListScreenState();
}

class _AnnouncmentListScreenState extends State<AnnouncmentListScreen> {
  TextEditingController announcementTitle = TextEditingController();
  TextEditingController announcementBody = TextEditingController();

  final databaseReference = FirebaseDatabase.instance.reference();
  FirebaseAuth auth = FirebaseAuth.instance;

  var color = Colors.black;

  List<String> listOfUrls = [];
  List<Widget> listOfPics = [];

  List<Announcement> announcementList = [];

  List<dynamic> notificationsList = [];

  late String schoolName;
  late String adminUID;

  var getDate;

  var formattedDate;

  late String sendTOken;

  var path;

  List<Map<String, dynamic>> files = [];

  late String  schlName;

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
      Duration(milliseconds: 200),
    );
    getInfo(adminUID);
    return adminUID;
  }

  Future<dynamic> getInfo(adminUID) async {
    databaseReference.child("users").child("Admin").child(adminUID).once().then(
      (snapshot) async {
        setState(() {
          schoolName = snapshot.value["school"];
          print(schoolName);
        });
      },
    );
  }

  getSchoolName() async {
    // ignore: unused_local_variable
    // final ref = FirebaseDatabase.instance.reference();
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

  Future<List> getAnnouncements() async {
    schoolName = await getSchoolName();

    print("Getting details!!");
    // print(notificationsList);

    try {
      var ref = databaseReference
          .child("users")
          .child("$schoolName")
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
          print(announcementList.length);
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

  @override
  void initState() {
    super.initState();
    getTodaysDate();
    getUID();
    getAnnouncements();
    // _load_Images();

    // FirebaseMessaging.instance.getInitialMessage();
    // FirebaseMessaging.onMessage.listen((event) {
    //   LocalNotificationService.display(event);
    // });
  }

  @override
  Widget build(BuildContext context) {
    // notificationsList.clear();
    // final List<String> parentNotificationTOkens =
    //     ModalRoute.of(context).settings.arguments as List;
    // notificationsList.add(parentNotificationTOkens);
    // // print(parentNotificationTOkens);
    return Scaffold(
      backgroundColor: Colors.grey[800],
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.grey[800],
        title: Text(
          "Announcements",
          style: GoogleFonts.lexendMega(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            if (announcementList.isEmpty)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "NO ANNOUNCEMENTS",
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
                                  "$title".toUpperCase(),
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.lexendMega(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  "$body",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.lexendMega(
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(
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

  Announcement({required this.title, required this.body, required this.date});

  static Announcement fromJson(Map<String, String> json) {
    return Announcement(
      title: json['title'].toString(),
      body: json['body'].toString(),
      date: json['date'].toString(),
    );
  }
}
