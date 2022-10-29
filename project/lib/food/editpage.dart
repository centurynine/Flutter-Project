import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:project/widget/drawer.dart';
import 'package:getwidget/getwidget.dart';
import 'package:uri_to_file/uri_to_file.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:math'; 

class EditData extends StatefulWidget {
  final DocumentSnapshot docs;
  const EditData({Key? key, required this.docs}) : super(key: key);

  @override
  State<EditData> createState() => _EditDataState();
}

class _EditDataState extends State<EditData> {
  final _formstateUpload = GlobalKey<FormState>();
  final auth = FirebaseFirestore.instance;
  var user = FirebaseAuth.instance.currentUser;
  var uploadUrl;
  bool imageUpload = false;
  String? title;
  String? subtitle;
  String? ingredients;
  String? description;
  String? docslength;
  String? countid;
  File? _foodpic;
  File? imageFile;
  String? dropdown;
  String? dropdownValue;
  String foodType = 'ไม่ระบุ';

@override
void initState(){
  super.initState();
  urlToFile();
}



Future<File> urlToFile() async {
try {
var imageUrl = '${widget.docs['uploadImageUrl']}.png';
print(imageUrl);
Uri uri = Uri.parse(imageUrl);
// สุ่มชื่อสำหรับเก็บไฟล์
var rng = new Random();
// เก็บค่าตำแหน่งที่จะจัดเก็บไฟล์
Directory tempDir = await getTemporaryDirectory();
// เรียกตำแหน่งที่จะเก็บไฟล์
String tempPath = tempDir.path;
// สร้างไฟล์ใหม่พร้อมกับสุ่มชื่อ
File file = new File('$tempPath'+ (rng.nextInt(100)).toString() +'.png');
http.Response response = await http.get(uri);
await file.writeAsBytes(response.bodyBytes);
setState(() {
  _foodpic = file;
  imageUpload = true;
});
return file; 
} catch (e) {
  throw Exception("Error " + e.toString());
 }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer:  DrawerWidget(),
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'แก้ไขรายการอาหาร',
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
                    "    แก้ไขข้อมูล ${widget.docs['title']} => ID ${widget.docs['id']}",
                    style: GoogleFonts.kanit(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Container(
                  margin: const EdgeInsets.only(left: 50.0, right: 50.0),
                  child: showImage()),
              const SizedBox(
                height: 20,
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
              const SizedBox(
                height: 10,
              ),
              Container(
                margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                child:  descriptionForm(),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                child:  selectType(context),
              ),
              Container(
                  margin: const EdgeInsets.only(left: 100.0, right: 100.0, bottom: 20.0),
                  child: submitButton()),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ));
  }

  Container selectType(BuildContext context) {
    return Container(
  height: 50,
  width: MediaQuery.of(context).size.width,
  margin: EdgeInsets.all(20),
  child: DropdownButtonHideUnderline(
  child: GFDropdown(
    hint: Text('เลือกประเภทอาหาร'),
    padding: const EdgeInsets.all(15),
    borderRadius: BorderRadius.circular(5),
    border: const BorderSide(
        color: Colors.black12, width: 1),
    dropdownButtonColor: Colors.white,
    value: dropdownValue,
    onChanged: (value) {
      setState(() {
        dropdownValue = value.toString();
        foodType = value.toString();
        print(foodType);
      });
      
    },
    
    items: [
      'อาหารไทย',
      'อาหารอีสาน',
      'อาหารฝรั่ง',
      'อาหารญี่ปุ่น',
      'อาหารเกาหลี',
      'ไม่ระบุ'
    ]
        .map((value) => DropdownMenuItem(
      value: value,
      child: Text(value),
    ))
        .toList(),
  ),
),
);
  }


