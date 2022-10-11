import 'package:flutter/material.dart';
class Recommendget extends StatefulWidget {
  const Recommendget({super.key});

  @override
  State<Recommendget> createState() => _RecommendgetState();
}

class _RecommendgetState extends State<Recommendget> {
  final selectIndex = 0;
  final tips = [
    'Show 1',
    'Show 2',
    'Show 3',
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
     height: 180,
     width: 350,
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
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(tips[selectIndex],
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    ),
                    const SizedBox(height: 10),
                    Text('สวัสดีครัล ผมนายสิวกอร์น',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                    ),
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
                child: Image.network('https://cdn-icons-png.flaticon.com/512/2397/2397697.png'),
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