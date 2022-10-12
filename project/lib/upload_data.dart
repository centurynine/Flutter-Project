import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UploadData extends StatefulWidget {
  const UploadData({super.key});

  @override
  State<UploadData> createState() => _UploadDataState();
}

class _UploadDataState extends State<UploadData> {
  final _formstate = GlobalKey<FormState>();
  String title = '';
  String subtitle = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Upload Data',
        style: GoogleFonts.kanit(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                    ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      
      ),
      body: Column(
        children: <Widget>[
          Container(
          child: titleForm(),
        ),
        Container(
          child: subtitleForm(),
        ),
        
        ],
      ),
    );
  }
  
  TextFormField titleForm() {
    return TextFormField(
      onSaved: (value) {
        title = value!.trim();
      },
      validator: (value) {
        if (value!.length < 8)
          return 'Please Enter more than 8 Character';
        else
          return null;
      },
      keyboardType: TextInputType.text,
      decoration: const InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(22.0)),
        ),
        hintText: 'หัวข้อ',
        labelText: 'ชื่ออาหาร',
        prefixIcon: Icon(Icons.food_bank),
      ),
    );
  }

  TextFormField subtitleForm() {
    return TextFormField(
      maxLines: 5,
      onSaved: (value) {
        subtitle = value!.trim();
      },
      validator: (value) {
        if (value!.length < 8)
          return 'Please Enter more than 8 Character';
        else
          return null;
      },
      keyboardType: TextInputType.text,
      decoration: const InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(22.0)),
        ),
        hintText: 'รายละเอียด',
        labelText: 'ขั้นตอนการทำ',
        prefixIcon: Icon(Icons.how_to_reg),
      ),
    );
  }

  ElevatedButton loginButton() {
    return ElevatedButton(
        child: const Text('Login'),
        style: ElevatedButton.styleFrom(
          primary: Colors.blue,
          onPrimary: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        ),
        onPressed: () async {
         if (_formstate.currentState!.validate()) {
            print('Valid Form');
            _formstate.currentState!.save();
            try {
              
            } catch (e) {
              print(e);
            }
            }

        }
        );

}
}