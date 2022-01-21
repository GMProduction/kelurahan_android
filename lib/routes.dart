
import 'package:kelurahan/DetailBerita.dart';
import 'package:kelurahan/inputSyarat.dart';
import 'package:provider/provider.dart';


import 'DetailKos.dart';
import 'base.dart';
import 'blocks/baseBloc.dart';
import 'daftar.dart';
import 'keterangan.dart';
import 'login.dart';
import 'splashScreen.dart';

class GenProvider {
  static var providers = [
    ChangeNotifierProvider<BaseBloc>.value(value: BaseBloc()),

  ];

  static routes(context) {
    return {
//           '/': (context) {
//        return Base();
//      },

      '/': (context) {
        return SplashScreen();
      },

      'splashScreen': (context) {
        return SplashScreen();
      },

      'login': (context) {
        // return Login();
        return Login();
      },



      'daftar': (context) {
        // return Login();
        return Daftar();
      },



      'base': (context) {
        // return Login();
        return Base();
      },



      'keterangan': (context) {
        return Keterangan();
      },


      'detailKos': (context) {
        return DetailKos();
      },

      'inputSyarat': (context) {
        return InputSyarat();
      },

      'detailBerita': (context) {
        return DetailBerita();
      },
    };
  }
}
