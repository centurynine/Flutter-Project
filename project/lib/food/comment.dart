import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
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
 @override
 void initState() {
   super.initState();

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
                return Container(
                  height: 400,
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
                                   height: 100,
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
                );} else {
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
}