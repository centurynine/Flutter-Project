import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project/HomePageWidget.dart';
import 'package:project/ShowMenu.dart';
import 'package:project/body_login.dart';
import 'package:project/facebook.dart';
import 'package:project/forgotpassword.dart';
import 'package:project/home.dart';
import 'package:project/login.dart';
import 'package:project/register.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:project/setting.dart';

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
      routes: {
        '/': (context) => Homepage(),
        '/register': (context) => RegisterPage(),
        '/login': (context) => LoginPage(),
        '/forgotpassword': (context) => forgotPassword(),
        '/fb': (context) => FacebookLogin(),
        '/setting': (context) => Setting(),
        '/widget': (context) => HomePageWidget(),
        '/food': (context) => BodyAfterLogin(),
        '/showmenu': (context) => ShowMenu(),
      },
    );
  }
}
