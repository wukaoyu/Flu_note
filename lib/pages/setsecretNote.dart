import 'package:flutter/material.dart';
import 'package:flu3/Sql/Notepad.dart';

class setsecretNodeScreen extends StatelessWidget {
  // Declare a field that holds the Todo
  final Note note;
  // In the constructor, require a Todo
  setsecretNodeScreen({Key key, @required this.note});
  int maxline;
  NoteSqlite noteSqlite = new NoteSqlite();

  String titlestr="";
  String contentstr="";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
            title: new Text('添加便签'),
            backgroundColor: Colors.black54,
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.delete),
                tooltip: "delete",
                onPressed: () {
                  showDialog<Null>(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return new AlertDialog(
                        title: new Text('确认删除？'),
                        actions: <Widget>[
                          new FlatButton(
                            child: new Text('确定'),
                            onPressed: () {
                              deletelist(note.id);
                              Navigator.of(context).pop();
                            },
                          ),
                          new FlatButton(
                            child: new Text('取消'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  ).then((val) {
                    Navigator.pop(context);
                  });
                },
              ),
              IconButton(
                icon: Icon(Icons.save),
                tooltip: "save",
                onPressed: () {
                  print(note.content);
                  setlist();
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
  TextField titleTextField() {
    return TextField(
      controller: TextEditingController.fromValue(TextEditingValue(
        text: note.name,
        selection: TextSelection.fromPosition(TextPosition(
            affinity: TextAffinity.downstream,
            offset: note.name.length)),
      )),
      decoration: InputDecoration(
        labelText: '请输入标题',
      ),
      onChanged :titlechange,
    );

  }
  TextField contentTextField(){
    return TextField(
      controller: TextEditingController.fromValue(TextEditingValue(
        text: note.content,
      )),
      maxLength: 500,
      maxLines: 20,
      //textAlign: TextAlign.center,
      style: new TextStyle(fontSize: 16),
      decoration: InputDecoration( border:InputBorder.none,  hintText: "输入文字",  counterText: "",),
      onChanged: (value){
        int len=value.toString().length;
        print(len);
        if(len>11){
        }else{
          maxline=1;
        }
        contentstr=value;
        note.content=value;
      },
    );
  }

  void titlechange(String v){
    titlestr=v;
    note.name=v;
  }

  ///删除
  void deletelist(int id) async{
    await noteSqlite.openSqlite();
    await noteSqlite.delete(id);
    await noteSqlite.close();
  }
///
// 修改
  void setlist() async{
    await noteSqlite.openSqlite();
    await noteSqlite.update(note);
    await noteSqlite.close();
  }

}

