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

class BodyAfterLogin extends StatefulWidget {
  const BodyAfterLogin({super.key});

  @override
  State<BodyAfterLogin> createState() => _BodyAfterLoginState();
}

class _BodyAfterLoginState extends State<BodyAfterLogin> {
  CollectionReference data = FirebaseFirestore.instance.collection('foods');
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
                              shape: RoundedRectangleBorder(
                                //<-- SEE HERE
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
                                style: GoogleFonts.notoSansThai(fontSize: 20),
                              ),
                              subtitle: Text(
                                (snapshot.data!).docs[index]['subtitle'],
                                style: GoogleFonts.kanit(fontSize: 13),
                              ),
                              leading: CircleAvatar(
                                radius: 30,
                                backgroundImage: NetworkImage(
                                    (snapshot.data!).docs[index]
                                        ['uploadImageUrl'],
                                        scale: 1,
                                        ),
                                backgroundColor: const Color(0xff6ae792),
                              ),
                              // Padding(
                              //   padding: const EdgeInsets.only(left: 1, top: 1),
                              //   child: Image.network(
                              //     (snapshot.data!).docs[index]
                              //         ['uploadImageUrl'],
                              //     width: 50,
                              //     height: 50,
                              //   ),
                              // ),
                              // Image.network((snapshot.data!).docs[index]['uploadImageUrl'],
                              //   width: 100,
                              //   height: 100,
                              // ),
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
                              title: Text('ลบรายการอาหาร'),
                              content: Text('คุณต้องการลบรายการอาหารนี้ใช่หรือไม่'),
                              actions: [
                                TextButton(
                                  child: Text('แก้ไข'),
                                  onPressed: () {
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
                                  child: Text('ตกลง'),
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
                                


                                    //  Text(
                                    // (snapshot.data!).docs[index]['id'],
                                    // textAlign: TextAlign.start,
                                    // style: GoogleFonts.kanit(fontSize: 14),
                                 
                                  
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
