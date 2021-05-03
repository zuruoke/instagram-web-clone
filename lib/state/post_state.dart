import 'package:flutter/cupertino.dart';
import 'package:instagram_clone/state/app_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostState extends AppState{

final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

void createPostInFirestore({
  required BuildContext context,
  required String uid, 
  required String caption, 
  required String username, 
  required String postPhotourl, 
  String? userProfilePicUrl, 
  required String postId, 
  required String collectionName}) {
  loading = true;
  _firebaseFirestore.collection(collectionName).doc(uid).collection('userPosts').doc(postId).set({
    'postId' : postId,
    'postOwneriId': uid,
    'postOwnerUsername': username,
    'postPhotoUrl': postPhotourl,
    'postOwnerPhotoUrl': userProfilePicUrl,
    'caption': caption,
    'timestamp': DateTime.now(),
    'likes': {},
    'comments': []
  });

  loading = false;

    }
  
  void createPostInFirestoreForAll({
  required BuildContext context,
  required String uid, 
  required String caption, 
  required String username, 
  required String postPhotourl, 
  String? userProfilePicUrl, 
  required String postId, 
  required String collectionName}) {
  _firebaseFirestore.collection(collectionName).doc(postId).set({
    'postId' : postId,
    'postOwneriId': uid,
    'postOwnerUsername': username,
    'postPhotoUrl': postPhotourl,
    'postOwnerPhotoUrl': userProfilePicUrl,
    'caption': caption,
    'timestamp': DateTime.now(),
    'likes': {},
    'comments': [],
  });


}

}