import 'package:flu3/Sql/Userad.dart';
import 'package:flu3/pages/scretlist_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class SecretPage extends StatefulWidget{
  @override
  _SecretPageState createState() =>_SecretPageState();
}
class _SecretPageState extends State<SecretPage>{

  String username="";
  String password="";
  MimaSqlite userSqlite = new MimaSqlite();
  final _formKey = GlobalKey<FormState>();
  String _email, _password;
  bool _isObscure = true;
  Color _eyeColor;
  @override

  void initState() {
    super.initState();
    insertData();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final PageController _controller =PageController(
      initialPage: 0,
    );
    return Scaffold(
      appBar: new AppBar(
        title: new Text('我的秘密'),
        leading: new Icon(Icons.account_circle),
        backgroundColor: Colors.black54,
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 22.0),
          children: <Widget>[
            SizedBox(
              height: kToolbarHeight,
            ),
            buildTitle(),
            buildTitleLine(),
            SizedBox(height: 70.0),
            buildEmailTextField(),
            SizedBox(height: 30.0),
            buildPasswordTextField(context),
            SizedBox(height: 60.0),
            buildLoginButton(context),
            SizedBox(height: 30.0),
          ],
        ),
      ),
    );
  }
  Align buildLoginButton(BuildContext context) {
    return Align(
      child: SizedBox(
        height: 45.0,
        width: 270.0,
        child: RaisedButton(
          child: Text(
            '登录',
            style: Theme.of(context).primaryTextTheme.headline,
          ),
          color: Colors.black,
          onPressed: () {
            insertData ();
            if (_formKey.currentState.validate()) {
              ///只有输入的内容符合要求通过才会到达此处
              _formKey.currentState.save();
              //TODO 执行登录方法
              if(_email==username && _password==password){
                Navigator.push(
                  context,
                  new MaterialPageRoute(builder: (context) => new secretScreen()),
                );
              }else{
                showDialog<Null>(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return new AlertDialog(
                      content: new SingleChildScrollView(
                        child: new ListBody(
                          children: <Widget>[
                            new Text('用户名或密码错误'),
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        new FlatButton(
                          child: new Text('确定'),
                          onPressed: () {
                            print("123");
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                ).then((val) {
                  print(val);
                });
              }
            }
          },
          shape: StadiumBorder(side: BorderSide()),
        ),
      ),
    );
  }


  TextFormField buildPasswordTextField(BuildContext context) {
    return TextFormField(
      onSaved: (String value) => _password = value,
      obscureText: _isObscure,
      validator: (String value) {
        if (value.isEmpty) {
          return '请输入密码';
        }
      },
      decoration: InputDecoration(
          labelText: '密码',
          suffixIcon: IconButton(
              icon: Icon(
                Icons.remove_red_eye,
                color: _eyeColor,
              ),
              onPressed: () {
                setState(() {
                  _isObscure = !_isObscure;
                  _eyeColor = _isObscure
                      ? Colors.grey
                      : Theme.of(context).iconTheme.color;
                });
              })),
    );
  }

  TextFormField buildEmailTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: '用户名',
      ),
      onSaved: (String value) => _email = value,
    );
  }

  Padding buildTitleLine() {
    return Padding(
      padding: EdgeInsets.only(left: 12.0, top: 4.0),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          color: Colors.black,
          width: 40.0,
          height: 2.0,
        ),
      ),
    );
  }

  Padding buildTitle() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        '欢迎使用',
        style: TextStyle(fontSize: 42.0),
      ),
    );
  }
  AlertDialog _alertDialog(){
    return AlertDialog(
      content: new SingleChildScrollView(
        child: new ListBody(
          children: <Widget>[
            new Text('用户名或密码错误'),
          ],
        ),
      ),
      actions: <Widget>[
        new FlatButton(
          child: new Text('确定'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }


  //数据量操作
  //添加
  void insertData () async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    username= await prefs.getString("username");
    password= await prefs.getString("password");
  }
}