import 'package:flutter/material.dart';
import 'package:project/body.dart';
import 'package:project/login.dart';

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
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      /// Home
      home: Homepage(),
    );
  }
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
        backgroundColor: Colors.black,
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
              accountEmail: Text("accountEmail"),
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
