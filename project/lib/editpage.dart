import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:project/ShowMenu.dart';
import 'package:project/home.dart';
import 'package:firebase_storage/firebase_storage.dart' as firbaseStorage;
import 'package:firebase_storage/firebase_storage.dart';

class EditMenu extends StatefulWidget {
  final DocumentSnapshot docs;
  const EditMenu({Key? key, required this.docs}) : super(key: key);
  @override
  State<EditMenu> createState() => _EditMenuState();
}

class _EditMenuState extends State<EditMenu> {
  CollectionReference data = FirebaseFirestore.instance.collection('foods');
  firbaseStorage.Reference storageRef =
      firbaseStorage.FirebaseStorage.instance.ref().child('foods/');
  String? id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.docs['title'],
            style: GoogleFonts.kanit(
              fontSize: 20,
            ),
          ),
          actions: [IconButton(onPressed: () {}, icon: Icon(Icons.search))],
        ),
        body: ListView(children: [
          Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Container(
                padding:
                    const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey[350]!),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                  ),
                child: Container(
                  height: 200,
                  width: 300,
                  child: Image.network(widget.docs['uploadImageUrl']
                ),
                )
              ),
              // CircleAvatar(
              //   radius: 150,
              //   backgroundImage: NetworkImage(
              //    widget.docs['uploadImageUrl']
              //   ),
              //   backgroundColor: const Color(0xff6ae792),
              // ),
              Container(
                alignment: Alignment.center,
                child: Text(
                  widget.docs['title'],
                  style: GoogleFonts.kanit(fontSize: 20),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  '         วัตถุดิบ',
                  style: GoogleFonts.kanit(fontSize: 20),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  widget.docs['ingredients'],
                  style: GoogleFonts.kanit(fontSize: 14),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  '         ขั้นตอนการทำ',
                  style: GoogleFonts.kanit(fontSize: 20),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  widget.docs['description'],
                  style: GoogleFonts.kanit(fontSize: 14),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ]));
  }
}
