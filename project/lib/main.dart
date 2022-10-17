

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project/food/ShowMenu.dart';
import 'package:project/food/allfood.dart';
import 'package:project/account/avatarupload.dart';
import 'package:project/account/changedisplayname.dart';
import 'package:project/account/facebook.dart';
import 'package:project/account/forgotpassword.dart';
import 'package:project/homepage/home.dart';
import 'package:project/account/login.dart';
import 'package:project/food/myfood.dart';
import 'package:project/account/register.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:project/search/searchpage.dart';
import 'package:project/search/searchpagemyfood.dart';
import 'package:project/account/setting.dart';
import 'package:project/food/upload_data.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp();
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    return buildMaterialApp();
  }

  MaterialApp buildMaterialApp() {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'josefinSans',
        scaffoldBackgroundColor: Colors.white,
        textTheme: GoogleFonts.josefinSansTextTheme(),
        appBarTheme: const AppBarTheme(
          color: Colors.blue,
          elevation: 0,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      builder: EasyLoading.init(),
      routes: {
        '/': (context) => Homepage(),
        '/register': (context) => RegisterPage(),
        '/login': (context) => LoginPage(),
        '/forgotpassword': (context) => forgotPassword(),
        '/fb': (context) => FacebookLogin(),
        '/setting': (context) => Setting(),
        '/food': (context) => BodyAfterLogin(),
    //    '/showmenu': (context) => ShowMenu(docs:),
        '/upload': (context) => UploadData(),
        '/changedisplayname': (context) => Changedisplayname(),
        '/searchpage': (context) => SearchPage(),
        '/searchpagemyfood': (context) => SearchPageMyFood(),
        '/myfood': (context) => MyFood(),
        '/avatarupload': (context) => AvatarUpload(),
      },
    );
  }
}
