import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/ui/upload_screen.dart';

final picker = ImagePicker();

  pickImageFromGallery(BuildContext context, {String? where}) async {
    //Navigator.of(context).pop();
    final PickedFile imageFile = (await picker.getImage(source: ImageSource.gallery))!;
    // if (imageFile != null){
    //   return UploadScreen(pickedFile: imageFile,);
    // }
    Navigator.push(context, MaterialPageRoute(builder: (context) => UploadScreen(pickedFile: imageFile, where: where)));
  }

takeImageFromCamera(BuildContext context, {String? where}) async {
  //Navigator.of(context).pop();
  final PickedFile imageFile = (await picker.getImage(source: ImageSource.camera))!;
  //return UploadScreen(pickedFile: imageFile,);
   Navigator.push(context, MaterialPageRoute(builder: (context) => UploadScreen(pickedFile: imageFile, where: where)));
}

buildModalSheet(BuildContext context, Size mq, {String? where}){
      showModalBottomSheet(
          context: context,
          backgroundColor: const Color.fromRGBO(255, 255, 255 , 1),
          shape: RoundedRectangleBorder( 
            borderRadius: const BorderRadius.all(
            Radius.circular(20),),),
          builder: (context) => buildBottomModalSheet(context, mq.height * 0.25, where: where));
    }

    buildBottomModalSheet(BuildContext context, double height, {String? where}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      height: height,
      child: Column(
      children: <Widget>[
         GestureDetector(
           onTap: (){
             takeImageFromCamera(context, where: where);
           },
           child: ListTile(
            leading: Text('Take Photo'),
            trailing: const Icon(
                  Icons.camera_alt,
                  color: Colors.blue,
                  size: 30,
                ),
              ),
          ),
          Divider(),
          GestureDetector(
            onTap: (){
              pickImageFromGallery(context, where: where);
            },
            child: ListTile( 
            leading: Text("Photo Library"),
            trailing: const Icon(
                  Icons.filter_none_outlined,
                  color: Colors.blue,
                  size: 30,
                ),
              ),
          ),
          Divider(),
           GestureDetector(
             onTap: (){},
             child: ListTile(
            leading: Text('Browse'),
            trailing: const Icon(
                Icons.linear_scale_sharp, color: Colors.blue, size: 30,),
            ),),
        ],
          ),);
  }