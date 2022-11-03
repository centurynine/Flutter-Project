import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class Uploadwidget extends StatefulWidget {
  const Uploadwidget({super.key});

  @override
  State<Uploadwidget> createState() => _UploadwidgetState();
}

class _UploadwidgetState extends State<Uploadwidget> {
  var selectIndex = 0;
  final tips = [
    'อัพโหลดสูตรอาหาร',
    'อัพโหลดสูตรอาหาร',
    'อัพโหลดสูตรอาหาร',
  ];
    final subtips = [
    'แชร์สูตรอาหารของคุณกับเพื่อนๆ',
    'แบ่งปันหรือเปิดเผยสูตรอาหารของคุณ',
    'นำเสนอสูตรอาหารของคุณให้เพื่อนๆ',
  ];

  @override
  
  void initState() {
    Timer.periodic(const Duration(seconds: 5), (timer) { 
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

  @override
  Widget build(BuildContext context) {
    return Container(
     height: 180,
     width: double.infinity,
     decoration: BoxDecoration(
        color: Colors.white,
   //     borderRadius: BorderRadius.circular(10),
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
          // Positioned(
          //   top: -40,
          //   right: 80,
          //   child: Container(
          //   height: 100,  
          //   width: 120,
          //   decoration: BoxDecoration(
          //     color: Colors.blue.withOpacity(0.2),
          //     shape: BoxShape.circle,
          //   ),
          // )
          // ),
          Padding(padding: const EdgeInsets.all(24),
          child: AnimatedSwitcher(duration: Duration(milliseconds: 600),
          child: Row(
           key: UniqueKey(),
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(tips[selectIndex],
                         style: GoogleFonts.kanit(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                    ),
                    const SizedBox(height: 10),
                    Text(subtips[selectIndex],
                        style: GoogleFonts.kanit(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 20,right: 80),
                      child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.red[400],
                                onPrimary: Colors.white,
                                shape:
                                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                              ),
                        onPressed: () {
                        Navigator.pushNamed(context, '/upload');                      },
                       child: Text('แชร์เลย!',
                        style: GoogleFonts.kanit(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        
                       )),
                    )
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Image.network('https://cdn-icons-png.flaticon.com/512/706/706164.png'),
                
              ),
            ],
          )
          ),
          )
        ],
      ),
    );
  }
}