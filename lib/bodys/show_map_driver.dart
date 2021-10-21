import 'dart:convert';

import 'package:bus_rbru/models/user_model.dart';
import 'package:bus_rbru/utility/my_constant.dart';
import 'package:bus_rbru/widgets/show_title.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowMapDriver extends StatefulWidget {
  const ShowMapDriver({Key? key}) : super(key: key);

  @override
  _ShowMapDriverState createState() => _ShowMapDriverState();
}

class _ShowMapDriverState extends State<ShowMapDriver> {
  UserModel? userModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findUserModel();
  }

  Future<Null> findUserModel() async {
    // SharedPreferences preferences = await SharedPreferences.getInstance();
    // String id = preferences.getString('id')!;
    // print('## id login ==> $id');
    String apiGetUserWhereId =
        '${MyConstant.domain}/busrbru/getUserWhereId.php?isAdd=true&id=3';
    await Dio().get(apiGetUserWhereId).then((value) {
      print('## value ==> $value');
      for (var item in json.decode(value.data)) {
        setState(() {
          userModel = UserModel.fromMap(item);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
                            title: 'Map Location ',
                            textStyle: MyConstant().h1Style(),
                          ),
                        ],
                      ),
                      buildmapuser(constraints),
                      // buildEditButton(),
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
            markers: <Marker>[
              Marker(
                  markerId: MarkerId('id'),
                  position: LatLng(
                    double.parse(userModel!.lat),
                    double.parse(userModel!.lng),
                  ),
                  infoWindow: InfoWindow(
                      title: 'Sittichai Nunwang',
                      snippet:
                          'lat = ${userModel!.lat}, lng = ${userModel!.lng}'))
            ].toSet(),
            myLocationEnabled: true,
          ),
        ),
      ],
    );
  }
}

// ElevatedButton buildEditButton() {
//     return ElevatedButton.icon(
//         onPressed: () =>
//             Navigator.pushNamed(context, MyConstant.routeEditProfileUser).then(
//               (value) => refreshUserModel(),
//             ),
//         icon: Icon(Icons.edit),
//         label: Text('Edit Location'));
//   }
// }
