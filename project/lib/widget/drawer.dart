import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project/food/allfood.dart';
import 'package:project/food/myfood.dart';
import 'package:project/homepage/home.dart';
import 'package:project/account/login.dart';
import 'package:project/account/setting.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  String? name;
  String? avatar = 'https://cdn-icons-png.flaticon.com/512/149/149071.png';
  @override
  final GlobalKey<ScaffoldState> _drawerKey = new GlobalKey<ScaffoldState>();
  String? userEmail = 'กรุณาเข้าสู่ระบบ';
  @override
  void initState() {
    checkNameWhoCreated();
    super.initState();
    if (FirebaseAuth.instance.currentUser != null) {
      userEmail = FirebaseAuth.instance.currentUser?.email;
    }
  }

  void checkNameWhoCreated() async {
    if (FirebaseAuth.instance.currentUser != null) {
      final users = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: FirebaseAuth.instance.currentUser!.email)
          .where('avatar')
          .get();
      if (users.docs.isNotEmpty) {
        print('พบข้อมูลชื่อผู้โพส');
        print(users.docs[0].data()['email']);
        if (mounted) {
          setState(() {
            name = users.docs[0].data()['name'];
            avatar = users.docs[0].data()['avatar'];
          });
        }
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
          name = 'ไม่พบชื่อผู้ใช้';
        });
      }
    } else {
      print('ไม่พบข้อมูล');
      setState(() {
        name = 'ไม่พบชื่อผู้ใช้';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      width: MediaQuery.of(context).size.width / 1.3,
      // color: Colors.white,
      child: ListView(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 0),
            decoration: const BoxDecoration(
              color: Colors.redAccent,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.black54,
                    blurRadius: 5.0,
                    offset: Offset(0.0, 0.75))
              ],
            ),
            child: Column(
              children: <Widget>[
                Container(
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 50,
                        height: 100,
                        margin: EdgeInsets.only(left: 10,right: 10),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: CircleAvatar(
                              backgroundImage: Image.network(avatar!).image
                              // radius: 10,

                              ),
                        ),
                      ),
                      FirebaseAuth.instance.currentUser != null
                          ? Container(
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    child: Center(
                                      child: Text(
                                        name.toString(),
                                        style: GoogleFonts.kanit(
                                          fontSize: 14,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Center(
                                      child: Text(
                                        userEmail.toString().length > 28
                                            ? userEmail
                                                    .toString()
                                                    .substring(0, 20) +
                                                '...'
                                            : userEmail.toString(),
                                        overflow: TextOverflow.fade,
                                        //  userEmail.toString().substring(0, userEmail.toString().indexOf('@')),
                                        style: GoogleFonts.kanit(
                                          fontSize: 14,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Container(
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(left: 10),
                                    child: Text(
                                      'กรุณาเข้าสู่ระบบ',
                                      style: GoogleFonts.kanit(
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                    ],
                  ),
                ),
              ],
            ),
          ),
          FirebaseAuth.instance.currentUser != null
              ? Column(
                  children: [
                    ListTile(
                      title: Text('หน้าแรก',
                          style: GoogleFonts.kanit(
                              fontSize: 14, color: Colors.black)),
                      leading: Image.asset(
                        'assets/images/house.png',
                        width: 25,
                        height: 25,
                      ),
                      onTap: () {
                        print("Clicked");
                        Navigator.pushReplacement(context,
                            CupertinoPageRoute(builder: (_) => Homepage()));
                      },
                    ),
                    ListTile(
                      title: Text('รายการอาหารทั้งหมด',
                          style: GoogleFonts.kanit(
                              fontSize: 14, color: Colors.black)),
                      leading: Image.asset(
                        'assets/allfood.png',
                        width: 25,
                        height: 25,
                      ),
                      onTap: () {
                        print("Clicked");
                        Navigator.pushReplacement(
                            context,
                            CupertinoPageRoute(
                                builder: (_) => BodyAfterLogin()));
                      },
                    ),
                    ListTile(
                      title: Text('รายการอาหารของฉัน',
                          style: GoogleFonts.kanit(
                              fontSize: 14, color: Colors.black)),
                      leading: Image.asset(
                        'assets/myfood.png',
                        width: 25,
                        height: 25,
                      ),
                      onTap: () {
                        print("Clicked");
                        Navigator.pushReplacement(context,
                            CupertinoPageRoute(builder: (_) => MyFood()));
                      },
                    ),
                    ListTile(
                      title: Text('ตั้งค่า',
                          style: GoogleFonts.kanit(
                              fontSize: 14, color: Colors.black)),
                      leading: Image.asset(
                        'assets/setting.png',
                        width: 25,
                        height: 25,
                      ),
                      onTap: () {
                        print("Clicked");
                        Navigator.pushReplacement(context,
                            CupertinoPageRoute(builder: (_) => Setting()));
                      },
                    ),
                    ListTile(
                      title: Text('ออกจากระบบ',
                          style: GoogleFonts.kanit(
                              fontSize: 14, color: Colors.black)),
                      leading: Image.asset(
                        'assets/logout.png',
                        width: 25,
                        height: 25,
                      ),
                      onTap: () {
                        _signOut();
                        //  Navigator.pushNamed(context, '/');
                      },
                    ),
                  ],
                )
              : Column(
                  children: [
                    Container(
                      child: ListTile(
                        title: Text(
                          'เข้าสู่ระบบ',
                          style: GoogleFonts.kanit(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        leading: Image.asset(
                          'assets/login.png',
                          width: 25,
                          height: 25,
                        ),
                        onTap: () {
                          print("Clicked");
                          Navigator.pushNamed(context, '/login');
                        },
                      ),
                    ),
                    ListTile(
                      title: Text(
                        'สมัครสมาชิก',
                        style: GoogleFonts.kanit(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      leading: Image.asset(
                        'assets/register.png',
                        width: 25,
                        height: 25,
                      ),
                      onTap: () {
                        print("Clicked");
                        Navigator.pushNamed(context, '/register');
                      },
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  Future _signOut() async {
    EasyLoading.showInfo('ออกจากระบบสำเร็จ');
    await FirebaseAuth.instance.signOut();
    //  Navigator.pop(context);
    _doOpenPage();
  }

  void _doOpenPage() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
    Future.delayed(const Duration(milliseconds: 2000), () {
      EasyLoading.dismiss();
    });
  }
}
