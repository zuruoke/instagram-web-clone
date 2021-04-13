import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget{

  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  _buildAppBar(){
    return AppBar(
      leading: IconButton(
        onPressed: null,
        icon: Icon(Icons.adjust_rounded, size: 35, color: Colors.black,
        ),
      ),
      title: Text('zuruokeokafor',style: TextStyle(fontWeight: FontWeight.bold),),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(Icons.person_add_outlined, size: 35, color: Colors.black,), 
        onPressed: null
        ),
        SizedBox(width: 20,)
      ],
      elevation: 1.4,
    );
  }


  topScreen(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(width: 25,),
        Container(
          height: 100, width: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black
          ),
        ),
        SizedBox(width: 50,),
        Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
          children: [
            Text('zuruokeokafor', style: TextStyle(fontSize: 30),),
          SizedBox(height: 10,),
          Container(
            width: 300, height: 30,
            child: TextButton(
            style: TextButton.styleFrom(
              elevation: 1.6,
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    side: BorderSide(color: Colors.grey)
            ),),
            onPressed: null,
            child: Text('Edit Profile', style: TextStyle(
              fontWeight: FontWeight.bold, 
              fontSize: 20, color: 
              Colors.black),),
          )
          )
          
          ],
        )
      ],
        ),
      SizedBox(height: 30,),
      Padding(
        padding: EdgeInsets.only(left: 30),
        child: Text('Okafor Zuruoke', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),)),
      SizedBox(height: 10,),
      Padding(
        padding: EdgeInsets.only(left: 30),
      child: Text('Entrepreneur', style: TextStyle(color: Colors.grey, fontSize: 16),),),
      SizedBox(height: 5,),
      Padding(
        padding: EdgeInsets.only(left: 30),
      child: Text("- Engineer\n\- Entrepreneur\n- Content Creator\n- Product Designer\n- Knowledge Seeker\n- I know my son gonna be here, so I'mma make this life \nlegendary", 
            style: TextStyle( fontSize: 17),),),
      SizedBox(height: 20,),
      Divider(thickness: 0.24, color: Colors.black,),
      SizedBox(height: 10,),
      Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text('12.5k', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
        Text('36M', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
        Text("  3954", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),)
      ],
    ),
    Padding(padding: EdgeInsets.only(top:5)),
      Row(
         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text('    posts'), 
        Text(' followers'),
        Text('following')
      ]
      ),
      
      Divider(thickness: 0.24, color: Colors.black,)
      ],
    );
  }

  buildFollowersCount(){
    return Container(
      child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text('12', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
        Text('36', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
        Text("54", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),)
      ],
    ));
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30,),
            topScreen(),
          ],
        ),
        ),
    );
  }
}