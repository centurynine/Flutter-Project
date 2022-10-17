import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class PleaseLogin extends StatefulWidget {
  const PleaseLogin({super.key});

  @override
  State<PleaseLogin> createState() => _PleaseLoginState();
}

class _PleaseLoginState extends State<PleaseLogin> {
  var selectIndex = 0;
  final tips = [
    'กรุณาเข้าสู่ระบบ',
    'กรุณาเข้าสู่ระบบ',
    'กรุณาเข้าสู่ระบบ',
  ];
    final subtips = [
    'เพื่อปลดล็อคเนื้อหาที่ซ่อนไว้',
    'เพื่อปลดล็อคเนื้อหาที่ซ่อนไว้',
    'เพื่อปลดล็อคเนื้อหาที่ซ่อนไว้',
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
     height: 200,
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
          Column(
            children: [
              Divider(
                color: Colors.grey,
                thickness: 4,
                height: 1,
              ),
            ],
          ),
          Positioned(
            top: 25,
          //  right: 200,
            left: 45,
            child: Image.asset('assets/images/lock.png', width: 100),
          ),
          Padding(padding: const EdgeInsets.all(24),
          child: AnimatedSwitcher(duration: Duration(milliseconds: 600),
          child: Row(
           key: UniqueKey(),
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 28.0),
                      child: Text(tips[selectIndex],
                           style: GoogleFonts.kanit(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(right: 15.0),
                      child: Text(subtips[selectIndex],
                          style: GoogleFonts.kanit(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10,right: 44,left: 10),
                      child: ElevatedButton(onPressed: () {
                        Navigator.pushNamed(context, '/login');                      
                        },
                       child: Text('เข้าสู่ระบบ',
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
           
            ],
            
          )
          
          ),
          
          )
          ,         
        ],
      ),
    );
  }
}