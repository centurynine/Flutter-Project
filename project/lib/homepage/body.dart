import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project/food/allfood.dart';
import 'package:project/account/login.dart';
import 'package:project/account/facebook.dart';
import 'package:project/food/myfood.dart';
import 'package:project/food/upload_data.dart';
import 'package:project/homepage/recommend_widget.dart';
import 'package:project/search/searchpage.dart';
import 'package:project/homepage/upload_widget.dart';
class Body extends StatefulWidget {
  const Body({super.key});
  @override
  State<Body> createState() => _BodyState();
}
class _BodyState extends State<Body> {
  String? name = '';
  String? userEmail = '';
  final db = FirebaseFirestore.instance;
  Future _getDataFromDatabase() async {
    if (FirebaseAuth.instance.currentUser != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: FirebaseAuth.instance.currentUser!.email)
          .get()
          .then(
            (QuerySnapshot snapshot) => {
              snapshot.docs.forEach((doc) {
                final getProfile =
                    json.decode(json.encode(doc.data()) as String)
                        as Map<String, dynamic>;
                print("documentID---- " + doc.data().toString());
                setState(() {
                  name = getProfile["name"];
                  userEmail = getProfile["email"];
                });
              }),
            },
          );
    } else {
      print('No user logged in');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      
      children: [
        FirebaseAuth.instance.currentUser != null
        ? Container(
          margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          child: GestureDetector(
             onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => SearchPage()));
                      },
            child: Container(
                height: 56,
                width: MediaQuery.of(context).size.width - 48,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: Colors.black.withOpacity(0.1),
                  //     offset: const Offset(0, 10),
                  //     blurRadius: 10,
                  //   ),
                  // ],
                ),
                alignment: Alignment.center,
                child: Row(
                  children: [
                    const SizedBox(width: 16),
                   IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SearchPage()));
                        },
                      ),
                    const SizedBox(width: 16),
                    GestureDetector(child: Text
                      ('Search',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      )
                      ,
                      ),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => SearchPage()));
                      },
                    ),
                  ],
                )),
          ),
        )
        : Container(
          margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          child: GestureDetector(
             onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => LoginPage()));
                      },
            child: Container(
                height: 56,
                width: MediaQuery.of(context).size.width - 48,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Row(
                  children: [
                    const SizedBox(width: 16),
                   IconButton(
              icon: const Icon(Icons.lock),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
                        },
                      ),
                    const SizedBox(width: 16),
                    GestureDetector(child: Text
                      ('Search',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      )
                      ,
                      ),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => LoginPage()));
                      },
                    ),
                  ],
                )),
          ),
        ),
        
        Container(
          alignment: Alignment.topLeft,
          child: Column(
            children: [
              Column(
                children: [
                  Text(
                    '   รายการแนะนำ',
                    style: GoogleFonts.kanit(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        SizedBox(height: 20),
        Recommendget(),
        SizedBox(height: 20),
        FirebaseAuth.instance.currentUser != null
            ? Column(
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(

                        width: 170,
                        height: 250,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(context, CupertinoPageRoute(builder: (_) => BodyAfterLogin()));
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.pinkAccent, 
                            backgroundColor: Colors.pinkAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            fixedSize: const Size(180, 70),
                            elevation: 15,
                            shadowColor: Colors.white,
                     //     side: BorderSide(color: Colors.red, width: 3),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 13),
                                width: 170,
                                height: 100,
                                child: Image.network(
                                  'https://cdn-icons-png.flaticon.com/512/1065/1065715.png',
                                  fit: BoxFit.fitHeight
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 15.0),
                                child: Text(
                                  'All Food List',
                                  style: GoogleFonts.kanit(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 19,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Text(
                                  'อาหารทั้งหมด',
                                  style: GoogleFonts.kanit(
                                    fontSize: 15,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0,bottom: 3),
                                child: Container(
                                  child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            primary: Colors.white,
                                            onPrimary: Colors.white,
                                            shape:
                                                RoundedRectangleBorder(borderRadius:
                                                BorderRadius.circular(20.0)),
                                          ),
                                    onPressed: () {
                                    Navigator.pushNamed(context, '/food');                      },
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Row(
                                      children: [
                                        Text('   คลิกเลย!  ',
                                          style: GoogleFonts.kanit(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.black87,
                                          ),
                                          
                                        ),
                                        Icon(Icons.arrow_forward_ios_rounded,
                                          color: Colors.pinkAccent,
                                        ),
                                      ],
                                    ),
                                  )
                                  ),
                                ),
                              )
                                      ],
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          Container(
                            width: 170,
                            height: 190,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushReplacement(context, CupertinoPageRoute(builder: (_) => MyFood()));
                              },
                               style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.blueGrey[900]?.withOpacity(0.4), 
                                backgroundColor: Colors.blueGrey[900]?.withOpacity(0.8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                fixedSize: Size(180, 70),
                                elevation: 15,
                                shadowColor: Colors.white,

                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(top: 13),
                                    width: 170,
                                    height: 70,
                                    child: Image.network(
                                      'https://cdn-icons-png.flaticon.com/512/3183/3183463.png',
                                      fit: BoxFit.fitHeight
                                    ),
                                  ),
                                  Text(
                                    'My Food List',
                                    style: GoogleFonts.kanit(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                      color: Colors.white,
                                    ),
                                  ),
                                   Text(
                                    'อาหารของฉัน',
                                    style: GoogleFonts.kanit(
                                      fontSize: 15,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Container(
                                    child: Row(
                                      children: [
                                        ElevatedButton(
                                          child: Row(
                                            children: [
                                              Text('ดูรายการ  ',
                                                style: GoogleFonts.kanit(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                  color: Colors.black87,
                                                ),
                                                ),
                                             Icon(Icons.arrow_forward_ios_rounded,
                                          color: Colors.pinkAccent,
                                        ),
                                            ],
                                          ),
                                              style: ElevatedButton.styleFrom(
                                                primary: Colors.white,
                                                onPrimary: Colors.white,
                                                shape:
                                                    RoundedRectangleBorder(borderRadius:
                                                    BorderRadius.circular(16.0)),
                                              ),
                                        onPressed: () {
                                        Navigator.pushNamed(context, '/myfood');                      },
                                  ),
                                      ],
                                    ),)
                                ],
                              ),
                            ),
                          ),

                          Container(
                            padding: EdgeInsets.only(top: 10),
                            width: 170,
                            height: 60,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/upload');
                              },
                               style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.blueGrey.withOpacity(0.8), 
                                backgroundColor: Colors.blueGrey.withOpacity(0.8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                fixedSize: Size(180, 70),
                                elevation: 15,
                                shadowColor: Colors.white,
                              ),
                              child: Text(
                                'อัพโหลดอาหาร',
                                style: GoogleFonts.kanit(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                      SizedBox(height: 20),
                      Uploadwidget(),
              ],

            )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton(
                    child: Text(
                      'เข้าสู่ระบบ',
                      style: GoogleFonts.kanit(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.red[400], backgroundColor: Colors.red[400],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22.0),
                      ),
                      fixedSize: Size(140, 70),
                      elevation: 15,
                      shadowColor: Colors.white,
               //       side: BorderSide(color: Colors.red, width: 3),
                    ),
                  ),
         
                  ElevatedButton(
                    child: Text(
                      'สมัครสมาชิก',
                      style: GoogleFonts.kanit(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.red[400], backgroundColor: Colors.red[400],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22.0),
                      ),
                      fixedSize: Size(140, 70),
                      elevation: 15,
                      shadowColor: Colors.white,
               //       side: BorderSide(color: Colors.red, width: 3),
                    ),
                  ),
                ],
              ),
        Column(
          children: [
              Container(
                
              )
          ],
        ),
        
      ],
    );
  }

  Widget columnWidget() {
    print('render - Column Widget');
    return Column(
      children: [
        Column(
        )
      ],
    );
  }

  Future signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushNamed(context, '/login');
  }
}