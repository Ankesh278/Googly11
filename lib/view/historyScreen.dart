
import 'package:flutter/material.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<String> historyItems = [
    "Visited Website A",
    "Viewed Creative Project B",
    "Read Article C",
    "Watched Video D",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        centerTitle: true,
        title: Text('History',style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),),
        automaticallyImplyLeading: true,
        backgroundColor: Color(0xff780000),
      ),
      body: ListView.builder(
        itemCount: historyItems.length,
        itemBuilder: (BuildContext context, int index) {
          final item = historyItems[index];
          return Dismissible(
            key: Key(item),
            direction: DismissDirection.endToStart,
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: 16.0),
              child: Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
            onDismissed: (direction) {
              setState(() {
                historyItems.removeAt(index);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$item removed from history'),
                ),
              );
            },
            child: Card(
              elevation: 2.0,
              margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: ListTile(
                title: Text(item),
                trailing: Icon(Icons.arrow_forward),
              ),
            ),
          );
        },
      ),
    );
  }
}