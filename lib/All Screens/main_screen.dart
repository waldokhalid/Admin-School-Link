import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// ignore: must_be_immutable
class MainScreen extends StatefulWidget {
  static const String idScreen = "MainScreen";
  late String name;
  late String phone;
  late String safeKidzID;

  MainScreen({
    key,
    required this.name,
    required this.phone,
  }) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List lastLatLng = [];
  List currentCoordinates = [];
  Location _locationTracker = Location();
  late StreamSubscription _locationSubscription;

  late String
      searchID; // parent searching using driver id and then it is stored here

  Set<Marker> _markers = Set();

  late BitmapDescriptor pinLocationIcon;

  var currentLatForAdress;
  var currentLongForAdress;

  bool trackDirver = true;

  TextEditingController searchTextEditingController = TextEditingController();

  final FirebaseAuth auth = FirebaseAuth.instance;

  final databaseReference = FirebaseDatabase.instance.reference();
  Completer<GoogleMapController> _controllerGoogleMaps = Completer();
  late GoogleMapController newGoogleMapController;
  final GlobalKey scaffoldKey = GlobalKey();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(39.04475400135195, 125.75316892920314),
    // target: LatLng(4.0435, 39.6682),
    zoom: 18.0,
    tilt: 70,
  );

  void getCurrentLocation() async {
    print(widget.phone);
    // This method grabs user location and streams updates of location to the database
    try {
      // Uint8List imageData = await getMarker();
      var position = await _locationTracker.getLocation();
      currentCoordinates.add(position.latitude);
      currentCoordinates.add(position.longitude);
      goTOCurrentUserLocation();
      // final randomUserUid = await getParentUID();
      _locationSubscription.cancel();
      _locationSubscription = _locationTracker.onLocationChanged.listen(
        (newLocalData) {
          setState(() {
            currentLatForAdress = newLocalData.latitude;
            currentLongForAdress = newLocalData.longitude;
          });
        },
      );
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }
  }

  void goTOCurrentUserLocation() async {
    newGoogleMapController.animateCamera(
      CameraUpdate.newCameraPosition(
        new CameraPosition(
          target: LatLng(currentCoordinates[0], currentCoordinates[1]),
          zoom: 10.0,
          tilt: 0,
        ),
      ),
    );
    // getAllDriversLocation();
  }

  getLastPosGoToDriver() async {
    print(searchID);
    bool trackDirver = true;
    while (trackDirver == true) {
      print("\n\n\nCalling lastPOsition()...\n\n\n");
      await lastPosition();
      print("$lastLatLng");
      print("\n\n\nCalling goToDriver()...\n\n\n");
      await goToDriver();
    }
  }

  // Future<void> startForegroundService() async {
  //   // ignore: await_only_futures
  //   await ForegroundService().start();
  // }

  Future goToDriver() async {
    // When button is pressed, this method gets latest coordinates and track it on the map with a red marker
    print("\n\n\nAnimating to Driver\n\n\n");
    LatLng coordinates = LatLng(lastLatLng[0], lastLatLng[1]);
    // print(coordinates);
    newGoogleMapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: coordinates,
          zoom: 17.0,
          tilt: 20,
        ),
      ),
    );
    print("Animated");
    setState(
      () {
        _markers.add(
          Marker(
            position: coordinates,
            markerId: MarkerId("Marker 1"),
            infoWindow: InfoWindow(title: "Driver"),
            icon: pinLocationIcon,
          ),
        );
      },
    );
    print("Marker Added");
    lastLatLng.clear();
    lastLatLng.clear();
    await Future.delayed(
      Duration(milliseconds: 1000),
    );
    // calculateDistance();
  }

  lastPosition() async {
    lastLatLng.clear();
    // print(Pdriver);
    // This method grabs the stream of location that is being sent to the database
    print("\n\n\nFetching Coordinates\n\n\n");

    print("Checking Search ID");
    print(searchID);
    var lastPosSnapshot = await databaseReference
        .child("users")
        .child("Driver Coordinates")
        .child(widget.phone.toString())
        .once();
    print(lastPosSnapshot.value);
    lastLatLng.add(lastPosSnapshot.value["Latitude"]);
    lastLatLng.add(lastPosSnapshot.value["Longitude"]);
    // print(driverUID);
    await Future.delayed(
      Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    _locationSubscription.cancel();
    super.dispose();
  }

  @override
  initState() {
    super.initState();
    getCurrentLocation();

    BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 2.5),
            'assets/images/customPIN.png')
        .then(
      (onValue) {
        pinLocationIcon = onValue;
      },
    );
    // getAllDriversLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        toolbarHeight: 50,
        // shadowColor: Colors.grey,
        backgroundColor: Colors.white.withOpacity(0.0),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.name,
              style: GoogleFonts.lexendMega(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            padding: const EdgeInsets.only(top: 100),
            // padding: EdgeInsets.fromLTRB(0, 100, 0, 15) + MediaQuery.of(context).padding,
            markers: _markers,
            trafficEnabled: true,
            compassEnabled: false,
            myLocationEnabled: true,
            tiltGesturesEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: false,
            initialCameraPosition: _kGooglePlex,
            // ignore: unnecessary_null_comparison
            mapType: _mapType == null ? MapType.normal : _mapType,
            onMapCreated: (GoogleMapController controller) {
              Future.delayed(
                Duration(milliseconds: 100),
              );
              controller.setMapStyle(Utils.mapStyles);
              _controllerGoogleMaps.complete(controller);
              newGoogleMapController = controller;
              // startForegroundService();
              // goTOCurrentUserLocation();
              // getCurrentLocation();
              // getAllDriversLocation();
              getLastPosGoToDriver();
            },
          ),
        ],
      ),
    );
  }
}

