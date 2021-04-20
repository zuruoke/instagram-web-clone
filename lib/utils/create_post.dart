import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

createPostInFirestore(
  {String uid, String caption, String username, String postPhotourl, String userProfilePicUrl, String postId, String collectionName}) {
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
  
  
  createPostInFirestoreForAll(
  {String uid, String caption, String username, String postPhotourl, String userProfilePicUrl, String postId, String collectionName}) {
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