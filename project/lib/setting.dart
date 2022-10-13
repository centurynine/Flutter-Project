import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:babstrap_settings_screen/babstrap_settings_screen.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});
  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  final prefs = SharedPreferences.getInstance();
  bool fullScreen = false;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white.withOpacity(.94),
        appBar: AppBar(
          title: const Text('Setting'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: Colors.white,
            onPressed: () {
              //   Navigator.pop(context);
              Navigator.pushNamed(context, '/');
            },
          ),
          // backgroundColor: Colors.transparent,
          // elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView(
            children: [
              // user card
              SimpleUserCard(
                userName: "AMX ขี้เมาแมน",
                userProfilePic: AssetImage("assets/maxprofile.png"),
              ),
              const SizedBox(height: 20),
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
              // You can add a settings title
              SettingsGroup(
                settingsGroupTitle: "Account",
                items: [
                  // SettingsItem(
                  //   onTap: () {},
                  //   icons: Icons.exit_to_app_rounded,
                  //   title: "Sign Out",
                  // ),
                  SettingsItem(
                    onTap: () {
                      Navigator.pushNamed(context, '/changedisplayname');
                    },
                    icons: Icons.settings,
                    title: "Change username",
                  ),
                  // SettingsItem(
                  //   onTap: () {},
                  //   icons: Icons.settings,
                  //   title: "Delete account",
                  //   titleStyle: TextStyle(
                  //     color: Colors.red,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  screen() async {
    if (fullScreen == false) {
      setState(() {
        fullScreen = true;
      });
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
          overlays: [SystemUiOverlay.bottom]);
    } else if (fullScreen == true) {
      setState(() {
        fullScreen = false;
      });
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
          overlays: SystemUiOverlay.values);
    }
  }
}
