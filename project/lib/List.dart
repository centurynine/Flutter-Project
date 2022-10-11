// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class foodBody extends StatefulWidget {
//   const foodBody({super.key});

//   @override
//   State<foodBody> createState() => _foodBodyState();
// }

// class _foodBodyState extends State<foodBody> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: StreamBuilder(
//           stream: FirebaseFirestore.instance.collection('foods').snapshots(),
//           builder:
//               (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//             if (!snapshot.hasData) {
//               return const Center(
//                 child: CircularProgressIndicator(),
//               );
//             }
//             return Column(
//               children: [
//                 Expanded(
//                   child: ListView(
//                     children: snapshot.data!.docs.map((document) {
//                       return ListTile(
//                         title: Text(document['title']),
//                         subtitle: Text(document['subtitle']),
//                       );
//                     }).toList(),
//                   ),
//                 ),
//               ],
//             );
            
//           }),
//     );
//   }
// }
