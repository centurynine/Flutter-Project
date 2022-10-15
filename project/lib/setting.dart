import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
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
  String? name;

@override
void initState() {
  if(name == null) {
    setState(() {
      name = 'ไม่พบชื่อผู้ใช้';
    });
  }
  super.initState();
  checkInfo();
}


  void checkInfo() async {
    if(FirebaseAuth.instance.currentUser != null){
     await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: FirebaseAuth.instance.currentUser!.email)
        .get()
       .then((value) => value.docs.forEach((element) {
        setState(() {
          name = element.data()['name'];
        });
      }));
      }
      else {
        setState(() {
          name = 'กรุณาเข้าสู่ระบบ';
        });
      }
      }
        



//   void checkInfo() async {
//     if(FirebaseAuth.instance.currentUser != null){
//     QuerySnapshot query = await FirebaseFirestore.instance
//         .collection('users')
//         .where('email', isEqualTo: FirebaseAuth.instance.currentUser!.email)
//         .get()
// ;
//     if (query.docs.isNotEmpty){
//         print('พบข้อมูล');
//         setState(() {
//           name = query.docs[0].data()['name'];
//         });
//     }
//     else {
//        print('ไม่พบข้อมูล');
//     }
//   }
//   else{
//     print('ไม่พบการเข้าสู่ระบบ');
//   }
// }
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
              BigUserCard(
                cardColor: Colors.red,
                userName: name.toString(),
                userProfilePic: AssetImage("assets/images/idcard.png"),
                cardActionWidget: SettingsItem(
                  icons: Icons.edit,
                  iconStyle: IconStyle(
                    withBackground: true,
                    borderRadius: 50,
                    backgroundColor: Colors.yellow[600],
                  ),
                  title: "Modify",
                  subtitle: "Tap to change your data",
                  onTap: () {
                    print("OK");
                  },
                ),
              ),
              const SizedBox(height: 20),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: []),
              // You can add a settings title
              SettingsGroup(
                settingsGroupTitle: "การตั้งค่า",
                settingsGroupTitleStyle: GoogleFonts.kanit(
                  fontSize: 22,
                  color: Colors.black87,
                ),
                items: [
                  SettingsItem(
                    onTap: () {
                      Navigator.pushNamed(context, '/changedisplayname');
                    },
                    icons: Icons.display_settings_outlined,
                    iconStyle: IconStyle(
                      withBackground: true,
                      borderRadius: 50,
                      backgroundColor: Colors.blue[400],
                    ),
                    title: "เปลี่ยนชื่อแสดงผล",
                    titleStyle: GoogleFonts.kanit(
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                  ),
                  SettingsItem(
                    onTap: () {
                      Navigator.pushNamed(context, '/forgotpassword');
                    },
                    icons: Icons.password,
                    iconStyle: IconStyle(
                      withBackground: true,
                      borderRadius: 50,
                      backgroundColor: Colors.red[400],
                    ),
                    title: "ลืมรหัสผ่าน",
                    titleStyle: GoogleFonts.kanit(
                      fontSize: 18,
                      color: Colors.black87,
                    ),
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
