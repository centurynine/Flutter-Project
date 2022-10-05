import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project/body.dart';
import 'package:project/login.dart';
import 'NavBar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(),
      body: const Body(),
      appBar: AppBar(
        title: const Text('Home', style: TextStyle(color: Colors.black,fontFamily: 'josefinSans'),),
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          color: Colors.black,
          onPressed: () {},
        ),
        
        actions: <Widget>[
          Text("Status: $statusText",
          style: TextStyle(color: Colors.black,fontFamily: 'josefinSans'
          ),
          ),
          IconButton(
            icon: const Icon(Icons.login),
            color: Colors.black,
            onPressed: () {
              Navigator.pushNamed(context, '/login');
            },
          ),
      
        ],
      ),
    );
    
  }


}
 