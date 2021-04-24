import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ActivityScreen extends StatefulWidget{
  final String currentUserId;

  ActivityScreen({required this.currentUserId});

  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Activity", 
            style: TextStyle(fontWeight: FontWeight.bold),),
        centerTitle: true,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20,),
            Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text("This Month", 
            style: TextStyle(fontWeight: FontWeight.bold),),
            ),
            SizedBox(height: 30,),
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.black,
              ),
              title: Text("black_gik started following you \n1w"),
              trailing: TextButton(
                style: TextButton.styleFrom(
                  elevation: 2, backgroundColor: Colors.blue
                ),
                onPressed: null, 
                child: Text('Follow', style: TextStyle(color: Colors.white,),)
                ),
            )

          ],
        )),
    );
  }
}