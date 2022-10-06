import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project/body.dart';
import 'package:project/login.dart';
import 'package:firebase_core/firebase_core.dart';
String showEmail = userEmail.toString();
void main(){
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
        backgroundColor: Color.fromARGB(255, 126, 174, 255),
        title: const Text(
          " Apple Store",
          style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.login),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
        ],
      ),
      body: Body(),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            Container(
              height: 30.0
            ),
            Container(
              child: Text("Menu",
          style: GoogleFonts.kanit(
            fontSize: 15,
            color: Colors.blue,
          ),),
            ),
            Container(
              margin: EdgeInsets.only(left: 20.0),
              child: Text(userEmail.toString(),
          style: GoogleFonts.kanit(
            fontSize: 15,
            color: Colors.blue,
          ),),
            ),
            ListTile(
              title: Text('Shared with me'),
              leading: Icon(Icons.people),
              onTap: () {
                print("Clicked");
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
              title: Text('Backups'),
              leading: Icon(Icons.backup),
              onTap: () {
                print("Clicked");
              },
            ),
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

    Future <LoginPage> _signOut()  async{
     await FirebaseAuth.instance.signOut();
    if(status == 1){
      status = 0;
      statusText = 'Loged out';
      setState(() {
        userEmail = 'กรุณาเข้าสู่ระบบ';
        showAlertDialog(context);
        gotoHomepage(context);
      });
      ;
      } 
      else {
      print('คุณออกจากระบบอยู่แล้ว');
    }
    return new LoginPage();
}


 showAlertDialog(BuildContext context){
      AlertDialog alert=AlertDialog(
        content: Row(
            children: [
               CircularProgressIndicator(),
               Container(margin: EdgeInsets.only(left: 5),child:Text("กำลังออกจากระบบ" )),
            ],),
      );
      showDialog(barrierDismissible: false,
        context:context,
        builder:(BuildContext context){
          return alert;
        },
      );
    }

gotoHomepage(BuildContext context){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Homepage()),
    );
  }

}
