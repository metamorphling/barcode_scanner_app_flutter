import 'package:flutter/material.dart';
import 'package:game_barcode_scanner/data/grid_info.dart';
import 'package:game_barcode_scanner/database/game_database.dart';
import 'package:game_barcode_scanner/widgets/db_item_edit_screen.dart';

class DataGrid extends StatefulWidget {
  static of(BuildContext context, {bool root = false}) => root
      ? context.findRootAncestorStateOfType<_DataGridState>()
      : context.findAncestorStateOfType<_DataGridState>();

  final GameDatabase _db;
  final GridInfo _gridInfo;

  DataGrid(this._db, this._gridInfo);

  @override
  _DataGridState createState() => _DataGridState(_db, _gridInfo);
}

class _DataGridState extends State<DataGrid> with TickerProviderStateMixin {
  List _data;
  GameDatabase _db;
  GridInfo _gridInfo;
  Map<String, List<Map<dynamic, dynamic>>> _list;
  List _tables;
  Map<String, List<String>> _columns;
  Map<String, List<Map<String, Object>>> _rows;
  String _chosenTable;

  _DataGridState(this._db, this._gridInfo);

  Stream<List> _getRows() async* {
    _tables = await _db.getAllTables();

    _list = new Map();
    _columns = new Map();
    _rows = new Map();

    await Future.forEach(_tables, (element) async {
      String table = element['name'];
      _columns[table] = <String>[];
      _list[table] = await _db.getAllFormated(table);

      // columns
      List<Map> columns = await _db.getAllColumns(table);
      columns.forEach((element) {
        String name = element['name'];
        _columns[table].add(name);
      });

      // rows
      var rows = await _db.getAllRows(table);
      _rows[table] = rows.toList();
    });

    if (_chosenTable == null) {
      _chosenTable = _columns.entries.first.key;
    }

    _gridInfo.columnNames = _columns[_chosenTable];
    _gridInfo.tableName = _chosenTable;

    yield _list[_chosenTable];
  }

  Map<String, Object> getRow(
    String tableName,
  ) {
    List<String> columnNames;

    // Map<String, Object> result = new Map<String, Object>();
    // int i = 0;
    // columnNames.forEach((element) {
    //   result[element] = rowValues[i];
    //   i++;
    // });
  }

  String getChosenTable() {
    return _chosenTable;
  }

  List<String> getColumnNames(String table) {
    return _columns[table];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: FractionalOffset.center,
        color: Colors.white,
        child: StreamBuilder<List>(
            stream: _getRows(),
            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
              if (snapshot.hasError) {
                return Column(children: <Widget>[
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 60,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text('Error: ${snapshot.error}'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text('Stack trace: ${snapshot.stackTrace}'),
                  ),
                ]);
              }

              if (snapshot.hasData == false) {
                return CircularProgressIndicator();
              }

              _data = snapshot.data;
              var columnLength = _columns[_chosenTable]?.length ?? 0;
              var dataLength = _data?.length ?? 0;
              var cellWidth = 200;
              var cellHeight = 50;
              var tableNames = _columns.keys.toList();

              Widget table = SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                      width: (columnLength * cellWidth).toDouble(),
                      height: 800,
                      child: ListView(
                        scrollDirection: Axis.vertical,
                        children: [
                          // Chips
                          ListView(
                              primary: true,
                              shrinkWrap: true,
                              children: <Widget>[
                                Wrap(
                                  spacing: 4.0,
                                  runSpacing: 0.0,
                                  children: List<Widget>.generate(
                                      _columns.length, (int index) {
                                    return ActionChip(
                                      avatar: CircleAvatar(
                                        backgroundColor: Colors.grey.shade800,
                                        child: Text(tableNames[index][0]),
                                      ),
                                      label: Text(tableNames[index]),
                                      onPressed: () {
                                        setState(() {
                                          _chosenTable = tableNames[index];
                                        });
                                      },
                                    );
                                  }).toList(),
                                )
                              ]),
                          // db headers
                          SizedBox(
                              width: (columnLength * cellWidth).toDouble(),
                              height: 50,
                              child: Row(
                                  children: List<Widget>.generate(
                                      columnLength,
                                      (column) => Container(
                                          width: cellWidth.toDouble(),
                                          height: cellHeight.toDouble(),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.blueGrey)),
                                          child: Center(
                                              child: Text(
                                            _columns[_chosenTable][column],
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6,
                                          )))))),
                          // db rows
                          SizedBox(
                              width: (columnLength * cellWidth).toDouble(),
                              height: 800,
                              child: ListView.builder(
                                  itemCount: dataLength,
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemBuilder: (context, row) {
                                    return Row(
                                        children: List<Widget>.generate(
                                            columnLength,
                                            (column) => Container(
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color:
                                                              Colors.blueGrey)),
                                                  width: cellWidth.toDouble(),
                                                  height: cellHeight.toDouble(),
                                                  child: InkWell(
                                                    onTap: () => {
                                                      print(
                                                          'onSubmited row $row col $column'),
                                                      Navigator.of(context).push(
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  DbItemEditScreen(
                                                                      tableName:
                                                                          _chosenTable,
                                                                      row: _data[
                                                                          row])))
                                                    },
                                                    child: Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text(_data == null
                                                          ? ""
                                                          : _data[row][_columns[
                                                                  _chosenTable]
                                                              [column]]),
                                                    ),
                                                  ),
                                                  // child: TextFormField(
                                                  //     initialValue: _data == null
                                                  //         ? ""
                                                  //         : _data[row][
                                                  //             cols[column]
                                                  //                 ['key']],
                                                  //     onFieldSubmitted: (val) {
                                                  //       print(
                                                  //           'onSubmited $val row $row col $column');
                                                  //     })
                                                )));
                                  }))
                        ],
                      )));

              return table;
            }));
  }
}
