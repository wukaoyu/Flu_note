import 'package:flu3/Sql/Notepad.dart';
import 'package:flutter/material.dart';


import 'addNote.dart';
import 'setNote.dart';
class AllListPage extends StatefulWidget{
  @override
  _AllListPageState createState() =>_AllListPageState();
}
class _AllListPageState extends State<AllListPage>{

  NoteSqlite noteSqlite = new NoteSqlite();
  var noteName = "";
  Note note = null;
  List<Note> notelist=[];


  @override
  void initState() {
    super.initState();
    insertData();
  }
  //列表组件
  Widget buildGrid() {
    List<Widget> tiles = [];//先建一个数组用于存放循环生成的widget
    ListView content; //单独一个widget组件，用于返回需要生成的内容widget
    for(var item in notelist) {
      tiles.add(
        new Container(
          height: 60.0,
          margin: EdgeInsets.fromLTRB(10,10,10,10),
          //表示与外部元素的距离是20px
          child: ListTile(
            onTap: () {
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                    builder: (context) => new DetailScreen(note: item),
                  ),
                );
            } ,
            subtitle:new Row(
              children: <Widget>[
                //new Text((item.id+1).toString()),
                new Container(
                  width: 100.0,
                  child: Text(item.name),
                  alignment: Alignment.center,
                ),
                new Text(item.date),
              ]
            )
          ),
          decoration:  new BoxDecoration(
            //border: new Border.all(width: 0.5, color: Colors.grey),
            borderRadius: new BorderRadius.circular((5.0)),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.grey,
                  offset: Offset(7.0, 6.0),
                  blurRadius: 5.0,
                  spreadRadius: 2.0
              ),
            ]
          ),
        )
      );
    }
    content = new ListView(
        children: tiles //重点在这里，因为用编辑器写Column生成的children后面会跟一个<Widget>[]，
      //此时如果我们直接把生成的tiles放在<Widget>[]中是会报一个类型不匹配的错误，把<Widget>[]删了就可以了
    );
    return content;
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: new AppBar(
        title: new Text('便签'),
        leading: new Icon(Icons.home),
        backgroundColor: Colors.deepOrangeAccent,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            tooltip: "refresh",
            onPressed: () {
              insertData();
            },
          ),
          IconButton(
            icon: Icon(Icons.add),
            tooltip: "add",
            onPressed: () {
              Navigator.push(
                context,
                new MaterialPageRoute(builder: (context) => new SecondScreen()),
              );
            },
          ),
        ],
      ),
      body: buildGrid(),
    );
  }

  void insertData() async{
    await noteSqlite.openSqlite();
    List<Note> notelistall= await noteSqlite.queryAll();
    notelist=[];
    for (var item in notelistall){
      if(item.type=="1"){
        notelist.add(item);
      }
    }
    Note note = await noteSqlite.getnote(1);
    await noteSqlite.close();
    setState(() {
      //noteName = note.name;
    });
  }
  TextFormField titleTextField(){
    return TextFormField(
      decoration: InputDecoration(
        labelText: '请输入标题',
      ),
    );
  }
}

