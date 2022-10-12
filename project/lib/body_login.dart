import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BodyAfterLogin extends StatefulWidget {
  const BodyAfterLogin({super.key});

  @override
  State<BodyAfterLogin> createState() => _BodyAfterLoginState();
}

class _BodyAfterLoginState extends State<BodyAfterLogin> {
  CollectionReference data = FirebaseFirestore.instance.collection('foods');

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Scaffold(
            appBar: AppBar(
              title: Text('Apple Store'),
              backgroundColor: Colors.grey,
            ),
              body: StreamBuilder<QuerySnapshot>(
                  stream: data.snapshots(),
                  builder: (context, snapshot) {
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
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.only(
                              left: 30, top: 20, right: 30, bottom: 20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset:
                                    const Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: ListTile(
                            title: Text((snapshot.data!).docs[index]['title']),
                            subtitle:
                                Text((snapshot.data!).docs[index]['subtitle']),
                            leading: Image.network('https://scontent.fbkk2-4.fna.fbcdn.net/v/t39.30808-1/272920248_6930110877060294_6433230853958653780_n.jpg?stp=dst-jpg_s200x200&_nc_cat=101&ccb=1-7&_nc_sid=7206a8&_nc_ohc=mK4HiRAU8bsAX8FRldE&_nc_pt=1&_nc_ht=scontent.fbkk2-4.fna&oh=00_AT8ltaBNz9jscrETynA1LGkqenjewaxy7KiQsBx-alVFvA&oe=634993A0'
                            ,width: 50,
                            height: 50,
                            
                            ),
                          
                          ),
                        );
                      },
                    );
                  })),
        ),
      ],
    );
  }
}
