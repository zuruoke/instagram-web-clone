import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/state/auth_state.dart';
import 'package:instagram_clone/ui/tab_screen.dart';
import 'package:instagram_clone/utils/enum.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends  StatefulWidget{
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  TextEditingController usernameController;
  TextEditingController emailController;
  TextEditingController passwordController;

  @override
  void initState() { 
    usernameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
    
  }

  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

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
        entryField(40, usernameController),
        entryField(5, emailController),
        entryField(5, passwordController),
        loginButton(),
        SizedBox(height: 30,),
        ],
        ),),  
      );
  }

   loginButton(){
    Size mq = MediaQuery.of(context).size;
    return Container(
      height: 55,
      width: 0.7 * mq.width,
       padding: EdgeInsets.only(top: 15, left: 30, right: 30, bottom: 5),
       child: TextButton(
         onPressed: submitForm, 
         style: TextButton.styleFrom(
           backgroundColor: Colors.blue,
           shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),),
         ),
         child: Text("Log In", style: TextStyle(color: Colors.white),)
         ),
    );
  }

  void submitForm() async{
     var state = Provider.of<AuthState>(context, listen: false);
     try {
     await state.signUpWithEmailAndPassword(context, emailController.text, passwordController.text, usernameController.text);
     } catch(error){
      print(error.toString());
    }
    if (state.authStatus == AuthStatus.Logged_In){
      Navigator.push(context, MaterialPageRoute(builder: (ctx) => TabScreen()));
    }
  }

  entryField(double topp, TextEditingController controllers){
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
                controller: controllers,
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
  Widget build(BuildContext context){
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            contentScreen(),
          ],
        ),
    ));
}
}