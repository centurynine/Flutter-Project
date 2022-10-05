import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/login.dart';
import 'package:project/login_page.dart';

class NavBar extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text("Account Name"), 
            accountEmail: Text(userEmail),
            )
        ],
        
      )
      

    );
  }
}