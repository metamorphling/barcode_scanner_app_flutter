import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:game_barcode_scanner/data/grid_info.dart';
import 'package:game_barcode_scanner/database/sqlite_database.dart';

import 'data_grid.dart';
import 'db_item_edit_screen.dart';

GridInfo _gridInfo = new GridInfo();

Widget getFilterButton() {
  return Expanded(
    child: Align(
      alignment: Alignment.bottomLeft,
      child: FloatingActionButton(
        tooltip: 'Filter',
        child: Icon(Icons.view_list),
        heroTag: "filter_btn",
        onPressed: () {},
      ),
    ),
  );
}

Widget getAddButton(BuildContext context) {
  return Expanded(
    child: Align(
      alignment: Alignment.bottomRight,
      child: FloatingActionButton(
        tooltip: 'Add',
        child: Icon(Icons.add),
        heroTag: "add_item_btn",
        onPressed: () {
          var rows = {for (var v in _gridInfo.columnNames) v: ''};
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  DbItemEditScreen(tableName: _gridInfo.tableName, row: rows)));
        },
      ),
    ),
  );
}

openDatabaseView(BuildContext context) {
  print("db call ");
  Navigator.of(context).push(MaterialPageRoute(builder: (context) {
    var list = [
      SizedBox(
        width: 30,
      ),
      getFilterButton(),
      getAddButton(context),
    ];
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Table"),
      ),
      body: DataGrid(db, _gridInfo),
      floatingActionButton: Row(
        children: list,
      ),
    );
  }));
}
