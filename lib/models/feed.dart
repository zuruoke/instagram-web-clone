import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/ui/profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeago;

class FeedItem extends StatefulWidget{

  final String? postId;
  final String type;
  final String userId;
  final String? userProfileUrl;
  final String username;
  final Timestamp timestamp;

  FeedItem({
    this.postId,
    required this.type,
    required this.userId,
    this.userProfileUrl,
    required this.username,
    required this.timestamp
  });

  factory FeedItem.fromDocument(QueryDocumentSnapshot doc){
    return FeedItem(
      postId: doc.data()['postId'],
      type: doc.data()['type'],
      userId: doc.data()['userId'],
      userProfileUrl: doc.data()['userProfileUrl'],
      username: doc.data()['username'],
      timestamp: doc.data()['timestamp'],
    );
  }


  _FeedItemState createState() => _FeedItemState();
}

class _FeedItemState extends State<FeedItem>{
  bool isFollowing = false;
  String? userUid;
  String? profilePicUrl;
  String? currentUserUsername;
  final followersRef = FirebaseFirestore.instance.collection('followers');
  final followingRef = FirebaseFirestore.instance.collection('following');
  final activityFeedRef = FirebaseFirestore.instance.collection('feed');

  showUserProfile() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (ctx) => ProfileScreen(currentUserId: widget.userId)));
  }

  getUserId() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    setState(() {
      userUid = _prefs.getString('userId');  
      checkIsFollowing(userUid);    
    });
  }

   getUserValues() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.reload();
    profilePicUrl = _prefs.getString('currentUserProfilePicUrl');
    currentUserUsername = _prefs.getString('currentUserUsername')!;     
  }

  checkIsFollowing(String? userUid) async {
    DocumentSnapshot doc = await followersRef.doc(widget.userId).collection('userFollowers').doc(userUid).get();
    setState(() {
      isFollowing = doc.exists;      
    });
  }

  handleFollow(){
    setState(() {
      isFollowing = true;   
    });

    followersRef.doc(widget.userId).collection('userFollowers').doc(userUid).set({});
    followingRef.doc(userUid).collection('userFollowing').doc(widget.userId).set({});
    addFollowToFeed();
  }


  handleUnfollow(){
    setState(() {
      isFollowing = false;
    });
    followersRef.doc(widget.userId)
                .collection('userFollowers')
                .doc(userUid).get()
                .then((doc) {
                  if(doc.exists){
                    doc.reference.delete();
                  }
                });

    followingRef.doc(userUid)
                .collection('userFollowing')
                .doc(widget.userId).get()
                .then((doc) {
                  if (doc.exists){
                    doc.reference.delete();
                  }
                });
    removeFollowFromFeed();
  }

  addFollowToFeed(){
    activityFeedRef.doc(widget.userId).collection('feedItems').doc(userUid).set({
      'type': 'follow',
      'timestamp': DateTime.now(),
      'userId': userUid,
      'userProfileUrl': profilePicUrl,
      'username': currentUserUsername,
    });
  }

  removeFollowFromFeed(){
     activityFeedRef.doc(widget.userId).collection('feedItems').doc(userUid).get()
        .then((doc){
            if (doc.exists){
              doc.reference.delete();
            }
        });
  }
  @override
  void initState() {
    getUserId();
    getUserValues(); 
    super.initState();
    
  }

 contentScreen(){
   return Column(
     children: [
      SizedBox(height: 30,),
      ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.black,
          backgroundImage: widget.userProfileUrl == null ? NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcT_ebls-UUShLJTBsclAHFxv2QYxDJIQdre45gDkFn5FEkC7JvI&usqp=CAU') 
                                                         : NetworkImage(widget.userProfileUrl!),
        ),
        title: widget.type == 'follow' ? Text("${widget.username} started following you \n${timeago.format(widget.timestamp.toDate())}")
               : widget.type == 'like' ? Text("${widget.username} liked your photo \n ${timeago.format(widget.timestamp.toDate())}")
               : Text('data'),
        trailing: widget.type == 'follow' ? TextButton(
          style: TextButton.styleFrom(
            elevation: 2, backgroundColor: Colors.blue
          ),
          onPressed: isFollowing ? handleUnfollow : handleFollow, 
          child:  isFollowing ? Text('Unfollow', style: TextStyle(color: Colors.white,),) : Text('Follow', style: TextStyle(color: Colors.white,),)
          )
          : widget.type == 'like' ? Icon(
            Icons.favorite_rounded, size: 30, color: Colors.redAccent,
          ) : Text('') ,
      )
     ],
   );
 }

  @override
  Widget build(BuildContext context) {
     return contentScreen();
  }
  
}