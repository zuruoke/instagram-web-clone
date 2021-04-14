import 'package:flutter/material.dart';
import 'package:instagram_clone/state/app_state.dart';
import 'package:instagram_clone/state/auth_state.dart';
import 'package:instagram_clone/ui/tab_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(InstagramCloneApp());
}

class InstagramCloneApp extends StatefulWidget{
  _InstagramCloneAppState createState() => _InstagramCloneAppState();
}

class _InstagramCloneAppState extends State<InstagramCloneApp> {

  @override
  Widget build(BuildContext context){
    return MultiProvider(
    providers: [
      ChangeNotifierProvider<AppState>(create: (_) => AppState()),
      ChangeNotifierProvider<AuthState>(create: (_) => AuthState()),
    ],

    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: TabScreen(),
    ));
  } 

}

