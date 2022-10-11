import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:project/home.dart';
import 'package:project/login.dart';

class FacebookLogin extends StatefulWidget {
  const FacebookLogin({Key? key}) : super(key: key);
  @override
  _FacebookLoginState createState() => _FacebookLoginState();
}

class _FacebookLoginState extends State<FacebookLogin> {
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
          title: const Text(
            "Facebook Login",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body:Column(
      children: <Widget>[
        
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
            "TEST", 
            style: Theme.of(context)
                .textTheme
                .headline5
                ?.copyWith(fontWeight: FontWeight.bold),
                ),  
          ),
            Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
             _displayLoginButton(),
             logoutFB(),
            ],
          ),
          Text(userName),
      ],
    ),
    );
  }

ElevatedButton logoutFB() {
    return ElevatedButton(
      onPressed: () {
        signOut();
      },
      child: const Text('Logout FB'),
    );
  }


  _displayLoginButton() {
    return GestureDetector(
      onTap: (){
        signInWithFacebook();
      },
      child: Container(
        width: 300,
        decoration: BoxDecoration(
            border: Border.all(
              color: Colors.blue,
            ),
            borderRadius: BorderRadius.circular(10),
            color: Colors.blue
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SignInButton(
              Buttons.Facebook,
              text: "Log in with facebook",
              mini: true,
              onPressed: () {
                signInWithFacebook();
              },
            ),
            const Text("  Log in with facebook",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 20),),
          ],
        ),
      ),
    );
  }

  _fbLogoutButton() {
    return GestureDetector(
      onTap: (){
        signOut();
      },
      child: Container(
        width: 300,
        decoration: BoxDecoration(
            border: Border.all(
              color: Colors.blue,
            ),
            borderRadius: BorderRadius.circular(10),
            color: Colors.blue
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SignInButton(
              Buttons.Facebook,
              text: "Logout",
              mini: true,
              onPressed: () {
                signInWithFacebook();
              },
            ),

            const Text("  Logout ",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 20),),
          ],
        ),
      ),
    );
  }


  void signInWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login(permissions: (['email', 'public_profile']));
      final token = result.accessToken!.token;
      print('Facebook token userID : ${result.accessToken!.grantedPermissions}');
      final graphResponse = await http.get(Uri.parse( 'https://graph.facebook.com/'
          'v2.12/me?fields=name,first_name,last_name,email&access_token=${token}'));
      final profile = jsonDecode(graphResponse.body);
      print("Profile is equal to $profile");
       Map<String,dynamic> data = jsonDecode(graphResponse.body);
          String userEmailfb = data["email"];
          String userNamefb = data["name"];
        setState(() {
          userEmail = userEmailfb;
          userName = userNamefb;
          status = 1;
        });
        print(userEmailfb);
        print(userName);
      try {
        final AuthCredential facebookCredential = FacebookAuthProvider.credential(result.accessToken!.token);
        final userCredential = await FirebaseAuth.instance.signInWithCredential(facebookCredential);
        uploadUserFB(userEmailfb,userNamefb);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Homepage()),
        );
      } catch(e){
      final snackBar = SnackBar(
        margin: const EdgeInsets.all(20),
        behavior: SnackBarBehavior.floating,
        content:  Text(e.toString()),
        backgroundColor: (Colors.redAccent),
        action: SnackBarAction(
          label: 'dismiss',
          onPressed: () {},
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    } catch (e) {
      print("error occurred");
      print(e.toString());
    }
  }

Future<void> signOut() async {
    await FacebookAuth.instance.logOut();
    print(_FacebookLoginState());
    showSuccess("Logout");
    // await _auth.signOut()
    setState(() {
      status = 0;
      userName = 'No Name';
    });
  }

Future<void> checkFB() async {
    print(_FacebookLoginState());
    // await _auth.signOut();
    // _user = null;
  }


  void showSuccess(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Success!"),
          content: Text(message),
          actions: <Widget>[
            Center(
              child: new TextButton(
                
                child: const Text("OK",
                textAlign: TextAlign.center,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        );
      },
    );
  }

  //  void uploadUserFB(String userEmail,String userName) async {
  //         if(FirebaseFirestore.instance.collection("users")
  //         .where('email', isEqualTo: userEmail)
  //         .get() != userEmail){
  //           print("User already exists");
  //           print(userEmail);
  //         }else{
  //         await FirebaseFirestore.instance.collection("users").add(
  //       {
  //     //    "uid": auth.currentUser!.uid,
  //         "email": userEmail.toString(),
  //     //    "username": userName.text,
  //         "name": userName.toString(),
  //         }
  //         );
  // }
  //  }

   void uploadUserFB(String userEmail,String userName) async {
          QuerySnapshot query = await FirebaseFirestore.instance.collection('users').where('email',isEqualTo:userEmail).get();
          if (query.docs.isNotEmpty){
                print("User already exists");
          }else if(query.docs.isEmpty){
          await FirebaseFirestore.instance.collection("users").add(
        {
          "uid": auth.currentUser!.uid,
          "email": userEmail.toString(),
          "name": userName.toString(),});   
  }
   }


}