import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project/login.dart';
import 'package:project/facebook.dart';
import 'package:project/recommend_widget.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {


  String? name = '';
  String? userName = '';
  String? userEmail = '';
  final db = FirebaseFirestore.instance;
  Future _getDataFromDatabase() async {
    if (FirebaseAuth.instance.currentUser != null) {
    await FirebaseFirestore.instance.collection('users')
      .where('email', isEqualTo: FirebaseAuth.instance.currentUser!.email)
      .get()
      .then((QuerySnapshot snapshot) => {
        snapshot.docs.forEach((doc) {
           final getProfile = 
             json.decode(json.encode(doc.data()) as String) as Map<String, dynamic>;
          print("documentID---- " + doc.data().toString());
         setState(() {
             userName = getProfile["username"];
             name = getProfile["name"];
             userEmail = getProfile["email"];
         });
        }),
      },
    );}
    else {
      print('No user logged in');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 24
            ),
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
                const Icon(Icons.search),
                const SizedBox(width: 16),
                Text(
                  'Search',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                  
                ),
              ],
            
            )

          ),
        ),
        Container(
          alignment: Alignment.topLeft,
          child: Column(
            children: [
              Column(
                children: [
                  Text('   รายการแนะนำ',
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
              Text("Login Success"),
            ],
          )
          : Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ElevatedButton(
                child: Text('เข้าสู่ระบบ',
                style: GoogleFonts.kanit(
                                    fontSize: 20,
                                    color: Colors.black,
                                  ),
                ),
                onPressed: () {
                Navigator.pushNamed(context, '/login');
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.white60,
                  onPrimary: Colors.blue[700],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  fixedSize: Size(150, 70),
                  elevation: 15,
                  shadowColor: Colors.white,
                  side: BorderSide(color: Colors.blue, width: 2),
                ),
               ),

               ElevatedButton(
                child: Text('สมัครสมาชิก',
                style: GoogleFonts.kanit(
                                    fontSize: 20,
                                    color: Colors.black,
                                  ),
                ),
                onPressed: () {
                Navigator.pushNamed(context, '/register');
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.white60,
                  onPrimary: Colors.blue[700],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  fixedSize: Size(150, 70),
                  elevation: 15,
                  shadowColor: Colors.white,
                  side: BorderSide(color: Colors.blue, width: 2),
                ),
               ),
            ], 
          ),
          Column(
            children: [
              Text("Name: $name"),
              Text("Username: $userName"),
              Text("Email: $userEmail"),
              SizedBox(height: 20),
              ElevatedButton(
                child: const Text('Get User Data'),
                onPressed: () {
                _getDataFromDatabase();
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.white60,
                  onPrimary: Colors.blue[700],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  fixedSize: Size(150, 70),
                  elevation: 15,
                  shadowColor: Colors.white,
                  side: BorderSide(color: Colors.blue, width: 2),
                ),
               ),
               ElevatedButton(
                child: const Text('Logout'),
                onPressed: () {
                signOut();
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.white60,
                  onPrimary: Colors.blue[700],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  fixedSize: Size(150, 70),
                  elevation: 15,
                  shadowColor: Colors.white,
                  side: BorderSide(color: Colors.blue, width: 2),
                ),
               ),
               ElevatedButton(
                child: Text("Popup"),
                onPressed: () {
                  ScaffoldMessenger.of(context)
                  .showMaterialBanner(MaterialBanner(
                    content: Text("This is a MaterialBanner"),
                    leading: Icon(Icons.info),
                    actions: [
                      TextButton(
                        child: Text("DISMISS"),
                        onPressed: () {
                          ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
                        },
                      ),
                    ],
                  ));

                },
                
                )
            ],
          ),columnWidget()
      ],
    );
  }

  Widget columnWidget(){
    print('render - Column Widget');
    return Column(
      children: [
        Text('data'),
        
      ],
    );
      
  }

  Future signOut() async {
    await FirebaseAuth.instance.signOut();
    if (status == 1) {
      setState(() {
        status = 0;
        userEmail = 'กรุณาเข้าสู่ระบบ';
      });
    } else {
      print('คุณออกจากระบบอยู่แล้ว');
    }
    Navigator.pushNamed(context, '/login');
  }



}