import 'package:flutter/material.dart';

class MyConstant {
  // Genernal
  static String appName = 'RBRU Shuttle Bus';
  static String domain =
      'http://9c30-2001-fb1-13c-9590-91bf-eaa7-d6ed-5651.ngrok.io';

  // Route
  static String routeAuthen = '/authen';
  static String routeCreateAccount = '/createaccount';
  static String routeStudent = '/student';
  static String routeDriver = '/driver';
  static String routeAddAress = '/addaddress';
  static String routeEditProfileUser = '/editprofileuser';
  static String routeEditProfileDriver = '/editprofiledriver';

  // Image
  static String image1 = 'images/image1.png';
  static String image2 = 'images/image2.png';
  static String image3 = 'images/image3.png';
  static String image4 = 'images/image4.png';
  static String image5 = 'images/avatar.png';
  static String image6 = 'images/Bus car.png';

  // color
  static Color primary = Color(0xfffea00);
  static Color dart = Color(0xffc7b800);
  static Color light = Color(0xffffff56);
  static Color mai = Color(0xffffd600);

  static Map<int, Color> mapMaterialColor = {
    50: Color.fromRGBO(255, 255, 214, 0.1),
    100: Color.fromRGBO(255, 255, 214, 0.2),
    200: Color.fromRGBO(255, 255, 214, 0.3),
    300: Color.fromRGBO(255, 255, 214, 0.4),
    400: Color.fromRGBO(255, 255, 214, 0.5),
    500: Color.fromRGBO(255, 255, 214, 0.6),
    600: Color.fromRGBO(255, 255, 214, 0.7),
    700: Color.fromRGBO(255, 255, 214, 0.8),
    800: Color.fromRGBO(255, 255, 214, 0.9),
    900: Color.fromRGBO(255, 255, 214, 1.0),
  };

  // style
  TextStyle h1Style() => TextStyle(
        fontSize: 24,
        color: dart,
        fontWeight: FontWeight.bold,
      );
  TextStyle h2Style() => TextStyle(
        fontSize: 18,
        color: dart,
        fontWeight: FontWeight.w700,
      );
  TextStyle h3Style() => TextStyle(
        fontSize: 14,
        color: dart,
        fontWeight: FontWeight.normal,
      );
  TextStyle h2WhiteStyle() => TextStyle(
        fontSize: 18,
        color: Colors.white,
        fontWeight: FontWeight.w700,
      );
  TextStyle h3WhiteStyle() => TextStyle(
        fontSize: 14,
        color: Colors.white,
        fontWeight: FontWeight.normal,
      );

  // buttonsStyle
  ButtonStyle myByyonStyle() => ElevatedButton.styleFrom(
        //primary: MyConstant.dart,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      );
}
