import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:project/setting.dart';

class AvatarUpload extends StatefulWidget {
  const AvatarUpload({super.key});

  @override
  State<AvatarUpload> createState() => _AvatarUploadState();
}

class _AvatarUploadState extends State<AvatarUpload> {
  File? _foodpic;
  File? imageFile;
  bool imageUpload = false;
  String? name;
  String? avatar = 'https://cdn-icons-png.flaticon.com/512/149/149071.png';
  String? id;
  final auth = FirebaseAuth.instance;

@override
void initState() {
  if(name == null) {
    setState(() {
      name = 'ไม่พบชื่อผู้ใช้';
    });
  }
  super.initState();
  checkInfo();
}


  void checkInfo() async {
    if(FirebaseAuth.instance.currentUser != null){
     await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: FirebaseAuth.instance.currentUser!.email)
        .get()
       .then((value) => value.docs.forEach((element) {
        setState(() {
          name = element.data()['name'];
          avatar = element.data()['avatar'];
          id = element.data()['id'];
        });
      }));
      }
      else {
        setState(() {
          name = 'กรุณาเข้าสู่ระบบ';
          avatar = 'https://cdn-icons-png.flaticon.com/512/149/149071.png';
        });
      }
      }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Image'),
        
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(top: 50.0),
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  "อัพโหลดรูปภาพ",
                  style: GoogleFonts.kanit(fontSize: 20, color: Colors.black87),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                showImage(),
                SizedBox(
                  height: 20,
                ),
                submitButton(),
              ],
            ),
          ],
        ),
      ),
    );
  }


  showImage() {
    return GestureDetector(
        onTap: () {
          _showImage();
        },
        child: Container(
          margin: EdgeInsets.only(top: 10),
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


  ElevatedButton submitButton() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.blue,
          onPrimary: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        ),
        onPressed: () async {
          if (FirebaseAuth.instance.currentUser == null) {
            ScaffoldMessenger.of(context).showMaterialBanner(MaterialBanner(
              content: Text(" กรุณาเข้าสู่ระบบ "),
              leading: Icon(Icons.info),
              actions: <Widget>[
                Builder(
                  builder: (context) => TextButton(
                    child: const Icon(Icons.close),
                    onPressed: () {
                      ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
                    },
                  ),
                ),
              ],
            ));
            Future.delayed(const Duration(milliseconds: 6000), () {
              ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
            });
          }
          if (FirebaseAuth.instance.currentUser != null) {
            if (imageUpload == false) {
              ScaffoldMessenger.of(context).showMaterialBanner(MaterialBanner(
                content: Text(" กรุณาอัพโหลดรูปภาพ "),
                leading: Icon(Icons.info),
                actions: <Widget>[
                  Builder(
                    builder: (context) => TextButton(
                      child: const Icon(Icons.close),
                      onPressed: () {
                        ScaffoldMessenger.of(context)
                            .hideCurrentMaterialBanner();
                      },
                    ),
                  ),
                ],
              ));
              Future.delayed(const Duration(milliseconds: 6000), () {
                ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
              });
            } else if (imageUpload == true) {
                print('Valid Form');
                try {
                  EasyLoading.show(status: 'Uploading...');
                  ScaffoldMessenger.of(context)
                      .showMaterialBanner(MaterialBanner(
                    content: Text("กำลังอัพโหลดข้อมูล..."),
                    leading: Icon(Icons.info),
                    actions: <Widget>[
                      Builder(
                        builder: (context) => TextButton(
                          child: const Icon(Icons.close),
                          onPressed: () {
                            ScaffoldMessenger.of(context)
                                .hideCurrentMaterialBanner();
                          },
                        ),
                      ),
                    ],
                  ));
                  Future.delayed(const Duration(milliseconds: 2000), () {
                    ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
                  });
                //  countdoc();
              //    sendNotification();
                  Navigator.pushNamed(context, '/setting');
                  EasyLoading.dismiss();
                } catch (e) {
                  print(e);
                }
              } else {
                print('Error');
              }
            }
        },
        child: Text(
          'อัพโหลด',
          style: GoogleFonts.kanit(
            fontSize: 18,
            color: Colors.white,
          ),
        ));
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

  _pictureCrop(imagePath) async {
    //ครอปรูป
    CroppedFile? croppedImage = await ImageCropper()
        .cropImage(sourcePath: imagePath, maxHeight: 1080, maxWidth: 1920);
    if (croppedImage != null) {
      setState(() {
        imageUpload = true;
        _foodpic = File(croppedImage.path);
      });
    } else {
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
          content: Text("ไม่ได้เลือกรูปภาพ กรุณาเลือกรูปภาพอีกครั้ง"),
          leading: Icon(Icons.info),
          actions: <Widget>[
            Builder(
              builder: (context) => TextButton(
                child: const Icon(Icons.close),
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
                },
              ),
            ),
          ],
        ));
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
        _pictureCrop(pickedFile.path);
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
    var reference = FirebaseStorage.instance.ref().child('users/$id/$id');
    var uploadTask = reference.putFile(_foodpic!);
    var url = await (await uploadTask).ref.getDownloadURL();
    print('uploadImageToFirebase URL IMAGE : {$url}');
   // changeAvatar(url);
  }




 void changeAvatar(String url) async {
    final User? user = auth.currentUser;
    final email = user!.email;
      await FirebaseFirestore.instance
      .collection('users')
      .where('uid' ,isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .get()
      .then((value) => value.docs.forEach((element) {
        FirebaseFirestore.instance.collection('users').doc(element.id).update({
          'avatar': url,
        });
      }));
      EasyLoading.dismiss();
      EasyLoading.showSuccess('เปลี่ยนรูปโปรไฟล์สำเร็จ');
      print(url);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Setting()),
      );
  }




}
