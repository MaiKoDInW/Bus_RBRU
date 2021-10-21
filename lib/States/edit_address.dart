//import 'dart:html';

import 'dart:io';
import 'dart:math';

import 'package:bus_rbru/models/address_model.dart';
import 'package:bus_rbru/utility/my_constant.dart';
import 'package:bus_rbru/utility/my_dialog.dart';
import 'package:bus_rbru/widgets/show_progress.dart';
import 'package:bus_rbru/widgets/show_title.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditAddress extends StatefulWidget {
  final AddressModel addressModel;
  const EditAddress({Key? key, required this.addressModel}) : super(key: key);

  @override
  _EditAddressState createState() => _EditAddressState();
}

class _EditAddressState extends State<EditAddress> {
  AddressModel? addressModel;
  TextEditingController nameController = TextEditingController();
  TextEditingController facultyController = TextEditingController();
  TextEditingController buildingController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  List<String> pathImage = [];
  List<File?> files = [];
  bool statusImage = false; //false => not change Image

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addressModel = widget.addressModel;
    // print('### image from MysQl ==>> ${addressModel!.images}');
    convertStringToArray();
    nameController.text = addressModel!.name;
    facultyController.text = addressModel!.faculty;
    buildingController.text = addressModel!.building;
    timeController.text = addressModel!.time;
  }

  void convertStringToArray() {
    String string = addressModel!.images;
    // print('string ก่อนตัด ==>> $string');
    string = string.substring(1, string.length - 1);
    // print('string หลังตัด ==>> $string');
    List<String> strings = string.split(',');
    for (var item in strings) {
      pathImage.add(item.trim());
      files.add(null);
    }

    print('## pathImage ==>> $pathImage');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit Address'),
          actions: [
            IconButton(
              onPressed: () => processEdit(),
              icon: Icon(Icons.edit),
              tooltip: 'Edit Address',
            ),
          ],
        ),
        body: LayoutBuilder(
          builder: (context, constraints) => Center(
            child: SingleChildScrollView(
              child: GestureDetector(
                onTap: () =>
                    FocusScope.of(context).requestFocus(FocusScopeNode()),
                behavior: HitTestBehavior.opaque,
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildTitle('General :'),
                      buildName(constraints),
                      buildfaculty(constraints),
                      buildbuilding(constraints),
                      buildTime(constraints),
                      buildTitle('Image Address :'),
                      buildImage(constraints, 0),
                      buildImage(constraints, 1),
                      buildEditAddress(constraints),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  Container buildEditAddress(BoxConstraints constraints) {
    return Container(
      margin: EdgeInsets.only(top: 16),
      width: constraints.maxWidth,
      child: ElevatedButton.icon(
          onPressed: () => processEdit(),
          icon: Icon(Icons.edit),
          label: Text('Edit Address')),
    );
  }

  Future<Null> chooseImage(int index, ImageSource source) async {
    try {
      // ignore: deprecated_member_use
      var result = await ImagePicker().getImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
      );
      setState(() {
        files[index] = File(result!.path);
        statusImage = true;
      });
    } catch (e) {}
  }

  Container buildImage(BoxConstraints constraints, int index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => chooseImage(index, ImageSource.camera),
            icon: Icon(Icons.add_a_photo),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 8),
            width: constraints.maxWidth * 0.5,
            child: files[index] == null
                ? CachedNetworkImage(
                    imageUrl:
                        '${MyConstant.domain}/busrbru/${pathImage[index]}',
                    placeholder: (context, url) => ShowProgress(),
                  )
                : Image.file(files[index]!),
          ),
          IconButton(
            onPressed: () => chooseImage(index, ImageSource.gallery),
            icon: Icon(Icons.add_photo_alternate),
          ),
        ],
      ),
    );
  }

  Row buildName(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: constraints.maxWidth * 0.75,
          child: TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please Fill Name in Blank';
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

  Row buildfaculty(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 16),
          width: constraints.maxWidth * 0.75,
          child: TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please Fill Faculty';
              } else {
                return null;
              }
            },
            controller: facultyController,
            decoration: InputDecoration(
              labelText: 'faculty :',
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }

  Row buildbuilding(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: constraints.maxWidth * 0.75,
          child: TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please Fill Building';
              } else {
                return null;
              }
            },
            controller: buildingController,
            decoration: InputDecoration(
              labelText: 'building :',
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }

  Row buildTime(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 16),
          width: constraints.maxWidth * 0.75,
          child: TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please Fill Time';
              } else {
                return null;
              }
            },
            controller: timeController,
            decoration: InputDecoration(
              labelText: 'Time :',
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }

  Row buildTitle(String title) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ShowTitle(
            title: title,
            textStyle: MyConstant().h2Style(),
          ),
        ),
      ],
    );
  }

  Future<Null> processEdit() async {
    if (formKey.currentState!.validate()) {
      MyDialog().showProgressDiolog(context);

      String name = nameController.text;
      String faculty = facultyController.text;
      String building = buildingController.text;
      String time = timeController.text;
      String id = addressModel!.id;
      String images;
      if (statusImage) {
        // upload Image and Refresh array pathImages
        int index = 0;
        for (var item in files) {
          if (item != null) {
            int i = Random().nextInt(100000);
            String nameImage = 'addressEdit$i.jpg';
            String apiUploadImage =
                '${MyConstant.domain}/busrbru/saveimageaddress.php';

            Map<String, dynamic> map = {};
            map['file'] =
                await MultipartFile.fromFile(item.path, filename: nameImage);
            FormData formData = FormData.fromMap(map);
            await Dio().post(apiUploadImage, data: formData).then((value) {
              pathImage[index] = '/imageaddress/$nameImage';
            });
          }
          index++;
        }

        images = pathImage.toString();
        Navigator.pop(context);
      } else {
        images = pathImage.toString();
        Navigator.pop(context);
      }

      print('## statusImage = $statusImage');
      print(
          '## id = $id,name = $name, faculty = $faculty, building = $building, time = $time');
      print('### images = $images');

      String apiEditaddress =
          '${MyConstant.domain}/busrbru/editAddressWhereId.php?isAdd=true&id=$id&name=$name&faculty=$faculty&time=$time&building=$building&images=$images';
      await Dio().get(apiEditaddress).then((value) => Navigator.pop(context));
    }
  }
}
