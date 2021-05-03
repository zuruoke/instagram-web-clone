import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/ui/profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostItem extends StatefulWidget{
  final String postId;
  final String postOwneriId;
  final String? postOwnerUsername;
  final String? postOwnerPhotoUrl;
  final String? postPhotoUrl;
  final String caption;
  final dynamic? likes;
  final Timestamp timestamp;

  PostItem({
    required this.postId,
    required this.postOwneriId,
    required this.postOwnerUsername,
    this.postOwnerPhotoUrl,
    this.postPhotoUrl,
    required this.caption,
    this.likes,
    required this.timestamp
  });

  factory PostItem.fromDocument(QueryDocumentSnapshot doc){
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
      if (val) {
        count += 1;
      }
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
  var _isLiked = false;
  String? userUid;
  String? profilePicUrl;
  late String currentUserUsername;
  final postsRef = FirebaseFirestore.instance.collection('allPosts');
  final userPostsRef = FirebaseFirestore.instance.collection('posts');
  final activityFeedRef = FirebaseFirestore.instance.collection('feed');

  _PostItemState(this.getLikeCounts, this.likesData);

  getUserId() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    setState(() {
      userUid = _prefs.getString('userId');      
    });
  }

   getUserValues() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.reload();
    profilePicUrl = _prefs.getString('currentUserProfilePicUrl');
    currentUserUsername = _prefs.getString('currentUserUsername')!;     
  }

  showUserProfile() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (ctx) => ProfileScreen(currentUserId: widget.postOwneriId)));
  }

  updateLikeData() {
    postsRef.doc(widget.postId).update({
      'likes.$userUid': true
    });
    userPostsRef.doc(widget.postOwneriId).collection('userPosts').doc(widget.postId).update({
      'likes.$userUid': true
    });
  }

  updateUnlikeData(){
    postsRef.doc(widget.postId).update({
      'likes.$userUid': false
    });
    userPostsRef.doc(widget.postOwneriId).collection('userPosts').doc(widget.postId).update({
      'likes.$userUid': false
    });
  }
  

  likePost(){
    setState(() {
      _isLiked = true;
      getLikeCounts += 1;
      likesData[userUid] = true;      
    });
    updateLikeData();
    addLikeToFeed();
  }

  unlikePost(){
    setState(() {
      _isLiked = false;
      getLikeCounts -= 1;
      likesData[userUid] = false;      
    });
    updateUnlikeData();
    removeLikeToFeed();
  }

  controllLikePost(){
    bool isAlreadyLiked = likesData[userUid] == true;

    if (isAlreadyLiked){
      unlikePost();

    } else {
      likePost();

    }
  }
  addLikeToFeed() {
    bool isNotPostOwner = (userUid != widget.postOwneriId);
    if (isNotPostOwner){
    activityFeedRef.doc(widget.postOwneriId).collection('feedItems').doc(widget.postId).set({
      'type': 'like',
      'postId': widget.postId,
      'timestamp': DateTime.now(),
      'userId': userUid,
      'userProfileUrl': profilePicUrl,
      'username': currentUserUsername,
    });
    }
  }

  removeLikeToFeed(){
     bool isNotPostOwner = (userUid != widget.postOwneriId);
    if (isNotPostOwner){
      activityFeedRef.doc(widget.postOwneriId).collection('feedItems').doc(widget.postId).get()
            .then((doc) { 
            if (doc.exists) {
              doc.reference.delete();
            }
             });
    }
  }

  @override
  void initState() {
    getUserId(); 
    super.initState();  
  }

  buildContentScreen(){
    return Column(
       children: [
            SizedBox(height: 20,),
            ListTile(
              leading: 
                Padding(padding: EdgeInsets.only(left: 10),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(widget.postOwnerPhotoUrl!),
                  backgroundColor: Colors.black),
              ),
              title: GestureDetector( 
                      onTap: showUserProfile,
                      child: Text(widget.postOwnerUsername!)
                      ),
              trailing: IconButton(
                icon: Icon(Icons.linear_scale_sharp, color: Colors.black,),
                onPressed: (){
                },
              ),
            ),
            SizedBox(height: 15,),
            GestureDetector(
              onDoubleTap: controllLikePost,
              child: Container(
              height: 300,
              decoration: BoxDecoration(
                color: Colors.black,
                image: DecorationImage(
                  image: NetworkImage(widget.postPhotoUrl!),
                  fit: BoxFit.contain
                  )
              ),
            ),),
            ListTile(
              leading: IconButton(
                icon: _isLiked ? Icon(Icons.favorite_rounded, size: 30, color: Colors.redAccent,)
                      : Icon(Icons.favorite_border_outlined, size: 30, color: Colors.black,),
                onPressed: controllLikePost
                ),
              title: Row( 
                children: [ 
                  IconButton(
                    icon: Icon(Icons.messenger_outline_sharp,
                               size: 30, color: Colors.black,), 
                    onPressed: null)]),
              trailing: IconButton(
                onPressed: null,
                icon: Icon(Icons.system_update_tv_rounded, 
                  color: Colors.black , size:30),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top:10, left: 30),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text('$getLikeCounts likes', style: TextStyle(fontWeight: FontWeight.bold),),
            ),),
            Padding(
              padding: EdgeInsets.only(top: 20, left: 30),
              child: Row(
                children: [
                  InkWell(
                    onTap: showUserProfile,
                    child: Text(widget.postOwnerUsername!, style: TextStyle(fontWeight: FontWeight.bold),),
                  ),
                  SizedBox(width: 10,),
                  Expanded(
                    child: Text(widget.caption, overflow: TextOverflow.ellipsis)
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top:20, left: 30),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                    timeago.format(widget.timestamp.toDate()),
                    overflow: TextOverflow.clip,
                ),),),
          SizedBox(height: 50,),
      ],
    );
  }
  
  @override
  Widget build(BuildContext context) {
    getUserValues();
    if (likesData[userUid] == true) {
      _isLiked = true;
    }   
    
    return Column(
      children: [
        buildContentScreen(),
      ],
    );
  }
  
}