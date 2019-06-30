import 'package:flu3/Sql/Notepad.dart';
import 'package:flutter/material.dart';
import 'package:flu3/Sql/date_format_base.dart';
class SecondScreen extends StatefulWidget{
  @override
  _SecretPageState createState() =>_SecretPageState();
}
class _SecretPageState extends State<SecondScreen>{
  int maxline;
  final title = TextEditingController();
  final content = TextEditingController();
  NoteSqlite noteSqlite = new NoteSqlite();

  final _textKey = GlobalKey< FormFieldState >();



  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: new AppBar(
        title: new Text('添加便签'),
        backgroundColor: Colors.deepOrangeAccent,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.save),
              tooltip: "save",
              onPressed: () {
                insertNote(title.text,content.text);
                Navigator.pop(context);
              },
            ),
          ]
      ),
      body:ListView(
        children: <Widget>[
          titleTextField(),
          contentTextField()
        ],
      )

    );
  }
  TextFormField titleTextField() {
    return TextFormField(
      key: _textKey,
      controller: title,
      //onSaved: (String value) => _password = value,
      decoration: InputDecoration(
        labelText: '请输入标题：',
      ),
    );
  }
  TextField contentTextField(){
    return TextField(
        controller: content,
        maxLength: 500,
        maxLines: 20,
        //textAlign: TextAlign.center,
        style: new TextStyle(fontSize: 16),
        decoration: InputDecoration( border:InputBorder.none,  hintText: "输入文字",  counterText: "",),
        onChanged: (value){
          int len=value.toString().length;
          print(len);
          if(len>11){
            setState(() {
              maxline=3;
            });
          }else{
            maxline=1;
          }
        },
    );
  }

  void insertNote(String title,String content) async{
    DateTime now = DateTime.now();
    String userdata=formatDate(now, [yyyy, '/', mm, '/', dd])+"/"+formatDate(now, [HH, ':', nn]);
    await noteSqlite.openSqlite();
    List<Note> notelistall= await noteSqlite.queryAll();
    await noteSqlite.insert(new Note(notelistall[notelistall.length-1].id+1,title,content,userdata,"1"));
    //切记用完就close
    await noteSqlite.close();
  }



}




