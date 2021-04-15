import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget{
  _LoginScreenState createState() => _LoginScreenState();

}

class _LoginScreenState extends State<LoginScreen>{

  contentScreen(){
    Size mq = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(left: 0.15 * mq.width, right: 0.15 * mq.width, top: 30,),
      child: Container(
        height: 0.55 * mq.height, width: 0.7 * mq.width,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            width: 0.3,
            color: Colors.grey
          )
        ),
        child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20,),
          Text("          Instagram",
            style:
              TextStyle(
                fontSize: 35, fontStyle: FontStyle.italic, color: Colors.black
              )),
        entryField(40),
        entryField(5),
        loginButton(),
        SizedBox(height: 30,),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: 30),
            Padding(
              padding: EdgeInsets.only(top: 8),
              child: Container(
              width: 0.225 * mq.width,
              decoration: BoxDecoration(
                color: Colors.grey,
                border: Border.all(
                  width: 0.10
                )
              ),
            ),),
            Padding(padding: EdgeInsets.only(left: 15, right: 15, bottom: 20),
              child: Text('OR', style: TextStyle(color: Colors.grey)) ,
            ),
            Padding(
              padding: EdgeInsets.only(top: 8),
              child: Container(
              width: 0.25 * mq.width,
              decoration: BoxDecoration(
                color: Colors.grey,
                border: Border.all(
                  width: 0.10
                )
              ),
            ),),
            SizedBox(width: 30),
          ],
        ),
        SizedBox(height: 20,),
        loginWithGoogle(),
        SizedBox(height: 20,),
        resetPassword()
        ],
      ),
        ),
      );
  }

  resetPassword(){
    Size mq = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(left: 0.231 * mq.width, right: 0.231 * mq.width ),
      child: InkWell(
        autofocus: true,
        focusColor: Colors.deepPurpleAccent,
        child: Text('   Forgot password? ', style: TextStyle(color: Colors.black, fontSize: 12),),
      onTap: (){},
    ),
    );
  }

  loginWithGoogle(){
    Size mq = MediaQuery.of(context).size;
    return Padding(
    padding: EdgeInsets.only(left: 0.231 * mq.width, right: 0.231 * mq.width),
    child: InkWell(
      autofocus: true,
      focusColor: Colors.deepPurpleAccent,
      child: Text('Log in with Google', style: TextStyle(color: Colors.deepPurpleAccent),),
      onTap: (){},
    ),
    );
  }

  signUpContent(){
    Size mq = MediaQuery.of(context).size;
    return Padding( 
      padding: EdgeInsets.only(left: 0.15 * mq.width, right: 0.15 * mq.width,),
      child: Container(
        height: 60, width: 0.7 * mq.width,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            width: 0.3,
            color: Colors.grey
          )
        ),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 0.12 * mq.width),
              child: Text("     Don't have an account? ")),
             Padding(
              padding: EdgeInsets.only( right: 0.12 * mq.width,),
            child: InkWell(
               autofocus: true,
              focusColor: Colors.deepPurpleAccent,
             child: Text('Sign Up', style: TextStyle(color: Colors.deepPurpleAccent),),
            onTap: (){},
            ),),
          ],
        )
      ),
    );
  }

  loginButton(){
    Size mq = MediaQuery.of(context).size;
    return Container(
      height: 55,
      width: 0.7 * mq.width,
       padding: EdgeInsets.only(top: 15, left: 30, right: 30, bottom: 5),
       child: TextButton(
         onPressed: (){}, 
         style: TextButton.styleFrom(
           backgroundColor: Colors.blue,
           shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),),
         ),
         child: Text("Log In", style: TextStyle(color: Colors.white),)
         ),
    );
  }

  entryField(double topp){
    return Padding(
            padding: EdgeInsets.only(top: topp, left: 30, right: 30, bottom: 5),
            child: Container(
              height: 45,
              decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(3),
              border: Border.all(
                color: Colors.grey,
                width: 1.0,
              )
              ),
              child: TextField(
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.normal
        ),
        decoration: InputDecoration(
           border: InputBorder.none,
           focusedBorder: OutlineInputBorder(
           ),
           contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        ),
              ),
            ),
          );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            contentScreen(),
            SizedBox(height: 20,),
            signUpContent(),
          ],
        ),
      )
    );
  }
}