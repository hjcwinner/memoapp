import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:memoapp/screens/edit.dart';
import 'package:memoapp/database/db.dart';
import 'package:memoapp/database/memo.dart';
import 'viewpage.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String delid = "";
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
        Expanded(child: memoBuilder(context))
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

  Future<List<Memo>> loadMemo() async {
    DBHelper sd = DBHelper();
    return await sd.memos();
  }

  Future<void> delMemo(String id) async {
    DBHelper sd = DBHelper();
    await sd.deleteMemo(id);
  }

  void showAlertDialog(BuildContext context) async {
    String result = await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('삭제 경고'),
          content: Text("삭제하시겠습니까?\n 삭제된 메모는 복구되지 않습니다."),
          actions: <Widget>[
            FlatButton(
              child: Text('삭제'),
              onPressed: () {
                Navigator.pop(context, "삭제");
                setState(() {
                  delMemo(delid);
                  delid = "";
                });
              },
            ),
            FlatButton(
              child: Text('취소'),
              onPressed: () {
                Navigator.pop(context, "취소");
              },
            ),
          ],
        );
      },
    );
  }

  Widget memoBuilder(BuildContext parentContext) {
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
            return InkWell(
              onTap: () {
                Navigator.push(parentContext,
                    CupertinoPageRoute(builder: (context) => ViewPage(id: memo.id)));
              },
              onLongPress: () {
                delid = memo.id;
                showAlertDialog(parentContext);
              },
              child: Container(
                padding: EdgeInsets.all(15),
                margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
                height: 120,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.blue, width: 1),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(color: Colors.lightBlue, blurRadius: 3)
                    ]),
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
              ),
            );
          },
        );
      },
      future: loadMemo(),
    );
  }
}
