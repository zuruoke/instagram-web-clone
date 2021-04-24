import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/post.dart';

class PostTile extends StatelessWidget{

  final PostItem post;

  PostTile({required this.post});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => 
        PostItem(
            postId: post.postId,
            postOwneriId: post.postOwneriId,
            postOwnerPhotoUrl: post.postOwnerPhotoUrl,
            postOwnerUsername: post.postOwnerUsername,
            postPhotoUrl: post.postPhotoUrl,
            caption: post.caption,
            likes: post.likes,
            timestamp: post.timestamp,
        )));
      },
      child: Image.network(post.postPhotoUrl!),
    );
  }
}