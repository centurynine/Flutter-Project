import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project/body.dart';
import 'package:project/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:project/pleaselogin.dart';
import 'allfood.dart';

bool fullScreen = false;
String screenText = 'Full Screen';
String showEmail = userEmail.toString();
void main() {
  runApp(MyApp());
}

/// App Widget
class MyApp extends StatefulWidget {
  /// Initialize app
  MyApp();
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  /// Widget
  @override
  Widget build(BuildContext context) => Scaffold();
}

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String? name;
  String? avatar =
      'https://cdn-icons-png.flaticon.com/512/149/149071.png';
  @override
 final GlobalKey<ScaffoldState> _drawerKey = new GlobalKey<ScaffoldState>();
  void initState() {
    checkNameWhoCreated();
    super.initState();
    SystemChrome.setEnabledSystemUIMode (SystemUiMode.manual, overlays: []);
    if(FirebaseAuth.instance.currentUser != null){
      userEmail = FirebaseAuth.instance.currentUser?.email;
    }
  }


  void checkNameWhoCreated() async {
    if(FirebaseAuth.instance.currentUser != null){
    final users = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: FirebaseAuth.instance.currentUser!.email)
        .where('avatar')
        .get();
        if(users.docs.isNotEmpty){
          print('พบข้อมูลชื่อผู้โพส');
          print(users.docs[0].data()['email']);
          setState(() {
            name = users.docs[0].data()['name'];
            avatar = users.docs[0].data()['avatar'];
          });
         // print(avatar);
          if(avatar == null){
            setState(() {
               print('ไม่พบรูปภาพ');
               avatar = 'https://cdn-icons-png.flaticon.com/512/149/149071.png';
            });
            print(avatar);
          }
          else {
            print('พบภาพโปรไฟล์');
          }
        }else if(users.docs.isEmpty){
          print('ไม่พบข้อมูลชื่อผู้โพส');
          setState(() {
            name = 'ไม่พบชื่อผู้โพส';
          });
        }}
        else{
          print('ไม่พบข้อมูล');
          setState(() {
            name = 'ไม่พบชื่อ';
          });
        }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu,
            color: Colors.black87,
          ),
          onPressed: () {
            _drawerKey.currentState!.openDrawer();
          },
        ),
        backgroundColor: Colors.white,
        title: Text(
          " Aroy App",
         style: GoogleFonts.kanit(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
        ),
        actions: <Widget>[
          FirebaseAuth.instance.currentUser == null
              ? IconButton(
                  icon: Icon(Icons.login,
                      color: Colors.black87, size: 30),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                )
              : IconButton(
                  icon: Icon(Icons.logout,
                                        color: Colors.black87, size: 30),
                  onPressed: () {
                    _signOut();
                  },
                ),
        ],
      ),
      body: ListView(children: [
        Container(
          child: const Body(),
        ),
        SizedBox(
          height: 20,
        ),
        
        FirebaseAuth.instance.currentUser != null
        ? Container()
        : PleaseLogin(),
        ]
        ),
      key: _drawerKey,
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 0),
              color: Colors.red[400],
              child: Column(
                children: <Widget>[
                  Container(
                    child: Row(
                      children: <Widget>[
                        Container(
                                width: 50,
                                height: 100,
                          margin: EdgeInsets.only(left: 10),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: CircleAvatar(
                              backgroundImage: Image.network(avatar!).image,
                               // radius: 10,
                              
                            ),
                          ),
                        ),
                        FirebaseAuth.instance.currentUser != null
                        ? Container(
                          child: Column(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(right: 50),
                                child: Text(
                                  name.toString(),
                                  style: GoogleFonts.kanit(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                               Container(
                                margin: EdgeInsets.only(left: 10),
                                child: Text(
                                  userEmail.toString().length > 28
                                      ? userEmail.toString().substring(0, 20) + '...'
                                      : userEmail.toString(),
                                  overflow: TextOverflow.fade,
                              //  userEmail.toString().substring(0, userEmail.toString().indexOf('@')),
                                  style: GoogleFonts.kanit(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                        : Container(
                          child: Column(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(left: 10),
                                child: Text(
                                  'กรุณาเข้าสู่ระบบ',
                                  style: GoogleFonts.kanit(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            FirebaseAuth.instance.currentUser != null
            ? Column(
              children: [
                ListTile(
                  title: Text('รายการอาหารทั้งหมด',
                  style: GoogleFonts.kanit(
                    fontSize: 14,
                    color: Colors.black)),
                   leading: Image.asset(
                    'assets/allfood.png',
                    width: 25,
                    height: 25,),
                  onTap: () {
                    print("Clicked");
                    Navigator.pushNamed(context, '/food');
                  },
                ),
                ListTile(
              title: Text('รายการอาหารของฉัน',
              style: GoogleFonts.kanit(
                fontSize: 14,
                color: Colors.black)),
               leading: Image.asset(
                'assets/myfood.png',
                width: 25,
                height: 25,),
              onTap: () {
                print("Clicked");
                Navigator.pushNamed(context, '/myfood');
              },
             ),
              ListTile(
              title: Text('ตั้งค่า',
              style: GoogleFonts.kanit(
                fontSize: 14,
                color: Colors.black)),
               leading: Image.asset(
                'assets/setting.png',
                width: 25,
                height: 25,),
              onTap: () {
                print("Clicked");
                Navigator.pushNamed(context, '/setting');
              },
             ),
              ListTile(
              title: Text('ออกจากระบบ',
              style: GoogleFonts.kanit(
                fontSize: 14,
                color: Colors.black)),
               leading: Image.asset(
                'assets/logout.png',
                width: 25,
                height: 25,),
              onTap: () {
                _signOut();
                Navigator.pushNamed(context, '/');
              },
             ),
              ],
            )
            : Column(
              children: [
                Container(
                  child: ListTile(
                    title: Text('เข้าสู่ระบบ',
                    style: GoogleFonts.kanit(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                    ),
                    leading: Image.asset(
                      'assets/login.png',
                      width: 25,
                      height: 25,
                    ),
                    onTap: () {
                      print("Clicked");
                      Navigator.pushNamed(context, '/login');
                    },
                  ),
                ),
                ListTile(
                title: Text('สมัครสมาชิก',
                style: GoogleFonts.kanit(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                ),
                leading: Image.asset(
                  'assets/register.png',
                  width: 25,
                  height: 25,
                ),
                onTap: () {
                  print("Clicked");
                  Navigator.pushNamed(context, '/register');
                },
              ),
              ],
            ),
          ],
        ),
      ),



    );
    
  }

  Future _signOut() async {
    EasyLoading.showInfo('ออกจากระบบสำเร็จ');
    await FirebaseAuth.instance.signOut();
  //  Navigator.pop(context);
    _doOpenPage(context);
    
    }

  }

showAlertDialog(BuildContext context) {
  AlertDialog alert = AlertDialog(
    content: Row(
      children: [
        const CircularProgressIndicator(),
        Container(
            margin: EdgeInsets.only(left: 5), child: Text("กำลังออกจากระบบ")),
      ],
    ),
  );
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

gotoHomepage(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => Homepage()),
  );
}

gotoLoginpage(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => LoginPage()),
  );
}

void _doOpenPage(context) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => LoginPage()),
  
  );
           Future.delayed(const Duration(milliseconds: 2000), () {
               EasyLoading.dismiss();
            });
 


}
