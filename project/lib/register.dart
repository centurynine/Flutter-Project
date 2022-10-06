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
        if (_formstate.currentState!.validate()) {
          print(email.text);
          print(password.text);
          final _user = await auth.createUserWithEmailAndPassword(
              email: email.text.trim(), password: password.text.trim());
          _user.user!.sendEmailVerification();
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
              ModalRoute.withName('/'));
        } else {
          print('Invalid Form');
        }
      },
    );
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
}
