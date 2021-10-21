import 'dart:convert';

import 'package:bus_rbru/models/user_model.dart';
import 'package:bus_rbru/utility/my_constant.dart';
import 'package:bus_rbru/utility/my_dialog.dart';
import 'package:bus_rbru/widgets/show_progress.dart';
import 'package:bus_rbru/widgets/show_title.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileUser extends StatefulWidget {
  const EditProfileUser({Key? key}) : super(key: key);

  @override
  _EditProfileUserState createState() => _EditProfileUserState();
}

class _EditProfileUserState extends State<EditProfileUser> {
  UserModel? userModel;
  TextEditingController nameController = TextEditingController();
  LatLng? latlng;
  final formKey = GlobalKey<FormState>();
  // File? file;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findUser();
    findLatLng();
  }

  Future<Null> findLatLng() async {
    Position? position = await findPosition();
    if (position != null) {
      setState(() {
        latlng = LatLng(position.latitude, position.longitude);
        print('lat = ${latlng!.latitude}');
      });
    }
  }

  Future<Position?> findPosition() async {
    Position? position;
    try {
      position = await Geolocator.getCurrentPosition();
    } catch (e) {
      position = null;
    }
    return position;
  }

  Future<Null> findUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String user = preferences.getString('user')!;

    String apiGetUser =
        '${MyConstant.domain}/busrbru/getUserWhereUser.php?isAdd=true&user=$user';
    await Dio().get(apiGetUser).then((value) {
      print('## value API ==>> $value');
      for (var item in json.decode(value.data)) {
        setState(() {
          userModel = UserModel.fromMap(item);
          nameController.text = userModel!.name;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit Profile user'),
          actions: [
            IconButton(
              onPressed: () => editValueToMySQL(),
              icon: Icon(Icons.edit),
              tooltip: 'Edit Loction User',
            ),
          ],
        ),
        body: LayoutBuilder(
          builder: (context, constraints) => GestureDetector(
            onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
            behavior: HitTestBehavior.opaque,
            child: Form(
              key: formKey,
              child: ListView(
                padding: EdgeInsets.all(16),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildtitle('Name :'),
                    ],
                  ),
                  buildname(constraints),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: buildtitle('Location : '),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ShowTitle(
                          title: 'เเสดงตำเเหน่งที่อยู่ปัจุบันของคุณ',
                          textStyle: MyConstant().h3Style()),
                    ],
                  ),
                  buildmap(constraints),
                  buildEditButton()
                ],
              ),
            ),
          ),
        ));
  }

  /*Future<Null> processEditProfileUser() async {
    print('## processEditProfile Work');
    if (formKey.currentState!.validate()) {
      if () {
        print('OK Avatar');
        editValueToMySQL();
      }
    }
  }*/

  Future<Null> editValueToMySQL() async {
    MyDialog().showProgressDiolog(context);
    String apieditprofile =
        '${MyConstant.domain}/busrbru/editProfileUserWhereId.php?isAdd=true&id=${userModel!.id}&name=${nameController.text}&lat=${latlng!.latitude}&lng=${latlng!.longitude}';
    await Dio().get(apieditprofile).then(
      (value) {
        Navigator.pop(context);
        Navigator.pop(context);
      },
    );
  }

  ElevatedButton buildEditButton() {
    return ElevatedButton.icon(
        onPressed: () => editValueToMySQL(),
        icon: Icon(Icons.edit),
        label: Text('Edit Location'));
  }

  Row buildmap(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
          margin: EdgeInsets.symmetric(vertical: 16),
          width: constraints.maxWidth * 0.75,
          height: constraints.maxWidth * 1,
          child: latlng == null
              ? ShowProgress()
              : GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: latlng!,
                    zoom: 15,
                  ),
                  onMapCreated: (controller) {},
                  markers: <Marker>[
                    Marker(
                      markerId: MarkerId('id'),
                      position: latlng!,
                      infoWindow: InfoWindow(
                          title: 'คุณอยู่ที่นี่',
                          snippet:
                              'lat = ${latlng!.latitude}, lng = ${latlng!.longitude}'),
                    ),
                  ].toSet(),
                ),
        ),
      ],
    );
  }

  Row buildname(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 16),
          width: constraints.maxWidth * 0.6,
          child: TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please Fill Name';
              } else {
                return null;
              }
            },
            controller: nameController,
            decoration: InputDecoration(
              labelText: 'Name :',
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }

  ShowTitle buildtitle(String title) {
    return ShowTitle(
      title: title,
      textStyle: MyConstant().h2Style(),
    );
  }
}
