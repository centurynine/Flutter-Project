
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:project/login.dart';
import 'package:project/facebook.dart';
class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {


  String? name = '';
  String? userName = '';
  String? userEmail = '';

  // Future _getDataFromDatabaseTWO() async {
  //   await FirebaseFirestore.instance.collection('users')
  //     .doc(FirebaseAuth.instance.currentUser!.uid)
  //     .get()
  //     .then((snapshot) async
  //     {
  //       if(snapshot.exists)
  //       {
  //         print(snapshot.exists);
  //         setState(() { 
  //           name = snapshot.data()!['name'];
  //           userName = snapshot.data()!['username'];
  //           userEmail = snapshot.data()!['email'];
  //         });
  //       }
  //     });
  // }
  Future _getDataFromDatabase() async {
    await FirebaseFirestore.instance.collection('users')
      .where('email', isEqualTo: FirebaseAuth.instance.currentUser!.email)
      .get()
      .then((QuerySnapshot snapshot) => {
        snapshot.docs.forEach((doc) {
          print("documentID---- " + doc.id);
          print("documentID---- " + doc.data().toString());
         setState(() {
            // name = doc.data()
            //  userName = snapshot.data()!['username'];
            //  userEmail = snapshot.data()!['email'];
         });
        }),
      },
    );
      
  }
  // Future _getDataFromDatabase() async {
  //   await FirebaseFirestore.instance.collection('users')
  //     .where('email', isEqualTo: FirebaseAuth.instance.currentUser!.email)
  //     .get
  //     .then(
  //     (QuerySnapshot snapshot) => {
  //       snapshot.documents.forEach((f) {
        
  //         print("documentID---- " + f.reference.documentID);
         
  //       }),
  //     },
  //   );
      
  // }


  // Future _getDataFromDatabase() async {
  //   await FirebaseFirestore.instance.collection('users').get().then((value) {
  //     value.docs.forEach((element) {
  //       setState(() {
  //         name = element['name'];
  //         userName = element['username'];
  //         userEmail = element['email'];
  //       });
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
            "TEST", 
            style: Theme.of(context)
                .textTheme
                .headline5
                ?.copyWith(fontWeight: FontWeight.bold),
                ),  
          ),
            Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ElevatedButton(onPressed: () {},
               child: const Text('ถ่ายรูป')),
               ElevatedButton(onPressed: () {
                signOut();
               },
               child: const Text('Logout FB')),
            ],
          ),
          
          status == 1
          ? Column(
            children: [
              Text("Login Success"),
            ],
          )
          : Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ElevatedButton(
                child: const Text('เข้าสู่ระบบ'),
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
                child: const Text('สมัครสมาชิก'),
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
            ],
          ),
      ],
      
    );
  }

  Future<LoginPage> signOut() async {
    await FirebaseAuth.instance.signOut();
    if (status == 1) {
      setState(() {
        status = 0;
        statusText = 'Loged out';
      });
    } else {
      print('คุณออกจากระบบอยู่แล้ว');
    }
    return new LoginPage();
  }

}