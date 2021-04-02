import 'package:flutter/material.dart';

class Token extends StatefulWidget {
  final String token;
  Token({this.token});
  @override
  _TokenState createState() => _TokenState();
}

class _TokenState extends State<Token> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(widget.token),
        ]
      ),
    );
  }
}