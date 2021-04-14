import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppState extends ChangeNotifier{
  bool _isLoading;
  bool get isLoading => _isLoading;
  set loading(bool value){
    _isLoading = value;
    notifyListeners();
  }
   }