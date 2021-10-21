import 'dart:convert';

import 'package:bus_rbru/models/user_model.dart';
import 'package:bus_rbru/utility/my_constant.dart';
import 'package:bus_rbru/widgets/show_progress.dart';
import 'package:bus_rbru/widgets/show_title.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ShowEditUser extends StatefulWidget {
  final UserModel userModel;

  const ShowEditUser({Key? key, required this.userModel}) : super(key: key);

  @override
  _ShowEditUserState createState() => _ShowEditUserState();
}

class _ShowEditUserState extends State<ShowEditUser> {
  UserModel? userModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userModel = widget.userModel;
  }

  Future<Null> refreshUserModel() async {
    print('### refreshUserModel work');
    String apiGetUserWhereId =
        '${MyConstant.domain}/busrbru/getUserWhereId.php?isAdd=true&id=${userModel!.id}';
    await Dio().get(apiGetUserWhereId).then((value) {
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
                              title: 'Name User:',
                              textStyle: MyConstant().h2Style()),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ShowTitle(
                                title: userModel!.name,
                                textStyle: MyConstant().h1Style()),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ShowTitle(
                            title: 'Map Location :',
                            textStyle: MyConstant().h2Style(),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ShowTitle(
                              title:
                                  'จะเเสดงจุดที่อยู่ที่คุณทำการสมัครสมาชิกไว้',
                              textStyle: MyConstant().h3Style()),
                        ],
                      ),
                      buildmapuser(constraints),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          buildEditButton(),
                        ],
                      ),
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
                      title: 'คุณอยู่ที่นี่',
                      snippet:
                          'lat = ${userModel!.lat}, lng = ${userModel!.lng}'))
            ].toSet(),
            myLocationEnabled: true,
          ),
        ),
      ],
    );
  }

  ElevatedButton buildEditButton() {
    return ElevatedButton.icon(
        onPressed: () =>
            Navigator.pushNamed(context, MyConstant.routeEditProfileUser).then(
              (value) => refreshUserModel(),
            ),
        icon: Icon(Icons.edit),
        label: Text('Edit Location'));
  }
}
