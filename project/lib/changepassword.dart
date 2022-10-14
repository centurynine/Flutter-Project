import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project/body.dart';
import 'package:project/login.dart';
import 'package:firebase_core/firebase_core.dart';



 


// void _changePassword(String password) async{
//    //Create an instance of the current user. 
//     FirebaseUser user = await FirebaseAuth.instance.currentUser();
//     user.updatePassword(password).then((_){
//       print("Successfully changed password");
//     }).catchError((error){
//       print("Password can't be changed" + error.toString());

//     });
//   }