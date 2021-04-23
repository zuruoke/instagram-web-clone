import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostItem extends StatefulWidget{
  final String postId;
  final String postOwneriId;
  final String postOwnerUsername;
  final String postOwnerPhotoUrl;
  final String postPhotoUrl;
  final String caption;
  final dynamic likes;
  final Timestamp timestamp;

  PostItem({
    this.postId,
    this.postOwneriId,
    this.postOwnerUsername,
    this.postOwnerPhotoUrl,
    this.postPhotoUrl,
    this.caption,
    this.likes,
    this.timestamp
  });

  factory PostItem.fromDocument(DocumentSnapshot doc){
    return PostItem(
      postId: doc.data()['postId'],
      postOwneriId: doc.data()['postOwneriId'],
      postOwnerPhotoUrl: doc.data()['postOwnerPhotoUrl'],
      postOwnerUsername: doc.data()['postOwnerUsername'],
      postPhotoUrl: doc.data()['postPhotoUrl'],
      caption: doc.data()['caption'],
      likes: doc.data()['likes'],
      timestamp: doc.data()['timestamp'],
    );
  }

  int getLikeCounts(){
    if (likes == null){
      return 0;
    }
    int count = 0;
    likes.values.forEach((val){
      count += 1;
    });
    return count;
  }

  
  @override
  _PostItemState createState() => _PostItemState(
    getLikeCounts(),likes
  );
}

class _PostItemState extends State<PostItem> {
  
  int getLikeCounts;
  Map likesData;
  var _isLiked;

  _PostItemState(this.getLikeCounts, this.likesData);

  getUserValues() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    setState(() {
      userUid = _prefs.getString('userId');      
    });
  }
  
  @override
  Widget build(BuildContext context) {
    
    
    return Center(
      child: Text(""),
    );
  }
  
}