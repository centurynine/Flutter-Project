import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project/food/ShowMenu.dart';
import 'package:project/widget/drawer.dart';
import 'package:project/food/editpage.dart';
CollectionReference users = FirebaseFirestore.instance.collection('users');
class SearchPageMyFood extends StatefulWidget {
  const SearchPageMyFood({super.key});

  @override
  State<SearchPageMyFood> createState() => _SearchPageMyFoodState();
}

class _SearchPageMyFoodState extends State<SearchPageMyFood> {
  String? name = ' ';
  String? name_lowercase = ' ';
  String? name_uppercase = ' ';
  bool isCreate = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer:  DrawerWidget(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,
              color: Colors.black, size: 20),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: GestureDetector(
          child: Container(
                height: 47,
                width: MediaQuery.of(context).size.width - 48,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: Colors.black.withOpacity(0.1),
                  //     offset: const Offset(0, 10),
                  //     blurRadius: 10,
                  //   ),
                  // ],
                ),
           
              child: TextField(
                decoration: InputDecoration(
                   border: InputBorder.none,
                    prefixIcon: Icon(Icons.search, color: Colors.black87),
                    hintText: 'ค้นหาเมนูของฉัน',
                    hintStyle: GoogleFonts.kanit(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                    contentPadding: EdgeInsets.only(top: 10.0)),
                onChanged: (val) {
                  setState(() {
                    name_lowercase = val.toLowerCase();
                    name_uppercase = val.toUpperCase();
                    name = val;
                //    print(name);
                  });
                },
              ),
           
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: (name != "")
              ? FirebaseFirestore.instance
                  .collection('foods')
                  .where('title',
                      isGreaterThanOrEqualTo: name,
                      isLessThan: name!.substring(0, name!.length - 1) +
                          String.fromCharCode(
                              name!.codeUnitAt(name!.length - 1) + 1),)
                  .snapshots()
              : FirebaseFirestore.instance.collection("foods")
                  .where('email', isEqualTo: FirebaseAuth.instance.currentUser!.email)
                  .snapshots(),
          builder: (context, snapshot) {
            return (snapshot.connectionState == ConnectionState.waiting)
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: (context, index) {
                      if(snapshot.data!.docs[index]['email'] == FirebaseAuth.instance.currentUser!.email){
                      if ((snapshot.data!).docs[index]['title'] == '' ||
                          (snapshot.data!).docs[index]['uploadImageUrl'] ==
                              '' ||
                          (snapshot.data!).docs[index]['id'] == '') {
                        return const SizedBox.shrink();
                      } else {
                        return Container(
                          width: 240,
                          height: 160,
                          margin: const EdgeInsets.only(
                              left: 20, top: 10, right: 10, bottom: 20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(30)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: const Offset(
                                    0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                              //<-- SEE HERE
                              side: const BorderSide(
                                  width: 4, color: Colors.grey),
                              borderRadius: BorderRadius.circular(23),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ShowMenu(
                                            docs: (snapshot.data!).docs[index],
                                          )));
                            },
                            title: Text(
                              (snapshot.data!).docs[index]['title'],
                              style: GoogleFonts.notoSansThai(fontSize: 20),
                            ),
                            subtitle: Text(
                              (snapshot.data!).docs[index]['subtitle'],
                              style: GoogleFonts.kanit(fontSize: 11),
                            ),
                            leading: CircleAvatar(
                              radius: 30,
                              backgroundImage: NetworkImage(
                                (snapshot.data!).docs[index]['uploadImageUrl'],
                                scale: 1,
                              ),
                              backgroundColor: const Color(0xff6ae792),
                            ),
                            trailing: Wrap(
                                spacing: 12,
                                children: <Widget>[
                                  FutureBuilder(
                                    future: users.doc().get(),
                                    builder: (ctx, futureSnapshot) {
                                      if (futureSnapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        checkCreate();
                                      }
                                      if (isCreate == true) {
                                        return GestureDetector(
                                          child: Icon(Icons.edit),
                                          onTap: () {
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                        'แก้ไขรายการอาหาร'),
                                                    content: Text(''),
                                                    actions: [
                                                      TextButton(
                                                        child: Text('แก้ไข'),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          EditData(
                                                                            docs:
                                                                                (snapshot.data!).docs[index],
                                                                          )));
                                                        },
                                                      ),
                                                      TextButton(
                                                        child: Text('ยกเลิก'),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      ),
                                                      TextButton(
                                                        child: Text('ลบ'),
                                                        onPressed: () {
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'foods')
                                                              .doc((snapshot
                                                                      .data!)
                                                                  .docs[index]
                                                                  .id)
                                                              .delete();
                                                          print(
                                                              'Database ID ${(snapshot.data!).docs[index]['id']} Deledted');
                                                          var imageID =
                                                              (snapshot.data!)
                                                                      .docs[
                                                                  index]['id'];
                                                          print(
                                                              'Picture ID : $imageID Deleted');
                                                          var reference =
                                                              FirebaseStorage
                                                                  .instance
                                                                  .ref()
                                                                  .child(
                                                                      'foods/$imageID');
                                                          var delete = reference
                                                              .delete();
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                });
                                          },
                                        );
                                      } else {
                                        return const SizedBox.shrink();
                                      }
                                    },
                                  ),

                                  //  Text(
                                  // (snapshot.data!).docs[index]['id'],
                                  // textAlign: TextAlign.start,
                                  // style: GoogleFonts.kanit(fontSize: 14),
                                ],
                              ),
                          ),
                        );
                      }
                     }else{
                        return const SizedBox.shrink();
                      } },
                  );
          }),
    );
  }

  void checkCreate() async {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection('foods')
        .where('email', isEqualTo: FirebaseAuth.instance.currentUser!.email)
        .get();
    if (query.docs.isNotEmpty) {
      isCreate = true;
    } else {
      isCreate = false;
    }
  }

}
            
                    /*DocumentSnapshot data =
                        snapshot.data?.docs[index] as DocumentSnapshot<Object?>;
                    return Card(
                      child: Row(
                        children: <Widget>[
                          Image.network(
                            data['uploadImageUrl'],
                            width: 150,
                            height: 100,
                            fit: BoxFit.fill,
                          ),
                          const SizedBox(
                            width: 25,
                          ),
                          Text(
                            data['title'],
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    );*/