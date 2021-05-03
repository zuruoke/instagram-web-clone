import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:instagram_clone/state/auth_state.dart';
import 'package:instagram_clone/ui/auth_ui/signup_screen.dart';
import 'package:instagram_clone/ui/tab_screen.dart';
import 'package:instagram_clone/utils/enum.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget{
  _LoginScreenState createState() => _LoginScreenState();

}

class _LoginScreenState extends State<LoginScreen>{

  late TextEditingController emailController;
  late TextEditingController passwordController;
  final _focusPassword = FocusNode();
  bool emailValidated = false;
  bool passwordValidated = false;

  @override
  void initState() { 
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
    
  }

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    _focusPassword.dispose();
    super.dispose();
  }

  contentScreen(){
    var state = Provider.of<AuthState>(context, listen: true);
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
          Align(
            alignment: Alignment.topCenter,
            child: Text("Instagram",
            style:
              TextStyle(
                fontSize: 35, fontStyle: FontStyle.italic, color: Colors.black
              )),),
        entryField(40, emailController, "email", false, true),
        entryField(5, passwordController, "password", true, false),
        state.isLoading ? SpinKitPouringHourglass( color: Colors.blue,) : loginButton(),
        SizedBox(height: 30,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
            Padding(padding: EdgeInsets.only(left: 15, right: 15, top: 10),
                child: Text('OR', style: TextStyle(color: Colors.grey)),
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
        resetPassword(),

        ],
      ),
        ),
      );
  }

  resetPassword(){
    //Size mq = MediaQuery.of(context).size;
    return InkWell(
        autofocus: true,
        focusColor: Colors.deepPurpleAccent,
        child: Align(
          alignment: Alignment.center,
          child: Text('Forgot password? ', style: TextStyle(color: Colors.black, fontSize: 12),),),
      onTap: (){},
    );
  }

  loginWithGoogle(){
    //Size mq = MediaQuery.of(context).size;
    return InkWell(
      autofocus: true,
      focusColor: Colors.deepPurpleAccent,
      child: Align(
        alignment: Alignment.center,
        child: Text('Log in with Google', style: TextStyle(color: Colors.deepPurpleAccent),)),
      onTap: loginWithGoogleButton,
    );
  }

  loginWithGoogleButton() async {
     var state = Provider.of<AuthState>(context, listen: false);
     try {
    await state.sigInWithGoogle();
  } catch(error){
      print(error.toString()); 
    }
    if (state.authStatus == AuthStatus.Logged_In){
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (ctx) => TabScreen()));
    }
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 0.12 * mq.width),
              child: Text("Don't have an account? ")),
             Padding(
              padding: EdgeInsets.only( right: 0.12 * mq.width,),
            child: InkWell(
               autofocus: true,
              focusColor: Colors.deepPurpleAccent,
             child: Text('Sign Up', style: TextStyle(color: Colors.blue),),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(
                builder: (ctx) => SignUpScreen()));
            },
            ),),
          ],
        )
      ),
    );
  }
  getTheApp(){
    return Column(
      children: [
        Text('Get the app'),
        SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 90),
              child: Image(
              image: 
                  NetworkImage('https://img.pngio.com/app-store-logopng-low-emission-zone-brussels-app-store-png-4491_1552.png'
                ),
                width: 150, height: 50,

                  )),
            Padding(
              padding: EdgeInsets.only(left: 10, right: 80),
            child: Image(
              image: NetworkImage('https://miro.medium.com/max/4000/1*OIIv4FEjJQMqh-zEPhtlYA.png'),
              width: 150, height: 50,
              ))
           //Image(image: AssetImage('assets/images/apple.png')),
           //Image(image: AssetImage('assets/images/google.png')),
          ],
        )
      ],
    );
  }

  void snackBar(String text) {
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

  submitLogin() async{
    var state = Provider.of<AuthState>(context, listen: false);
    await state.signInWithEmailAndPassword(context, emailController.text, passwordController.text);
    if (state.authStatus == AuthStatus.Logged_In){
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (ctx) => TabScreen()));
    }
    else {
      snackBar(state.errorMessage!);
    }
    state.errorMessage = null;
  }

  loginButton(){
    Size mq = MediaQuery.of(context).size;
    return Container(
      height: 55,
      width: 0.7 * mq.width,
       padding: EdgeInsets.only(top: 15, left: 30, right: 30, bottom: 5),
       child: TextButton(
         onPressed: submitLogin, 
         style: TextButton.styleFrom(
           backgroundColor: emailValidated && passwordValidated ? Colors.blue : Colors.blue[100], 
           shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),),
         ),
         child: Text("Log In", style: TextStyle(color: Colors.white),)
         ),
    );
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
                onChanged: (_value){
                  isEmail ? checkOnChangedEmail(_value) : checkOnChangedPassword(_value);
                },
                onSubmitted: (_) {
                  isEmail ? FocusScope.of(context).requestFocus(_focusPassword) : doNothingAction();
                },
                obscureText: isPassword,
                controller: textEditingcontroller,
                keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
                focusNode: isPassword ? _focusPassword : null,
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

  void doNothingAction(){
    print('');
  }

  checkOnChangedEmail(String _value){
    if (_value.length > 2){
      setState(() {
         emailValidated = true;     
    });
    }
    else if (_value.length < 2){
      setState(() {
        emailValidated = false;       
      });
    }
  }

  checkOnChangedPassword(String _value){
    if (_value.length > 2){
      setState(() {
         passwordValidated = true;     
    });
    }
    else if (_value.length < 2){
      setState(() {
        passwordValidated  = false;       
      });
    }
  }

  footer(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text('About'),Text('Blogs'),Text('Jobs'),Text('Help'),Text('API'),Text('Privacy'),Text('Terms'), Text('Top Accounts')
          ],
        )),
        Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Hashtags'), SizedBox(width: 20,), Text("Locations")
            ],
          ),
        ),
         Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 15),
          child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text('Beauty'),Text('Dance & Performance'),Text('Fitness'),Text('Food & Drinks'),Text('Home & Garden'),
          ],
        )),
        Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Music'), SizedBox(width: 20,), Text("Visual Arts")
            ],
          ),
        ),
      ],
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
            SizedBox(height: 40,),
            getTheApp(),
            SizedBox(height: 20,),
            footer(),
            SizedBox(height: 20,)
          ],
        ),
      )
    );
  }
}