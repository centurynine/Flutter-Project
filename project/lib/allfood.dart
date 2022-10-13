import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:project/ShowMenu.dart';
import 'package:project/home.dart';
import 'package:firebase_storage/firebase_storage.dart' as firbaseStorage;

class BodyAfterLogin extends StatefulWidget {
  const BodyAfterLogin({super.key});

  @override
  State<BodyAfterLogin> createState() => _BodyAfterLoginState();


}

class _BodyAfterLoginState extends State<BodyAfterLogin> {
  CollectionReference data = FirebaseFirestore.instance.collection('foods');
  firbaseStorage.Reference storageRef =
      firbaseStorage.FirebaseStorage.instance.ref().child('foods/');
  // imgUrl(String id) async {
  //  // print('ID : $id');
  //   var url = await storageRef.child(id).getDownloadURL();
  //   print(url);
  //   return url;
  // }

  @override
  
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                actions: [
                  IconButton(
                    alignment: Alignment.centerRight,
                    icon: Icon(Icons.home),
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/');
                    },
                  ),
                  IconButton(
                    alignment: Alignment.centerRight,
                    icon: Icon(Icons.search),
                    onPressed: () {},
                  ),
                ],
                title: Text(
                  'รายการอาหาร',
                  style: GoogleFonts.kanit(
                    fontSize: 20,
                  ),
                ),
                backgroundColor: Colors.grey,
              ),
              body: StreamBuilder<QuerySnapshot>(
                  stream: data.snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Something went wrong');
                      print('Something went wrong');
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      
                      EasyLoading.show(status: 'Loading...');
                      print('Loading');
                      return Text("กำลังโหลดข้อมูล...",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.kanit(fontSize: 20));
                    }
                    EasyLoading.dismiss();
                    return ListView.builder(
                      itemCount: (snapshot.data!).docs.length,
                      itemBuilder: (context, index) {
                        if ((snapshot.data!).docs[index]['title'] == '') {
                          return SizedBox.shrink();
                        } else {
                          return Container(
                            width: 200,
                            height: 150,
                            margin: const EdgeInsets.only(
                                left: 30, top: 20, right: 30, bottom: 20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: const Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: ListTile(
                              onTap: () {
                              //   imgUrl((snapshot.data!).docs[index]['id']);
                              //   print('url: $url');
                              },
                              title:
                                  Text((snapshot.data!).docs[index]['title']),
                              subtitle: Text(
                                  (snapshot.data!).docs[index]['subtitle']),
                              leading: Image.network(
                                (snapshot.data!).docs[index]['uploadImageUrl'],
                                width: 100,
                                height: 100,
                              ),
                              trailing: Wrap(
                                spacing: 12,
                                children: <Widget>[
                                  Text(
                                    'ID',
                                    textAlign: TextAlign.end,
                                    style: GoogleFonts.kanit(fontSize: 10),
                                  ),
                                  Text(
                                    (snapshot.data!).docs[index]['id'],
                                    textAlign: TextAlign.start,
                                    style: GoogleFonts.kanit(fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                      },
                    );
                  })),
        ),
      ],
    );
  }

  // void getImage() async {
  //   var imgUrl = await storageRef.child('${id}').getDownloadURL();
  //   print(imgUrl);
  // }


  // void getImage() async {
  //   final imgUrl = await storageRef.child().getDownloadURL();
  //   print(imgUrl);
  // }


}
