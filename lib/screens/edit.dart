import 'package:flutter/material.dart';
import 'package:memoapp/database/memo.dart';
import 'package:memoapp/database/db.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert'; // for the utf8.encode method

class EditPage extends StatefulWidget {
  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  String title = '';

  String text = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
        appBar: AppBar(
          actions: [
            IconButton(icon: const Icon(Icons.delete), onPressed: () {}),
            IconButton(
                icon: const Icon(Icons.save),
                onPressed: () {
                  saveDB();
                  Navigator.pop(context);
                })
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              TextField(
                onChanged: (String title) {
                  this.title = title;
                },
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(hintText: '제목을 쓰세요'),
              ),
              SizedBox(height: 25),
              TextField(
                onChanged: (String text) {
                  this.text = text;
                },
                decoration: InputDecoration(hintText: '내용을 쓰세요'),
                keyboardType: TextInputType.multiline,
                maxLines: 8,
              )
            ],
          ),
        ));
  }

  Future<void> saveDB() async {
    DBHelper sd = DBHelper();

    var fido = Memo(
        id: Str512sha(DateTime.now().toString()),
        title: this.title,
        text: this.text,
        createTime: DateTime.now().toString(),
        editTime: DateTime.now().toString());
    await sd.insertMemo(fido);
  }

  String Str512sha(String text) {
    var bytes = utf8.encode(text); // data being hashed

    var digest = sha512.convert(bytes);

    return digest.toString();
  }
}
