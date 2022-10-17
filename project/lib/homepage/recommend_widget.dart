import 'dart:async';
import 'package:flutter/material.dart';
class Recommendget extends StatefulWidget {
  const Recommendget({super.key});

  @override
  State<Recommendget> createState() => _RecommendgetState();
}

class _RecommendgetState extends State<Recommendget> {
  var selectIndex = 0;
  final tips = [
    'Show 1',
    'Show 2',
    'Show 3',
  ];
  @override
  
  void initState() {
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
          )
          ),
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
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    ),
                    const SizedBox(height: 10),
                    Text('สวัสดีฆรับ ผมนายสิวกอร์น',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                    ),
                    ElevatedButton(onPressed: () {},
                     child: Text('ดูรายละเอียด',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                     ))
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