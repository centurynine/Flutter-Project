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
        body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return LoginPage();
            } else {
              return LoginPage();
            }
          },
        ),
      );
}

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          " Apple Store",
          style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
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
                        Container(
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
                        ),

                      ],
                      
                    ),
                    
                  ),
                ],
              ),
            ),
            if (status == 0)
              ListTile(
                title: Text('เข้าสู่ระบบ'),
                leading: Icon(Icons.login),
                onTap: () {
                  print("เข้าสู่ระบบ");
                  gotoLoginpage(context);
                },
              ),
            ListTile(
              title: Text('Starred'),
              leading: Icon(Icons.star),
              onTap: () {
                print("Clicked");
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
            if (status == 1)
              ListTile(
                title: Text('Logout'),
                leading: Icon(Icons.logout),
                onTap: () {
                  print("Clicked Signout");
                  _signOut();
                },
              ),
            const SizedBox(
              height: 200,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                    onPressed: () {
                      
                    },
                    child: Text(screenText)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<LoginPage> _signOut() async {
    await FirebaseAuth.instance.signOut();
    if (status == 1) {
      setState(() {
        status = 0;
        statusText = 'Loged out';
        userEmail = 'กรุณาเข้าสู่ระบบ';
        showAlertDialog(context);
        gotoHomepage(context);
      });
    } else {
      print('คุณออกจากระบบอยู่แล้ว');
    }
    return new LoginPage();
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