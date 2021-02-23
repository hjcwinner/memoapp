import 'package:flutter/material.dart';
import 'package:memoapp/database/db.dart';
import 'package:memoapp/database/memo.dart';

class Edit2 extends StatefulWidget {
  Edit2({Key key, this.id}) : super(key: key);
  final String id;

  @override
  _Edit2State createState() => _Edit2State();
}

class _Edit2State extends State<Edit2> {
  BuildContext _context;

  String title = '';
  String text = '';
  String createTime = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        actions: [
          IconButton(icon: const Icon(Icons.save), onPressed: updateDB),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: loadBuilder(),
      ),
    );
  }

  Future<List<Memo>> loadMemo(String id) async {
    DBHelper sd = DBHelper();
    return await sd.findMemo(id);
  }

  loadBuilder() {
    return FutureBuilder<List<Memo>>(
      future: loadMemo(widget.id),
      builder: (BuildContext context, AsyncSnapshot<List<Memo>> snapshot) {
        if (snapshot.data == null || snapshot.data == []) {
          return Container(
            child: Text('데이터를 불러올 수 없습니다'),
          );
        } else {
          Memo memo = snapshot.data[0];

          TextEditingController ctitle = TextEditingController();
          title = memo.title;
          ctitle.text = title;

          TextEditingController ctext = TextEditingController();
          text = memo.text;
          ctext.text = text;

          // title = memo.title;
          // text = memo.text;
          createTime = memo.createTime;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: ctitle,
                maxLength: 2,
                onChanged: (String title) {
                  this.title = title;
                },
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
                decoration: InputDecoration(hintText: '제목을 쓰세요'),
              ),
              SizedBox(height: 25),
              TextField(
                controller: ctext,
                onChanged: (String text) {
                  this.text = text;
                },
                decoration: InputDecoration(hintText: '내용을 쓰세요'),
                keyboardType: TextInputType.multiline,
                //maxLines: null,
              )
            ],
          );
        }
      },
    );
  }

  updateDB() async {
    DBHelper sd = DBHelper();

    var fido = Memo(
        id: widget.id,
        title: this.title,
        text: this.text,
        createTime: this.createTime,
        editTime: DateTime.now().toString());

    sd.updateMemo(fido);
    Navigator.pop(_context);
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
