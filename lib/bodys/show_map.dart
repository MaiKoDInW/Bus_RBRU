import 'dart:convert';

import 'package:bus_rbru/bodys/show_edit_user.dart';

import 'package:bus_rbru/models/user_model.dart';
import 'package:bus_rbru/utility/my_constant.dart';
import 'package:bus_rbru/utility/my_dialog.dart';
import 'package:bus_rbru/widgets/show_progress.dart';
import 'package:bus_rbru/widgets/show_title.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowMap extends StatefulWidget {
  const ShowMap({Key? key}) : super(key: key);

  @override
  _ShowMapState createState() => _ShowMapState();
}

class _ShowMapState extends State<ShowMap> {
  UserModel? userModel;
  double? lat, lng;
  // final formKey = GlobalKey<FormState>();
  // String? get id => null;

  // Map<MarkerId, Marker> mapMarkers = Map();
  List<UserModel> acceptModels = [];
  Map<MarkerId, Marker> mapMarkers = Map();
  late BitmapDescriptor myIcon;
  List<Polyline> myPolyline = [];

  @override
  void initState() {
    super.initState();
    findUserModel();
    readAllPosition();
    // findDriverModel();
    // checkPermission();
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(1, 1)), 'images/007.png')
        .then((onValue) {
      myIcon = onValue;
    });
  }

  Future<Null> findUserModel() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String id = preferences.getString('id')!;
    print('## id login ==> $id');
    String apiGetUserWhereId =
        '${MyConstant.domain}/busrbru/getUserWhereId.php?isAdd=true&id=2';
    await Dio().get(apiGetUserWhereId).then((value) {
      print('## value ==> $value');
      for (var item in json.decode(value.data)) {
        setState(() {
          userModel = UserModel.fromMap(item);
        });
      }
    });
  }

  void createAllMarker(LatLng latLng, String idMarker, String title) {
    MarkerId markerId = MarkerId(idMarker);
    Marker marker = Marker(
      markerId: markerId,
      position: latLng,
      icon: myIcon,
      infoWindow: InfoWindow(title: title),
    );
    mapMarkers[markerId] = marker;
  }

  Future<Null> readAllPosition() async {
    String apiReadAllPosition =
        '${MyConstant.domain}/busrbru/getUserWhereId.php?isAdd=true&id=2';
    await Dio().get(apiReadAllPosition).then(
      (value) {
        // print('######### value ==>> $value');
        int i = 0;
        for (var item in json.decode(value.data)) {
          UserModel model = UserModel.fromMap(item);
          setState(() {
            acceptModels.add(model);
            createAllMarker(
                LatLng(double.parse(model.lat), double.parse(model.lng)),
                'idMarker$i',
                model.name);
          });
          i++;
        }
      },
    );
  }

  // Future<Null> findDriverModel() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   String id = preferences.getString('id')!;
  //   print('## id login ==> $id');
  //   String apiGetUserWhereId =
  //       '${MyConstant.domain}/busrbru/getUserWhereType.php?isAdd=true&type=Driver';
  //   await Dio().get(apiGetUserWhereId).then((value) {
  //     print('## value ==> $value');
  //     for (var item in json.decode(value.data)) {
  //       setState(() {
  //         userModel = UserModel.fromMap(item);
  //       });
  //     }
  //   });
  // }

  // Future<Null> checkPermission() async {
  //   bool locationService;
  //   LocationPermission locationPermission;

  //   locationService = await Geolocator.isLocationServiceEnabled();
  //   if (locationService) {
  //     print('Service Location Open');
  //     locationPermission = await Geolocator.checkPermission();
  //     if (locationPermission == LocationPermission.denied) {
  //       locationPermission = await Geolocator.requestPermission();
  //       if (locationPermission == LocationPermission.deniedForever) {
  //         MyDialog().alertLocationService(
  //             context, 'ไม่อณุญาติเเชร์ Location', 'โปรดเเชร์ Location');
  //       } else {
  //         // findLatLng
  //         findLatLng();
  //       }
  //     } else {
  //       if (locationPermission == LocationPermission.deniedForever) {
  //         MyDialog().alertLocationService(
  //             context, 'ไม่อณุญาติเเชร์ Location', 'โปรดเเชร์ Location');
  //       } else {
  //         // findLatLng
  //         findLatLng();
  //       }
  //     }
  //   } else {
  //     print('Service Location Close');
  //     MyDialog().alertLocationService(
  //         context, 'กรุณาเปิด Location Service ', 'Location Service Close');
  //   }
  // }

  // Future<Null> findLatLng() async {
  //   print('findLatLng ==> work');
  //   Position? position = await findPostion();
  //   setState(() {
  //     lat = position!.latitude;
  //     lng = position.longitude;
  //     print('lat = $lat, lng = $lng');
  //   });
  // }

  // Future<Position?> findPostion() async {
  //   Position postion;
  //   try {
  //     postion = await Geolocator.getCurrentPosition();
  //     return postion;
  //   } catch (e) {
  //     return null;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // double size = MediaQuery.of(context).size.width;
    return Scaffold(
      body: LayoutBuilder(
          builder: (context, constraints) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ShowTitle(
                              title: '', textStyle: MyConstant().h2Style()),
                        ],
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     Padding(
                      //       padding: const EdgeInsets.all(8.0),
                      //       child: ShowTitle(
                      //           title: userModel!.name,
                      //           textStyle: MyConstant().h1Style()),
                      //     ),
                      //   ],
                      // ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ShowTitle(
                            title: 'Map Location ',
                            textStyle: MyConstant().h1Style(),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ShowTitle(
                              title: 'จะเเสดงจุดที่อยู่ที่คุณอยู่ห่างจากรถบัส',
                              textStyle: MyConstant().h3Style()),
                        ],
                      ),
                      buildmapuser(constraints),
                    ],
                  ),
                ),
              )),
    );
  }

  Row buildmapuser(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 15),
          width: constraints.maxWidth * 0.9,
          height: constraints.maxWidth * 1.2,
          child: GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(
                double.parse(userModel!.lat),
                double.parse(userModel!.lng),
              ),
              zoom: 16,
            ),
            markers: Set<Marker>.of(mapMarkers.values),
            // markers: <Marker>[
            //   Marker(
            //     markerId: MarkerId('id'),

            //     position: LatLng(
            //       double.parse(userModel!.lat),
            //       double.parse(userModel!.lng),
            //     ),
            //     infoWindow: InfoWindow(
            //         title: 'รถบัสรับส่งโดยสาร',
            //         snippet:
            //             'lat = ${userModel!.lat}, lng = ${userModel!.lng}'),
            //   )
            // ].toSet(),
            myLocationEnabled: true,
          ),
        ),
      ],
    );
  }

  /*floatingActionButton: FloatingActionButton(
        child: Icon(Icons.edit),
        onPressed: () =>
            Navigator.pushNamed(context, MyConstant.routeEditProfileUser),
      ),*/
  //     body: GestureDetector(
  //       onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
  //       behavior: HitTestBehavior.opaque,
  //       child: Form(
  //         key: formKey,
  //         child: SingleChildScrollView(
  //           child: Column(
  //             children: [
  //               Container(
  //                 margin: EdgeInsets.symmetric(vertical: 15),
  //                 child: ShowTitle(
  //                   title: 'GOOGLE MAP',
  //                   textStyle: MyConstant().h1Style(),
  //                 ),
  //               ),

  //               buildTitle('เเสดงพิกัดที่คุณอยู่(ปัจจุบัน)'),
  //               buildMap(),
  //               // buildbutton(size),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  /*Row buildbutton(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 15),
          width: size * 0.5,
          child: ElevatedButton(
            style: MyConstant().myByyonStyle(),
            onPressed: () {
              Navigator.pushNamed(context, MyConstant.routeEditProfileUser);
            },
            child: Text(
              'เพิ่มพิกัด',
            ),
          ),
        ),
      ],
    );
  }*/

  /*Future<Null> processAddLocation(String id) async {
    // สิ่งที่ต้องทำถ้าไม่อยู่ที่เดิม
    String apiInsertLocation =
        '${MyConstant.domain}/busrbru/idlatlng.php?isAdd=true&lat=$lat&lng=$lng';

    await Dio().get(apiInsertLocation).then((value) async {
      if (value.toString() == 'true') {
        String apiReadAllPosition =
            '${MyConstant.domain}/findtaxi/getAllPosition.php';
        // print('###########################################');
        // print('####### api = $apiReadAllPosition');
        // print('###########################################');
        await Dio().get(apiReadAllPosition).then((value) {
          int loopTime = 0;
          for (var item in json.decode(value.data)) {
            AcceptModel acceptModel = AcceptModel.fromMap(item);
          }
        });
      }
    });
  }

  void createAllMarker(LatLng latLng, String idMarker, String title) {
    MarkerId markerId = MarkerId(idMarker);
    Marker marker = Marker(
      markerId: markerId,
      position: latLng,
      infoWindow: InfoWindow(title: title),
    );
    mapMarkers[markerId] = marker;
  }

  Future<Null> readAllPosition() async {
    String apiReadAllPosition = '${MyConstant.domain}/busrbru/getAllData.php';
    await Dio().get(apiReadAllPosition).then(
      (value) {
        // print('######### value ==>> $value');
        int i = 0;
        for (var item in json.decode(value.data)) {
          AcceptModel model = AcceptModel.fromMap(item);
          setState(() {
            acceptModels.add(model);
            createAllMarker(
                LatLng(double.parse(model.lat), double.parse(model.lng)),
                'idMarker$i',
                model.id);
          });
          i++;
        }
      },
    );
  }*/

  // Set<Marker> setMarker() => <Marker>[
  //       Marker(
  //         markerId: MarkerId('id'),
  //         position: LatLng(lat!, lng!),
  //         infoWindow: InfoWindow(
  //             title: 'คุณอยู่ที่นี่', snippet: 'Lat = $lat, Lng = $lng'),
  //       ),
  //     ].toSet();

