import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:project/food/addcomment.dart';


class CommentPage extends StatefulWidget {
  final DocumentSnapshot docs;

  const CommentPage({Key? key, required this.docs}) : super(key: key);

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  Query<Map<String, dynamic>> dataComment = FirebaseFirestore.instance
      .collection('comments')
      .where('id', isEqualTo: '89');
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
            if (snapshot.hasData) {
      //            checkCreate();
      // checkAdmin();
                return Container(
                  height: 300,
                  child: ListView(
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
                                margin: EdgeInsets.only(top: 10 , left: 10 , right: 20),
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
                    }).toList(),
                  ),
                );
                } else {
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Text('No Data'),
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


  void deleteComment(String comment_id) async {
    await FirebaseFirestore.instance
        .collection('comments')
        .where('id', isEqualTo: widget.docs['id'])
        .where('email', isEqualTo: FirebaseAuth.instance.currentUser!.email)
        .where('comment_id', isEqualTo: comment_id)
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