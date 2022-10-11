import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class BodyAfterLogin extends StatefulWidget {
  const BodyAfterLogin({super.key});

  @override
  State<BodyAfterLogin> createState() => _BodyAfterLoginState();
}

class _BodyAfterLoginState extends State<BodyAfterLogin> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text('After Login Successfuly'),
          ],
        )
      ],
    );
  }
}