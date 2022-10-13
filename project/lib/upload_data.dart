import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:firebase_storage/firebase_storage.dart';


class UploadData extends StatefulWidget {
  const UploadData({super.key});
  @override
  State<UploadData> createState() => _UploadDataState();
}

class _UploadDataState extends State<UploadData> {
  final _formstateUpload = GlobalKey<FormState>();
  final auth = FirebaseFirestore.instance;
  var user = FirebaseAuth.instance.currentUser;
  var uploadUrl;
  String? title;
  String? subtitle;
  String? ingredients;
  String? description;
  String? docslength;
  String? countid;
  File? _foodpic;
  File? imageFile;

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
                  child: showImage()),
              const SizedBox(
                height: 10,
              ),
              Container(
                  margin: const EdgeInsets.only(left: 100.0, right: 100.0),
                  child: submitButton()),
              const SizedBox(
                height: 10,
              ),
               Container(
                  margin: const EdgeInsets.only(left: 100.0, right: 100.0),
                  child: testUpload()),
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
             countDocuments();
             
          _formstateUpload.currentState!.reset();
          
          Navigator.pushNamed(context, '/food');
          EasyLoading.dismiss();
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
    print('จำนวนข้อมูลก่อนเพิ่ม $docslength');
    updateDocuments();
}

  void updateDocuments() async {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection('docs_all_count')
        .where('allcount')
        .get();
    if (query.docs.isNotEmpty) {
      FirebaseFirestore.instance
        .collection('docs_all_count')
        .where('allcount')
        .get()
        .then((value) => 
              FirebaseFirestore.instance
                  .collection('docs_all_count')
                  .doc(value.docs[0].id)
                  .update({"allcount": FieldValue.increment(1)})
            );
       print('Add 1 to allcount');
      createID();
    } else if (query.docs.isEmpty) {
      print('ไม่สามารถเพิ่มฟอร์มจำนวนได้');
    }
  }

    void createID() async {
    QuerySnapshot createcountid = await FirebaseFirestore.instance
        .collection('docs_all_count')
        .where('allcount')
        .get();
     if (createcountid.docs.isNotEmpty) {
       var countid = (createcountid.docs[0]['allcount'].toString());
        print("จำนวนข้อมูล ID ทั้งหมดที่สร้างและ ID ปัจจุบัน : $countid");
        setState(() {
          countid = countid;
        });
        uploadImageToFirebase(countid);
  }
 }

 void createDatabase(String countid, String url) async {
    await FirebaseFirestore.instance.collection("foods").add(
        {
          "id": countid,
          "uid": FirebaseAuth.instance.currentUser!.uid,
          "email": FirebaseAuth.instance.currentUser!.email,
          "displayname": FirebaseAuth.instance.currentUser!.displayName,
          "title": title,
          "subtitle": subtitle,
          "description": description,
          "ingredients": ingredients,
          "created_at": DateTime.now(),
          "uploadImageUrl": url,
        }
          );
          print('Create complete');
          ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
          ScaffoldMessenger.of(context)
                  .showMaterialBanner(MaterialBanner(
                    content: Text("เพิ่มรายการอาหารเรียบร้อย!"),
                    leading: Icon(Icons.food_bank_sharp),
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


 //////////////////////////////CAMERA


 showImage() {
    return GestureDetector(
        onTap: () {
          _showImage();
        },
        child: Container(
          padding: const EdgeInsets.all(9), // Border width
          decoration: BoxDecoration(
              color: Colors.grey[350], borderRadius: BorderRadius.circular(20)),
          child: ClipRRect(
            
            borderRadius: BorderRadius.circular(5),
            child: SizedBox.fromSize(
              size: const Size.fromRadius(80), // Image radius
              child: Image(
                fit: BoxFit.fitHeight,
                image: _foodpic == null
                    ? const AssetImage('assets/pictureupload.png')
                    : Image.file(_foodpic!).image,
              ),
            ),
          ),
        ));
  }


  ElevatedButton uploadImageButton() {
    return ElevatedButton(
      onPressed: () {
        _showImage();
      },
      child: const Text('เลือกรูปภาพ'),
    );
  }

  ElevatedButton testUpload() {
    return ElevatedButton(
      onPressed: () {
    //   uploadImageToFirebase(countid);
      },
      child: const Text('TestUpload'),
    );
  }

  _showImage() {
    // AlertBox options
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("กรุณาเลือกรูปจาก"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () {
                    chooseImageFromCamera();
                 //   _pictureFromCamera();
                  },
                  child: Row(
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Icon(
                          Icons.camera,
                          color: Colors.blue,
                        ),
                      ),
                      Text("กล้องถ่ายรูป")
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                       chooseImageFromGallery();
                      },
                  child: Row(
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Icon(
                          Icons.image,
                          color: Colors.blue,
                        ),
                      ),
                      Text("คลังรูปภาพ")
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

  // _pictureFromCamera() async {
  //   //รอกล้อง
  //   XFile? pickedFile =
  //       await ImagePicker().pickImage(source: ImageSource.camera);
  //   _pictureCrop(pickedFile!.path);
  //   Navigator.pop(context);
  // }

  // _pictureFromGallery() async {
  //   //รอคลัง
  //   XFile? pickedFile =
  //       await ImagePicker().pickImage(source: ImageSource.gallery);
  //   _pictureCrop(pickedFile!.path);
  //   Navigator.pop(context);
  // }

  _pictureCrop(imagePath) async {
    //ครอปรูป
    CroppedFile? croppedImage = await ImageCropper()
        .cropImage(sourcePath: imagePath, maxHeight: 1080, maxWidth: 1920);
    if (croppedImage != null) {
      setState(() {
        _foodpic = File(croppedImage.path);
      });
    }
    else {
      setState(() {
        _foodpic = File(imagePath);
      });
    }
  }

  chooseImageFromCamera() async {
    Navigator.pop(context);
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _foodpic = File(pickedFile.path);
        _pictureCrop(pickedFile.path);
      } else {
        ScaffoldMessenger.of(context).showMaterialBanner(MaterialBanner(
          content: Text("ไม่ได้เลือกรูปภาพ โปรดเลือกรูปภาพใหม่อีกครั้ง"),
          leading: Icon(Icons.warning),
          actions: [
            TextButton(
              child: Text("ปิด"),
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
              },
            ),
          ],
        ));
        Future.delayed(const Duration(milliseconds: 3000), () {
          ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
        });
      }
    });
  }


  chooseImageFromGallery() async {
    Navigator.pop(context);
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _foodpic = File(pickedFile.path);
      } else {
        ScaffoldMessenger.of(context).showMaterialBanner(MaterialBanner(
          content: Text("ไม่ได้เลือกรูปภาพ โปรดเลือกรูปภาพใหม่อีกครั้ง"),
          leading: Icon(Icons.info),
          actions: [
            TextButton(
              child: Text("ปิด"),
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
              },
            ),
          ],
        ));
        Future.delayed(const Duration(milliseconds: 2500), () {
          ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
        });
      }
    });
  }

 
Future uploadImageToFirebase(String countid) async {
        var reference = FirebaseStorage.instance.ref().child('foods/${countid}');
        var uploadTask = reference.putFile(_foodpic!);
        var url = await (await uploadTask).ref.getDownloadURL();
        print('uploadImageToFirebase URL IMAGE : {$url}');
        createDatabase(countid, url);
       // pathUpload();
      }

  void pathUpload() {
    print('pathUpload URL IMAGE : {$uploadUrl}');
  }

}