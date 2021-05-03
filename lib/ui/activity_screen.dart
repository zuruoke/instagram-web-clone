import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/feed.dart';

class ActivityScreen extends StatelessWidget{
  final String currentUserId;
  final CollectionReference ref = FirebaseFirestore.instance.collection('feed');

  ActivityScreen({required this.currentUserId});
  getActivityFeeds (){
    return StreamBuilder(
      stream: ref.doc(currentUserId).collection('feedItems').orderBy('timestamp', descending: true).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
        if (snapshot.hasData){
          List<FeedItem> feeds = [];
          snapshot.data!.docs.forEach((QueryDocumentSnapshot doc){
            feeds.add(FeedItem.fromDocument(doc));
          });
          return Column(
            children: feeds,
          );
        }
        return Center(
          child: Text("")
        );
      }
      );
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Activity", 
            style: TextStyle(fontWeight: FontWeight.bold),),
        centerTitle: true,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
          SizedBox(height: 20,),
          Padding(
            padding: EdgeInsets.only(left: 20),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text("This Month", 
            style: TextStyle(fontWeight: FontWeight.bold),),),
          ),
            getActivityFeeds(),

          ],
        )),
    );
  }
}