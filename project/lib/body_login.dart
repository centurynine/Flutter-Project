import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BodyAfterLogin extends StatelessWidget {

  CollectionReference data = FirebaseFirestore.instance.collection('foods');

  @override
  Widget build(BuildContext context) {
    return
    SafeArea(child: 
    Scaffold(
            appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          " Bundies",
         style: GoogleFonts.kanit(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: data.snapshots(),
          builder: (context,snapshot){
            if (snapshot.hasError) {
              return Text('Something went wrong');
              print('Something went wrong');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading");
               print('Loading');
            }
            return ListView.builder(
              itemCount: (snapshot.data!).docs.length,
              itemBuilder: (context,index){
                return ListTile(
                  title: Text((snapshot.data!).docs[index]['title']),
                  subtitle: Text((snapshot.data!).docs[index]['subtitle']),
                );
              },
            );
          }
          ),  
          ),
    );
  }
}