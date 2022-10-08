import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  
  bool fullScreen = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Setting'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: Colors.black,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Column(
          children: [
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("FullScreen"),
                Container(
                  child: Switch(
                    value: fullScreen,
                    onChanged: (value) {
                      setState(() {
                        screen();
                        print(fullScreen);
                      });
                    },
                    activeTrackColor: Colors.lightGreenAccent,
                    activeColor: Colors.green,
                  ),
                ),
              ],
            ),
          
          ],
        ));
  }


    screen() {
    if (fullScreen == false) {
      setState(() {
        fullScreen = true;
      });
      SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    } else if(fullScreen == true){
      setState(() {
        fullScreen = false;
      });
      SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    }
  }
}
