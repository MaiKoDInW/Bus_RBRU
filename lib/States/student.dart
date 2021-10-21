import 'dart:convert';

import 'package:bus_rbru/bodys/show_address.dart';
import 'package:bus_rbru/bodys/show_bustime.dart';
import 'package:bus_rbru/bodys/show_map.dart';
import 'package:bus_rbru/bodys/show_edit_user.dart';
import 'package:bus_rbru/models/user_model.dart';

import 'package:bus_rbru/utility/my_constant.dart';
import 'package:bus_rbru/widgets/show_progress.dart';
import 'package:bus_rbru/widgets/show_signout.dart';
import 'package:bus_rbru/widgets/show_title.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Student extends StatefulWidget {
  const Student({Key? key}) : super(key: key);

  @override
  _StudentState createState() => _StudentState();
}

class _StudentState extends State<Student> {
  List<Widget> widgets = [
    // ShowBusTime(),
    // ShowAddress(),
    ShowMap(),
    // ShowMapFindLatLng(),
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
          // widgets.add(ShowMap());
          widgets.add(ShowEditUser(userModel: userModel!));
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student'),
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
                      // showbustime(),
                      // showaddress(),
                      showmap(),
                      showedituser(),
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
          /* gradient: RadialGradient(
              colors: [MyConstant.dart, MyConstant.mai],
              center: Alignment(-0.8, -0.2),
              radius: 0.8),*/
        ),
        currentAccountPicture: CircleAvatar(
          backgroundImage:
              NetworkImage('${MyConstant.domain}${userModel?.avatar}'),
        ),
        accountName: Text(userModel == null ? 'Name' : userModel!.name),
        accountEmail: Text(userModel == null ? 'Type' : userModel!.type));
  }

  /*ListTile showbustime() {
    return ListTile(
      onTap: () {
        setState(() {
          indexWidget = 0;
          Navigator.pop(context);
        });
      },
      leading: Icon(Icons.filter_1),
      title: ShowTitle(
        title: 'Bus Time',
        textStyle: MyConstant().h2Style(),
      ),
      subtitle: ShowTitle(
        title: 'เเสดงรายระเอียดเวลาของรถบัส',
        textStyle: MyConstant().h3Style(),
      ),
    );
  }

  ListTile showaddress() {
    return ListTile(
      onTap: () {
        setState(() {
          indexWidget = 1;
          Navigator.pop(context);
        });
      },
      leading: Icon(Icons.filter_2),
      title: ShowTitle(
        title: 'Address',
        textStyle: MyConstant().h2Style(),
      ),
      subtitle: ShowTitle(
        title: 'เเสดงรายละเอียดที่อยู่ของคุณ',
        textStyle: MyConstant().h3Style(),
      ),
    );
  }*/

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
        title: 'Google Map',
        textStyle: MyConstant().h2Style(),
      ),
      subtitle: ShowTitle(
        title: 'เเสดงรายละเอียดแผนที่ของ Google',
        textStyle: MyConstant().h3Style(),
      ),
    );
  }

  ListTile showedituser() {
    return ListTile(
      onTap: () {
        setState(() {
          indexWidget = 1;
          Navigator.pop(context);
        });
      },
      leading: Icon(Icons.filter_2),
      title: ShowTitle(
        title: 'User Account',
        textStyle: MyConstant().h2Style(),
      ),
      subtitle: ShowTitle(
        title: 'เเสดงรายละเอียดของข้อมูลที่สมัครสมาชิก',
        textStyle: MyConstant().h3Style(),
      ),
    );
  }
}
