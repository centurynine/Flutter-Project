import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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
          Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: SizedBox(
                  height: 300,
                  child: Image.network(
                      "https://i.ytimg.com/vi/q4bVLN2Y6h0/hqdefault.jpg"),
                ),
              ),
      ],
    );
  }
}