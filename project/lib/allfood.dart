import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:project/ShowMenu.dart';
import 'package:project/editpage.dart';
import 'package:project/home.dart';
import 'package:firebase_storage/firebase_storage.dart' as firbaseStorage;
import 'package:project/searchpage.dart';

class BodyAfterLogin extends StatefulWidget {
  const BodyAfterLogin({super.key});

  @override
  State<BodyAfterLogin> createState() => _BodyAfterLoginState();
}

class _BodyAfterLoginState extends State<BodyAfterLogin> {
  Query<Map<String, dynamic>> data = FirebaseFirestore.instance.collection('foods').orderBy('id', descending: true);

  CollectionReference users = FirebaseFirestore.instance.collection('users');
  firbaseStorage.Reference storageRef =
      firbaseStorage.FirebaseStorage.instance.ref().child('foods/');
  bool isAdmin = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white,
                automaticallyImplyLeading: false,
                actions: [
                  IconButton(
                    alignment: Alignment.centerRight,
                    icon: const Icon(Icons.search,color: Colors.black87, size: 30.0),
                    onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => SearchPage()));
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
              leading: 

                       IconButton(
                        alignment: Alignment.centerRight,
                        icon: const Icon(Icons.home,
                            color: Colors.black87, size: 30.0),
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
                    EasyLoading.dismiss();
                    return ListView.builder(
                      itemCount: (snapshot.data!).docs.length,
                      itemBuilder: (context, index) {
                        if ((snapshot.data!).docs[index]['title'] == '' ||
                            (snapshot.data!).docs[index]['uploadImageUrl'] ==
                                '' ||
                            (snapshot.data!).docs[index]['id'] == '') {
                          return SizedBox.shrink();
                        } else {
                          return Container(
                            width: 240,
                            height: 160,
                            margin: const EdgeInsets.only(
                                left: 20, top: 10, right: 10, bottom: 20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(30)),
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
                              minVerticalPadding: 0,
                              textColor: Colors.grey[900],
                              shape: RoundedRectangleBorder(
                                side: BorderSide(width: 4, color: Colors.grey),
                                borderRadius: BorderRadius.circular(23),
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ShowMenu(
                                              docs:
                                                  (snapshot.data!).docs[index],
                                            )));
                              },
                              title: Text(
                                (snapshot.data!).docs[index]['title'],
                                maxLines: 1,
                                style: GoogleFonts.notoSansThai(fontSize: 20),
                              ),
                              subtitle: Text(
                                (snapshot.data!).docs[index]['subtitle'],
                                maxLines: 6,
                                style: GoogleFonts.kanit(fontSize: 13),
                              ),
                              leading: Column(
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    margin: EdgeInsets.symmetric(horizontal: 2),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                            (snapshot.data!).docs[index]
                                                ['uploadImageUrl']),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  ],
                              ),
                              trailing: Wrap(
                                spacing: 12,
                                children: <Widget>[
                                            FutureBuilder(
              future: users.doc().get(),
              builder: (ctx, futureSnapshot) {
                if (futureSnapshot.connectionState == ConnectionState.waiting) {
                  checkAdmin();
                }
                if (isAdmin == true) {
                  return GestureDetector(
                    child: Icon(Icons.edit),
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('แก้ไขรายการอาหาร'),
                              content: Text(''),
                              actions: [
                                TextButton(
                                  child: Text('แก้ไข'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EditData(
                                              docs:
                                                  (snapshot.data!).docs[index],
                                            )));
                                  },
                                ),
                                TextButton(
                                  child: Text('ยกเลิก'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: Text('ลบ'),
                                  onPressed: () {
                                    FirebaseFirestore.instance
                                        .collection('foods')
                                        .doc((snapshot.data!).docs[index].id)
                                        .delete();
                                      print('Database ID ${(snapshot.data!).docs[index]['id']} Deledted');
                                      var imageID = (snapshot.data!).docs[index]['id'];
                                      print('Picture ID : $imageID Deleted');
                                      var reference = FirebaseStorage.instance.ref().child('foods/$imageID');
                                      var delete = reference.delete();
                                      Navigator.of(context).pop();
                                      EasyLoading.show(status: 'ลบรายการอาหารแล้ว');
                                      Future.delayed(const Duration(milliseconds: 2000), () {
                                        EasyLoading.dismiss();
                                      });
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

  void checkAdmin() async {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: FirebaseAuth.instance.currentUser!.email)
        .where('admin', isEqualTo: 'true')
        .get();
    if (query.docs.isNotEmpty){
        isAdmin = true;
    }
    else {
       isAdmin = false;
    }
  }

}
