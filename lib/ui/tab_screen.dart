import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/ui/activity_screen.dart';
import 'package:instagram_clone/ui/add_screen.dart';
import 'package:instagram_clone/ui/home_screen.dart';
import 'package:instagram_clone/ui/profile_screen.dart';
import 'package:instagram_clone/ui/search_screen.dart';

class TabScreen extends StatefulWidget{

  _TabScreenState createState() => _TabScreenState();
}



class _TabScreenState extends State<TabScreen>{

  PageController _pageController;
  int pageIndex = 0;
  var _selected = 0;

  whenPageChanges(int index){
    setState(() {
          this.pageIndex = index;
        });
  }

  onTapChange(int pageIndex){
     _pageController.animateToPage(pageIndex, duration: const Duration(microseconds: 400 ), curve: Curves.ease);
      setState(() {
              _selected = pageIndex;
            });
  }

  @override
  void initState() { 
    _pageController = PageController();
    super.initState();
  }

  @override
    void dispose() {
       _pageController?.dispose();
      super.dispose();
    }

    _buildModalSheet(context){
      showModalBottomSheet(
            context: context,
            builder: (builder){
              return new Container(
                height: 350.0,
                color: Colors.transparent, //could change this to Color(0xFF737373), 
                           //so you don't have to change MaterialApp canvasColor
                child: new Container(
                    decoration: new BoxDecoration(
                        color: Colors.white,
                        borderRadius: new BorderRadius.only(
                            topLeft: const Radius.circular(10.0),
                            topRight: const Radius.circular(10.0))),
                    child: new Center(
                      child: new Text("This is a modal sheet"),
                    )),
              );
            }
        );
    }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: PageView(
        children: [
          HomeScreen(),
          SearchScreen(),
          AddScreen(),
          ActivityScreen(),
          ProfileScreen(),
        ],
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        onPageChanged: whenPageChanges,
      ),

      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: Colors.white,
        onTap: onTapChange,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled, size: 35, color: _selected == 0 ? Colors.black : Colors.grey)),
          BottomNavigationBarItem(icon: Icon(Icons.search_sharp, size: 35, color: _selected == 1 ? Colors.black : null)),
          BottomNavigationBarItem(
            icon: IconButton(
                  onPressed: null,
                  icon: Icon(Icons.add_box_outlined, size: 40, color: _selected == 2 ? Colors.black : null))),
          BottomNavigationBarItem(icon: _selected == 3 ? Icon(Icons.favorite_sharp, size:35, color: Colors.black,) : Icon(Icons.favorite_border_sharp,size:35)),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle_sharp, size: 35, color: _selected == 4 ? Colors.black : null)),
          
        ],
      ),
      
    );
  }
}