import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
class UploadData extends StatefulWidget {
  const UploadData({super.key});

  @override
  State<UploadData> createState() => _UploadDataState();
}

class _UploadDataState extends State<UploadData> {
  final _formstateUpload = GlobalKey<FormState>();
  final auth = FirebaseFirestore.instance;
  var user = FirebaseAuth.instance.currentUser;
  String? title;
  String? subtitle;
  String? ingredients;
  String? description;
  String? docslength;
  int? _myDocCount;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Upload Data',
        style: GoogleFonts.kanit(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                    ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      
      ),
        body: Form(
          autovalidateMode: AutovalidateMode.always,
          key: _formstateUpload,
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: SizedBox(
                  height: 100,
                  child: Image.network(
                      "https://cdn-icons-png.flaticon.com/512/2276/2276931.png"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "    อัพโหลดรายการอาหาร",
                    style: GoogleFonts.kanit(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: titleForm(),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: subtitleForm(),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: descriptionForm(),
              ),
               const SizedBox(
                height: 10,
              ),
              Container(
                margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: ingredientsForm(),
              ),
              Container(
                  margin: const EdgeInsets.only(left: 100.0, right: 100.0),
                  child: submitButton()),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        )
    );
  }
  
  TextFormField titleForm() {
    return TextFormField(
      onSaved: (value) {
        title = value!.trim();
      },
      validator: (value) {
        if (value!.length < 2)
          return 'กรุณากรอกข้อมูล';
        else
          return null;
      },
      keyboardType: TextInputType.text,
      decoration: const InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(22.0)),
        ),
        hintText: 'หัวข้อ',
        labelText: 'ชื่ออาหาร',
        prefixIcon: Icon(Icons.food_bank),
      ),
    );
  }

  TextFormField subtitleForm() {
    return TextFormField(
      onSaved: (value) {
        subtitle = value!.trim();
      },
      validator: (value) {
        if (value!.length < 2)
          return 'กรุณากรอกข้อมูล';
        else
          return null;
      },
      keyboardType: TextInputType.text,
      decoration: const InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(22.0)),
        ),
        hintText: 'แสดงรายละเอียดเล็กน้อย',
        labelText: 'คำอธิบาย',
        prefixIcon: Icon(Icons.food_bank),
      ),
    );
  }

  TextFormField descriptionForm() {
    return TextFormField(
      maxLines: 10,
      onSaved: (value) {
        description = value!.trim();
      },
      validator: (value) {
        if (value!.length < 2)
          return 'กรุณากรอกข้อมูล';
        else
          return null;
      },
      keyboardType: TextInputType.multiline,
      decoration: const InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(22.0)),
        ),
        hintText: 'รายละเอียด',
        labelText: 'ขั้นตอนการทำ',
        prefixIcon: Icon(Icons.how_to_reg),
      ),
    );
  }

  TextFormField ingredientsForm() {
    return TextFormField(
      maxLines: 5,
      onSaved: (value) {
        ingredients = value!.trim();
      },
      validator: (value) {
        if (value!.length < 2)
          return 'กรุณากรอกข้อมูล';
        else
          return null;
      },
      keyboardType: TextInputType.multiline,
      decoration: const InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        hintText: '',
        labelText: 'ส่วนผสม',
        
        prefixIcon: Icon(Icons.food_bank),
      ),
    );
  }


  ElevatedButton submitButton() {
    return ElevatedButton(
        child: const Text('อัพโหลดข้อมูล'),
        style: ElevatedButton.styleFrom(
          primary: Colors.blue,
          onPrimary: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        ),
        onPressed: () async {
          if (user == null) {
            ScaffoldMessenger.of(context)
                  .showMaterialBanner(MaterialBanner(
                    content: Text("กรุณาเข้าสู่ระบบ"),
                    leading: Icon(Icons.info),
                    actions: [
                      TextButton(
                        child: const Icon(Icons.settings),
                        onPressed: () {
                          ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
                        },
                      ),
                    ],
                  ));
                  Future.delayed(const Duration(milliseconds: 6000), () {
                  ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
                });
          }
          if (user != null) {
            if (_formstateUpload.currentState!.validate()) {
            print('Valid Form');
            _formstateUpload.currentState!.save();
            try {
              EasyLoading.show(status: 'Uploading...');
              ScaffoldMessenger.of(context)
                  .showMaterialBanner(MaterialBanner(
                    content: Text("กำลังอัพโหลดข้อมูล..."),
                    leading: Icon(Icons.info),
                    actions: [
                      TextButton(
                        child: const Icon(Icons.settings),
                        onPressed: () {
                          ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
                        },
                      ),
                    ],
                  ));
                  Future.delayed(const Duration(milliseconds: 6000), () {
                  ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
                });
             await FirebaseFirestore.instance.collection("foods").add(
        {
          "uid": FirebaseAuth.instance.currentUser!.uid,
          "email": FirebaseAuth.instance.currentUser!.email,
          "displayname": FirebaseAuth.instance.currentUser!.displayName,
          "title": title,
          "subtitle": subtitle,
          "description": description,
          "ingredients": ingredients,
          "created_at": DateTime.now(),
      
          }
          );
          _formstateUpload.currentState!.reset();
          ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
          Navigator.pushNamed(context, '/food');
          EasyLoading.dismiss();
          countDocuments();
        } catch (e) {
              print(e);
            }
            }
            else {
              print('Error');
            }

        }}
        );

}

void countDocuments() async {
    QuerySnapshot _myDoc = await FirebaseFirestore.instance.collection('foods').get();
    List<DocumentSnapshot> _myDocCount = _myDoc.docs;
    docslength = _myDocCount.length.toString();
    print(docslength);
    updateDocuments();
}

  void updateDocuments() async {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection('docs_count')
        .where('count')
        .get();
    if (query.docs.isNotEmpty) {
      // FirebaseFirestore.instance.collection('docs_count').doc().update({
      //   'count': _myDocCount,
      // });
      FirebaseFirestore.instance
        .collection('docs_count')
        .where('count')
        .get()
        .then((value) => value.docs.forEach((element) {
              FirebaseFirestore.instance
                  .collection('docs_count')
                  .doc(element.id)
                  .update({'count': docslength});
            }));
   print('Docs is not empty');
    } else if (query.docs.isEmpty) {
      print('Docs is empty');
    }
  }


}