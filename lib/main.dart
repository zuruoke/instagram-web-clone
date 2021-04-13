import 'package:flutter/material.dart';
import 'package:instagram_clone/ui/tab_screen.dart';

void main() {
  runApp(InstagramCloneApp());
}

class InstagramCloneApp extends StatefulWidget{

  _InstagramCloneAppState createState() => _InstagramCloneAppState();
}

class _InstagramCloneAppState extends State<InstagramCloneApp> {

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: TabScreen(),
    );
  } 

}

