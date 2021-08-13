import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:game_barcode_scanner/database/sqlite_database.dart';

class DbItemEditScreen extends StatefulWidget {
  final Map<String, Object> row;
  final String tableName;

  const DbItemEditScreen({
    Key key,
    @required this.tableName,
    @required this.row,
  }) : super(key: key);

  @override
  DbItemEditState createState() => DbItemEditState();
}

class DbItemEditState extends State<DbItemEditScreen> {
  bool _isLoading = false;

  List<Widget> getColumnWidgets(Map<String, Object> columns) {
    List<Widget> list = <Widget>[];
    columns.forEach((key, value) {
      list.add(
        new TextFormField(
          initialValue: widget.row[key]?.toString() ?? "",
          decoration: InputDecoration(hintText: key),
          onChanged: (newValue) => {
            saveField(key, newValue),
          },
        ),
      );
    });
    return list;
  }

  Widget getStack() {
    Stack(
      children: <Widget>[
        Opacity(
          opacity:
              1, // You can reduce this when loading to give different effect
          child: AbsorbPointer(
            absorbing: _isLoading,
            // child: _loginScreen(loginBloc.state),
          ),
        ),
        Opacity(
          opacity: _isLoading ? 1.0 : 0,
          child: CircularProgressIndicator(),
        ),
      ],
    );
  }

  void saveField(String key, String newValue) {
    widget.row[key] = newValue;
  }

  void saveItem(Map<String, Object> row) async {
    // Navigator.of(context).push(getStack());
    _isLoading = true;
    db.setRow(widget.tableName, row);
    // await Future.delayed(Duration(seconds: 5));
    _isLoading = false;
    Navigator.of(context).pop();
  }

  List<Widget> getInputView() {
    var fieldList = getColumnWidgets(widget.row);
    return fieldList;
  }

  Widget getSaveButton() {
    var saveButton = ElevatedButton(
      style: ButtonStyle(
          minimumSize: MaterialStateProperty.all<Size>(
              Size(MediaQuery.of(context).size.width, 50))),
      onPressed: () => {
        saveItem(widget.row),
      },
      child: Text("Save"),
    );

    // return Expanded(
    // child:
    return Align(
      child: saveButton,
      alignment: Alignment.bottomCenter,
    );
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(title: Text("Add item")),
      body: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.1),
          child: ListView(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: getInputView(),
                ),
              ),
              new Expanded(
                child: new Text('Datetime',
                    style: new TextStyle(color: Colors.grey)),
              ),
              getSaveButton(),
            ],
          )),
    );
  }
}
