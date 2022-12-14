import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:project/food/ShowMenu.dart';
import 'package:project/food/notfound.dart';
import 'package:project/widget/drawer.dart';
import 'package:project/food/editpage.dart';
import 'package:project/homepage/home.dart';
import 'package:firebase_storage/firebase_storage.dart' as firbaseStorage;
import 'package:project/account/login.dart';
import 'package:project/search/searchpage.dart';

class BodyAfterLogin extends StatefulWidget {
  const BodyAfterLogin({super.key});

  @override
  State<BodyAfterLogin> createState() => _BodyAfterLoginState();
}

class _BodyAfterLoginState extends State<BodyAfterLogin> {
  Query<Map<String, dynamic>> data = FirebaseFirestore.instance
      .collection('foods')
      .orderBy('created_at', descending: true);

  CollectionReference users = FirebaseFirestore.instance.collection('users');
  firbaseStorage.Reference storageRef =
      firbaseStorage.FirebaseStorage.instance.ref().child('foods/');
  bool isAdmin = false;
  String? counted = '0';

  @override
  void initState() {
    super.initState();
    if (FirebaseAuth.instance.currentUser == null) {
      print('ไม่พบการเข้าสู่ระบบ');
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.push(
            context, new MaterialPageRoute(builder: (context) => LoginPage()));
      });
    } else {
      print('Found user');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(
          child: Scaffold(
              drawer: DrawerWidget(),
              appBar: AppBar(
                backgroundColor: Colors.white,
                automaticallyImplyLeading: false,
                actions: [
                  IconButton(
                    alignment: Alignment.centerRight,
                    icon: const Icon(Icons.search,
                        color: Colors.black87, size: 30.0),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SearchPage()));
                    },
                  ),
                ],
                title: Text(
                  'รายการอาหาร',
                  style: GoogleFonts.kanit(
                    fontSize: 20,
                    color: Colors.black87,
                  ),
                ),
                leading: IconButton(
                  alignment: Alignment.centerRight,
                  icon:
                      const Icon(Icons.home, color: Colors.black87, size: 30.0),
                  iconSize: 30,
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/');
                  },
                ),
              ),
              body: StreamBuilder<QuerySnapshot>(
                  stream: data.snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Something went wrong');
                      print('Something went wrong');
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      EasyLoading.show(status: 'กำลังโหลด...');
                      print('Loading');
                      return Text("",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.kanit(fontSize: 20));
                    }
                    if (snapshot.data!.docs.isEmpty) {
                      EasyLoading.dismiss();
                      return NotFound();
                    }

                    EasyLoading.dismiss();
                    return ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: (snapshot.data!).docs.length,
                      itemBuilder: (context, index) {
                        if ((snapshot.data!).docs[index]['title'] == null ||
                            (snapshot.data!).docs[index]['uploadImageUrl'] ==
                                null ||(snapshot.data!).docs[index]['id'] == null || (snapshot.data!).docs[index]['like'] == null 
                                || (snapshot.data!).docs[index]['created_at'] == null
                                || (snapshot.data!).docs[index]['description'] == null
                                || (snapshot.data!).docs[index]['displayname'] == null
                                || (snapshot.data!).docs[index]['food_type'] == null
                                || (snapshot.data!).docs[index]['ingredients'] == null
                                || (snapshot.data!).docs[index]['subtitle'] == null
                                || (snapshot.data!).docs[index]['uid'] == null
                                ) { 
                          return SizedBox.shrink();
                        } else {
                          return Card(
                            margin: EdgeInsets.all(5),
                            clipBehavior: Clip.antiAlias,
                            child: Container(
                              height: 120,
                              padding: const EdgeInsets.all(0),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ShowMenu(
                                                docs: (snapshot.data!)
                                                    .docs[index],
                                              )));
                                },
                                child: Row(
                                  children: [
                                  Expanded(
                                    flex: 6,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(7),
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                (snapshot.data!).docs[index]
                                                    ['uploadImageUrl'],
                                              ),
                                              fit: BoxFit.cover),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Spacer(
                                  //   flex: 0,
                                  // ),
                                  Expanded(
                                    flex: 14,
                                    child: Container(
                                      padding: const EdgeInsets.only(
                                          top: 10, bottom: 20),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: <Widget>[
                                          Row(
                                            children: [
                                              Flexible(
                                                child: Text(
                                                  (snapshot.data!).docs[index]
                                                      ['title'],
                                                  maxLines: 1,
                                                  style:
                                                      GoogleFonts.notoSansThai(
                                                          fontSize: 20),
                                                ),
                                              ),
                                              FutureBuilder(
                                                future: users.doc().get(),
                                                builder: (ctx, futureSnapshot) {
                                                  if (futureSnapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    checkAdmin();
                                                  }
                                                  if (isAdmin == true || FirebaseAuth.instance.currentUser!.email == '${(snapshot.data!).docs[index]['email']}') {
                                                    return GestureDetector(
                                                      child: Icon(Icons.edit),
                                                      onTap: () {
                                                        showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AlertDialog(
                                                                title: Text(
                                                                    'แก้ไขรายการอาหาร'),
                                                                content:
                                                                    Text(''),
                                                                actions: [
                                                                  TextButton(
                                                                    child: Text(
                                                                        'แก้ไข'),
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                      Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: (context) => EditData(
                                                                                    docs: (snapshot.data!).docs[index],
                                                                                  )));
                                                                    },
                                                                  ),
                                                                  TextButton(
                                                                    child: Text(
                                                                        'ยกเลิก'),
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    },
                                                                  ),
                                                                  TextButton(
                                                                    child: Text(
                                                                        'ลบ'),
                                                                    onPressed:
                                                                        () {
                                                                      FirebaseFirestore
                                                                          .instance
                                                                          .collection(
                                                                              'foods')
                                                                          .doc((snapshot.data!)
                                                                              .docs[index]
                                                                              .id)
                                                                          .delete();
                                                                      print(
                                                                          'Database ID ${(snapshot.data!).docs[index]['id']} Deledted');
                                                                      var imageID =
                                                                          (snapshot.data!).docs[index]
                                                                              [
                                                                              'id'];
                                                                      print(
                                                                          'Picture ID : $imageID Deleted');
                                                                      var reference = FirebaseStorage
                                                                          .instance
                                                                          .ref()
                                                                          .child(
                                                                              'foods/$imageID');
                                                                      var delete =
                                                                          reference
                                                                              .delete();
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                      EasyLoading
                                                                          .showSuccess(
                                                                              'ลบรายการอาหารแล้ว');
                                                                    },
                                                                  ),
                                                                ],
                                                              );
                                                            });
                                                      },
                                                    );
                                                  } else {
                                                    return SizedBox.shrink();
                                                  }
                                                },
                                              )
                                            ],
                                          ),

                                          Row(
                                            children: <Widget>[
                                              Flexible(
                                                child: RichText(
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  strutStyle: StrutStyle(
                                                      fontSize: 12.0),
                                                  text: TextSpan(
                                                    style: GoogleFonts.kanit(
                                                      fontSize: 13,
                                                      color: Colors.black,
                                                    ),
                                                    text: (snapshot.data!)
                                                            .docs[index]
                                                        ['subtitle'],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          (snapshot.data!).docs[index]
                                                          ['displayname'] ==
                                                      null ||
                                                  (snapshot.data!).docs[index]
                                                          ['displayname'] ==
                                                      ''
                                              ? Expanded(
                                                  child: Row(
                                                    children: <Widget>[
                                                      Text(
                                                        'แชร์โดย : ',
                                                        style:
                                                            GoogleFonts.kanit(
                                                                fontSize: 13,
                                                                color: Colors
                                                                    .black),
                                                      ),
                                                      Text(
                                                        "ไม่พบบัญชีผู้ใช้",
                                                        maxLines: 1,
                                                        style:
                                                            GoogleFonts.kanit(
                                                                fontSize: 10),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              : Expanded(
                                                  child: Row(
                                                    children: <Widget>[
                                                      Text(
                                                        'แชร์โดย : ',
                                                        style:
                                                            GoogleFonts.kanit(
                                                                fontSize: 13,
                                                                color: Colors
                                                                    .black),
                                                      ),
                                                      Text(
                                                        (snapshot.data!)
                                                                .docs[index]
                                                            ['displayname'],
                                                        maxLines: 1,
                                                        style:
                                                            GoogleFonts.kanit(
                                                                fontSize: 12),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                          Row(
                                            children: [
                                              Flexible(
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.grey
                                                            .withOpacity(0.5),
                                                        spreadRadius: 1,
                                                        blurRadius: 1,
                                                        offset: Offset(0,
                                                            1), // changes position of shadow
                                                      ),
                                                    ],
                                                  ),
                                                  child: Container(
                                                    child: IntrinsicWidth(
                                                      child: Row(
                                                        children: [
                                                          Text(' '),
                                                          Icon(
                                                            Icons.store,
                                                            size: 15,
                                                          ),
                                                          Text(
                                                            textAlign: TextAlign.center,
                                                            '${(snapshot.data!).docs[index]['food_type']}     ',
                                                            maxLines: 1,
                                                            style: GoogleFonts.kanit(
                                                                fontSize: 13),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Flexible(
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.grey
                                                            .withOpacity(0.5),
                                                        spreadRadius: 1,
                                                        blurRadius: 1,
                                                        offset: Offset(0,
                                                            1), // changes position of shadow
                                                      ),
                                                    ],
                                                  ),
                                                  child: Container(
                                                    child: IntrinsicWidth(
                                                      child: Row(
                                                        children: [
                                                          Text(' '),
                                                          Icon(Icons.favorite,
                                                              color: Colors.red[400],
                                                              size: 15),
                                                          Text(
                                                            textAlign: TextAlign.center,
                                                            '${(snapshot.data!).docs[index]['like']}    ',
                                                            maxLines: 1,
                                                            style: GoogleFonts.kanit(
                                                                fontSize: 13),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          // Align(
                                          //   alignment: Alignment.bottomRight,
                                          //   child: Row(
                                          //     mainAxisAlignment: MainAxisAlignment.end,
                                          //     children: <Widget>[
                                          //       ElevatedButton(
                                          //           onPressed: null,
                                          //           child: Text("DETAIL ITEM")),
                                          //       ElevatedButton(
                                          //           onPressed: null, child: Text("BELI")),
                                          //     ],
                                          //   ),
                                          // )
                                        ],
                                      ),
                                    ),
                                  ),
                                ]),
                              ),
                            ),
                          );
                        }
                      },
                    );
                  })))
    ]);
  }

  // checkLike(String id) async {
  //   if (FirebaseAuth.instance.currentUser != null) {
  //     QuerySnapshot _myDoc = await FirebaseFirestore.instance
  //         .collection('users_like')
  //         .where('${id}', isEqualTo: true)
  //         .get();
  //     List<DocumentSnapshot> _myDocCount = _myDoc.docs;
  //     counted = _myDocCount.length.toString();
  //     return counted;
  //   } else {
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(builder: (context) => Homepage()),
  //     );
  //   }
  // }

  Future<void> checkAdmin() async {
    if (FirebaseAuth.instance.currentUser != null) {
      QuerySnapshot query = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: FirebaseAuth.instance.currentUser!.email)
          .where('admin', isEqualTo: 'true')
          .get();
      if (query.docs.isNotEmpty) {
        isAdmin = true;
      } else {
        isAdmin = false;
      }
    } else {
      print('ไม่พบการเข้าสู่ระบบ');
    }
  }
}
