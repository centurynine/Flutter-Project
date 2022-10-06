import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project/forgotpassword.dart';
import 'package:project/home.dart';
import 'package:project/login.dart';
import 'package:project/register.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
 
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return buildMaterialApp();
  }
  MaterialApp buildMaterialApp() {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'josefinSans',
        scaffoldBackgroundColor: Colors.white,
        textTheme: 
          GoogleFonts.josefinSansTextTheme(),
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
      },
    );
  }
  
}

