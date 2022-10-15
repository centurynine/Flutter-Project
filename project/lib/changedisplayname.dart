import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project/body.dart';
import 'package:project/setting.dart';

class Changedisplayname extends StatefulWidget {
  const Changedisplayname({super.key});
  @override
  State<Changedisplayname> createState() => _ChangedisplaynameState();
}

class _ChangedisplaynameState extends State<Changedisplayname> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  String? nameNew;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(' Change Displayname',
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
                  "assets/images/idcard.png"),
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
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Container(
                margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: nameText()),
          ),
          SizedBox(height: 20),
          Container(
              margin: const EdgeInsets.only(left: 100.0, right: 100.0),
              child: buildButton()),
        ]),
      ),
    );
  }

  TextFormField nameText() {
    return TextFormField(
      maxLength: 25,
      onSaved: (value) {
        nameNew = value!.trim();
      },
      validator: (value) {
        if (!validateUsername(value!))
          return 'กรุณากรอกชื่อให้มากกว่า 6 ตัวอักษร';
        else
        setState(() {
          nameNew = value;
        });
          return null;
      },
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(22.0)),
        ),
        labelText: 'Display name',
        prefixIcon: Icon(Icons.email),
        hintText: 'Your Name',
      ),
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
        checkName();
      },
      child: const Text('Change DisplayName'),
    );
  }

  void checkName() async {
    final User? user = auth.currentUser;
    final email = user!.email;
    if (formKey.currentState!.validate()) {
      QuerySnapshot query = await FirebaseFirestore.instance
      .collection('users')
      .where('name' ,isEqualTo: nameNew)
      .get();
      if(query.docs.isEmpty){
        print('สามารถเปลี่ยนชื่อได้');
        EasyLoading.show(status: 'กำลังโหลด...');
        changeName();
      }
      else {
         print('ไม่สามารถเปลี่ยนชื่อได้');
         EasyLoading.showError('ไม่สามารถใช้ชื่อนี้ได้');
      }
    }
  }

 void changeName() async {
    final User? user = auth.currentUser;
    final email = user!.email;
    if (formKey.currentState!.validate()) {
      await FirebaseFirestore.instance
      .collection('users')
      .where('uid' ,isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .get()
      .then((value) => value.docs.forEach((element) {
        FirebaseFirestore.instance.collection('users').doc(element.id).update({
          'name': nameNew,
        });
      }));
      EasyLoading.dismiss();
      EasyLoading.showSuccess('เปลี่ยนชื่อสำเร็จแล้ว');
      print(nameNew);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Setting()),
      );
    }
  }

  bool validateUsername(String value) {
    if (value.length < 6) {
      return false;
    } else {
      return true;
    }
  }


}