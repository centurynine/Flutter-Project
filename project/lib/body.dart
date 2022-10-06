import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:project/login.dart';

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
            "TEST", 
            style: Theme.of(context)
                .textTheme
                .headline5
                ?.copyWith(fontWeight: FontWeight.bold),
                ),  
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ElevatedButton(onPressed: () {},
               child: const Text('ถ่ายรูป')),
               ElevatedButton(onPressed: () {},
               child: const Text('Enabled'))
            ],
          ),
      ],
      
    );
  }
}