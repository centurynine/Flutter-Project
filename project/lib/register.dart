import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formstate = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController userName = TextEditingController();

  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Register'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: Colors.black,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Form(
          key: _formstate,
          child: ListView(
            children: <Widget>[
                            Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: SizedBox(
                  height: 100,
                  child: Image.network(
                      "https://cdn-icons-png.flaticon.com/512/2397/2397697.png"),
                ),
              ),
              SizedBox(height: 50),
              Container(
                alignment: Alignment.topLeft,
                child: Text("    สมัครสมาชิก",
                style: GoogleFonts.kanit(
                        fontSize: 20,
                        color: Colors.black,
                      ),  
              )),
              Text("              กรอกข้อมูลเพื่อทำการลงทะเบียน",
           style: GoogleFonts.kanit(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                      
                      
          ),
              SizedBox(height: 20),
              Container(
                  margin: const EdgeInsets.only(left: 40.0, right: 40.0),
                  child: buildNameField()),
                  SizedBox(height: 10),
              Container(
                  margin: const EdgeInsets.only(left: 40.0, right: 40.0),
                  child: buildUserNameField()),
              SizedBox(height: 10),
              Container(
                  margin: const EdgeInsets.only(left: 40.0, right: 40.0),
                  child: buildEmailField()),
              SizedBox(height: 10),
              Container(
                  margin: const EdgeInsets.only(left: 40.0, right: 40.0),
                  child: buildPasswordField()),
              SizedBox(height: 10),
              Container(
                  margin: const EdgeInsets.only(left: 40.0, right: 40.0),
                  child: buildConfirmPasswordField()),
              SizedBox(height: 30),
              Container(
                  margin: const EdgeInsets.only(left: 100.0, right: 100.0),
                  child: buildRegisterButton()),
            
            ],
          ),
        ));
  }



  ElevatedButton buildRegisterButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Colors.blue,
        onPrimary: Colors.white,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
      child: const Text('Register'),
      onPressed: () async {
        print('Register');
        registerWithEmailPassword();
      },
    );
  }


 Future<void> registerWithEmailPassword() async {
    //Email şifre kayıt
    try {
      // var userCredential =
      final _user = await auth.createUserWithEmailAndPassword(
          email: email.text.trim(), 
          password: password.text.trim(),
          );
          uploadUser();
          _user.user!.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if ( e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
         ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("อีเมลล์ถูกใช้งานแล้ว")));
      } else if (e.code == 'operation-not-allowed') {
        print('There is a problem with auth service config :/');
      } else if (e.code == 'weak-password') {
        print('Please type stronger password');
      } else {
        print('auth error ' + e.toString());
        print(e);
      }
    }
  }


  TextFormField buildPasswordField() {
    return TextFormField(
      controller: password,
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
        prefixIcon: Icon(Icons.lock),
        labelText: 'Password',
      ),
    );
  }

  TextFormField buildConfirmPasswordField() {
    return TextFormField(
      controller: confirmPassword,
      validator: (value) {
        if(value!.isEmpty)
           return 'กรุณากรอกรหัสผ่านอีกครั้ง';
         if(value != password.text)
           return 'รหัสผ่านไม่ตรงกัน';
         return null;
      },
      obscureText: true,
      keyboardType: TextInputType.text,
      decoration: const InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(22.0)),
        ),
        prefixIcon: Icon(Icons.lock),
        labelText: 'Confirm Password',
      ),
    );
  }


  TextFormField buildUserNameField() {
    return TextFormField(
      controller: userName,
      validator: (value) {
        if (value!.isEmpty)
          return 'Username is required';
        else
          return null;
      },
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(22.0)),
        ),
        prefixIcon: Icon(Icons.person),
        labelText: 'User Name',
        hintText: 'Bunhee',
      ),
    );
  }

  TextFormField buildNameField() {
    return TextFormField(
      controller: name,
      validator: (value) {
        if (value!.isEmpty)
          return 'กรุณากรอกชื่อ';
        else
          return null;
      },
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(22.0)),
        ),
        prefixIcon: Icon(Icons.person),
        labelText: 'Name',
        hintText: 'Sivagon ganjanaburi',
      ),
    );
  }


  TextFormField buildEmailField() {
    return TextFormField(
      controller: email,
      validator: (value) {
        if (value!.isEmpty)
          return 'กรุณากรอกอีเมล';
        else
          return null;
      },
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(22.0)),
        ),
        prefixIcon: Icon(Icons.email),
        labelText: 'E-mail',
        hintText: 'email@example.com',
      ),
    );
  }

  Future<bool> isUserLogged() async {
    var user = await auth.currentUser;
    if (user != null) {
      return true;
    } else {
      return false;
    }
  }

  void uploadUser() async {

          await FirebaseFirestore.instance.collection("users").add(
        {
          "email": email.text,
          "username": userName.text,
          "name": name.text
          }
          );
  }
}
