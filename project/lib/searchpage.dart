import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String? name = ' ';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Card(
          child: TextField(
            decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search), hintText: 'Search'),
            onChanged: (val) {
              setState(() {
                name = val;
                print(name);

              }
              );
            },
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: (name != "")
            ? FirebaseFirestore.instance
                .collection('foods')
                .where(
                  'title',
                  isGreaterThanOrEqualTo: name,
                  isLessThan: name!.substring(0, name!.length - 1) + String.fromCharCode(name!.codeUnitAt(name!.length - 1) + 1))
                .snapshots()
            : FirebaseFirestore.instance.collection("foods").snapshots(),
        builder: (context, snapshot) {
          return (snapshot.connectionState == ConnectionState.waiting)
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot data =
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
                    );
                  },
            );
        },
      ),
    );
  }
}
