import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/ui/tab_screen.dart';
import 'package:instagram_clone/utils/create_post.dart';
import 'package:instagram_clone/utils/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

// ignore: must_be_immutable
class PostScreen extends StatefulWidget{
  PickedFile pickedImage;
  String where;

  PostScreen({this.pickedImage, this.where});
  
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  String userUid;
  String profilePicUrl;
  String currentUserUsername;
  String postId = Uuid().v4();
  TextEditingController captionController = TextEditingController();
  final String _url = "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcT_ebls-UUShLJTBsclAHFxv2QYxDJIQdre45gDkFn5FEkC7JvI&usqp=CAU";

  @override
  void initState() { 
    getUserValues();
    super.initState();
    
  }

  getUserValues() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    setState(() {
      userUid = _prefs.getString('userId');
      profilePicUrl = _prefs.getString('currentUserProfilePicUrl') ?? "";
      currentUserUsername = _prefs.getString('currentUserUsername');      
    });
  }
  
  @override
  void dispose() { 
    captionController?.dispose();
    super.dispose();
  }


    handleUploadStories() async {
    String imageUrl = '';
    if (captionController.text.length > 0){
      try {
        imageUrl = await uploadImageToFirebaseStorage(id: postId, img: widget.pickedImage, folder: 'Stories');
        createPostInFirestore(
            uid: userUid, caption: captionController.text, 
            username: currentUserUsername, postPhotourl: imageUrl, 
            userProfilePicUrl: profilePicUrl, postId: postId, collectionName: "stories"
        );
        createPostInFirestoreForAll(
            uid: userUid, caption: captionController.text, 
            username: currentUserUsername, postPhotourl: imageUrl, 
            userProfilePicUrl: profilePicUrl, postId: postId, collectionName: "allStories"
        );
      } catch (error){
        print(error.toString());
      }
      setState(() {
        captionController.clear();
        widget.pickedImage = null;
        postId = Uuid().v4();        
      });
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => TabScreen(),));

    }

  }

    handleUploadPost() async {
    String imageUrl = '';
    if (captionController.text.length > 0){
      try {
        imageUrl = await uploadImageToFirebaseStorage(id: postId, img: widget.pickedImage, folder: 'Posts');
        createPostInFirestore(
            uid: userUid, caption: captionController.text, 
            username: currentUserUsername, postPhotourl: imageUrl, 
            userProfilePicUrl: profilePicUrl, postId: postId, collectionName: "posts"
        );
        createPostInFirestoreForAll(
            uid: userUid, caption: captionController.text, 
            username: currentUserUsername, postPhotourl: imageUrl, 
            userProfilePicUrl: profilePicUrl, postId: postId, collectionName: "allPosts"
        );
      } catch (error){
        print(error.toString());
      }
      setState(() {
        captionController.clear();
        widget.pickedImage = null;
        postId = Uuid().v4();        
      });
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => TabScreen(),));

    }

  }

  showAlertBox() {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              backgroundColor: const Color.fromRGBO(35, 35, 35, 1),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              title: Text(
                'Write a Caption$currentUserUsername',
                style: const TextStyle(color: Colors.white),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text(
                    'Okay',
                    style: const TextStyle(
                        color: Color(0xFF41E24E),
                        fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
  }

  textField(){
    return TextField(
          cursorColor: Colors.black,
          style: const TextStyle(color: Colors.black),
          decoration: const InputDecoration(
            hintText: 'Write a caption...',
            hintStyle: const TextStyle(color: Colors.grey),
            enabledBorder: const OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white54, width: 0),
              borderRadius: const BorderRadius.all(
                Radius.zero
              ),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white54, width: 0),
              borderRadius: const BorderRadius.all(
               Radius.zero
              ),
            ),
          ),
          maxLines: 11,
          controller: captionController,
        );
  }

  insertContent(){
    Size mq = MediaQuery.of(context).size;
    return Container(
      color: Colors.white,
      height: 0.12 * mq.height,
      child: ListTile(
        leading: Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: CircleAvatar(
          backgroundImage: profilePicUrl != null ? NetworkImage(profilePicUrl) : NetworkImage(_url),
          radius: 20,
        )),
        title: textField(),
        trailing: Container(
          height: 60, width: 60,
          decoration: BoxDecoration(
            color: Colors.black,
          ),
          child: Image.network(
              widget.pickedImage.path,
              fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  addOns(String text){
    Size mq = MediaQuery.of(context).size;
    return Container(
      color: Colors.white,
      height: 0.07 * mq.height,
      child: ListTile(
              leading: Text(text, style: TextStyle(fontWeight: FontWeight.bold),),
              trailing: Icon(Icons.arrow_forward_ios_outlined, color: Colors.black,),
            ),);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_outlined, color: Colors.black,),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        title: Text("New Post", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 1.0,
        actions: [
          TextButton(
            onPressed: widget.where == null ? handleUploadPost : handleUploadStories,
            style: TextButton.styleFrom(
           backgroundColor: Colors.white,), 
            child: Text("Share", style: TextStyle(color: Colors.blue),)
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            insertContent(),
            Divider(color: Colors.black, thickness: 0.2,),
            SizedBox(height: 15,),
            Divider(color: Colors.black, thickness: 0.2,),
            addOns('Add Location'),
            Divider(color: Colors.black, thickness: 0.2,),
            SizedBox(height: 15,),
            Divider(color: Colors.black, thickness: 0.2,),
            addOns('Tag People'),
            Divider(color: Colors.black, thickness: 0.2,),
          ],
        ),
      ),
    );
  }
}