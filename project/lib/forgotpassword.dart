import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project/body.dart';

class forgotPassword extends StatefulWidget {
  const forgotPassword({super.key});

  @override
  State<forgotPassword> createState() => _forgotPasswordState();
}

class _forgotPasswordState extends State<forgotPassword> {

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Form(
        child: ListView(
            children: <Widget>[
        TextFormField(
          controller: emailController,
          cursorColor: Colors.lightBlue,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            labelText: 'Email',
            labelStyle: GoogleFonts.kanit(
              fontSize: 20,
            ),
          ),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (!validateEmail(value!)){
              return 'Please enter your email';
            }
            return null;
          },
        ),
        buildButton(),
        ]
        ),
      ),
        
    );
  }

  ElevatedButton buildButton() {
    return ElevatedButton(
      onPressed: () async {
        verifyEmail();
      },
      child: const Text('Send'),
    );
  }

  Future verifyEmail() async {
    try {
      await FirebaseAuth.instance
    .sendPasswordResetEmail(email: emailController.text.trim());
     ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("ส่งข้อมูลรีเซ็ทรหัสผ่านสำเร็จ")));
  }
   on FirebaseAuthException catch(e){
    print(e);
    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("ไม่พบข้อมูลผู้ใช้งาน")));

   }
  }

    bool validateEmail(String value) {
    RegExp regex = RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
    return (!regex.hasMatch(value)) ? false : true;
  }

  
}