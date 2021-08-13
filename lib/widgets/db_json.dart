import 'package:flutter/material.dart';

class DbFromJson extends StatefulWidget {
  final List<String> columns;

  const DbFromJson({Key key, @required this.columns}) : super(key: key);

  @override
  DbFromJsonState createState() => DbFromJsonState();
}

class DbFromJsonState extends State<DbFromJson> {
  List<int> _chosenList = <int>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Table"),
      ),
      body: Wrap(
          // crossAxisCount: 2,
          direction: Axis.horizontal,
          children: List.generate(
            widget.columns.length,
            (i) {
              return ActionChip(
                // avatar: CircleAvatar(
                //   backgroundColor: Colors.grey.shade800,
                //   child: Text(widget.columns[i][0]),
                // ),
                label: Text(widget.columns[i]),
                backgroundColor: _chosenList.contains(i)
                    ? Colors.blue[100]
                    : Colors.grey[200],
                onPressed: () {
                  _chosenList.contains(i)
                      ? _chosenList.remove(i)
                      : _chosenList.add(i);
                  setState(() {});
                },
              );
            },
          )),
    );
  }
}
