import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:project/food/ShowMenu.dart';
import 'package:project/widget/drawer.dart';
import 'package:project/homepage/home.dart';
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
      backgroundColor: Colors.white,
      drawer:  DrawerWidget(),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => 
        [
        SliverAppBar(
          leading: Container(
            margin: EdgeInsets.only(left: 10, top: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: IconButton(
              color: Colors.black87,
              icon: Icon(Icons.arrow_back_ios_new_outlined),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          expandedHeight: 240,
          flexibleSpace: Stack(
            children: [
              FlexibleSpaceBar(
              background: Image.network(
                widget.docs['uploadImageUrl'],
                fit: BoxFit.cover,
              ),
            ),
                Positioned(
                  child: Container(
                    height: 33,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(40),
                      ),
                    ),
                  ),
                  bottom: -7,
                  left: 0,
                  right: 0,
                )

        ],
        
        ),
          floating: true,
          pinned: true,
        ), ],
        
      
      //backgroundColor: Colors.white,
      
       
        //    appBar: AppBar(
        //     backgroundColor: Colors.transparent,
        //     automaticallyImplyLeading: false,
        //     leading: IconButton(
        //       icon: const Icon(Icons.arrow_back_ios_new_outlined,
        //           color: Colors.black87, size: 20),
        //       color: Colors.black87,
        //       onPressed: () {
        //         //   Navigator.pop(context);
        //         Navigator.pop(context);
        //       },
        //     ),
        //     title: Text(
        //       widget.docs['title'],
        //       style: GoogleFonts.kanit(
        //         fontSize: 20,
        //         color: Colors.black87
        //       ),
        //     ),
        //     actions: [IconButton(onPressed: () {}, icon: Icon(Icons.search, color: Colors.black87,))],
        //          ),
        //  ),
        body: GestureDetector(
          onTap: () {
          },
          child: Column(
          children: <Widget>[
            Expanded(
              child: Container(

                decoration: 
                BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
                child: ListView(
                  
                  children: [
                    
                  Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
            
                      Container(
                        alignment: Alignment.center,
                        child: Text(
                          widget.docs['title'],
                          style: GoogleFonts.kanit(fontSize: 23),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                       Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: Divider(
                          thickness: 1,
                          color: Colors.grey,
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '         รายละเอียดอาหาร',
                          style: GoogleFonts.kanit(fontSize: 20),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          widget.docs['subtitle'],
                          style: GoogleFonts.kanit(fontSize: 14),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: Divider(
                          thickness: 1,
                          color: Colors.grey,
                        ),
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
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: Divider(
                          thickness: 1,
                          color: Colors.grey,
                        ),
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
                ]),
              ),
            ),
          ],
            ),
        )));
  }
}
