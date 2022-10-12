import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UploadData extends StatefulWidget {
  const UploadData({super.key});

  @override
  State<UploadData> createState() => _UploadDataState();
}

class _UploadDataState extends State<UploadData> {
  final _formstateUpload = GlobalKey<FormState>();
  final auth = FirebaseFirestore.instance;
  String? title;
  String? subtitle;
  String? ingredients;
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
      maxLines: 10,
      onSaved: (value) {
        subtitle = value!.trim();
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
          if (_formstateUpload.currentState!.validate()) {
            print('Valid Form');
            _formstateUpload.currentState!.save();
            try {
             await FirebaseFirestore.instance.collection("foods").add(
        {
          "uid": FirebaseAuth.instance.currentUser!.uid,
          "email": FirebaseAuth.instance.currentUser!.email,
          "title": title,
          "subtitle": subtitle,
          "ingredients": ingredients,
          }
          );
          Navigator.pushNamed(context, 'food');
        } catch (e) {
              print(e);
            }
            }
            else {
              print('Error');
            }

        }
        );

}
}