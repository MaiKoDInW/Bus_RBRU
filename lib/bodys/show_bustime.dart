import 'package:flutter/material.dart';

class ShowBusTime extends StatefulWidget {
  const ShowBusTime({Key? key}) : super(key: key);

  @override
  _ShowBusTimeState createState() => _ShowBusTimeState();
}

class _ShowBusTimeState extends State<ShowBusTime> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: Text('Bus Time'))),
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            Container(
              height: 150,
              width: double.infinity,
              color: Colors.amber[400],
              alignment: Alignment.center,
              child: Text(
                'Monday',
              ),
            ),
            Container(
              height: 150,
              width: double.infinity,
              color: Colors.pink[400],
              alignment: Alignment.center,
              child: Text(
                'Tuesday',
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              height: 150,
              width: double.infinity,
              color: Colors.green[400],
              alignment: Alignment.center,
              child: Text(
                'Wednesday',
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              height: 150,
              width: double.infinity,
              color: Colors.orange,
              alignment: Alignment.center,
              child: Text(
                'Thursday',
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              height: 150,
              width: double.infinity,
              color: Colors.blue[300],
              alignment: Alignment.center,
              child: Text(
                'Friday',
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/*import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() => runApp(ShowBusTime());

class ShowBusTime extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Google Maps Demo',
      home: MapSample(),
    );
  }
}

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}*/

/* appBar: AppBar(title: Center(child: Text('Bus Time'))),
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            Container(
              height: 150,
              width: double.infinity,
              color: Colors.amber[400],
              alignment: Alignment.center,
              child: Text(
                'Monday',
              ),
            ),
            Container(
              height: 150,
              width: double.infinity,
              color: Colors.pink[400],
              alignment: Alignment.center,
              child: Text(
                'Tuesday',
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              height: 150,
              width: double.infinity,
              color: Colors.green[400],
              alignment: Alignment.center,
              child: Text(
                'Wednesday',
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              height: 150,
              width: double.infinity,
              color: Colors.orange,
              alignment: Alignment.center,
              child: Text(
                'Thursday',
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              height: 150,
              width: double.infinity,
              color: Colors.blue[300],
              alignment: Alignment.center,
              child: Text(
                'Friday',
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }*/

//import 'dart:html';
/*
import 'package:bus_rbru/utility/my_constant.dart';
import 'package:bus_rbru/utility/my_dialog.dart';
import 'package:bus_rbru/widgets/show_progress.dart';
import 'package:bus_rbru/widgets/show_title.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ShowBusTime extends StatefulWidget {
  const ShowBusTime({Key? key}) : super(key: key);

  @override
  _ShowBusTimeState createState() => _ShowBusTimeState();
}

class _ShowBusTimeState extends State<ShowBusTime> {
  double? lat, lng;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    checkPermission();
  }

  Future<Null> checkPermission() async {
    bool locationService;
    LocationPermission locationPermission;

    locationService = await Geolocator.isLocationServiceEnabled();
    if (locationService) {
      print('Service Location Open');
      locationPermission = await Geolocator.checkPermission();
      if (locationPermission == LocationPermission.denied) {
        locationPermission = await Geolocator.requestPermission();
        if (locationPermission == LocationPermission.deniedForever) {
          MyDialog().alertLocationService(
              context, 'ไม่อณุญาติเเชร์ Location', 'โปรดเเชร์ Location');
        } else {
          // findLatLng
          findLatLng();
        }
      } else {
        if (locationPermission == LocationPermission.deniedForever) {
          MyDialog().alertLocationService(
              context, 'ไม่อณุญาติเเชร์ Location', 'โปรดเเชร์ Location');
        } else {
          // findLatLng
          findLatLng();
        }
      }
    } else {
      print('Service Location Close');
      MyDialog().alertLocationService(
          context, 'กรุณาเปิด Location Service ', 'Location Service Close');
    }
  }

  Future<Null> findLatLng() async {
    print('findLatLng ==> work');
    Position? position = await findPostion();
    setState(() {
      lat = position!.latitude;
      lng = position.longitude;
      print('lat = $lat, lng = $lng');
    });
  }

  Future<Position?> findPostion() async {
    Position postion;
    try {
      postion = await Geolocator.getCurrentPosition();
      return postion;
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        behavior: HitTestBehavior.opaque,
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                buildTitle('เเสดงพิกัดที่คุณอยู่'),
                buildMap(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Set<Marker> setMarker() => <Marker>[
        Marker(
          markerId: MarkerId('id'),
          position: LatLng(lat!, lng!),
          infoWindow: InfoWindow(
              title: 'คุณอยู่ที่นี่', snippet: 'Lat = $lat, Lng = $lng'),
        ),
      ].toSet();

  Widget buildMap() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 340,
            height: 650,
            child: lat == null
                ? ShowProgress()
                : GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(lat!, lng!),
                      zoom: 16,
                    ),
                    onMapCreated: (controller) => {},
                    markers: setMarker(),
                  ),
          ),
        ],
      );

  Container buildTitle(String title) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16),
      child: ShowTitle(
        title: title,
        textStyle: MyConstant().h2Style(),
      ),
    );
  }
}*/
