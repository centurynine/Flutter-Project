import 'dart:async';
import 'dart:ffi';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project/food/ShowMenu.dart';

class Recommendget extends StatefulWidget {
  const Recommendget({super.key});

  @override
  State<Recommendget> createState() => _RecommendgetState();
}

class _RecommendgetState extends State<Recommendget> {

  var selectIndex = 0;

  String index1 = '';
  String index2 = '';
  String index3 = '';
  final List<String> tips = ['รายการอาหารแนะนำ'];
  final List<String> subtips = ['สุ่มเมนูช่วยในการตัดสินใจ'];
  final List<String> imagetips = [
    'https://cdn-icons-png.flaticon.com/512/2401/2401460.png'
  ];
  final List<String> foodID = [];
  @override
  void initState() {
    getFoodID();
    Timer.periodic(const Duration(seconds: 3), (timer) {
      if (this.mounted) {
        setState(() {
          selectIndex = (selectIndex + 1) % tips.length;
        });
      }
      // setState(() {
      //   if(selectIndex != tips.length - 1) {
      //     selectIndex++;
      //   } else {
      //     selectIndex = 0;
      //   }
      // });
    });
    super.initState();
  }

  void getFoodID() async {
    await FirebaseFirestore.instance
        .collection('foods')
        .where('id')
        .get()
        .then((value) => value.docs.forEach((element) {
              foodID.add(element.data()['id']);
            }));
    randomFoodID();
  }

  void randomFoodID() {
    final random = Random();
    final index1 = random.nextInt(foodID.length);
    final index2 = random.nextInt(foodID.length);
    final index3 = random.nextInt(foodID.length);

    setState(() {
      this.index1 = foodID[index1];
      this.index2 = foodID[index2];
      this.index3 = foodID[index3];
    });
    setMessages1();
    setMessages2();
    setMessages3();
  }

  void setMessages1() async {
    await FirebaseFirestore.instance
        .collection('foods')
        .where('id', isEqualTo: index1)
        .get()
        .then((value) => value.docs.forEach((element) {
              tips.add(element.data()['title']);
              subtips.add(element.data()['subtitle']);
              imagetips.add(element.data()['uploadImageUrl']);
            }));
  }

  void setMessages2() async {
    await FirebaseFirestore.instance
        .collection('foods')
        .where('id', isEqualTo: index2)
        .get()
        .then((value) => value.docs.forEach((element) {
              tips.add(element.data()['title']);
              subtips.add(element.data()['subtitle']);
              imagetips.add(element.data()['uploadImageUrl']);
            }));
  }

  void setMessages3() async {
    await FirebaseFirestore.instance
        .collection('foods')
        .where('id', isEqualTo: index3)
        .get()
        .then((value) => value.docs.forEach((element) {
              tips.add(element.data()['title']);
              subtips.add(element.data()['subtitle']);
              imagetips.add(element.data()['uploadImageUrl']);
            }));
 
    
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      width: 340,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
              top: -40,
              right: 80,
              child: Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
              )),
           Positioned(
              bottom: -20,
              left: 20,
              child: Container(
                height: 60,
                width: 70,
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
              )),
          Padding(
            padding: const EdgeInsets.all(24),
            child: AnimatedSwitcher(
                duration: Duration(milliseconds: 600),
                child: Row(
                  key: UniqueKey(),
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          (tips.length > 1)
                              ? Flexible(
                                fit: FlexFit.loose,
                                child: Text(tips[selectIndex],
                                maxLines: 1,
                                    style: GoogleFonts.kanit(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black)),
                              )
                              : Text(tips[0],
                                  style: GoogleFonts.kanit(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black)),

                          const SizedBox(height: 10),
                          (subtips.length > 1)
                              ? Flexible(
                            child: RichText(
                              overflow: TextOverflow.ellipsis,
                              strutStyle: StrutStyle(fontSize: 12.0),
                              text: 
                              TextSpan(
                                  style: GoogleFonts.kanit(
                                    fontSize: 13,
                                    color: Colors.black,
                                  ),
                                  text: subtips[selectIndex]
                                  ),
                            ),)
                          
                              : Flexible(
                            child: RichText(
                              overflow: TextOverflow.ellipsis,
                              strutStyle: StrutStyle(fontSize: 12.0),
                              text: 
                              TextSpan(
                                  style: GoogleFonts.kanit(
                                    fontSize: 13,
                                    color: Colors.black,
                                  ),
                                  text: subtips[0]
                                  ),
                            ),),
                          // Flexible(
                          //   child: RichText(
                          //     overflow: TextOverflow.ellipsis,
                          //     strutStyle: StrutStyle(fontSize: 12.0),
                          //     text: 
                          //     TextSpan(
                          //         style: GoogleFonts.kanit(
                          //           fontSize: 13,
                          //           color: Colors.black,
                          //         ),
                          //         text: subtips[selectIndex]
                          //         ),
                          //   ),
                          // ),

                          FirebaseAuth.instance.currentUser != null
                          ? ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/searchpage');
                              },
                              child: Text(
                                'ค้นหาอาหาร',
                                style: GoogleFonts.kanit(
                                    fontSize: 12, color: Colors.white),
                              ))
                          :ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/login');
                              },
                              child: Text(
                                'ค้นหาอาหาร',
                                style: GoogleFonts.kanit(
                                    fontSize: 12, color: Colors.white),
                              ))
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                          (imagetips.length > 1)
                              ?  Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          imagetips[selectIndex],
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                              : Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          imagetips[0],
                          fit: BoxFit.cover,
                        ),
                      ),
                    )

                    // Container(
                    //   height: 100,
                    //   width: 100,
                    //   decoration: BoxDecoration(
                    //     color: Colors.white,
                    //     borderRadius: BorderRadius.circular(10),
                    //   ),
                    //   child: ClipRRect(
                    //     borderRadius: BorderRadius.circular(10),
                    //     child: Image.network(
                    //       imagetips[selectIndex],
                    //       fit: BoxFit.cover,
                    //     ),
                    //   ),
                    // ),
                  ],
                )),
          )
        ],
      ),
    );
  }
}
