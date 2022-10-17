import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project/food/allfood.dart';
import 'package:project/account/login.dart';
import 'package:project/account/facebook.dart';
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
                      ElevatedButton(
                        child: Text(
                          'รายการอาหารทั้งหมด',
                          style: GoogleFonts.kanit(
                            fontSize: 17,
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/food');
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.red[400], backgroundColor: Colors.red[400],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22.0),
                          ),
                          fixedSize: Size(180, 70),
                          elevation: 15,
                          shadowColor: Colors.white,
                     //     side: BorderSide(color: Colors.red, width: 3),
                        ),
                      ),
                      ElevatedButton(
                        child: Text(
                          'รายการอาหารของฉัน',
                          style: GoogleFonts.kanit(
                            fontSize: 17,
                            color: Colors.white,
                          ),
                        ),
                        
                        onPressed: () {
                          Navigator.pushNamed(context, '/myfood');
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.red[400], backgroundColor: Colors.red[400],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22.0),
                          ),
                          fixedSize: Size(180, 70),
                          elevation: 15,
                          shadowColor: Colors.white,
                          
                        //  side: BorderSide(color: Colors.red, width: 3),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                        child: Text(
                          'แชร์สูตรอาหาร',
                          style: GoogleFonts.kanit(
                            fontSize: 17,
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/upload');
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.pinkAccent, backgroundColor: Colors.pinkAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22.0),
                          ),
                          fixedSize: Size(140, 70),
                          elevation: 15,
                          shadowColor: Colors.white,
                          side: BorderSide(color: Colors.pinkAccent, width: 3),
                        ),
                      ),
                      SizedBox(height: 20),
                      Uploadwidget()
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