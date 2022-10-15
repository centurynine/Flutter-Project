import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project/body.dart';
import 'package:project/login.dart';
import 'package:firebase_core/firebase_core.dart';
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
  @override
 final GlobalKey<ScaffoldState> _drawerKey = new GlobalKey<ScaffoldState>();
  void initState() {
    super.initState();
    if(FirebaseAuth.instance.currentUser != null){
      userEmail = FirebaseAuth.instance.currentUser?.email;
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
        Container(
          child: Text('After body',
          style: GoogleFonts.kanit(
                      fontSize: 40,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
          ),
        ),Container(
          child: Text('After body',
          style: GoogleFonts.kanit(
                      fontSize: 40,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
          ),
        ),
        Container(
          child: Text('After body',
        ),
        ),
        ]
        ),
      key: _drawerKey,
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            Container(
              color: Colors.red[400],
              child: Column(
                children: <Widget>[
                  Container(
                    child: Row(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Image.network(
                            "https://cdn-icons-png.flaticon.com/512/2397/2397697.png",
                            width: 50,
                            height: 100,
                          ),
                        ),
                        FirebaseAuth.instance.currentUser != null
                        ? Container(
                          child: Column(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(right: 50),
                                child: Text(
                                  FirebaseAuth.instance.currentUser!.displayName.toString(),
                                  style: GoogleFonts.kanit(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                               Container(
                                margin: EdgeInsets.only(left: 10),
                                child: Text(
                                  userEmail.toString(),
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
