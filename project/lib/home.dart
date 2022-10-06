import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/body.dart';
import 'package:project/login.dart';
import 'package:firebase_core/firebase_core.dart';
String userEmail = 'No email';


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
            const UserAccountsDrawerHeader(
              accountName: Text("accountName"), 
              accountEmail: Text("userEmail"),
              currentAccountPicture: FlutterLogo(
                size: 42.0,
              ),
              ),
            ListTile(
              title: Text('My Files'),
              leading: Icon(Icons.folder),
              onTap: () {
                print("Clicked");
              },
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
          ],
        ),
      ),
    );
  }
}
