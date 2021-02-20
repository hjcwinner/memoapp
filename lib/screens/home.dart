import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:memoapp/screens/edit.dart';

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
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 20, top: 20, bottom: 20),
                child: Text(
                  'Memo App',
                  style: TextStyle(fontSize: 30, color: Colors.blue),
                ),
              )
            ],
          ),
          ...Loadlist()
        ],
      ),
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

  List<Widget> Loadlist() {
  List<Widget> ListAdd = [] ; 
  ListAdd.add(Container(color: Colors.redAccent, height: 100));
  ListAdd.add(Container(color: Colors.purpleAccent, height: 100));
  return ListAdd;
}
}
