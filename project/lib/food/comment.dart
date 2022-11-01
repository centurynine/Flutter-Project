import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project/food/addcomment.dart';
import 'package:project/food/notfound.dart';


class CommentPage extends StatefulWidget {
  final DocumentSnapshot docs;

  const CommentPage({Key? key, required this.docs}) : super(key: key);

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  String? avatar = 'https://firebasestorage.googleapis.com/v0/b/mainproject-25523.appspot.com/o/users%2F18%2F18?alt=media&token=f441ac6d-3a63-444f-b694-f5f6f90b14de';
  bool? create = false;
  bool? isAdmin = false;
 @override
 void initState() {
   super.initState();
   checkAdmin();
 }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
             .collection('comments')
             .where('id', isEqualTo: widget.docs['id'])
            .snapshots(),
          builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Container(
                        child: Padding(
                          padding: const EdgeInsets.all(11.0),
                          child: Text('การโหลดข้อมูลผิดพลาด',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.kanit(fontSize: 18)),
                        ),
                      );
                      print('Something went wrong');
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      EasyLoading.show(status: 'กำลังโหลด...');
                      print('Loading');
                      return Text("กำลังโหลด...",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.kanit(fontSize: 20));
                    }
                    if(snapshot.data!.docs.isEmpty){
                      EasyLoading.dismiss();
                      return Container(
                        child: Padding(
                          padding: const EdgeInsets.all(11.0),
                          child: Text('ไม่มีคอมเม้นต์',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.kanit(fontSize: 18)),
                        ),
                      );
                    }
                    EasyLoading.dismiss();
            if (snapshot.hasData) {
                return Container(
                    constraints: new BoxConstraints(
                          minHeight: 110.0,
                          maxHeight: 300.0,
                    ),
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    children: snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>; 
                      return Container(
                        child: Row(

                          children: [
                            Container(
                                   width: 50,
                                   height: 50,
                            margin: EdgeInsets.only(left: 20),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(data['avatar']!),
                              ),
                            ),
                          ),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(top: 5 , left: 10 , right: 20, bottom: 5),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ListTile(
                                    trailing:  isAdmin == true || FirebaseAuth.instance.currentUser!.email == '${data['email']}'
                                      ? IconButton(
                                        icon: Icon(Icons.delete), onPressed: () {
                                          deleteComment('${data['comment_id']}');
                                        },)
                                      : SizedBox.shrink() ,
                                    title: Text(data['name']),
                                    subtitle: Text(data['descript']),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    ).toList(),

                  ),
                );
                } else {
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Text(''),
                          );
                        }
                     },
                  ),
              ],
              
          );
          
      }

  Future<void> checkCreate() async {
    await FirebaseFirestore.instance
        .collection('comments')
        .where('id', isEqualTo: widget.docs['id'])
        .where('email', isEqualTo: FirebaseAuth.instance.currentUser!.email)
        .get()
        .then((value) {
      if (value.docs.isEmpty) {
        print('ไม่พบเจ้าของคอมเม้นต์');
        setState(() {
          create = false;
        });
      } else if ((value.docs.isNotEmpty)) {
        print('พบเจ้าของคอมเม้นต์');
        setState(() {
          create = true;
        });
      }
    });
  }
  
  Future<void> checkAdmin() async {
    await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: FirebaseAuth.instance.currentUser!.email)
        .where('admin', isEqualTo: 'true')
        .get()
        .then((value) {
      if (value.docs.isEmpty) {
        print('isAdmin = false');
        setState(() {
          isAdmin = false;
        });
      } else if ((value.docs.isNotEmpty)) {
        print('isAdmin = true');
        setState(() {
          isAdmin = true;
        });
      }
    });
  }


  void deleteComment(String commentId) async {
    await FirebaseFirestore.instance
        .collection('comments')
        .where('id', isEqualTo: widget.docs['id'])
        .where('comment_id', isEqualTo: commentId)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        FirebaseFirestore.instance
            .collection('comments')
            .doc(element.id)
            .delete();
      });
    });
    EasyLoading.showSuccess('ลบคอมเม้นต์สำเร็จ');
  }

}