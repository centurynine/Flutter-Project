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
import 'package:project/widget/drawer.dart';
import 'package:getwidget/getwidget.dart';
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

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

  bool imageUpload = false;
  String? title;
  String? subtitle;
  String? ingredients;
  String? description;
  String? docslength;
  String? countid;
  File? _foodpic;
  File? imageFile;
  String? message;
  String channelId = "1000";
  String channelName = "FLUTTER_NOTIFICATION_CHANNEL";
  String channelDescription = "FLUTTER_NOTIFICATION_CHANNEL_DETAIL";
  String? dropdown;
  String? dropdownValue;
  String foodType = 'ไม่ระบุ';
  String? titlenoti;
  String? subtitlenoti;
  TextEditingController titleController = TextEditingController();
  TextEditingController subtitleController = TextEditingController();
  TextEditingController ingredientsController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       drawer:  DrawerWidget(),
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'อัพโหลดรายการอาหาร',
            style: GoogleFonts.kanit(
              fontSize: 20,
              color: Colors.black,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
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
                height: 20,
              ),

              Container(
                margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: descriptionForm(),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                child: selectType(context),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                  margin: const EdgeInsets.only(
                      left: 100.0, right: 100.0, bottom: 20.0),
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
    hint: Text('เลือกประเภทอาหาร',
    style: GoogleFonts.kanit(
      fontSize: 16,
      color: Colors.grey,
    ),
    ),
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
      child: Text(value,
          style: GoogleFonts.kanit(
              fontSize: 16, color: Colors.black87)),
    ))
        .toList(),
  ),
),
);
  }

  initState() {
    message = "No message.";
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('notiicon');
    var initializationSettingsIOS = DarwinInitializationSettings(
        onDidReceiveLocalNotification: (id, title, body, payload) async {
      print("onDidReceiveLocalNotification called.");
    });
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (payload) async {
      print("onSelectNotification called.");
      setState(() {
        message = payload.payload;
      });
    });
    super.initState();



    
  }

  sendNotification() async {
    const BigPictureStyleInformation bigPictureStyleInformation =
      BigPictureStyleInformation(
      DrawableResourceAndroidBitmap('food'),
      largeIcon: DrawableResourceAndroidBitmap('bell'),
      contentTitle: 'อัพโหลดรายการอาหารแล้ว',
      htmlFormatContentTitle: true,
      summaryText: 'รายการอาหารถูกอัพโหลดลงในระบบแล้ว',
      htmlFormatSummaryText: true,
    );
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      '10000',
      'FLUTTER_NOTIFICATION_CHANNEL',
      channelDescription: 'FLUTTER_NOTIFICATION_CHANNEL_DETAIL',
      importance: Importance.max,
      priority: Priority.high,
      styleInformation: bigPictureStyleInformation,
    );

    var iOSPlatformChannelSpecifics = const DarwinNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        111, 'อัพโหลดรายการอาหารแล้ว', 'เมนู $titlenoti', platformChannelSpecifics,
        payload: ' ');
  }

  TextFormField titleForm() {
    return TextFormField(
      controller: titleController,
      onChanged: (value) {
        title = value.trim();
        setState(() {
          titlenoti = title;
        });
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
      controller: subtitleController,
      onChanged: (value) {
        subtitle = value.trim();
        setState(() {
          subtitlenoti = subtitle;
        });
      },
      validator: (value) {
        if (value!.length < 2)
          return 'กรุณากรอกข้อมูล';
        else
          return null;
      },
      keyboardType: TextInputType.text,
      maxLength: 200,
      minLines: 1,
      maxLines: 6,
      decoration: const InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
        hintText: 'แสดงรายละเอียดเล็กน้อย',
        labelText: 'คำอธิบาย',
        prefixIcon: Icon(Icons.note_alt),
      ),
    );
  }

  TextFormField descriptionForm() {
    return TextFormField(
      controller: descriptionController,
      minLines: 1,
      maxLines: 15,
      onChanged: (value) {
        description = value.trim();
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
        prefixIcon: Icon(Icons.description_outlined ),
      ),
    );
  }

  TextFormField ingredientsForm() {
    return TextFormField(
      controller: ingredientsController,
      minLines: 1,
      maxLines: 15,
      onChanged: (value) {
        ingredients = value.trim();
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
        prefixIcon: Icon(Icons.fastfood_outlined),
      ),
    );
  }

  ElevatedButton submitButton() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.red[400],
          onPrimary: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        ),
        onPressed: () async {
          if (user == null) {
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
          if (user != null) {
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
              if (_formstateUpload.currentState!.validate()) {
                print('Valid Form');
                _formstateUpload.currentState!.save();
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
              //    sendNotification();
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
        },
        child: Text(
          'อัพโหลด',
          style: GoogleFonts.kanit(
            fontSize: 18,
            color: Colors.white,
          ),
        ));
  }

  void countDocuments() async {
    if(FirebaseAuth.instance.currentUser != null) {
    QuerySnapshot _myDoc =
        await FirebaseFirestore.instance.collection('foods').get();
    List<DocumentSnapshot> _myDocCount = _myDoc.docs;
    docslength = _myDocCount.length.toString();
    print('จำนวนข้อมูลก่อนเพิ่ม $docslength');
    updateDocuments();
  } else {
    print('ไม่พบการเข้าสู่ระบบ');
  }
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
          .then((value) => FirebaseFirestore.instance
              .collection('docs_all_count')
              .doc(value.docs[0].id)
              .update({"allcount": FieldValue.increment(1)}));
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
    await FirebaseFirestore.instance
    .collection("foods")
    .doc(countid)
    .set({
      "id": countid,
      "uid": FirebaseAuth.instance.currentUser!.uid,
      "email": FirebaseAuth.instance.currentUser!.email,
      "displayname": FirebaseAuth.instance.currentUser!.displayName,
      "title": '$title',
      "subtitle": '$subtitle',
      "description": description,
      "ingredients": ingredients,
      "created_at": DateTime.now(),
      "food_type": foodType,
      "like": '0',
      "uploadImageUrl": url,
    });
    sendNotification();
    print('Create complete');
    ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
    ScaffoldMessenger.of(context).showMaterialBanner(MaterialBanner(
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
    if(FirebaseAuth.instance.currentUser != null) {
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
  } else {
    print('ไม่พบการเข้าสู่ระบบ');
  }
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
}
