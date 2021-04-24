import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:instagram_clone/state/app_state.dart';
import 'package:instagram_clone/utils/enum.dart';
import 'package:instagram_clone/utils/http_exception.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthState extends AppState{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late AuthStatus authStatus;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  late String userUid;
  String? profilePicUrl;
  String? currentUserUsername;
  var screenHeight;
  var screenWidth;

  void getScreenSize(BuildContext context){
    Size size = MediaQuery.of(context).size;
    screenHeight = size.width;
    screenWidth = size.height;
  }

  getUserCredentials() {
    User user = _auth.currentUser!;
    userUid = user.uid;
    _firebaseFirestore.collection('users').doc(user.uid).get()
              .then((value) {
                profilePicUrl = value.data()!['photo'];
                currentUserUsername = value.data()!['username'];
      });

  }

  Future<void> getUserUid() async{
    User user = _auth.currentUser!;
    userUid = user.uid;
  }

  Future<void> getUserProfileUrlandUsername({String? id}) async{
    if (id == null){
      getUserUid();
      DocumentSnapshot snapshot = await _firebaseFirestore.collection('users').doc(userUid).get();
      profilePicUrl =  snapshot.data()!['photo'];
      currentUserUsername = snapshot.data()!['username'];
    } else {
      DocumentSnapshot snapshot = await _firebaseFirestore.collection('users').doc(id).get();
      profilePicUrl =  snapshot.data()!['photo'];
      currentUserUsername = snapshot.data()!['username'];
  }
  }

  Future<void> signInWithEmailAndPassword(BuildContext context, String email, String password) async{
    try {
      loading = true;
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      if (user != null){
        authStatus = AuthStatus.Logged_In;
        saveSharedPreference(uid: user.uid);
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
      User? user = userCredential.user;
      if (user != null){
        authStatus = AuthStatus.Logged_In;
        saveUserInfo(uid: user.uid, email: email, username: args);
        saveSharedPreference(uid: user.uid);
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
    removeSharedPreference();
  }

  Future<void> sigInWithGoogle() async {
    GoogleAuthProvider authProvider = GoogleAuthProvider();
    try {
      loading = true;
      final UserCredential userCredential = await _auth.signInWithPopup(authProvider);
      User? user = userCredential.user;

      if (user != null){
        authStatus = AuthStatus.Logged_In;
        saveUserInfo(uid: user.uid, email: user.email!, username: user.displayName!);
        saveSharedPreference(uid: user.uid);
      }

    } catch (error){

    }
     loading = false;
  }

  Future<void> signOutWithGoogle() async{
    await googleSignIn.signOut();
    await _auth.signOut();
    authStatus = AuthStatus.Not_Logged_In;
    removeSharedPreference();
  }

  void saveUserInfo({required String uid, required String username, required String email}){
    final userRef = _firebaseFirestore.collection('users').doc(uid);
    userRef.set({
        'id': uid,
        'email': email,
        'username': username,
        'photo': null,
        'bio': '',

    });
  }

  Future<void> saveSharedPreference({required String uid}) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DocumentSnapshot snapshot = await _firebaseFirestore.collection('users').doc(uid).get();
    prefs.setString('userId', uid);
    prefs.setString('currentUserProfilePicUrl', snapshot.data()!['photo']);
    prefs.setString('currentUserUsername', snapshot.data()!['username']);
  }

  removeSharedPreference() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('userId');
    prefs.remove('currentUserProfilePicUrl');
    prefs.remove('currentUserUsername');
  }

  }



