import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class AddFoodsMenuPage extends StatefulWidget {
  const AddFoodsMenuPage({super.key});

  @override
  State<AddFoodsMenuPage> createState() => _AddFoodsMenuPageState();
}

class _AddFoodsMenuPageState extends State<AddFoodsMenuPage> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _time = TextEditingController();
  final _ingredient = TextEditingController();
  final _details = TextEditingController();
  File? _foodpic;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Menus"),
      ),
      body: Form(
        key: _form,
        child: ListView(
          children: <Widget>[
            showImage(),
            buildNameField(),
            buildTimeToDoField(),
            buildIngredientField(),
            buildDetailsField(),
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
          padding: const EdgeInsets.all(4), // Border width
          decoration: BoxDecoration(
              color: Colors.blue, borderRadius: BorderRadius.circular(30)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: SizedBox.fromSize(
              size: const Size.fromRadius(80), // Image radius
              child: Image(
                fit: BoxFit.cover,
                image: _foodpic == null
                    ? const AssetImage('assets/dish.png')
                    : Image.file(_foodpic!).image,
              ),
            ),
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
                    _pictureFromCamera();
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
                    _pictureFromGallery();
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

  _pictureFromCamera() async {
    //รอกล้อง
    XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    _pictureCrop(pickedFile!.path);
    Navigator.pop(context);
  }

  _pictureFromGallery() async {
    //รอคลัง
    XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    _pictureCrop(pickedFile!.path);
    Navigator.pop(context);
  }

  _pictureCrop(imagePath) async {
    //ครอปรูป
    CroppedFile? croppedImage = await ImageCropper()
        .cropImage(sourcePath: imagePath, maxHeight: 1080, maxWidth: 1920);
    if (croppedImage != null) {
      setState(() {
        _foodpic = File(croppedImage.path);
      });
    }
  }

  chooseImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
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

  TextFormField buildNameField() {
    return TextFormField(
      controller: _name,
      decoration: const InputDecoration(
        labelText: 'Menu Name',
        icon: Icon(Icons.fastfood_rounded),
        contentPadding: EdgeInsets.symmetric(vertical: 25.0, horizontal: 10.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(22.0)),
        ),
      ),
      validator: (value) => value!.isEmpty ? 'Please fill a menu name' : null,
    );
  }

  TextFormField buildTimeToDoField() {
    return TextFormField(
      controller: _time,
      decoration: const InputDecoration(
        labelText: 'Time to do',
        icon: Icon(Icons.access_time),
        contentPadding: EdgeInsets.symmetric(vertical: 25.0, horizontal: 10.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(22.0)),
        ),
      ),
      validator: (value) => value!.isEmpty ? 'Please fill a time' : null,
    );
  }

  TextFormField buildIngredientField() {
    return TextFormField(
      controller: _ingredient,
      decoration: const InputDecoration(
        labelText: 'Ingredients',
        icon: Icon(Icons.menu_book_rounded),
        contentPadding: EdgeInsets.symmetric(vertical: 25.0, horizontal: 10.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(22.0)),
        ),
      ),
      validator: (value) => value!.isEmpty ? 'Please fill a ingredient' : null,
    );
  }

  TextFormField buildDetailsField() {
    return TextFormField(
      controller: _details,
      maxLines: 10,
      decoration: const InputDecoration(
        labelText: 'Details',
        icon: Icon(Icons.note_alt_rounded),
        contentPadding: EdgeInsets.symmetric(vertical: 25.0, horizontal: 10.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(22.0)),
        ),
      ),
      validator: (value) => value!.isEmpty ? 'Please fill a details' : null,
    );
  }
}
