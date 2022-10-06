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
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        
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
          Text(userName),
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