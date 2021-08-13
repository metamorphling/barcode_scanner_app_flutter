import 'package:path/path.dart';

const String DATABASE_GAMES = "game_data.db";
const String PATH_ASSETS = "assets";
final String pathFolderAssetsDatabase = join(PATH_ASSETS, "database");
final String pathFileDatabaseGames =
    join(pathFolderAssetsDatabase, DATABASE_GAMES);
