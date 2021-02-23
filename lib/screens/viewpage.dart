import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:memoapp/database/memo.dart';
import 'package:memoapp/database/db.dart';
import 'edit2.dart';

class ViewPage extends StatefulWidget {
  ViewPage({Key key, this.id}) : super(key: key);

  final String id;

  @override
  _ViewPageState createState() => _ViewPageState();
}

class _ViewPageState extends State<ViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  setState(() {
                    showAlertDialog(context);
                  });
                }),
            IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => Edit2(id: widget.id)));
                })
          ],
        ),
        body: Padding(padding: EdgeInsets.all(20), child: LoadBuilder()));
  }

  Future<List<Memo>> loadMemo(String id) async {
    DBHelper sd = DBHelper();
    return await sd.findMemo(id);
  }

  LoadBuilder() {
    return FutureBuilder<List<Memo>>(
      future: loadMemo(widget.id),
      builder: (BuildContext context, AsyncSnapshot<List<Memo>> snapshot) {
        if (snapshot?.data?.isEmpty ?? true) {
          return Container(
            child: Text('데이터를 불러올 수 없습니다'),
          );
        } else {
          Memo memo = snapshot.data[0];
          return Container(
            height: 220,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue, width: 2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: 70,
                  child: SingleChildScrollView(
                    child: Text(
                      memo.title,
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                Text("메모 만든 시간: " + memo.createTime.split('.')[0],
                    textAlign: TextAlign.end),
                Text(
                  "메모 수정 시간: " + memo.editTime.split('.')[0],
                  textAlign: TextAlign.end,
                ),
                SizedBox(height: 25),
                Expanded(child: SingleChildScrollView(child: Text(memo.text))),
              ],
            ),
          );
        }
      },
    );
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
                  delMemo(widget.id);
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

  Future<void> delMemo(String id) async {
    DBHelper sd = DBHelper();
    await sd.deleteMemo(id);
  }
}
