import 'package:bus_rbru/States/Edit_profile_driver.dart';
import 'package:bus_rbru/States/add_address_user.dart';
import 'package:bus_rbru/States/authen.dart';
import 'package:bus_rbru/States/create_account.dart';
import 'package:bus_rbru/States/driver.dart';
import 'package:bus_rbru/States/edit_profile_user.dart';
import 'package:bus_rbru/States/student.dart';

import 'package:bus_rbru/utility/my_constant.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

final Map<String, WidgetBuilder> map = {
  '/authen': (BuildContext context) => Authen(),
  '/createaccount': (BuildContext context) => CreateAccount(),
  '/student': (BuildContext context) => Student(),
  '/driver': (BuildContext context) => Driver(),
  '/addaddress': (BuildContext context) => AddAddress(),
  '/editprofileuser': (BuildContext context) => EditProfileUser(),
  '/editprofiledriver': (BuildContext context) => EditProfileDriver(),
};

String? initlalRoute;

Future<Null> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String? type = preferences.getString('type');
  print('### type = $type');
  if (type?.isEmpty ?? true) {
    initlalRoute = MyConstant.routeAuthen;
    runApp(Myapp());
  } else {
    switch (type) {
      case 'Student':
        initlalRoute = MyConstant.routeStudent;
        runApp(Myapp());
        break;
      case 'Driver':
        initlalRoute = MyConstant.routeDriver;
        runApp(Myapp());
        break;
      default:
    }
  }
}

class Myapp extends StatelessWidget {
  const Myapp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MaterialColor materialColor =
        MaterialColor(0xffffff56, MyConstant.mapMaterialColor);
    return MaterialApp(
      title: MyConstant.appName,
      routes: map,
      initialRoute: initlalRoute,
      //theme: ThemeData(primarySwatch: materialColor),
    );
  }
}
