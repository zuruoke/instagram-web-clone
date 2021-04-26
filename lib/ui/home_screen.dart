import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/post.dart';
import 'package:instagram_clone/state/auth_state.dart';
import 'package:instagram_clone/ui/auth_ui/login_screen.dart';
import 'package:instagram_clone/utils/bottom_sheet.dart';
import 'package:instagram_clone/utils/enum.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget{

  final String currentUserId;
  

  HomeScreen({required this.currentUserId});

  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final String userUid;
  late List<PostItem> post;
  final CollectionReference ref = FirebaseFirestore.instance.collection('allPosts');

  getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userUid = prefs.getString('userId')!;
    });
  }

  @override
  void initState() { 
    getUserId();
    getTimeline();
    super.initState();
    
  }

  stories(){
    Size mq = MediaQuery.of(context).size;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(padding: EdgeInsets.only(left: 20)),
          profileContainer(),
          SizedBox(width: 0.07 * mq.width),
          storiesContainer("zekyume"),
          SizedBox(width: 0.045 * mq.width,),
          storiesContainer("davido"),
          SizedBox(width: 0.045 * mq.width,),
          storiesContainer("madiba"),
          SizedBox(width: 0.045 * mq.width,),
          storiesContainer("thugger1"),
          SizedBox(width: 0.045 * mq.width,),
          storiesContainer("lil wayne"),
          SizedBox(width: 0.045 * mq.width,),
          storiesContainer("son heung min"),
          SizedBox(width: 0.045 * mq.width,),
          storiesContainer("sergio"),
          SizedBox(width: 0.045 * mq.width,),
          storiesContainer("bastein"),
          SizedBox(width: 0.045 * mq.width,),
          storiesContainer("arlias penta"),
          SizedBox(width: 0.045 * mq.width,),
          storiesContainer("labryinth"),
        ],
      ),
    );
  }

  profileContainer(){
    Size mq = MediaQuery.of(context).size;
    return Column(
      children: [
        GestureDetector(
          onTap: () {
             buildModalSheet(context, mq, where: 'stories');
          },
          child: Stack(
      children: [
        Container(
          width: 80, height: 80,
          decoration: BoxDecoration(
            color: Colors.grey,
            shape: BoxShape.circle
          ),
        ),
        Positioned(
          //bottom: 0.10, right: 0.8,
          bottom: 0, right: 0,
          child: Icon(Icons.add_circle, color: Colors.blue, size: 28,
          )
          ),
        // Positioned.fill(
        //   child: Align(
        //   alignment: Alignment.bottomRight,
        //   child: Icon(Icons.add_circle, color: Colors.blue,
        //   )),
        // ),
      ],
    ),),
    SizedBox(height: 15,),
    Text("Your Story")
      ],
    );
  }

  storiesContainer(String text){
    return Column(
      children: [
        Container(
          width: 80, height: 80,
          decoration: BoxDecoration(
            color: Colors.grey,
            shape: BoxShape.circle,
            border: Border.all(
              width: 2,
              color: Colors.deepOrange
            )
          ),
    ),
    SizedBox(height: 15,),
    Text(text)
      ],
    );
  }

  getTimeline() async {
    QuerySnapshot snapshot = 
    await FirebaseFirestore.instance
        .collection('allPosts')
        .orderBy('timestamp', descending: true)
        .get();

    List<PostItem> post =
        snapshot.docs.map((doc) => PostItem.fromDocument(doc)).toList();
    setState(() {
      this.post = post;
    });
  }

  getPosts (){
    return StreamBuilder(
      stream: ref.orderBy('timestamp', descending: true).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
        if (snapshot.hasData){
          List<PostItem> posts = [];
          snapshot.data!.docs.forEach((QueryDocumentSnapshot doc){
            posts.add(PostItem.fromDocument(doc));
          });
          return Column(
            children: posts,
          );
        }
        return Center(
          child: Text("")
        );
      }
      );
  }

  logOut() async{
    var state = Provider.of<AuthState>(context, listen: false);
    await state.signOutWithEmailAndPassword();
    if (state.authStatus == AuthStatus.Not_Logged_In){
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (ctx) => LoginScreen()));
    }
     }
  

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        leading:
        Padding(
          padding: EdgeInsets.only(left: 10),
          child: IconButton(
            icon: Icon(Icons.camera_alt_outlined, color: Colors.black, size: 35,),
            onPressed: (){}
        )),
        title: Text('Instagram', 
            style:
              TextStyle(
                fontSize: 35, fontStyle: FontStyle.italic, color: Colors.black
              )),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: IconButton(icon: Icon(Icons.send_outlined, size: 35, color: Colors.black,),
          onPressed: logOut
          )),
        ],
    ),
    body: Scrollbar(
      child: SingleChildScrollView(
      scrollDirection: Axis.vertical,
        child: Column(
          children: [
            SizedBox(height: 20,),
            stories(),
            SizedBox(height: 20,),
            Divider(height: 0.0,),
            getPosts(),
          ],
        ),),
    ));
  }
}