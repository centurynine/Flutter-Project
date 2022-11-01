import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class Addcomment extends StatefulWidget {
  final DocumentSnapshot docs;

  const Addcomment({super.key, required this.docs});

  @override
  State<Addcomment> createState() => _AddcommentState();
}

class _AddcommentState extends State<Addcomment> {
  String? name = 'ไม่พบผู้ใช้';
  String? descript = '';
  String? avatar = 'https://firebasestorage.googleapis.com/v0/b/mainproject-25523.appspot.com/o/avatarnull%2Favatar.png?alt=media&token=14755271-9e58-4710-909c-b10f9c1917e9';
  TextEditingController descriptionController = TextEditingController();
  String? countID;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(top: 10 , left: 20 , right: 20),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: titleForm()
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                          SizedBox(
                                          height: 50,
                                        ),
                                        
                    ],
    );
                    
  }

  TextFormField titleForm() {
    return TextFormField(
      controller: descriptionController,
      onChanged: (value) {
        descript = value.trim();
      },
      validator: (value) {
        if (value!.length < 2)
          return 'กรุณากรอกข้อมูล';
        else
          return null;
      },
      keyboardType: TextInputType.text,
      maxLength: 80,
      minLines: 1,
      maxLines: 10,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: 'Comment',
        labelText: 'Comment',
        prefixIcon: Icon(Icons.comment),
        suffixIcon: IconButton(
          
          icon: Icon(Icons.send),
          onPressed: (
          ) {
            if (descript!.isEmpty) {
              EasyLoading.showError('กรุณากรอกข้อมูล');
            } else {
              checkName();
            }
          },
        ),
      ),
    );
  }

  void checkName() async {
    await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: FirebaseAuth.instance.currentUser!.email)
        .get()
        .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
        print(doc['name']);
      });
      setState(() {
        name = querySnapshot.docs[0]['name'];
        avatar = querySnapshot.docs[0]['avatar'];
      });
    });
    countComment();
  }

  void countComment() async {
      await FirebaseFirestore.instance
          .collection('comments_count')
          .where('count')
          .get()
          .then((value) => FirebaseFirestore.instance
              .collection('comments_count')
              .doc(value.docs[0].id)
              .update({"count": FieldValue.increment(1)}));
     createCommentID() ;
  }


  void createCommentID() async {
    QuerySnapshot createcountid = await FirebaseFirestore.instance
        .collection('comments_count')
        .where('count')
        .get();
    if (createcountid.docs.isNotEmpty) {
      var countid = (createcountid.docs[0]['count'].toString());
      setState(() {
        countID = countid;
      });
      addcomment(countID!);
    }
  }


  void addcomment(String countID) async {
    await FirebaseFirestore.instance.collection('comments').add({
      'comment_id': countID,
      'name': name,
      'email': FirebaseAuth.instance.currentUser!.email,
      'descript': descript,
      'id': widget.docs['id'],
      'avatar': avatar,
      'date': DateTime.now(),
    });
    descriptionController.clear();
    descript = '';
    EasyLoading.showSuccess('คอมเม้นสำเร็จ');
  }




}