import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

createPostInFirestore({
      required String uid, 
      required String caption, 
      required String username, 
      required String postPhotourl, 
      String? userProfilePicUrl, 
      required String postId, 
      required String collectionName}) {
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

    }
  
  
  createPostInFirestoreForAll({
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