import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project/account/login.dart';
import 'package:project/widget/drawer.dart';
import 'package:project/account/setting.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});
  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  TextEditingController newPasswordSave = TextEditingController();
  TextEditingController confirmNewPasswordSave = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final userEmail = FirebaseAuth.instance.currentUser?.email;
  String? currentPassword;
  String? newPassword;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer:  DrawerWidget(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(' Change Password',
            style: TextStyle(color: Colors.black87)
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
          color: Colors.black87,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Form(
        key: formKey,
        child: ListView(children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: SizedBox(
              height: 100,
              child: Image.asset(
                  "assets/images/passwordchange.png"),
            ),
          ),
          SizedBox(height: 80),
          Text(
            "           Password change",
            style: GoogleFonts.kanit(
              fontSize: 20,
              color: Colors.black,
            ),
          ),
          Text(
            "             กรอกรหัสผ่าน",
            style: GoogleFonts.kanit(
              fontSize: 14,
              color: Colors.black,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Container(
                margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: passwordText()),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Container(
                margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: newPasswordText()),
          ),
                    Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Container(
                margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: confirmNewPasswordText()),
          ),
          SizedBox(height: 20),
          Container(
              margin: const EdgeInsets.only(left: 100.0, right: 100.0),
              child: buildButton()),
        ]),
      ),
    );
  }

  TextFormField passwordText() {
    return TextFormField(
      onSaved: (value) {
        currentPassword = value!.trim();
      },
      validator: (value) {
        if (!validatePassword(value!))
          return 'กรุณากรอกรหัสผ่านให้มากกว่า 8 ตัวอักษร';
        else
        setState(() {
          currentPassword = value;
        });
          return null;
      },
      obscureText: true,
      keyboardType: TextInputType.visiblePassword,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(22.0)),
        ),
        labelText: 'รหัสผ่านเก่า',
        prefixIcon: Icon(Icons.password_outlined),
        hintText: '@examplepassword',
        labelStyle: GoogleFonts.kanit(
          fontSize: 14,
        ),
      ),
    );
  }


  TextFormField newPasswordText() {
    return TextFormField(
      controller: newPasswordSave,
      onSaved: (value) {
        newPassword = value!.trim();
      },
      validator: (value) {
        if (!validatePassword(value!))
          return 'กรุณากรอกรหัสผ่านให้มากกว่า 8 ตัวอักษร';
        else
        setState(() {
          newPassword = value;
        }
        );
          return null;
      },
      keyboardType: TextInputType.visiblePassword,
      textInputAction: TextInputAction.next,
      obscureText: true,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(22.0)),
        ),
        labelText: 'รหัสผ่านใหม่',
        prefixIcon: Icon(Icons.password_outlined),
        hintText: '@newpassword',
        labelStyle: GoogleFonts.kanit(
          fontSize: 14,
        ),
      ),
    );
  }


  TextFormField confirmNewPasswordText() {
    return TextFormField(
      controller: confirmNewPasswordSave,
      onSaved: (value) {
        newPassword = value!.trim();
      },
      validator: (value) {
        if(value!.isEmpty)
           return 'กรุณากรอกรหัสผ่านอีกครั้ง';
         if(value != newPasswordSave.text)
           return 'รหัสผ่านไม่ตรงกัน';
         return null;
      },
      keyboardType: TextInputType.visiblePassword,
      textInputAction: TextInputAction.next,
      obscureText: true,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(22.0)),
        ),
        labelText: 'ยืนยันรหัสผ่านใหม่',
        prefixIcon: Icon(Icons.password_outlined),
        hintText: '@newpassword',
        labelStyle: GoogleFonts.kanit(
          fontSize: 14,
        ),
      ),
    );
  }

  ElevatedButton buildButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(200, 50),
        primary: Colors.red[400],
        onPrimary: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
      onPressed: () async {
        _changePassword();
      },
      child: Text('เปลี่ยนรหัสผ่าน',
      style: GoogleFonts.kanit(
        fontSize: 20,
        color: Colors.white,
      ),
      ),
    );
  }

 Future _changePassword() async {
  if (FirebaseAuth.instance.currentUser != null) {
    var user = FirebaseAuth.instance.currentUser!;
    if (formKey.currentState!.validate()) {
      try {
    final cred =  EmailAuthProvider.credential(email: userEmail!, password: currentPassword!);
    await user.reauthenticateWithCredential(cred).then((value) async {
      try {
        await user.updatePassword(newPassword!);
        EasyLoading.showSuccess('เปลี่ยนรหัสผ่านสำเร็จแล้ว');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Setting()),
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          EasyLoading.showError('รหัสผ่านต้องมีอย่างน้อย 6 ตัวอักษร');
        } else if (e.code == 'wrong-password') {
          EasyLoading.showError('รหัสผ่านไม่ถูกต้อง');
        }
      } catch (e) {
        print(e);
      }
    });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        EasyLoading.showError('รหัสผ่านไม่ถูกต้อง');
      }
    }
    }
 } else {
    EasyLoading.showError('กรุณาเข้าสู่ระบบ');
          Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
  }
 }
 }




  // bool validatePassword(String value) {
  //   String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$';
  //   RegExp regExp = new RegExp(pattern);
  //   return regExp.hasMatch(value);
  // }

  bool validatePassword(String value) {
    if (value.length < 8) {
      return false;
    } else {
      return true;
    }
  }



    