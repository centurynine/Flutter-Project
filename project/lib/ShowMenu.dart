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
  String? name;
  String? avatar = 'https://cdn-icons-png.flaticon.com/512/149/149071.png';
  void checkNameWhoCreated() async {
    final users = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: widget.docs['email'])
        .where('avatar')
        .get();
        if(users.docs.isNotEmpty){
          print('พบข้อมูลชื่อผู้โพส');
          print(users.docs[0].data()['email']);
          setState(() {
            name = users.docs[0].data()['name'];
            avatar = users.docs[0].data()['avatar'];
          });
         // print(avatar);
          if(avatar == null){
            setState(() {
               print('ไม่พบรูปภาพ');
               avatar = 'https://cdn-icons-png.flaticon.com/512/149/149071.png';
            });
            print(avatar);
          }
          else {
            print('พบภาพโปรไฟล์');
          }
        }else if(users.docs.isEmpty){
          print('ไม่พบข้อมูลชื่อผู้โพส');
          setState(() {
            name = 'ไม่พบชื่อผู้โพส';
          });
        }
  }

  @override
  void initState() {
    super.initState();
    checkNameWhoCreated();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_outlined,
                color: Colors.black87, size: 20),
            color: Colors.black87,
            onPressed: () {
              //   Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
          title: Text(
            widget.docs['title'],
            style: GoogleFonts.kanit(
              fontSize: 20,
              color: Colors.black87
            ),
          ),
          actions: [IconButton(onPressed: () {}, icon: Icon(Icons.search, color: Colors.black87,))],
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
                  borderRadius: BorderRadius.circular(25),
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
              //   child: Container(
                  
              //     height: 200,
              //     width: 300,
              //     child: Image.network(widget.docs['uploadImageUrl'],
              //         fit: BoxFit.cover),
                
              //   )
              // ),
                  child:
                  
              ClipRRect(
    borderRadius: BorderRadius.circular(25.0),
    child: Image.network(
        widget.docs['uploadImageUrl'],
        height: 200.0,
        width: 300.0,
        fit: BoxFit.cover,
    ),
),),


              Container(
                
                alignment: Alignment.center,
                child: Text(
                  widget.docs['title'],
                  style: GoogleFonts.kanit(fontSize: 20),
                ),
              ),
              SizedBox(
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
              SizedBox(
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
              SizedBox(
                height: 20,
              ),
                ClipRRect(
                      borderRadius: BorderRadius.circular(35.0),
                      child: Image.network(avatar.toString(),
                          width: 95, height: 95, fit: BoxFit.cover
                      ),
                    ),
              SizedBox(
                height: 10,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'แชร์เมนูโดย $name',
                  style: GoogleFonts.kanit(fontSize: 14),
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ]));
  }
}
