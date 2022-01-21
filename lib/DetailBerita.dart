// ignore: file_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'component/JustHelper.dart';
import 'component/NavDrawer.dart';
import 'component/TextFieldLogin.dart';
import 'component/commonPadding.dart';
import 'component/genButton.dart';
import 'component/genColor.dart';
import 'component/genText.dart';
import 'component/genToast.dart';
import 'component/request.dart';

class DetailBerita extends StatefulWidget {
  final int id;

  DetailBerita({this.id});

  @override
  _DetailBeritaState createState() => _DetailBeritaState();
}

class _DetailBeritaState extends State<DetailBerita>
    with WidgetsBindingObserver {
  final req = new GenRequest();

  bool loading = false;
  bool readyToHit = true;

  // NotifBloc notifbloc;
  bool isLoaded = false;
  String dropdownValue = 'One';
  String keterangan = '';
  var id;
  var dataBerita;

  @override
  void initState() {
    // TODO: implement initState
    // analytics.

    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

//  FUNCTION

//  getClientId() async {
//    clientId = await getPrefferenceIdClient();
//    if (clientId != null) {
//      print("CLIENT ID" + clientId);
//    }
//  }




  String clienId;

//  getRoom() async {
//    clienId = await getPrefferenceIdClient();
//    return clienId;
//  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);

    // notifbloc.dispose();
    // bloc.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final DetailBerita args = ModalRoute
        .of(context)
        .settings
        .arguments;
    id = args.id;

    if (!isLoaded) {
      print("id detail $id");
      getDetail(id);
      isLoaded = true;
    }


    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: GenColor.primaryColor, // status bar color
    ));

    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery
                .of(context)
                .size
                .width,
            maxHeight: MediaQuery
                .of(context)
                .size
                .height),
        designSize: Size(360, 690),
        orientation: Orientation.portrait);

    if (!isLoaded) {
      isLoaded = true;
    }

    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: GenColor.primaryColor,
        elevation: 0,
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  // Navigator.pushNamed(context, "notifikasi", arguments: );
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.notifications,
                      size: 26.0,
                    ),
                  ],
                ),
              )),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: dataBerita == null
                  ? Center(
                child: CircularProgressIndicator(),
              )
                  : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(
                      ip + dataBerita["gambar"],
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    CommonPadding(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GenText(
                            dataBerita["judul"],
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),

                          GenText(
                            formatTanggalFromStringGMT(dataBerita["created_at"]),
                            style: TextStyle(
                                fontSize: 12),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          GenText(
                            dataBerita["deskripsi"],
                            style: TextStyle(
                                fontSize: 14),
                          ),
                          SizedBox(height: 5,),

                          SizedBox(height: 30,),
                          // GenText(dataBerita["keterangan"]),
                        ],
                      ),
                    ),



                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }






  void getDetail(id) async {
    print("GET Berita $dataBerita");

    dataBerita = await req.getApi("berita/$id");

    dataBerita = dataBerita["payload"];

    print("DATA Berita $dataBerita");

    setState(() {});
  }

}
