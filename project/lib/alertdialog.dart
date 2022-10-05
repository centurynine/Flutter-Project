import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';


class showFailDialog extends StatefulWidget {
  const showFailDialog({super.key});

  @override
  State<showFailDialog> createState() => _showFailDialogState();
}

class _showFailDialogState extends State<showFailDialog> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          Text("Status:",
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