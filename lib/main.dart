import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:game_barcode_scanner/widgets/main_menu.dart';
import 'database/sqlite_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var database = db;
  await Firebase.initializeApp();
  runApp(MyApp());
  await database.initialize();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Editable Table',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      debugShowCheckedModeBanner: false,
      home: TablePage(),
    );
  }
}

class TablePage extends StatefulWidget {
  @override
  _TablePageState createState() => _TablePageState();
}

class _TablePageState extends State<TablePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text(""),
      ),
      // body: DataGrid(db),
      body: MainMenu(),
    );
  }
}