//   Widget buildMap() => Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(
//             width: 340,
//             height: 540,
//             child: lat == null
//                 ? ShowProgress()
//                 : GoogleMap(
//                     initialCameraPosition: CameraPosition(
//                       target: LatLng(
//                         double.parse(userModel!.lat),
//                         double.parse(userModel!.lng),
//                       ),
//                       zoom: 16,
//                     ),
//                     onMapCreated: (controller) => {},
//                     markers: <Marker>[
//                       Marker(
//                           markerId: MarkerId('id'),
//                           position: LatLng(
//                             double.parse(userModel!.lat),
//                             double.parse(userModel!.lng),
//                           ),
//                           infoWindow: InfoWindow(
//                               title: 'ตำเเหน่งของรถบัส',
//                               snippet:
//                                   'lat = ${userModel!.lat}, lng = ${userModel!.lng}'))
//                     ].toSet(),
//                     // markers: setMarker(),
//                     // markers: {
//                     //   Marker(
//                     //     markerId: MarkerId("1"),
//                     //     position:
//                     //         LatLng(12.663166381260405, 102.10415014813167),
//                     //     infoWindow: InfoWindow(
//                     //         title: "รถบัส",
//                     //         snippet: "เเสดงตำเเหน่งรถเเบบสมมุติ"),
//                     //   )
//                     // },
//                     myLocationEnabled: true,
//                   ),
//           ),
//         ],
//       );

//   Container buildTitle(String title) {
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: 5),
//       child: ShowTitle(
//         title: title,
//         textStyle: MyConstant().h2Style(),
//       ),
//     );
//   }
// }
}
