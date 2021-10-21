import 'dart:io';
import 'dart:math';

import 'package:bus_rbru/utility/my_constant.dart';
import 'package:bus_rbru/utility/my_dialog.dart';
import 'package:bus_rbru/widgets/show_image.dart';
import 'package:bus_rbru/widgets/show_progress.dart';
import 'package:bus_rbru/widgets/show_title.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({Key? key}) : super(key: key);

  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  String? typeUser;
  String avatar = '';
  File? file;
  double? lat, lng;
  final formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController userController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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

  Row buildName(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 16),
          width: size * 0.6,
          child: TextFormField(
            controller: nameController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'กรุณาหรอก Name ด้วยครับ';
              } else {}
            },
            decoration: InputDecoration(
              labelStyle: MyConstant().h3Style(),
              labelText: 'Name :',
              prefixIcon: Icon(
                Icons.fingerprint_sharp,
                //color: MyConstant.dart,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyConstant.dart),
                borderRadius: BorderRadius.circular(50),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: BorderSide(color: MyConstant.light),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row buildAddress(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 16),
          width: size * 0.6,
          child: TextFormField(
            controller: addressController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'กรุณาหรอก Address ด้วยครับ';
              } else {}
            },
            maxLines: 3,
            decoration: InputDecoration(
              labelStyle: MyConstant().h3Style(),
              labelText: 'Address :',
              hintStyle: MyConstant().h3Style(),
              prefixIcon: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Icon(
                  Icons.home_filled,
                  //color: MyConstant.dart,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyConstant.dart),
                borderRadius: BorderRadius.circular(50),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: BorderSide(color: MyConstant.light),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row buildPhone(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 16),
          width: size * 0.6,
          child: TextFormField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value!.isEmpty) {
                return 'กรุณาหรอก Phone ด้วยครับ';
              } else {}
            },
            decoration: InputDecoration(
              labelStyle: MyConstant().h3Style(),
              labelText: 'Phone :',
              prefixIcon: Icon(
                Icons.phone,
                //color: MyConstant.dart,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyConstant.dart),
                borderRadius: BorderRadius.circular(50),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: BorderSide(color: MyConstant.light),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row buildUser(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 16),
          width: size * 0.6,
          child: TextFormField(
            controller: userController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'กรุณาหรอก User ด้วยครับ';
              } else {}
            },
            decoration: InputDecoration(
              labelStyle: MyConstant().h3Style(),
              labelText: 'User :',
              prefixIcon: Icon(
                Icons.perm_contact_cal,
                //color: MyConstant.dart,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyConstant.dart),
                borderRadius: BorderRadius.circular(50),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: BorderSide(color: MyConstant.light),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row buildPassword(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 16),
          width: size * 0.6,
          child: TextFormField(
            controller: passwordController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'กรุณาหรอก Password ด้วยครับ';
              } else {}
            },
            decoration: InputDecoration(
              labelStyle: MyConstant().h3Style(),
              labelText: 'Password :',
              prefixIcon: Icon(
                Icons.password_outlined,
                //color: MyConstant.dart,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyConstant.dart),
                borderRadius: BorderRadius.circular(50),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: BorderSide(color: MyConstant.light),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        actions: [buildCreateNewAccount()],
        title: Text('Create New Account'),
        backgroundColor: MyConstant.mai,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        behavior: HitTestBehavior.opaque,
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                buildTitle('ข้อมูลทั่วไป :'),
                buildName(size),
                buildTitle('ชนิดของผู้ใช้งาน :'),
                buildRadioStudent(size),
                buildRadioDriver(size),
                buildTitle('ข้อมูลพื้นฐาน :'),
                buildAddress(size),
                buildPhone(size),
                buildUser(size),
                buildPassword(size),
                buildTitle('รูปภาพ :'),
                buildSubtitle(),
                buildAvatar(size),
                buildTitle('เเสดงพิกัดที่คุณอยู่ :'),
                buildMap(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconButton buildCreateNewAccount() {
    return IconButton(
      onPressed: () {
        if (formKey.currentState!.validate()) {
          if (typeUser == null) {
            print('Non Choose Type');
            MyDialog().normalDialog(context, 'ยังไม่ได้เลือกชนิดของ User',
                'กรุณาเลือกชนิดของ User ที่ต้องการ');
          } else {
            print('Process Insent to database');
            uploadPictureAndInsertData();
          }
        }
      },
      icon: Icon(Icons.cloud_upload),
    );
  }

  Future<Null> uploadPictureAndInsertData() async {
    String name = nameController.text;
    String address = addressController.text;
    String phone = phoneController.text;
    String user = userController.text;
    String password = passwordController.text;
    print(
        '## name= $name, address = $address, phone = $phone, user = $user, password = $password');
    String path =
        '${MyConstant.domain}/busrbru/getUserWhereUser.php?isAdd=true&user=$user';
    await Dio().get(path).then((value) async {
      print('## value ==>> $value');
      if (value.toString() == 'null') {
        print('User OK');
        if (file == null) {
          // No Avatar
          processInsertMySQL(
            name: name,
            address: address,
            phone: phone,
            user: user,
            password: password,
          );
        } else {
          // Hava Avatar
          print('### process Upload Avatar');
          String apiSaveAvatar = '${MyConstant.domain}/busrbru/saveAvatar.php';
          int i = Random().nextInt(100000);
          String nameAvatar = 'avatar$i.jpg';
          Map<String, dynamic> map = Map();
          map['file'] =
              await MultipartFile.fromFile(file!.path, filename: nameAvatar);
          FormData data = FormData.fromMap(map);
          await Dio().post(apiSaveAvatar, data: data).then((value) {
            avatar = '/busrbru/avatar/$nameAvatar';
            processInsertMySQL(
              name: name,
              address: address,
              phone: phone,
              user: user,
              password: password,
            );
          });
        }
      } else {
        MyDialog().normalDialog(context, 'User False ! ', 'Please change User');
      }
    });
  }

  Future<Null> processInsertMySQL(
      {String? name,
      String? address,
      String? phone,
      String? user,
      String? password}) async {
    print('### processInsertMySQL Work and avatar ==>> $avatar');
    String apiInsertUser =
        '${MyConstant.domain}/busrbru/insertUser.php?isAdd=true&name=$name&type=$typeUser&address=$address&phone=$phone&user=$user&password=$password&avatar=$avatar&lat=$lat&lng=$lng';
    await Dio().get(apiInsertUser).then((value) {
      if (value.toString() == 'true') {
        Navigator.pop(context);
      } else {
        MyDialog().normalDialog(
            context, 'Create New User False !!!', 'Please Try Again');
      }
    });
  }

  Set<Marker> setMarker() => <Marker>[
        Marker(
          markerId: MarkerId('id'),
          position: LatLng(lat!, lng!),
          infoWindow: InfoWindow(
              title: 'คุณอยู่ที่นี่', snippet: 'Lat = $lat, Lng = $lng'),
        ),
      ].toSet();

  Widget buildMap() => Container(
        width: 370,
        height: 200,
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
      );

  Future<Null> chooseImage(ImageSource source) async {
    try {
      // ignore: deprecated_member_use
      var result = await ImagePicker().getImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
      );
      setState(() {
        file = File(result!.path);
      });
    } catch (e) {}
  }

  Row buildAvatar(double size) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () => chooseImage(ImageSource.camera),
          icon: Icon(
            Icons.add_a_photo,
            size: 36,
            color: MyConstant.dart,
          ),
        ),
        Container(
            margin: EdgeInsets.symmetric(vertical: 16),
            width: size * 0.6,
            child: file == null
                ? ShowImage(path: MyConstant.image5)
                : Image.file(file!)),
        IconButton(
          onPressed: () => chooseImage(ImageSource.gallery),
          icon: Icon(
            Icons.add_photo_alternate,
            size: 36,
            color: MyConstant.dart,
          ),
        ),
      ],
    );
  }

  ShowTitle buildSubtitle() {
    return ShowTitle(
        title:
            'รูปภาพที่เเสดงถึงผู้ใช้งาน (ถ้าไม่เลือกรูปภาพ เราจะเเสดงภาพพื้นฐานเเทน)',
        textStyle: MyConstant().h3Style());
  }

  Row buildRadioStudent(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: size * 0.6,
          child: RadioListTile(
            value: 'Student',
            groupValue: typeUser,
            onChanged: (value) {
              setState(() {
                typeUser = value as String?;
              });
            },
            title: ShowTitle(
              title: 'นักศึกษา (Student)',
              textStyle: MyConstant().h3Style(),
            ),
          ),
        ),
      ],
    );
  }

  Row buildRadioDriver(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: size * 0.6,
          child: RadioListTile(
            value: 'Driver',
            groupValue: typeUser,
            onChanged: (value) {
              setState(() {
                typeUser = value as String?;
              });
            },
            title: ShowTitle(
              title: 'คนขับรถ (Driver)',
              textStyle: MyConstant().h3Style(),
            ),
          ),
        ),
      ],
    );
  }

  Container buildTitle(String title) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16),
      child: ShowTitle(
        title: title,
        textStyle: MyConstant().h2Style(),
      ),
    );
  }
}
