import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project/body.dart';

class Changedisplayname extends StatefulWidget {
  const Changedisplayname({super.key});
  @override
  State<Changedisplayname> createState() => _ChangedisplaynameState();
}

class _ChangedisplaynameState extends State<Changedisplayname> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(' Change Displayname'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Form(
        child: ListView(children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: SizedBox(
              height: 100,
              child: Image.network(
                  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSTBqPGnBVxNcciJClCawl8fnZovFiRoc-c3g&usqp=CAU"),
            ),
          ),
          SizedBox(height: 80),
          Text(
            "           Display name change",
            style: GoogleFonts.kanit(
              fontSize: 20,
              color: Colors.black,
            ),
          ),
          Text(
            "             กรอกชื่อเพื่อเปลี่ยน",
            style: GoogleFonts.kanit(
              fontSize: 14,
              color: Colors.black,
            ),
          ),
          // Container(
          //   margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
          //                     decoration: BoxDecoration(
          //                       border: Border(
          //                         bottom: BorderSide(
          //                           color: Colors.black,
          //                           width: 0.5,
          //                         ),
          //                       ),
          //                     ),
          //                   ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Container(
                margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: forgorText()),
          ),
          SizedBox(height: 20),
          Container(
              margin: const EdgeInsets.only(left: 100.0, right: 100.0),
              child: buildButton()),
        ]),
      ),
    );
  }

  TextFormField forgorText() {
    return TextFormField(
      controller: emailController,
      cursorColor: Colors.lightBlue,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.people),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        labelText: 'Display Name',
        labelStyle: GoogleFonts.kanit(
          fontSize: 15,
        ),
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (!validateUsername(value!)) {
          return 'Please enter your Displayname';
        }
        return null;
      },
    );
  }

  ElevatedButton buildButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Colors.lightBlue,
        onPrimary: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
      onPressed: () async {},
      child: const Text('Change DisplayName'),
    );
  }

  bool validateUsername(String value) {
    RegExp regex = RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
    return (!regex.hasMatch(value)) ? false : true;
  }
}
