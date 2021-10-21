import 'dart:convert';

import 'package:bus_rbru/bodys/show_auto_time.dart';
import 'package:bus_rbru/bodys/show_map_driver.dart';
import 'package:bus_rbru/models/user_model.dart';
import 'package:bus_rbru/utility/my_constant.dart';
import 'package:bus_rbru/widgets/show_progress.dart';
import 'package:bus_rbru/widgets/show_signout.dart';
import 'package:bus_rbru/widgets/show_title.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Driver extends StatefulWidget {
  const Driver({Key? key}) : super(key: key);

  @override
  _DriverState createState() => _DriverState();
}

class _DriverState extends State<Driver> {
  List<Widget> widgets = [
    // ShowBusTime(),
    // ShowAddress(),
    // ShowMap(),
    // ShowMapFindLatLng(),
    ShowMapDriver(),
    // ShowAutoTime(),
  ];
  int indexWidget = 0;
  UserModel? userModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findUserModel();
  }

  Future<Null> findUserModel() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String id = preferences.getString('id')!;
    print('## id login ==> $id');
    String apiGetUserWhereId =
        '${MyConstant.domain}/busrbru/getUserWhereId.php?isAdd=true&id=$id';
    await Dio().get(apiGetUserWhereId).then((value) {
      print('## value ==> $value');
      for (var item in json.decode(value.data)) {
        setState(() {
          userModel = UserModel.fromMap(item);

          // widgets.add(ShowBusTime());
          // widgets.add(ShowAddress());
          // widgets.add(ShowMapDriver());
          widgets.add(ShowAutoTime(userModel: userModel!));
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Driver'),
      ),
      drawer: widgets.length == 0
          ? SizedBox()
          : Drawer(
              child: Stack(
                children: [
                  ShowSignOut(),
                  Column(
                    children: [
                      buildhead(),
                      showmap(),
                      showautotime(),
                    ],
                  ),
                ],
              ),
            ),
      body: widgets.length == 0 ? ShowProgress() : widgets[indexWidget],
    );
  }

  UserAccountsDrawerHeader buildhead() {
    return UserAccountsDrawerHeader(
        otherAccountsPictures: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.emoji_emotions_outlined),
            iconSize: 40,
            color: Colors.yellow[500],
            tooltip: 'Good Luck',
          )
        ],
        decoration: BoxDecoration(
          color: Colors.cyan[400],
        ),
        currentAccountPicture: CircleAvatar(
          backgroundImage:
              NetworkImage('${MyConstant.domain}${userModel?.avatar}'),
        ),
        accountName: Text(userModel == null ? 'Name' : userModel!.name),
        accountEmail: Text(userModel == null ? 'Type' : userModel!.type));
  }

  ListTile showmap() {
    return ListTile(
      onTap: () {
        setState(() {
          indexWidget = 0;
          Navigator.pop(context);
        });
      },
      leading: Icon(Icons.filter_1),
      title: ShowTitle(
        title: 'Map Driver',
        textStyle: MyConstant().h2Style(),
      ),
      subtitle: ShowTitle(
        title: 'เเสดงพิกัด GPS ที่อยู่ปัจจุบัน',
        textStyle: MyConstant().h3Style(),
      ),
    );
  }

  ListTile showautotime() {
    return ListTile(
      onTap: () {
        setState(() {
          indexWidget = 1;
          Navigator.pop(context);
        });
      },
      leading: Icon(Icons.filter_2),
      title: ShowTitle(
        title: 'Showautotime',
        textStyle: MyConstant().h2Style(),
      ),
      subtitle: ShowTitle(
        title: '-',
        textStyle: MyConstant().h3Style(),
      ),
    );
  }
}
