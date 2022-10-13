
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:project/ShowMenu.dart';
import 'package:project/home.dart';
import 'package:firebase_storage/firebase_storage.dart' as firbaseStorage;
import 'package:firebase_storage/firebase_storage.dart';


class ShowMenu extends StatefulWidget {
  final DocumentSnapshot docs;

  const ShowMenu({Key? key, required this.docs}) : super(key: key);

  @override
  State<ShowMenu> createState() => _ShowMenuState();
}

class _ShowMenuState extends State<ShowMenu> {
    CollectionReference data = FirebaseFirestore.instance.collection('foods');
  firbaseStorage.Reference storageRef =
      firbaseStorage.FirebaseStorage.instance.ref().child('foods/');
  String? id;

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () {},
           icon: Icon(Icons.search)
           )
        ],
      ),
      body: Column(
        children: [
          Container(
            child: Text(
               widget.docs['id'],
              ),
          ),
                    Container(
            child: Text(
               widget.docs['title'],
              ),
          )
        ],
      )
    );
  }}