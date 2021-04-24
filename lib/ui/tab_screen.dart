import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/state/auth_state.dart';
import 'package:instagram_clone/ui/activity_screen.dart';
import 'package:instagram_clone/ui/add_screen.dart';
import 'package:instagram_clone/ui/home_screen.dart';
import 'package:instagram_clone/ui/profile_screen.dart';
import 'package:instagram_clone/ui/search_screen.dart';
import 'package:instagram_clone/utils/bottom_sheet.dart';
import 'package:provider/provider.dart';

class TabScreen extends StatefulWidget{

  _TabScreenState createState() => _TabScreenState();
}



class _TabScreenState extends State<TabScreen>{
  late final String _uid;
  PageController? _pageController;
  int pageIndex = 0;
  var _selected = 0;

  whenPageChanges(int index){
    setState(() {
          this.pageIndex = index;
        });
  }

  onTapChange(int pageIndex){
     _pageController!.animateToPage(pageIndex, duration: const Duration(microseconds: 400 ), curve: Curves.ease);
      setState(() {
              _selected = pageIndex;
            });
  }

  @override
  void initState() { 
    var state = Provider.of<AuthState>(context, listen: false);
    _pageController = PageController();
    state.getUserUid();
    setState(() {
      _uid = state.userUid;      
    });
    super.initState();
  }

  @override
    void dispose() {
       _pageController?.dispose();
      super.dispose();
    }


  @override
  Widget build(BuildContext context){
    Size mq = MediaQuery.of(context).size;
    return Scaffold(
      body: PageView(
        children: [
          HomeScreen(currentUserId: _uid),
          SearchScreen(currentUserId: _uid),
          AddScreen(),
          ActivityScreen(currentUserId: _uid),
          ProfileScreen(currentUserId: _uid),
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
          BottomNavigationBarItem(icon: IconButton(
            onPressed: (){
              buildModalSheet(context, mq);
            },
            padding: EdgeInsets.all(1),
            icon: Icon(Icons.add_box_outlined, size: 40, color: _selected == 2 ? Colors.black : null))),
          BottomNavigationBarItem(icon: _selected == 3 ? Icon(Icons.favorite_sharp, size:35, color: Colors.black,) : Icon(Icons.favorite_border_sharp,size:35)),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle_sharp, size: 35, color: _selected == 4 ? Colors.black : null)),
          
        ],
      ),
      
    );
  }
}