import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/state/auth_state.dart';
import 'package:instagram_clone/ui/auth_ui/add_profile_pic.dart';
import 'package:instagram_clone/utils/enum.dart';
import 'package:instagram_clone/utils/validate_credentials.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends  StatefulWidget{
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  final _formKey = GlobalKey<FormState>();
  late TextEditingController usernameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;

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
    return Container(
      height: 0.65 * mq.height,
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          entryField(40, usernameController, 'username', false, false),
          entryField(5, emailController, 'email', false, true),
          entryField(5, passwordController, 'password', true, false),
          loginButton(),
          Divider(height: 30),
          SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

   loginButton(){
    Size mq = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(top: 15, left: 0.05 * mq.width, right: 0.05 * mq.width, bottom: 5),
      child: Container(
      height: 35,
      width: 0.9 * mq.width,
       //padding: EdgeInsets.only(top: 15, left: 30, right: 30, bottom: 5),
       child: TextButton(
         onPressed: submitForm, 
         style: TextButton.styleFrom(
           backgroundColor: Colors.blue,
           shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),),
         ),
         child: Text("Sign Up", style: TextStyle(color: Colors.white),)
         ),
    ));
  }

  void submitForm() async{
     var state = Provider.of<AuthState>(context, listen: false);
     if (usernameController.text.isEmpty){
       snackBar('Please enter Username');
       return;
     }
     if (usernameController.text.length > 20){
       snackBar('Username length cannot exceed 20 characters');
       return;
     }
     var status = validateEmail(emailController.text);
     if (!status){
       snackBar('Enter a Valid email address');
       return;
     }
     if (passwordController.text.isEmpty){
       snackBar("Enter a password");
       return;
     }
     if(passwordController.text.length < 5){
       snackBar('Weak Password');
       return;
     }
     await state.signUpWithEmailAndPassword(context, emailController.text, passwordController.text, usernameController.text);
     if (state.authStatus == AuthStatus.Logged_In){
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (ctx) => AddProfilePicScreen(name: usernameController.text)));
    }
    else{
      snackBar(state.errorMessage2!);
    }
    state.errorMessage2 = null;
  }

  entryField(double topp, TextEditingController textEditingcontroller, String text, bool isPassword, bool isEmail){
    return Padding(
      padding: EdgeInsets.only(top: topp, left: 30, right: 30, bottom: 5),
      child: Container(
        height: 38,
        decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(3),
        border: Border.all(
          color: Colors.grey,
          width: 0.2,
        )
        ),
        child: TextField(
        obscureText: isPassword,
        controller: textEditingcontroller,
        keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
        style: TextStyle(
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.normal
    ),
        decoration: InputDecoration(
          labelText: text,
          labelStyle: TextStyle(fontSize: 13, color: Colors.grey),
          border: InputBorder.none,
          focusedBorder: OutlineInputBorder(
      ),
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
    ),
        ),
      ),
    );
    }

  snackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 2),
      shape: const RoundedRectangleBorder(
          borderRadius: const BorderRadius.only(
              topRight: const Radius.circular(15),
              topLeft: const Radius.circular(15))),
      content: Text(
        text,
        style: const TextStyle(
            fontWeight: FontWeight.w700, color: Colors.black, fontSize: 16),
      ),
      backgroundColor: Colors.redAccent,
    ));
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        elevation: 1.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.black,), 
          onPressed: (){
            Navigator.pop(context);
          }
        ),
        title: Text("Register", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 30,),
            contentScreen(),
          ],
        ),
    ));
}
}