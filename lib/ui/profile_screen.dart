import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/post.dart';
import 'package:instagram_clone/models/post_tile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget{
  final String currentUserId;

  ProfileScreen({required this.currentUserId});
  

  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String selected = 'grid';
  late String userId;
  String? profilePicUrl;
  late String currentUserUsername;
  late String postOwnerUsername;
  late String postOwnerPhotoUrl;
  var isFollowing = false;
  var followingCount = 0;
  var followersCount = 0;
  List<PostItem> allPosts = [];
  final CollectionReference postsRef = FirebaseFirestore.instance.collection('posts');
  final CollectionReference userRef = FirebaseFirestore.instance.collection('users');
  final followersRef = FirebaseFirestore.instance.collection('followers');
  final followingRef = FirebaseFirestore.instance.collection('following');

  getUserId() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    setState(() {
      userId =  _prefs.getString('userId')!;
      checkIsFollowing(userId);      
    });  
  }

  getPostOwnerData() async{
    DocumentSnapshot snapshot = await userRef.doc(widget.currentUserId).get();
    setState(() {
      postOwnerPhotoUrl = snapshot.data()!['photo'];
      postOwnerUsername = snapshot.data()!['username'];      
    });
    
  }


  getAllPosts() async {
    QuerySnapshot snapshot = await postsRef.doc(widget.currentUserId).collection('userPosts').orderBy('timestamp', descending: true).get();
    setState(() {
      allPosts =
          snapshot.docs.map((QueryDocumentSnapshot doc) => PostItem.fromDocument(doc)).toList();
    });
  }

   getUserValues() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.reload();
    profilePicUrl = _prefs.getString('currentUserProfilePicUrl');
    currentUserUsername = _prefs.getString('currentUserUsername')!;     
  }

  getFollowersCount() async {
    QuerySnapshot snapshot = await followersRef.doc(widget.currentUserId).collection('userFollowers').get();
    setState(() {
      followersCount = snapshot.docs.length;      
    });
  }

  getFollowingCount() async {
    QuerySnapshot snapshot = await followingRef.doc(widget.currentUserId).collection('userFollowing').get();
    setState(() {
      followingCount = snapshot.docs.length;      
    });
  }

  handleFollow(){
    setState(() {
      isFollowing = true;
      followersCount += 1;     
    });

    followersRef.doc(widget.currentUserId).collection('userFollowers').doc(userId).set({});
    followingRef.doc(userId).collection('userFollowing').doc(widget.currentUserId).set({});
  }


  handleUnfollow(){
    setState(() {
      isFollowing = false;
      followersCount -= 1;
        
    });
    followersRef.doc(widget.currentUserId)
                .collection('userFollowers')
                .doc(userId).get()
                .then((doc) {
                  if(doc.exists){
                    doc.reference.delete();
                  }
                });

    followingRef.doc(userId)
                .collection('userFollowing')
                .doc(widget.currentUserId).get()
                .then((doc) {
                  if (doc.exists){
                    doc.reference.delete();
                  }
                });
  }

  checkIsFollowing(String userUid) async {
    DocumentSnapshot doc = await followersRef.doc(widget.currentUserId).collection('userFollowers').doc(userUid).get();
    setState(() {
      isFollowing = doc.exists;      
    });
  }

  @override
  void initState() { 
    getUserId();
    getAllPosts();
    //getPostOwnerData();
    getFollowersCount();
    getFollowingCount();
    super.initState();
    
  }


  _buildAppBar(){
    bool isCurrentUser = (userId == widget.currentUserId);
    return AppBar(
      leading: isCurrentUser ? IconButton(
        onPressed: null,
        icon: Icon(Icons.adjust_rounded, size: 35, color: Colors.black,
      ),
        ) : IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(Icons.arrow_back_ios_rounded, size: 35, color: Colors.black,
        ),
      ),
      title: Text(postOwnerUsername,style: TextStyle(fontWeight: FontWeight.bold),),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(Icons.person_add_outlined, size: 35, color: Colors.black,), 
        onPressed: null
        ),
        SizedBox(width: 20,)
      ],
      elevation: 1.4,
    );
  }


  topScreen(){
    bool isCurrentUser = (userId == widget.currentUserId);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(width: 25,),
        Container(
          height: 100, width: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black,
            image: DecorationImage(
              image: NetworkImage(postOwnerPhotoUrl)
            )
          ),
        ),
        SizedBox(width: 50,),
        Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
          children: [
            Text(postOwnerUsername, style: TextStyle(fontSize: 30),),
          SizedBox(height: 10,),
          Container(
            width: 280, height: 30,
            child: TextButton(
            style: TextButton.styleFrom(
              elevation: 1.6,
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    side: BorderSide(color: Colors.grey)
            ),),
            onPressed: isCurrentUser ? null : isFollowing ? handleUnfollow : handleFollow,
            child: isCurrentUser ? Text('Edit Profile', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),) :
                   isFollowing ? Text('Unfollow', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),) :
                   Text('Follow', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),)
          ),
            )
          ],
        )
      ],
        ),
      SizedBox(height: 30,),
      Padding(
        padding: EdgeInsets.only(left: 30),
        child: Text(postOwnerUsername.toUpperCase(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),)),
      SizedBox(height: 10,),
      Padding(
        padding: EdgeInsets.only(left: 30),
      child: Text('Entrepreneur', style: TextStyle(color: Colors.grey, fontSize: 16),),),
      SizedBox(height: 5,),
      Padding(
        padding: EdgeInsets.only(left: 30),
      child: Text("- Engineer\n\- Entrepreneur\n- Content Creator\n- Product Designer\n- Knowledge Seeker\n- I know my son gonna be here, so I'mma make this life \nlegendary", 
            style: TextStyle( fontSize: 17),),),
      SizedBox(height: 20,),
      Divider(thickness: 0.24, color: Colors.black,),
      SizedBox(height: 10,),
      Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text('${allPosts.length}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
        Text('$followersCount', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
        Text('$followingCount', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),)
      ],
    ),
    Padding(padding: EdgeInsets.only(top:5)),
      Row(
         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text('    posts'), 
        Text(' followers'),
        Text('following')
      ]
      ),
      SizedBox(height: 10,),
      Divider(thickness: 0.24, color: Colors.black,),
      SizedBox(height: 2,),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
          icon: Icon(Icons.grid_on_sharp, size: 30, color: selected == 'grid' ? Colors.blue : null), 
          onPressed: (){
            setState(() { 
              selected = 'grid';
             });
          }
          ),
          IconButton(
          icon: Icon(Icons.crop_square_sharp, size: 30, color: selected == 'list' ? Colors.blue : null,), 
          onPressed: (){
            setState(() { 
              selected = 'list';
             });
          }
          ),
          IconButton(
          icon: Icon(Icons.shopping_bag_rounded, size: 30, color: selected == 'save' ? Colors.blue : null,), 
          onPressed: (){
            setState(() {
              selected = 'save'; 
            });
          }
          ),
          IconButton(
          icon: Icon(Icons.portrait_outlined, size: 30, color: selected == 'photosOfYou' ? Colors.blue : null,), 
          onPressed: (){
            setState(() {
              selected = 'photosOfYou';  
            });
          }
          ),
        ],
      ),
      //Divider(thickness: 0.24, color: Colors.black,),
      SizedBox(height: 12,),
      selected == 'grid' ? gridStyle() : 
      selected == 'list' ? listStyle() : 
      selected == 'save' ? saveLayout() :
      selected == 'photosOfYou' ? photosOfYouLayout() :
      Container()
      ],
    );
  }

  buildGridTile(){
    List<GridTile> gridTiles = [];
    allPosts.forEach((posts) { 
      gridTiles.add(
        GridTile(
          child: PostTile(post: posts)
        ));
    });
    return GridView.count(
      crossAxisCount: 3,
      childAspectRatio: 1.0,
      mainAxisSpacing: 1.5,
      crossAxisSpacing: 1.5,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: gridTiles,
      );
  }

  photosOfYouLayout(){
    return Container();
  }

  saveLayout(){
    return Container();
  }

  listStyle(){
    return Column( 
      children: [
      Divider(thickness: 0.24, color: Colors.black,),
      Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: 
        allPosts,
    ),
      ],
    );

  }

  gridStyle(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        bodyContents(),
        SizedBox(height: 2,),
        bodyContents(),
        SizedBox(height: 2,),
        bodyContents(),
        SizedBox(height: 2,),
        bodyContents(),
        SizedBox(height: 2,),
      ],
    );
  }

  bodyContents(){
    Size mq = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
           width: 0.330 * mq.width,
          height: 160,
          decoration: BoxDecoration(
            color: Colors.black,
          ),
        ),
        SizedBox(width: 2,),
         Container(
           width: 0.330 * mq.width,
          height: 160,
          decoration: BoxDecoration(
            color: Colors.black
          ),
        ),
         SizedBox(width: 2,),
         Container(
           width: 0.332 * mq.width,
          height: 160,
          decoration: BoxDecoration(
            color: Colors.black
          ),
        ),
      ],
    );
  }

  listContentScreen(String text ){
    return Column(
       children: [
            ListTile(
              leading: 
                Padding(padding: EdgeInsets.only(left: 10),
                child: CircleAvatar(backgroundColor: Colors.black),
              ),
              title: Text(text),
              trailing: IconButton(
                icon: Icon(Icons.linear_scale_sharp, color: Colors.black,),
                onPressed: (){},
              ),
            ),
            SizedBox(height: 15,),
            Container(
              height: 300,
              decoration: BoxDecoration(
                color: Colors.black
              ),
            ),
            //SizedBox(height: 5,),
            ListTile(
              leading: IconButton(
                icon: Icon(Icons.favorite_border_outlined, 
                          size: 30, color: Colors.black,), 
                onPressed: null),
              title: Row( children: [ 
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
      ],
    );
  }

  @override
  Widget build(BuildContext context){
    getUserValues();
    getPostOwnerData();

    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30,),
            topScreen(),
          ],
        ),
        ),
    );
  }
}