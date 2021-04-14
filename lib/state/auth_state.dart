import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:instagram_clone/state/app_state.dart';
import 'package:instagram_clone/utils/enum.dart';
import 'package:instagram_clone/utils/http_exception.dart';

class AuthState extends AppState{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  AuthStatus authStatus;

  Future<void> signInWithEmailAndPassword(BuildContext context, String email, String password) async{
    try {
      loading = true;
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User user = userCredential.user;
      if (user != null){
        authStatus = AuthStatus.Logged_In;
      }
      
      } catch(error){
        authStatus = AuthStatus.Not_Logged_In;
        throw HttpException(error.toString());
      }
      loading = false;
      }
  Future<void> signUpWithEmailAndPassword(BuildContext context, String email, String password, String args) async{
    try {
      loading = true;
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User user = userCredential.user;
      if (user != null){
        authStatus = AuthStatus.Logged_In;
      }

    } catch(error){
      authStatus = AuthStatus.Not_Logged_In;
      throw HttpException(error.toString());
    }
    loading = false;
  }

  }



