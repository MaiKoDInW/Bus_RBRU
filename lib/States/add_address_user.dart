import 'dart:io';
import 'dart:math';

import 'package:bus_rbru/utility/my_constant.dart';
import 'package:bus_rbru/utility/my_dialog.dart';
import 'package:bus_rbru/widgets/show_image.dart';
import 'package:bus_rbru/widgets/show_title.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddAddress extends StatefulWidget {
  const AddAddress({Key? key}) : super(key: key);

  @override
  _AddAddressState createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  final formKey = GlobalKey<FormState>();
  List<File?> files = [];
  File? file;
  TextEditingController nameContrroller = TextEditingController();
  TextEditingController facultyContrroller = TextEditingController();
  TextEditingController timeContrroller = TextEditingController();
  TextEditingController buildingContrroller = TextEditingController();

  List<String> paths = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialFile();
  }

  void initialFile() {
    for (var i = 0; i < 2; i++) {
      files.add(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () => processAddress(), icon: Icon(Icons.cloud_upload))
        ],
        title: Text('Add addreess'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) => GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          behavior: HitTestBehavior.opaque,
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    buildAddName(constraints),
                    buildAddFaculty(constraints),
                    buildAddbuilding(constraints),
                    buildAddTime(constraints),
                    buildimagebus(constraints),
                    buildaddbutton(constraints),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container buildaddbutton(BoxConstraints constraints) {
    return Container(
      width: constraints.maxWidth * 0.75,
      child: ElevatedButton(
        style: MyConstant().myByyonStyle(),
        onPressed: () {
          processAddress();
        },
        child: Text('add Address'),
      ),
    );
  }

  Future<Null> processAddress() async {
    if (formKey.currentState!.validate()) {
      bool checkFile = true;
      for (var item in files) {
        if (item == null) {
          checkFile = false;
        }
      }
      if (checkFile) {
        // print('## choose 2 image success');

        MyDialog().showProgressDiolog(context);

        String apiSaveImageAddress =
            '${MyConstant.domain}/busrbru/saveimageaddress.php';
        // print('### apisaveimageaddress == $apiSaveImageAddress');
        int loop = 0;
        for (var item in files) {
          int i = Random().nextInt(1000000);
          String nameFile = 'imageaddress$i.jpg';

          paths.add('/imageaddress/$nameFile');

          Map<String, dynamic> map = {};
          map['file'] =
              await MultipartFile.fromFile(item!.path, filename: nameFile);
          FormData data = FormData.fromMap(map);
          await Dio().post(apiSaveImageAddress, data: data).then((value) async {
            print('Upload Succress');
            loop++;
            if (loop >= files.length) {
              SharedPreferences preferences =
                  await SharedPreferences.getInstance();

              String idStudent = preferences.getString('id')!;
              String nameStudent = preferences.getString('name')!;
              String name = nameContrroller.text;
              String faculty = facultyContrroller.text;
              String time = timeContrroller.text;
              String building = buildingContrroller.text;
              String images = paths.toString();
              print('### idStudent = $idStudent, nameStudent = $nameStudent');
              print(
                  '### name = $name, faculty = $faculty, time = $time, buiding = $building');
              print('### image ==> $images');

              String path =
                  '${MyConstant.domain}/busrbru/insertAddress.php?isAdd=true&idStudent=$idStudent&nameStudent=$nameStudent&name=$name&faculty=$faculty&time=$time&building=$building&images=$images';

              await Dio().get(path).then((value) => Navigator.pop(context));

              Navigator.pop(context);
            }
          });
        }
      } else {
        MyDialog()
            .normalDialog(context, 'More Image', 'Please Choose More Image');
      }
    }
  }

  Future<Null> processImagePicker(ImageSource source, index) async {
    try {
      // ignore: deprecated_member_use
      var result = await ImagePicker().getImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
      );
      // files[index] = File(result!.path);
      setState(() {
        file = File(result!.path);
        files[index] = file;
      });
    } catch (e) {}
  }

  Future<Null> chooseSourceImageDialog(int index) async {
    print('Click form index ==>> $index');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: ListTile(
          leading: ShowImage(path: MyConstant.image2),
          title: ShowTitle(
              title: 'Image ${index + 1} ?', textStyle: MyConstant().h2Style()),
          subtitle:
              ShowTitle(title: 'title', textStyle: MyConstant().h3Style()),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  processImagePicker(ImageSource.camera, index);
                },
                child: Text('camera'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  processImagePicker(ImageSource.gallery, index);
                },
                child: Text('gallery'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Column buildimagebus(BoxConstraints constraints) {
    return Column(
      children: [
        Container(
          width: constraints.maxWidth * 0.5,
          height: constraints.maxWidth * 0.5,
          child: file == null
              ? Image.asset(MyConstant.image6)
              : Image.file(
                  file!,
                  fit: BoxFit.cover,
                ),
        ),
        Container(
          width: constraints.maxWidth * 0.6,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 48,
                height: 48,
                child: InkWell(
                  onTap: () => chooseSourceImageDialog(0),
                  child: files[0] == null
                      ? Image.asset(MyConstant.image1)
                      : Image.file(files[0]!),
                ),
              ),
              Container(
                width: 48,
                height: 48,
                child: InkWell(
                  onTap: () => chooseSourceImageDialog(1),
                  child: files[1] == null
                      ? Image.asset(MyConstant.image2)
                      : Image.file(files[1]!),
                ),
              ),

              /* Container(
                width: 48,
                height: 48,
                child: InkWell(
                  onTap: () => chooseSourceImageDialog(2),
                  child: Image.asset(MyConstant.image3),
                ),
              ),
              Container(
                width: 48,
                height: 48,
                child: InkWell(
                  onTap: () => chooseSourceImageDialog(3),
                  child: Image.asset(MyConstant.image4),
                ),
              ),*/
            ],
          ),
        ),
      ],
    );
  }

  Widget buildAddName(BoxConstraints constraints) {
    return Container(
      width: constraints.maxWidth * 0.75,
      margin: EdgeInsets.only(top: 16),
      child: TextFormField(
        controller: nameContrroller,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please Fill Name in Blank';
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
          labelStyle: MyConstant().h3Style(),
          labelText: 'ชื่อ :',
          prefixIcon: Icon(
            Icons.person,
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
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide(color: Colors.red),
          ),
        ),
      ),
    );
  }

  Widget buildAddFaculty(BoxConstraints constraints) {
    return Container(
      width: constraints.maxWidth * 0.75,
      margin: EdgeInsets.only(top: 16),
      child: TextFormField(
        controller: facultyContrroller,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please Fill Faculty in Blank';
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
          labelStyle: MyConstant().h3Style(),
          labelText: 'สาขา/คณะ :',
          prefixIcon: Icon(
            Icons.person,
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
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide(color: Colors.red),
          ),
        ),
      ),
    );
  }

  Widget buildAddTime(BoxConstraints constraints) {
    return Container(
      width: constraints.maxWidth * 0.75,
      margin: EdgeInsets.only(top: 16),
      child: TextFormField(
        controller: timeContrroller,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please Fill Time in Blank';
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
          labelStyle: MyConstant().h3Style(),
          labelText: 'เวลา :',
          prefixIcon: Icon(
            Icons.person,
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
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide(color: Colors.red),
          ),
        ),
      ),
    );
  }

  Widget buildAddbuilding(BoxConstraints constraints) {
    return Container(
      width: constraints.maxWidth * 0.75,
      margin: EdgeInsets.only(top: 16),
      child: TextFormField(
        controller: buildingContrroller,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please Fill Building in Blank';
          } else {
            return null;
          }
        },
        maxLines: 3,
        decoration: InputDecoration(
          labelStyle: MyConstant().h3Style(),
          labelText: 'ตึก/อาคาร :',
          prefixIcon: Icon(
            Icons.person,
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
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide(color: Colors.red),
          ),
        ),
      ),
    );
  }
}
