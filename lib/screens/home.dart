import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:memoapp/screens/edit.dart';
import 'package:memoapp/database/db.dart';
import 'package:memoapp/database/memo.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Padding(
          padding: EdgeInsets.only(left: 20, top: 40, bottom: 20),
          child: Container(
            alignment: Alignment.centerLeft,
            child: Text(
              'Memo App',
              style: TextStyle(fontSize: 30, color: Colors.blue),
            ),
          ),
        ),
        Expanded(child: memoBuilder())
      ]),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
              context, CupertinoPageRoute(builder: (context) => EditPage()));
        },
        tooltip: '메모를 추가하려면 클릭하세요',
        label: Text('메모 추가'),
        icon: Icon(Icons.add),
      ),
    );
  }

  List<Widget> LoadMemo() {
    List<Widget> listAdd = [];
    listAdd.add(Container(color: Colors.redAccent, height: 100));
    listAdd.add(Container(color: Colors.purpleAccent, height: 100));
    return listAdd;
  }

  Future<List<Memo>> loadMemo() async {
    DBHelper sd = DBHelper();
    return await sd.memos();
  }

  Widget memoBuilder() {
    return FutureBuilder(
      builder: (context, projectSnap) {
        if (projectSnap.data.isEmpty) {
          return Container(
            alignment: Alignment.center,
            child: Text(
              '메모를 작성하세요\n\n\n\n',
              style: TextStyle(fontSize: 25, color: Colors.blue[700]),
            ),
          );
        }
        return ListView.builder(
          padding: EdgeInsets.all(20),
          physics: BouncingScrollPhysics(),
          itemCount: projectSnap.data.length,
          itemBuilder: (context, index) {
            Memo memo = projectSnap.data[index];
            return Container(
              padding: EdgeInsets.all(15),
              margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
              height: 120,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.blue, width: 1),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.lightBlue, blurRadius: 3)]
                  ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [  
                      Text(
                        memo.title,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        memo.text,
                        style: TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        '최종 수정 시간:' + memo.editTime.split('.')[0],
                        style: TextStyle(fontSize: 11),
                        textAlign: TextAlign.end,
                      )
                    ],
                  )
                  // Widget to display the list of project
                ],
              ),
            );
          },
        );
      },
      future: loadMemo(),
    );
  }
}
