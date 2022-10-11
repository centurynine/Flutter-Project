import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project/body.dart';
import 'package:project/login.dart';
import 'package:firebase_core/firebase_core.dart';

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
  Widget build(BuildContext context) => Scaffold(
      
      );
}

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override

  void initState() {
    super.initState();
    if(FirebaseAuth.instance.currentUser != null){
      userEmail = FirebaseAuth.instance.currentUser?.email;
      status = 1;
      statusText = "Logged In";
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          " Apple Store",
         style: GoogleFonts.kanit(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
        ),
        actions: <Widget>[
          FirebaseAuth.instance.currentUser == null
              ? IconButton(
                  icon: Icon(Icons.login),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                )
              : IconButton(
                  icon: Icon(Icons.logout),
                  onPressed: () {
                    _signOut();
                  },
                )
        ],
      ),
      body: Body(),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            Container(
              color: Colors.blue,
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
            if (FirebaseAuth.instance.currentUser == null)
              ListTile(
                title: Text('เข้าสู่ระบบ'),
                leading: Icon(Icons.login),
                onTap: () {
                  print("เข้าสู่ระบบ");
                  gotoLoginpage(context);
                },
              ),
            ListTile(
              title: Text('สูตรกล้ามโต'),
              leading: Icon(Icons.star),
              onTap: () {
                print("Clicked");
                Navigator.pushNamed(context, '/widget');
              },
            ),
            ListTile(
              title: Text('Recent'),
              leading: Icon(Icons.timer),
              onTap: () {
                print("Clicked");
              },
            ),
            ListTile(
              title: Text('Offline'),
              leading: Icon(Icons.offline_pin),
              onTap: () {
                print("Clicked");
              },
            ),
            ListTile(
              title: Text('Uploads'),
              leading: Icon(Icons.file_upload),
              onTap: () {
                print("Clicked");
              },
            ),
            ListTile(
              title: Text('Setting'),
              leading: Icon(Icons.settings),
              onTap: () {
                print("Clicked");
                Navigator.pushNamed(context, '/setting');
              },
            ),
            if (FirebaseAuth.instance.currentUser != null)
              ListTile(
                title: Text('Logout'),
                leading: Icon(Icons.logout),
                onTap: () {
                  print("Clicked Signout");
                  _signOut();
                },
              ),
          ],
        ),
      ),



    );
    
  }

  Future _signOut() async {
    await FirebaseAuth.instance.signOut();
    if(FirebaseAuth.instance.currentUser == null){
      setState(() {
        userEmail = 'No login';
        Navigator.pushNamed(context, '/');
      });
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
}