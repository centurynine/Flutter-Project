import 'package:project/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formstate = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
        body: Form(
      key: _formstate,
      child: ListView(
        children: <Widget>[
          buildEmailField(),
          buildPasswordField(),
          buildRegisterButton(),
        ],
      ),
      
    )
    
    );
  }

  ElevatedButton buildRegisterButton() {
    return ElevatedButton(
      child: const Text('Register'),
      onPressed: ()  async{
        print('Register');
        if (_formstate.currentState!.validate()){
        print(email.text);
        print(password.text);
        final _user = await auth.createUserWithEmailAndPassword(
          email: email.text.trim(),
          password: password.text.trim()
          );
        _user.user!.sendEmailVerification();
        Navigator.pushAndRemoveUntil(
           context,
           MaterialPageRoute(builder: (context) => const LoginPage()),
           ModalRoute.withName('/'));}
           else {
            print('Invalid Form');
           }
      },
    );
  }

  TextFormField buildPasswordField() {
    return TextFormField(
      controller: password,
      validator: (value) {
        if (value!.length < 8)
          return 'Please Enter more than 8 Character';
        else
          return null;
      },
      obscureText: true,
      keyboardType: TextInputType.text,
      decoration: const InputDecoration(
        labelText: 'Password',
        icon: Icon(Icons.lock),
      ),
    );
  }

  TextFormField buildEmailField() {
    return TextFormField(
      controller: email,
      validator: (value) {
        if (value!.isEmpty)
          return 'Please fill in E-mail field';
        else
          return null;
      },
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        labelText: 'E-mail',
        icon: Icon(Icons.email),
        hintText: 'email@x.com',
      ),
    );
  }
}
