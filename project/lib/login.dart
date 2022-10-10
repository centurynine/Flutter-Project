import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

int status = 0;
String statusText = "Not Logged In";
bool logoutBt = false;
String userEmail = "No Email";
String userName = "No Name";
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formstate = GlobalKey<FormState>();
  String? email;
  String? password;
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Login'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: Colors.black,
            onPressed: () {
              //   Navigator.pop(context);
              Navigator.pushNamed(context, '/');
            },
          ),
          actions: <Widget>[
            //  status == 1 ? logoutButton(context) : Container(),
          ],
        ),
        body: Form(
          autovalidateMode: AutovalidateMode.always,
          key: _formstate,
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: SizedBox(
                  height: 100,
                  child: Image.network(
                      "https://cdn-icons-png.flaticon.com/512/1728/1728853.png"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "    เข้าสู่ระบบ",
                    style: GoogleFonts.kanit(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Container(
                child: emailTextFormField(),
                margin: const EdgeInsets.only(left: 20.0, right: 20.0),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                child: passwordTextFormField(),
                margin: const EdgeInsets.only(left: 20.0, right: 20.0),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                child: forgetButton(context),
                margin: const EdgeInsets.only(left: 20.0, right: 10.0),
              ),
              Container(
                  margin: const EdgeInsets.only(left: 100.0, right: 100.0),
                  child: loginButton()),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      "ยังไม่ได้เป็นสมาชิก?",
                      style: GoogleFonts.kanit(
                        fontSize: 15,
                        color: Colors.black,
                      ),
                    )),
              ),
              Container(
                  margin: const EdgeInsets.only(left: 100.0, right: 100.0),
                  child: registerButton(context)),
              Container(
                child: loginfbButton(context),
                margin: const EdgeInsets.only(left: 20.0, right: 10.0),
              ),
              // Padding(
              //   padding: const EdgeInsets.all(20.0),
              //   child: logoutText(context),
              // ),
              // Text(userEmail),
            ],
          ),
        ));
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

  GestureDetector forgetButton(BuildContext context) {
    return GestureDetector(
      child: Container(
        alignment: Alignment.topRight,
        child: Text(
          "ลืมรหัสผ่าน?",
          style: GoogleFonts.kanit(
            fontSize: 15,
            color: Colors.blue,
          ),
        ),
      ),
      onTap: () {
        print('Goto  Regis pagge');
        Navigator.pushNamed(context, '/forgotpassword');
      },
    );
  }

  GestureDetector logoutText(BuildContext context) {
    return GestureDetector(
      child: Container(
        alignment: Alignment.center,
        child: Text(
          "ออกจากระบบ",
          style: GoogleFonts.kanit(
            fontSize: 15,
            color: Colors.blue,
          ),
        ),
      ),
      onTap: () {
        _signOut();
      },
    );
  }

  IconButton logoutButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.logout),
      color: Colors.black,
      onPressed: () {
        _signOut();
      },
    );
  }

  IconButton loginfbButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.facebook), 
      iconSize: 50.0,
      color: Colors.black,
      onPressed: () {
        Navigator.pushNamed(context, '/fb');
      },
    );
  }

  ElevatedButton loginButton() {
    return ElevatedButton(
        child: const Text('Login'),
        style: ElevatedButton.styleFrom(
          primary: Colors.blue,
          onPrimary: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        ),
        onPressed: () async {
          if (_formstate.currentState!.validate()) {
            print('Valid Form');
            _formstate.currentState!.save();
            try {
              await auth
                  .signInWithEmailAndPassword(
                      email: email!, password: password!)
                  .then((value) {
                if (value.user!.emailVerified) {
                  status = 1;
                  userEmail = value.user!.email!;
                  statusLogin();
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Login Pass")));
               //   _getDataFromDatabase();
                  Navigator.pushNamed(context, '/');
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please verify email")));
                }
              }).catchError((reason) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Login or Password Invalid")));
              });
          } on FirebaseAuthException catch (e) {
              if (e.code == 'user-not-found') {
                print('No user found for that email.');
              } else if (e.code == 'wrong-password') {
                print('Wrong password provided for that user.');
              }
            }
          } else {
            print('Invalid Form');
            _showMyDialog();
          }
        });
  }

  TextFormField passwordTextFormField() {
    return TextFormField(
      onSaved: (value) {
        password = value!.trim();
      },
      validator: (value) {
        if (value!.length < 8)
          return 'Please Enter more than 8 Character';
        else
          return null;
      },
      obscureText: true,
      keyboardType: TextInputType.text,
      decoration: const InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(22.0)),
        ),
        hintText: 'รหัสผ่าน',
        labelText: 'Password',
        prefixIcon: Icon(Icons.lock),
      ),
    );
  }
 
  TextFormField emailTextFormField() {
    return TextFormField(
      onSaved: (value) {
        email = value!.trim();
      },
      validator: (value) {
        if (!validateEmail(value!))
          return 'Please fill in E-mail field';
        else
          return null;
      },
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(22.0)),
        ),
        labelText: 'E-mail',
        prefixIcon: Icon(Icons.email),
        hintText: 'email@example.com',
      ),
    );
  }

  bool validateEmail(String value) {
    RegExp regex = RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
    return (!regex.hasMatch(value)) ? false : true;
  }

/////////////
  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ผิดพลาด'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('กรุณากรอกอีเมลล์และรหัสผ่านให้ถูกต้อง'),
              ],
            ),
          ),
          actions: <Widget>[
            Container(
              alignment: Alignment.center,
              child: ElevatedButton(
                child: const Text('   ตกลง   '),
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  onPrimary: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        );
      },
    );
  }

  void statusLogin() {
    if (status == 1) {
      setState(() {
        statusText = 'Loged in';
      });
      print('Login = $status');
    } else {
      print('Login Fail');
    }
  }

  void statusLogout() {
    if (status == 0) {
      setState(() {
        statusText = 'Loged out';
      });
      userEmail = "No Email";
      print('Logout');
    } else {
      print('Logout Fail');
      print('Status $status');
    }
////////
  }

   Future _signOut() async {
    await FirebaseAuth.instance.signOut();
    if (status == 1) {
      setState(() {
        status = 0;
        statusText = 'Loged out';
      });
      statusLogout();
    } else {
      print('คุณออกจากระบบอยู่แล้ว');
    }
  }
}