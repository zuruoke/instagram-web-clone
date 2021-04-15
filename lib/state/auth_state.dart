import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:instagram_clone/state/app_state.dart';
import 'package:instagram_clone/utils/enum.dart';
import 'package:instagram_clone/utils/http_exception.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthState extends AppState{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  AuthStatus authStatus;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

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
        saveUserInfo(uid: user.uid, email: email, username: args);
      }

    } catch(error){
      authStatus = AuthStatus.Not_Logged_In;
      throw HttpException(error.toString());
    }
    loading = false;
  }

  Future<void> signOutWithEmailAndPassword() async{
    await _auth.signOut();
    authStatus = AuthStatus.Not_Logged_In;
  }

  Future<void> sigInWithGoogle() async {
    GoogleAuthProvider authProvider = GoogleAuthProvider();
    try {
      loading = true;
      final UserCredential userCredential = await _auth.signInWithPopup(authProvider);
      User user = userCredential.user;

      if (user != null){
        authStatus = AuthStatus.Logged_In;
      }

    } catch (error){

    }
     loading = false;
  }

  Future<void> signOutWithGoogle() async{
    await googleSignIn.signOut();
    await _auth.signOut();
    authStatus = AuthStatus.Not_Logged_In;
  }

  void saveUserInfo({String uid, String username, String email}){
    final userRef = _firebaseFirestore.collection('users').doc(uid);
    userRef.set({
        'id': uid,
        'email': email,
        'username': username,

    });
  }

  }



