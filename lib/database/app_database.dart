import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../constants.dart' as Constants;

abstract class AppDatabase<T> {
  Database _db;
  bool _isInitialized = false;
  String _databaseName;
  List<String> _columns;
  List<T> _rows;

  AppDatabase(String databaseName) {
    _databaseName = databaseName;
  }

  Future<void> initialize() async {
    // Construct a file path to copy database to
    Directory documentsDirectory = await getExternalStorageDirectory();
    String path = join(documentsDirectory.path, _databaseName);

    // Only copy if the database doesn't exist
    if (FileSystemEntity.typeSync(path) == FileSystemEntityType.notFound) {
      // Load database from asset and copy
      ByteData data = await rootBundle.load(Constants.pathFileDatabaseGames);
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Save copied asset to documents
      await new File(path).writeAsBytes(bytes);
    }

    Directory appDocDir = await getExternalStorageDirectory();
    String databasePath = join(appDocDir.path, _databaseName);
    this._db = await openDatabase(databasePath);
    _isInitialized = true;
  }

  bool isInitialized() => _isInitialized;
  Database getDatabase() => _db;

  Future<List<Map>> getAllRows(String table) async {
    if (!_isInitialized) await this.initialize();
    return await this._db.query(table);
  }

  Future<List<Map>> getAllColumns(String table) async {
    if (!_isInitialized) await this.initialize();
    return await this._db.rawQuery("PRAGMA table_info($table);");
  }

  Future<List<Map>> getAllTables() async {
    if (!_isInitialized) await this.initialize();
    return await this._db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type ='table' AND name NOT LIKE 'sqlite_%' AND name NOT LIKE 'android_%';");
  }

  Future<void> setRow(String table, Map<String, Object> row) async {
    if (!_isInitialized) await this.initialize();
    return await this
        ._db
        .insert(table, row, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map>> getAllFormated(String table) async {
    if (!_isInitialized) await this.initialize();
    var maps = await getTable(table);
    if (maps.isEmpty) return List.empty();
    var first = maps.first;
    var columns = first.keys.toList();

    return List.generate(maps.length, (i) {
      return (Map<String, Object>.fromIterable(
        columns,
        key: (item) => item,
        value: (item) => maps[i][item],
      ));
    });
  }

  Future<List<Map>> getTable(String table) async {
    if (!_isInitialized) await this.initialize();
    return await this._db.query(table);
  }
}
