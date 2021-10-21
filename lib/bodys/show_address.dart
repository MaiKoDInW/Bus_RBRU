import 'dart:convert';
//import 'dart:html';

import 'package:bus_rbru/States/Edit_address.dart';
import 'package:bus_rbru/models/address_model.dart';
import 'package:bus_rbru/utility/my_constant.dart';
import 'package:bus_rbru/widgets/show_image.dart';
import 'package:bus_rbru/widgets/show_progress.dart';
import 'package:bus_rbru/widgets/show_title.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowAddress extends StatefulWidget {
  const ShowAddress({Key? key}) : super(key: key);

  @override
  _ShowAddressState createState() => _ShowAddressState();
}

class _ShowAddressState extends State<ShowAddress> {
  bool load = true;
  bool? haveData;
  List<AddressModel> addressModels = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadValueFromAPI();
  }

  Future<Null> loadValueFromAPI() async {
    if (addressModels.length != 0) {
      addressModels.clear();
    }

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String id = preferences.getString('id')!;

    String apiGetAddressWhereIdUser =
        '${MyConstant.domain}/busrbru/getAddressWhereIdUser.php?isAdd=true&idStudent=$id';
    await Dio().get(apiGetAddressWhereIdUser).then((value) {
      // print('value ==> $value');

      if (value.toString() == 'null') {
        // No Data
        setState(() {
          load = false;
          haveData = false;
        });
      } else {
        // Have Data
        for (var item in json.decode(value.data)) {
          AddressModel model = AddressModel.fromMap(item);
          print('name User ==> ${model.name}');

          setState(() {
            load = false;
            haveData = true;
            addressModels.add(model);
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: load
          ? ShowProgress()
          : haveData!
              ? LayoutBuilder(
                  builder: (context, constraints) => buildListView(constraints),
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ShowTitle(
                          title: 'No Address',
                          textStyle: MyConstant().h1Style()),
                      ShowTitle(
                          title: 'Please Add Address',
                          textStyle: MyConstant().h2Style())
                    ],
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: MyConstant.mai,
        onPressed: () =>
            Navigator.pushNamed(context, MyConstant.routeAddAress).then(
          (value) => loadValueFromAPI(),
        ),
        child: Text('Add'),
      ),
    );
  }

  String createUrl(String string) {
    String result = string.substring(1, string.length - 1);
    List<String> strings = result.split(',');
    String url = '${MyConstant.domain}/busrbru${strings[0]}';

    return url;
  }

  ListView buildListView(BoxConstraints constraints) {
    return ListView.builder(
      itemCount: addressModels.length,
      itemBuilder: (context, index) => Card(
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(4),
              width: constraints.maxWidth * 0.5 - 4,
              height: constraints.maxWidth * 0.5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ShowTitle(
                    title: addressModels[index].name,
                    textStyle: MyConstant().h2Style(),
                  ),
                  Container(
                    width: constraints.maxWidth * 0.5,
                    height: constraints.maxWidth * 0.4,
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: createUrl(addressModels[index].images),
                      placeholder: (context, url) => ShowProgress(),
                      errorWidget: (context, url, error) =>
                          ShowImage(path: MyConstant.image1),
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              padding: EdgeInsets.all(4),
              width: constraints.maxWidth * 0.5 - 4,
              height: constraints.maxWidth * 0.4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShowTitle(
                      title: 'สาขา ${addressModels[index].faculty}',
                      textStyle: MyConstant().h3Style()),
                  ShowTitle(
                      title: 'ตึก ${addressModels[index].building}',
                      textStyle: MyConstant().h3Style()),
                  ShowTitle(
                      title: 'เวลา ${addressModels[index].time}',
                      textStyle: MyConstant().h3Style()),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                          onPressed: () {
                            print('## Click Edit');
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditAddress(
                                    addressModel: addressModels[index],
                                  ),
                                )).then((value) => loadValueFromAPI());
                          },
                          icon: Icon(
                            Icons.edit_outlined,
                            size: 25,
                            color: MyConstant.dart,
                          )),
                      IconButton(
                          onPressed: () {
                            print('## You Click Delete From index = $index');
                            confirmDialogDelete(addressModels[index]);
                          },
                          icon: Icon(
                            Icons.delete_outline,
                            size: 25,
                            color: MyConstant.dart,
                          )),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Null> confirmDialogDelete(AddressModel addressModel) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: ListTile(
          leading: CachedNetworkImage(
            imageUrl: createUrl(addressModel.images),
            placeholder: (context, url) => ShowAddress(),
          ),
          title: ShowTitle(
            title: 'Delete ${addressModel.name} ?',
            textStyle: MyConstant().h2Style(),
          ),
          subtitle: ShowTitle(
            title: 'สถานที่ ${addressModel.building}',
            textStyle: MyConstant().h3Style(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              print('## Confirm Delete at id ==> ${addressModel.id}');
              String apiDeleteAddressWhereId =
                  '${MyConstant.domain}/busrbru/deleteAddressWhereId.php?isAdd=true&id=${addressModel.id}';
              await Dio().get(apiDeleteAddressWhereId).then((value) {
                Navigator.pop(context);
                loadValueFromAPI();
              });
            },
            child: Text('Delete'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cencel'),
          ),
        ],
      ),
    );
  }
}