List<MapType> mapType = [
  MapType.normal,
  MapType.hybrid,
  MapType.satellite,
  MapType.terrain,
  MapType.none,
];
MapType _mapType = MapType.normal;
List<String> mapTypeName = ["Normal", "Hybird", "Satellite", "Terrain", "None"];

class Utils {
  static String mapStyles = '''[
              {
                "elementType": "geometry",
                "stylers": [
                  {
                    "color": "#f5f5f5"
                  }
                ]
              },
              {
                "elementType": "labels.icon",
                "stylers": [
                  {
                    "visibility": "on"
                  }
                ]
              },
              {
                "elementType": "labels.text.fill",
                "stylers": [
                  {
                    "color": "#616161"
                  }
                ]
              },
              {
                "elementType": "labels.text.stroke",
                "stylers": [
                  {
                    "color": "#f5f5f5"
                  }
                ]
              },
              {
                "featureType": "administrative.land_parcel",
                "elementType": "labels.text.fill",
                "stylers": [
                  {
                    "color": "#bdbdbd"
                  }
                ]
              },
              {
                "featureType": "poi",
                "elementType": "geometry",
                "stylers": [
                  {
                    "color": "#eeeeee"
                  }
                ]
              },
              {
                "featureType": "poi",
                "elementType": "labels.text.fill",
                "stylers": [
                  {
                    "color": "#757575"
                  }
                ]
              },
              {
                "featureType": "poi.park",
                "elementType": "geometry",
                "stylers": [
                  {
                    "color": "#e5e5e5"
                  }
                ]
              },
              {
                "featureType": "poi.park",
                "elementType": "labels.text.fill",
                "stylers": [
                  {
                    "color": "#9e9e9e"
                  }
                ]
              },
              {
                "featureType": "road",
                "elementType": "geometry",
                "stylers": [
                  {
                    "color": "#ffffff"
                  }
                ]
              },
              {
                "featureType": "road.arterial",
                "elementType": "labels.text.fill",
                "stylers": [
                  {
                    // "color": "#757575"
                    "color": "#000000"

                  }
                ]
              },
              {
                "featureType": "road.highway",
                "elementType": "geometry",
                "stylers": [
                  {
                    "color": "#000000"
                  }
                ]
              },
              {
                "featureType": "road.highway",
                "elementType": "labels.text.fill",
                "stylers": [
                  {
                    "color": "#000000"
                  }
                ]
              },
              {
                "featureType": "road.local",
                "elementType": "labels.text.fill",
                "stylers": [
                  {
                    "color": "#000000"
                  }
                ]
              },
              {
                "featureType": "transit.line",
                "elementType": "geometry",
                "stylers": [
                  {
                    "color": "#e5e5e5"
                  }
                ]
              },
              {
                "featureType": "transit.station",
                "elementType": "geometry",
                "stylers": [
                  {
                    "color": "#eeeeee"
                  }
                ]
              },
              {
                "featureType": "water",
                "elementType": "geometry",
                "stylers": [
                  {
                    // "color": "#c9c9c9"
                    "color": "#008ECC"

                  }
                ]
              },
              {
                "featureType": "water",
                "elementType": "labels.text.fill",
                "stylers": [
                  {
                    // "color": "#9e9e9e"
                    "color": "#008ECC"
                  }
                ]
              }
            ]''';
}

class LocationCoordinates {
  final double latitude;
  final double longitude;
  final String name;
  LocationCoordinates({
    required this.latitude,
    required this.longitude,
    required this.name,
  });
  factory LocationCoordinates.fromJson(Map<dynamic, dynamic> json) {
    return LocationCoordinates(
      latitude: json["latitude"],
      longitude: json["latitude"],
      name: json["DriverUID"].toString(),
    );
  }
}

displayToastMessage(String message, BuildContext context) {
  // create the displayToastMessage method.
  // giveit a parameter that will be a message.
  Fluttertoast.showToast(msg: (message));
}
