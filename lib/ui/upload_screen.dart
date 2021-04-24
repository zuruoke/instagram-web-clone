import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/ui/post_screen.dart';
import 'package:instagram_clone/ui/tab_screen.dart';


class UploadScreen extends StatefulWidget{

  final PickedFile pickedFile;
  final String? where;

  UploadScreen({required this.pickedFile, this.where});


  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {

  @override
  void initState() { 
    super.initState();
    
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies(); 
  // }

  @override
  Widget build(BuildContext context) {
    Size mq = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 1.0,
        leading: IconButton(
          icon: Icon(Icons.cancel_outlined, color: Colors.black,), 
          onPressed: (){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => TabScreen()));
          }
          ),
        title: Text('New Photo Post', style: TextStyle(fontWeight: FontWeight.bold),),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => PostScreen(pickedImage: widget.pickedFile, where: widget.where)));
            },
            style: TextButton.styleFrom(
           backgroundColor: Colors.white,), 
            child: Text("Next", style: TextStyle(color: Colors.blue),)
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: 0.8 * mq.height,
              child: Image.network(
                widget.pickedFile.path,
                fit: BoxFit.contain
            ),
            ), 
          ],),
      )
    );  
  }
  
}