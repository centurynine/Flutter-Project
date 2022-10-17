import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project/widget/drawer.dart';
import 'package:project/homepage/home.dart';
import 'package:project/account/login.dart';
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
  String? countUser;
  String? countID;
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


  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer:  DrawerWidget(),
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text('Register',
              style: TextStyle(
                color: Colors.black87,
              )),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_outlined,
                color: Colors.black87, size: 20),
            color: Colors.black87,
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
                height: 50,
                  margin: const EdgeInsets.only(left: 100.0, right: 100.0),
                  child: buildRegisterButton()),
            
            ],
          ),
        ));
  }



  ElevatedButton buildRegisterButton() {
    return ElevatedButton(
      
      style: ElevatedButton.styleFrom(
        
        primary: Colors.red[400],
        onPrimary: Colors.white,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
      child: Text('สมัครสมาชิก',
      style: GoogleFonts.kanit(
                        fontSize: 18,
                        color: Colors.white,
                      ),
      ),
      onPressed: () async {
        print('Register');
        registerWithEmailPassword();
      },
    );
  }

 Future<void> registerWithEmailPassword() async {
  if(FirebaseAuth.instance.currentUser == null) {
    try {
      final _user = await auth.createUserWithEmailAndPassword(
          email: email.text.trim(), 
          password: password.text.trim(),
          );
           print(_user.user!.uid);
           FirebaseAuth.instance.currentUser!.updateProfile(displayName: name.text.trim());
           countDocuments();
          _user.user!.sendEmailVerification();
        //  _signOut();
              //               ScaffoldMessenger.of(context)
              //     .showMaterialBanner(MaterialBanner(
              //       content: Text("ลงทะเบียนสำเร็จ โปรดยืนยันอีเมลล์"),
              //       leading: Icon(Icons.info),
              //       actions: [
              //         TextButton(
              //           child: Text("ปิด"),
              //           onPressed: () {
              //             ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
              //           },
              //         ),
              //       ],
              //     ));
              // Future.delayed(Duration(milliseconds: 3000), () {
              //   ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
              // });
         // Navigator.pushNamed(context, '/');
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
    }}
    else {
      Navigator.pushReplacement(context, CupertinoPageRoute(builder: (_) => Homepage()));
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

  void countDocuments() async {
    QuerySnapshot _allUser =
        await FirebaseFirestore.instance.collection('users').get();
    List<DocumentSnapshot> _myDocCount = _allUser.docs;
    countUser = _myDocCount.length.toString();
    print('จำนวนข้อมูลก่อนเพิ่ม $countUser');
    updateDocuments();
  }
  

  void updateDocuments() async {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection('users_count')
        .where('userallcount')
        .get();
    if (query.docs.isNotEmpty) {
      FirebaseFirestore.instance
          .collection('users_count')
          .where('userallcount')
          .get()
          .then((value) => FirebaseFirestore.instance
              .collection('users_count')
              .doc(value.docs[0].id)
              .update({"userallcount": FieldValue.increment(1)}));
      print('Add 1 to allcount');
      createID();
    } else if (query.docs.isEmpty) {
      print('ไม่สามารถเพิ่มฟอร์มจำนวนได้');
    }
  }




  void createID() async {
    QuerySnapshot createcountid = await FirebaseFirestore.instance
        .collection('users_count')
        .where('userallcount')
        .get();
    if (createcountid.docs.isNotEmpty) {
      var countid = (createcountid.docs[0]['userallcount'].toString());
      print("จำนวนข้อมูล ID ทั้งหมดที่สร้างและ ID ปัจจุบัน : $countid");
      setState(() {
        countID = countid;
      });
      uploadUser(countID!);
    }
  }


  // void uploadImageToFirebase(String countid) async {
  //   String fileName = basename(_image!.path);
  //   Reference firebaseStorageRef =
  //       FirebaseStorage.instance.ref().child('users/$countid/$fileName');
  //   UploadTask uploadTask = firebaseStorageRef.putFile(_image!);
  //   TaskSnapshot taskSnapshot = await uploadTask;
  //   taskSnapshot.ref.getDownloadURL().then(
  //     (value) {
  //       print("Done: $value");
  //       setState(() {
  //         _uploadedFileURL = value;
  //       });
  //       addDataToFirebase(countid);
  //     },
  //   );
  // }

  void uploadUser(String countID) async {
          await FirebaseFirestore.instance.collection("users").add(
        {
          "id": countID,
          "uid": auth.currentUser!.uid,
          "email": email.text,
          "name": name.text,
          "admin": false.toString(),
          "created_at": DateTime.now().toString(),
          "loginwith": 'Firebase',
          "avatar": 'https://firebasestorage.googleapis.com/v0/b/mainproject-25523.appspot.com/o/avatarnull%2Favatar.png?alt=media&token=14755271-9e58-4710-909c-b10f9c1917e9'
          }
    );
    _signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Homepage()));
  }

     Future _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

}
