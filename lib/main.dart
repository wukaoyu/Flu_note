
import 'package:flu3/nav/tab_navigator.dart';
import 'package:flutter/material.dart';
void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: '我的笔记',
      home: TabNavigator(),
    );
  }


}