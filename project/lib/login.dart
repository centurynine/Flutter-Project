import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project/facebook.dart';
import 'package:project/home.dart';

int status = 0;
dynamic userEmail = "No Email";
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
  void initState() {
    super.initState();
    if(FirebaseAuth.instance.currentUser != null){
      print('Found user');
     SchedulerBinding.instance.addPostFrameCallback((_) {
  Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => Homepage()));
});
    }
    else {
      print('ไม่พบการเข้าสู่ระบบ');
    }
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text('Login',
              style: TextStyle(
                color: Colors.black87,
              )),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_outlined,
                color: Colors.black87, size: 20),
            color: Colors.black87,
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
        Navigator.pushReplacement(context, CupertinoPageRoute(builder: (_) => FacebookLogin()));
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
              EasyLoading.show(status: 'กำลังโหลด...');
              await auth
                  .signInWithEmailAndPassword(
                      email: email!, password: password!)
                  .then((value) {
                if (value.user!.emailVerified) {
                  userEmail = value.user!.email!;
                  ScaffoldMessenger.of(context)
                      .showMaterialBanner(MaterialBanner(
                    content: Text("เข้าสู่ระบบสำเร็จ"),
                    leading: Icon(Icons.info),
                    actions: [
                      TextButton(
                        child: Text("ปิด"),
                        onPressed: () {
                          ScaffoldMessenger.of(context)
                              .hideCurrentMaterialBanner();
                        },
                      ),
                    ],
                  ));
                  EasyLoading.showSuccess('เข้าสู่ระบบสำเร็จ!');
                 Future.delayed(const Duration(milliseconds: 1500), () {
                  ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
                  EasyLoading.dismiss();
                 });
                  //   _getDataFromDatabase();
                  Navigator.pushNamed(context, '/');
                } else {
                  FirebaseAuth.instance.currentUser!.sendEmailVerification();
                  FirebaseAuth.instance.signOut();
                  EasyLoading.showError('ตรวจสอบอีเมลของคุณ');
                  ScaffoldMessenger.of(context)
                      .showMaterialBanner(MaterialBanner(
                    content: Text("ยังไม่ยืนยันอีเมลล์"),
                    leading: Icon(Icons.info),
                    actions: [
                      TextButton(
                        child: Text("ปิด"),
                        onPressed: () {
                          ScaffoldMessenger.of(context)
                              .hideCurrentMaterialBanner();
                        },
                      ),
                    ],
                  ));
                  Future.delayed(const Duration(milliseconds: 2500), () {
                  EasyLoading.dismiss();
                  });
                }
              }).catchError((reason) {
                ScaffoldMessenger.of(context).showMaterialBanner(MaterialBanner(
                  content: Text("อีเมลล์หรือรหัสผ่านไม่ถูกต้อง"),
                  leading: Icon(Icons.info),
                  actions: [
                    TextButton(
                      child: Text("ปิด"),
                      onPressed: () {
                        ScaffoldMessenger.of(context)
                            .hideCurrentMaterialBanner();
                      },
                    ),
                  ],
                ));
                EasyLoading.showError('อีเมลล์หรือรหัสผ่านไม่ถูกต้อง');
                Future.delayed(const Duration(milliseconds: 2500), () {
                  ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
                  EasyLoading.dismiss();
                });
                
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


  Future _signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
