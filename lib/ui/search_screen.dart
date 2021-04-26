import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget{
  final String currentUserId;

  SearchScreen({required this.currentUserId});

  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchController = TextEditingController();
  var search = false;
  
  @override
  void initState() { 
    setState(() {
          search = false;
        });
    super.initState();
    
  }

  containerNoSearch(){
    Size mq = MediaQuery.of(context).size;
    return Row(
        children: [
        SizedBox(width: 0.08 * mq.width),
        Stack(
          children: [
            Container(
              height: 30,
              width: 0.84 * mq.width,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black
                ),
                borderRadius: BorderRadius.circular(5),
                color: Colors.white
              ),
            ),
            SizedBox(width: 0.08 * mq.width,),
            Positioned(
              left: 0.35 * mq.width,
              top: 8,
              child: Icon(Icons.search, size: 16)),
            Positioned(
              left: 0.39 * mq.width,
              top: 8,
              child: Text('Search'))
          ],
        ),
              
          ],
            );
  }

  containerWithSearch(){
    Size mq = MediaQuery.of(context).size;
    return Row(
        children: [
        SizedBox(width: 0.08 * mq.width),
            Container(
              height: 30,
              width: 0.79 * mq.width,
              child: TextField(
                cursorColor: Colors.grey,
                autofocus: true,
                controller: _searchController,
                decoration: InputDecoration(
                  prefix: Icon(Icons.search, size:17),
                  //hintText: '\nSearch',
                  //hintStyle: TextStyle(fontSize: 15),
                  //labelText: "Search",
                  //labelStyle: TextStyle(fontSize: 15),
                  border: OutlineInputBorder(),
                ),
              ),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black
                ),
                borderRadius: BorderRadius.circular(5),
                color: Colors.white
              ),
            ),
            SizedBox(
            width: 0.13 * mq.width,
            child: TextButton(
            onPressed: (){
              setState(() {
                search = false;                
              });
            }, 
            child: Text('Cancel',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold
              ),
              ),
            )),
        ],
    );
  }

  contentScreen(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        topScreen(),
        SizedBox(height: 2,),
        bodyContents(),
        SizedBox(height: 2,),
        bodyContents(),
        SizedBox(height: 2,),
        bodyContents(),
        SizedBox(height: 2,),
        bodyContents(),
        SizedBox(height: 2,),
        bodyContents(),
        SizedBox(height: 2,),
        bodyContents()
      ],
    );
  }

  topScreen(){
    Size mq = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
          width: 0.330 * mq.width,
          height: 160,
          decoration: BoxDecoration(
            color: Colors.black
          ),
        ),
        SizedBox(height: 2),
         Container(
          width: 0.330 * mq.width,
          height: 160,
          decoration: BoxDecoration(
            color: Colors.black
          ),
        ),
        ],
      ),
      SizedBox(width: 2,),
        Container(
          width: 0.6658999999 * mq.width,
          height: 322,
          decoration: BoxDecoration(
            color: Colors.black
          ),
        ),
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
            color: Colors.black
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
  noContentScreen(){
    Size mq = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.only(top:20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 0.08 * mq.width),
            child: Text("Recent", 
            style: TextStyle(fontWeight: FontWeight.bold),),),
          Padding(
            padding: EdgeInsets.only(right: 0.08 * mq.width),
            child: Text("Clear All", 
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold),),),
      ],)
    );
  }

  @override
  Widget build(BuildContext context){
    //Size mq = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            SizedBox(height: 20,),
            GestureDetector(
              child: search ? containerWithSearch() : containerNoSearch(),
              onTap: (){
                setState(() {
                  search = true;
                  });
              },
            ),
            SizedBox(height: 10,),
            Divider(thickness: 0.2, color: Colors.black,),
            search ? noContentScreen() : contentScreen(),
            
          ],
        ),
        ),
    );
  }
}