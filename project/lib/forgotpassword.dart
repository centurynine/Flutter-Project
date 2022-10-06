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
        child: ListView(children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: SizedBox(
              height: 100,
              child: Image.network(
                  "https://cdn-icons-png.flaticon.com/512/6195/6195696.png"),
            ),
          ),
          SizedBox(height: 80),
          Text("           Password Reset",
           style: GoogleFonts.kanit(
                        fontSize: 20,
                        color: Colors.black,
                      ),
          ),
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
          registerButton(context),


        ]

        
        ),
      ),
    );
  }

  TextFormField forgorText() {
    return TextFormField(
      controller: emailController,
      cursorColor: Colors.lightBlue,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.email),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        labelText: 'Enter Email Address',
        labelStyle: GoogleFonts.kanit(
          fontSize: 15,
        ),
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (!validateEmail(value!)) {
          return 'Please enter your email';
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
      onPressed: () async {
        verifyEmail();
      },
      child: const Text('Reset Password'),
    );
  }

  Future verifyEmail() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("ส่งข้อมูลรีเซ็ทรหัสผ่านสำเร็จ")));
    } on FirebaseAuthException catch (e) {
      print(e);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("ไม่พบข้อมูลผู้ใช้งาน")));
    }
  }

  bool validateEmail(String value) {
    RegExp regex = RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
    return (!regex.hasMatch(value)) ? false : true;
  }


  GestureDetector registerButton(BuildContext context) {
    return GestureDetector(
      child: Container(
        alignment: Alignment.center,
        child: Text(
          "สมัครสมาชิก!",
          style: GoogleFonts.kanit(
            fontSize: 15,
            color: Colors.blue,
          ),
        ),
      ),
      onTap: () {
        print('Goto  Regis pagge');
        Navigator.pushNamed(context, '/register');
      },
    );
  }


}
