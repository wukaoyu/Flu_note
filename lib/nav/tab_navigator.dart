import 'package:flu3/pages/alllist_page.dart';
import 'package:flu3/pages/secret_page.dart';
import 'package:flutter/material.dart';
class TabNavigator extends StatefulWidget {
  @override
  _TabNavigatorState createState() => _TabNavigatorState();
}

class _TabNavigatorState extends State<TabNavigator> {
  final _defaultColor = Colors.grey;
  final _activeColor = Colors.blue;
  int _currentIndex = 0;
  final PageController _controller = PageController(
    initialPage: 0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        onPageChanged: (index){
          setState(() {
            if (_currentIndex != index) {
              _currentIndex = index;
            }
          });
        },
        children: <Widget>[
          AllListPage(),
          SecretPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            _controller.animateToPage(
                index,
                duration:  const Duration(milliseconds: 300),
                curve: Curves.ease
            );
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home, color: _defaultColor),
                activeIcon: Icon(Icons.home, color: Colors.deepOrangeAccent),
                title: Text(
                  '便签',
                  style: TextStyle(
                      color: _currentIndex != 0 ? _defaultColor : _activeColor),
                )),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_circle, color: _defaultColor),
                activeIcon: Icon(Icons.account_circle, color: Colors.black54),
                title: Text(
                  '我的',
                  style: TextStyle(
                      color: _currentIndex != 1 ? _defaultColor : _activeColor),
                )),
          ]),
    );
  }
}
TextFormField buildEmailTextField() {
  return TextFormField(
    decoration: InputDecoration(
      labelText: '请输入标题111',
    ),
  );
}
