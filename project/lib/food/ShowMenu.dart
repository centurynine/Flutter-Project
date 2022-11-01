
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:project/food/ShowMenu.dart';
import 'package:project/food/addcomment.dart';
import 'package:project/food/comment.dart';
import 'package:project/food/editpage.dart';
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
  bool? isCreate = false;
  String counted = '0';
  CollectionReference data = FirebaseFirestore.instance.collection('foods');

  firbaseStorage.Reference storageRef =
      firbaseStorage.FirebaseStorage.instance.ref().child('foods/');
  String? id;
  String? name;
  String? avatar = 'https://cdn-icons-png.flaticon.com/512/149/149071.png';
  bool? userLiked = false;
  void checkNameWhoCreated() async {
    final users = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: widget.docs['email'])
        .where('avatar')
        .get();
    if (users.docs.isNotEmpty) {
      print('พบข้อมูลชื่อผู้โพส');
      print(users.docs[0].data()['email']);
      setState(() {
        name = users.docs[0].data()['name'];
        avatar = users.docs[0].data()['avatar'];
      });
      // print(avatar);
      if (avatar == null) {
        setState(() {
          print('ไม่พบรูปภาพ');
          avatar = 'https://cdn-icons-png.flaticon.com/512/149/149071.png';
        });
        print(avatar);
      } else {
        print('พบภาพโปรไฟล์');
      }
    } else if (users.docs.isEmpty) {
      print('ไม่พบข้อมูลชื่อผู้โพส');
      setState(() {
        name = 'ไม่พบชื่อผู้โพส';
      });
    }
  }


  Future<void> checkLike() async {
    if (FirebaseAuth.instance.currentUser != null) {
    final users = await FirebaseFirestore.instance
        .collection('users_like')
        .where('email', isEqualTo: FirebaseAuth.instance.currentUser?.email)
        .where('${widget.docs['id']}', isEqualTo: true)
        .get();
    if (users.docs.isNotEmpty) {
      print('ผู้ใช้กดถูกใจแล้ว');
      setState(() {
        userLiked = true;
      });
      // print(avatar);
    } else if (users.docs.isEmpty) {
      print('ผู้ใช้ไม่กดถูกใจ');
      setState(() {
        userLiked = false;
      });
    }
  }else {
    Navigator.pushNamed(context, '/');
  }
  }

  @override
  void initState() {
    super.initState();
    checkNameWhoCreated();
    checkLike();
    updateCountLike();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        drawer: const DrawerWidget(),
        body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
                  SliverAppBar(
                    
                    leading: Container(
                      margin: const EdgeInsets.only(left: 10, top: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: IconButton(
                        color: Colors.black87,
                        icon: const Icon(Icons.arrow_back_ios_new_outlined),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    actions: [
                      FirebaseAuth.instance.currentUser?.email == widget.docs['email']
                      ? Container(
                        margin: const EdgeInsets.only(right: 10, top: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: IconButton(
                          color: Colors.black87,
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            if (FirebaseAuth.instance.currentUser != null) {
                              if (FirebaseAuth.instance.currentUser?.email ==
                                  widget.docs['email']) {
                                // Navigator.pushNamed(context, '/EditData',
                                //     arguments: widget.docs);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EditData(
                                              docs: widget.docs,
                                            )));
                              } else {
                                EasyLoading.showError('ไม่สามารถแก้ไขได้');
                              }
                            } else {
                              Navigator.pushNamed(context, '/');
                            }
                          },
                        ),
                      )
                      : Container(),
                    ],
                    iconTheme: const IconThemeData(color: Colors.black),
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
                          bottom: -7,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: 33,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(30),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    floating: true,
                    pinned: false,

                  ),
                ],
            body: Column(
              children: <Widget>[
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50),
                      ),
                    ),
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      children: [
                      Column(
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${widget.docs['title']} ',
                                  style: GoogleFonts.kanit(fontSize: 23),
                                ),
                                userLiked == true
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      GestureDetector(
                                        onTap: () {
                                          pressLike();
                                          print('Pressed UnLike');
                                        },
                                        child: Icon(
                                          Icons.favorite,
                                          color: Colors.pinkAccent,
                                          size: 24.0,
                                        ),
                                      ),
                                    ],
                                )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      GestureDetector(
                                        onTap: () {
                                          print('Pressed Like');
                                          pressLike();
                                        },
                                        child: Icon(
                                          Icons.favorite,
                                          color: Colors.grey,
                                          size: 24.0,
                                        ),
                                      ),
                                    ],

                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            margin:
                                const EdgeInsets.symmetric(horizontal: 20),
                            child: const Divider(
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
                            margin:
                                const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              widget.docs['subtitle'],
                              style: GoogleFonts.kanit(fontSize: 14),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            margin:
                                const EdgeInsets.symmetric(horizontal: 20),
                            child: const Divider(
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
                            margin:
                                const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              widget.docs['ingredients'],
                              style: GoogleFonts.kanit(fontSize: 14),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            margin:
                                const EdgeInsets.symmetric(horizontal: 20),
                            child: const Divider(
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
                            margin:
                                const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              widget.docs['description'],
                              style: GoogleFonts.kanit(fontSize: 14),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                                                    Container(
                            margin:
                                const EdgeInsets.symmetric(horizontal: 20),
                            child: const Divider(
                              thickness: 1,
                              color: Colors.grey,
                            ),
                          ),
                            Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '         ถูกใจ : ${counted}',
                              style: GoogleFonts.kanit(fontSize: 14),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(35.0),
                            child: Image.network(avatar.toString(),
                                width: 95, height: 95, fit: BoxFit.cover),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            margin:
                                const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              'แชร์เมนูโดย $name',
                              style: GoogleFonts.kanit(fontSize: 14),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                      SizedBox( height: 20,),
                      Text('  Comments',
                          style: GoogleFonts.kanit(fontSize: 20)),
                      Container(
                        child: Divider(
                          height: 1,
                          thickness: 1,
                          color: Colors.grey[300],
                        ),
                      ),

                      CommentPage(
                        docs: widget.docs,
                      ),

                                            Container(
                      //  margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: Divider(
                          height: 1,
                          thickness: 1,
                          color: Colors.grey[300],
                        ),
                      ),
                      Container(
                        child: Addcomment(
                          docs: widget.docs,
                        ),
                      ),  
                    ]
                    ),
                  ),
                ),

              ],
            )
            )
            );
  }

  Future<void> pressLike() async {
    if (FirebaseAuth.instance.currentUser != null) {
    final users = await FirebaseFirestore.instance
        .collection('users_like')
        .where('email', isEqualTo: FirebaseAuth.instance.currentUser?.email)
        .get();
      if(users.docs.isEmpty){
        await FirebaseFirestore.instance.collection('users_like').add({
          'email': FirebaseAuth.instance.currentUser?.email,
          '${widget.docs['id']}': true,
        });
        setState(() {
          userLiked = true;
        });
           print('Create email Like field');
      }
      else if (users.docs.isNotEmpty) {
         final usersLike = await FirebaseFirestore.instance
        .collection('users_like')
        .where('email', isEqualTo: FirebaseAuth.instance.currentUser?.email)
        .where('${widget.docs['id']}' , isEqualTo: true)
        .get();
        if(usersLike.docs.isEmpty){
          await FirebaseFirestore.instance
          .collection('users_like')
          .doc(users.docs[0].id).update({
          '${widget.docs['id']}': true,
            });
            setState(() {
              userLiked = true;
            });
        }
        else if(usersLike.docs.isNotEmpty){
          await FirebaseFirestore.instance.collection('users_like')
          .doc(users.docs[0].id).update({
          '${widget.docs['id']}': false,
            });
            setState(() {
              userLiked = false;
            });
        }
        }
        updateCountLike();
        }
  else {
    Navigator.pushNamed(context, '/');
  }}  


  Future<void> updateCountLike() async {
    QuerySnapshot _myDoc = await FirebaseFirestore.instance
    .collection('users_like')
    .where('${widget.docs['id']}' , isEqualTo: true)
    .get();
    List<DocumentSnapshot> _myDocCount = _myDoc.docs;
    counted = _myDocCount.length.toString();
    print('จำนวนกดถูกใจ : $counted');
    setState(() {
      counted = counted;
    });
    updateDocuement();
  }

  Future<void> updateDocuement() async {
    final users = await FirebaseFirestore.instance
        .collection('foods')
        .where('id', isEqualTo: '${widget.docs['id']}')
        .where('like')
        .get();
    if(users.docs.isNotEmpty){
              await FirebaseFirestore.instance
              .collection('foods')
              .doc(users.docs[0].id).update({
          'like': counted,
          }
          );
    }
    else if (users.docs.isEmpty){
      await FirebaseFirestore.instance
      .collection('foods')
      .add({
          'like': counted,
          }
          );
    }
  }

 
}



 