  TextFormField titleForm() {
    return TextFormField(
      initialValue: widget.docs['title'],
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
      maxLength: 30,
      decoration: const InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
        hintText: 'หัวข้อ',
        labelText: 'ชื่ออาหาร',
        prefixIcon: Icon(Icons.food_bank),
      ),
    );
  }

  TextFormField subtitleForm() {
    return TextFormField(
      initialValue: widget.docs['subtitle'],
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
      maxLength: 200,
      decoration: const InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
        hintText: 'แสดงรายละเอียดเล็กน้อย',
        labelText: 'คำอธิบาย',
        prefixIcon: Icon(Icons.food_bank),
        
      ),
    );
  }

  TextFormField descriptionForm() {
    return TextFormField(
      initialValue: widget.docs['description'],
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
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
        hintText: 'รายละเอียด',
        labelText: 'ขั้นตอนการทำ',
        alignLabelWithHint: true,
        prefixIcon: Icon(Icons.how_to_reg),
      ),
    );
  }

  TextFormField ingredientsForm() {
    return TextFormField(
      initialValue: widget.docs['ingredients'],
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
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
        hintText: '',
        labelText: 'ส่วนผสม',
        prefixIcon: Icon(Icons.food_bank),
      ),
    );
  }

  ElevatedButton submitButton() {
    return ElevatedButton(
        child: Text(
          'อัพโหลด',
          style: GoogleFonts.kanit(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          primary: Colors.blue,
          onPrimary: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        ),
        onPressed: () async {
          if (user == null) {
            ScaffoldMessenger.of(context).showMaterialBanner(MaterialBanner(
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
            if (imageUpload == false) {
              ScaffoldMessenger.of(context).showMaterialBanner(MaterialBanner(
                content: Text("กรุณาอัพโหลดรูปภาพ"),
                leading: Icon(Icons.info),
                actions: [
                  TextButton(
                    child: const Icon(Icons.settings),
                    onPressed: () {
                    },
                  ),
                ],
              ));
              Future.delayed(const Duration(milliseconds: 6000), () {
                ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
              });
            } else if (imageUpload == true) {
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
                          ScaffoldMessenger.of(context)
                              .hideCurrentMaterialBanner();
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
              } else {
                print('Error');
              }
            }
          }
        });
  }

  void countDocuments() async {
    QuerySnapshot _myDoc =
        await FirebaseFirestore.instance.collection('foods').get();
    List<DocumentSnapshot> _myDocCount = _myDoc.docs;
    docslength = _myDocCount.length.toString();
    print('จำนวนข้อมูลก่อนเพิ่ม $docslength');
    createID();
  }

  void createID() async {
      var countid = widget.docs['id'];
      print("EditID : $countid");
      setState(() {
        countid = countid;
      });
      uploadImageToFirebase(countid);
  }

  void createDatabase(String countid, String url) async {
     QuerySnapshot query = await FirebaseFirestore.instance
        .collection('foods')
        .where('id', isEqualTo: countid)
        .get();
       if (query.docs.isNotEmpty) {
      FirebaseFirestore.instance
          .collection('foods')
          .where('id', isEqualTo: countid)
          .where(widget.docs['id']) 
          .get()
          .then((value) => FirebaseFirestore.instance
              .collection('foods')
              .doc(value.docs[0].id)
              .update({
                "id": countid,
                "title": title,
                "subtitle": subtitle,
                "description": description,
                "ingredients": ingredients,
                "created_at": DateTime.now(),
                "food_type": foodType,
                "uploadImageUrl": url,
          }
          )
          );
          }
    print('Edit complete');
    ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
  }

  //////////////////////////////CAMERA

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
    var reference = FirebaseStorage.instance.ref().child('foods/${countid}');
    var uploadTask = reference.putFile(_foodpic!);
    var url = await (await uploadTask).ref.getDownloadURL();
    print('uploadImageToFirebase URL IMAGE : {$url}');
    createDatabase(countid, url);
  }


  // void editData() async {
  //   FirebaseFirestore.instance.collection('foods').get().then((snapshot) {
  //           for (DocumentSnapshot edit in snapshot.docs) {
  //             edit.reference.update({
  //               'isReadyToPlay': true, 
  //               'totalScore': 254 
  //             });
  //           }
  //         }
  //         );
  // }

}
