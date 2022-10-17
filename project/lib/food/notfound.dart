import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotFound extends StatefulWidget {
  const NotFound({super.key});

  @override
  State<NotFound> createState() => _NotFoundState();
}

class _NotFoundState extends State<NotFound> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 50.0),
          alignment: Alignment.center,
          child: Text('ไม่พบรายการอาหาร',
          style: GoogleFonts.kanit(fontSize: 20, color: Colors.black87),),
        ),
      ],
    );
  }
}