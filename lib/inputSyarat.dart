import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kelurahan/component/genText.dart';
import 'component/TextFieldLogin.dart';
import 'component/genButton.dart';
import 'component/genColor.dart';
import 'component/genToast.dart';
import 'component/request.dart';

class InputSyarat extends StatefulWidget {
  var id;

  InputSyarat({this.id});

  @override
  _InputSyaratState createState() => _InputSyaratState();
}

class _InputSyaratState extends State<InputSyarat> {
  bool readyToHit = true;
  final req = new GenRequest();

  List idSyarats = [];
  var id, dataSurat;
  List<XFile> _image = [];
  List inputan = [];
  bool isloaded = false;

  Future<XFile> pickImage(id) async {
    final _picker = ImagePicker();

    final XFile pickedFile =
    await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      print('PickedFile: ${pickedFile.toString()}');
      setState(() {
        _image[id] = XFile(pickedFile.path); // Exception occurred here
      });
    } else {
      print('PickedFile: is null');
    }

    print("idSyarats $idSyarats");
    print("gambars $_image");
    if (_image[id] != null) {
      return _image[id];
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final InputSyarat args = ModalRoute
        .of(context)
        .settings
        .arguments;
    id = args.id;

    print("ID NYA $id");
    if (!isloaded) {
      getDetail(id);
      isloaded = true;
    }
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(30),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 30,
            ),
            Text(
              "UPLOAD SYARAT",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 30,
            ),
            dataSurat == null
                ? CircularProgressIndicator()
                : Expanded(
              child: Container(
                child: SingleChildScrollView(
                    child: Column(
                        children: dataSurat["payload"]["syarat"]
                            .map<Widget>((e) {
                          print("index " +
                              dataSurat["payload"]["syarat"]
                                  .indexOf(e)
                                  .toString());
                          var index = dataSurat["payload"]["syarat"].indexOf(e);
                          return Column(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      FloatingActionButton(
                                          mini: true,
                                          child: Icon(Icons.camera_alt),
                                          onPressed: () {
                                            pickImage(index);
                                          }),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      GenText(e["nama"]),
                                    ],
                                  ),
                                  _image[index] == null
                                      ? Container(
                                    height: 50,
                                  )
                                      : Image.file(
                                    File(_image[index].path),
                                    height: 100,
                                    fit: BoxFit.fitWidth,
                                  ),
                                ],
                              ),
                              Divider(),
                              SizedBox(
                                height: 10,
                              )
                            ],
                          );
                        }).toList())),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            readyToHit
                ? GenButton(
              text: "Submit",
              ontap: () {
                tambah();
                // login(email, password);
                // Navigator.pushNamed(context, "base");
              },
            )
                : CircularProgressIndicator(),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  void tambah() async {
    setState(() {
      readyToHit = false;
    });

    Map inputan = {};

    for (int i = 0; i < idSyarats.length; i++) {
      String fileName = _image[i].path
          .split('/')
          .last;

      inputan["syarat[$i]"] = idSyarats[i];
      inputan["gambar[$i]"] =
      await MultipartFile.fromFile(_image[i].path, filename: fileName);
      "gambar[$i]";
    }

    print("INPUTAN $inputan");

    // var jsonInputan = json.decode(inputan.toString());
    dynamic data;
    data = await req.postForm("surat/$id", Map<String, dynamic>.from(inputan));

    print("DATA $data");


    if (data["status"] == 200) {
      toastShow("Berhasil input, silahkan tunggu update dari kami", context,
          Colors.black);
      Navigator.pushReplacementNamed(context, "base");
    } else if (data["code"] == 202) {
      setState(() {
        toastShow(data["payload"]["msg"], context, GenColor.red);
        readyToHit = true;
      });
    } else {
      setState(() {
        toastShow("Terjadi kesalahan coba cek koneksi internet kamu", context,
            GenColor.red);
        readyToHit = true;
      });
    }
  }

  void getDetail(id) async {
    print("GET SURAT $dataSurat");

    dataSurat = await req.getApi("surat/$id");

    var jmlsyarat = dataSurat["payload"]["syarat"].length;

    for (int i = 0; i < jmlsyarat; i++) {
      idSyarats.add(dataSurat["payload"]["syarat"][i]["id"]);
      _image.add(null);
    }
    print("DATA DETAIL $dataSurat");

    setState(() {});
  }
}
