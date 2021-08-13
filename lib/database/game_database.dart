import 'package:game_barcode_scanner/data/gamedata.dart';
import 'package:sqflite/sqflite.dart';
import 'app_database.dart';
import '../constants.dart' as Constants;

class GameDatabase extends AppDatabase<GameData> {
  GameDatabase() : super(Constants.DATABASE_GAMES);

  // @override
  // Future<List<GameData>> getAllRows() async {
  //   var maps = await getTable((GameData).toString());
  //   return List.generate(maps.length, (i) {
  //     return GameData(
  //       maps[i]["ProductName"],
  //       maps[i]["ProductCode"],
  //       maps[i]["SerialCode"],
  //       maps[i]["Developer"],
  //       maps[i]["Publisher"],
  //       maps[i]["DateReleased"],
  //       maps[i]["Genre"],
  //       maps[i]["Region"],
  //       maps[i]["Platform"],
  //     );
  //   });
  // }

  // @override
  // Future<List<GameData>> getAllColumns() async {
  //   var maps = await getTable((GameData).toString());
  //   return maps.first.keys;
  // }
}
