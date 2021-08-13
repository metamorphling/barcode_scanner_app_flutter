import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:game_barcode_scanner/widgets/database_view.dart';
import 'package:game_barcode_scanner/widgets/initialize_view.dart';

import 'camera_view.dart';

enum MenuItemType {
  Database,
  Camera,
  Initialize,
}

Map<MenuItemType, String> _menuItemsText = {
  MenuItemType.Database: "View Database",
  MenuItemType.Camera: "Start Camera",
  MenuItemType.Initialize: "Initialize Database",
};

Map<MenuItemType, Function> _menuItemCalls = {
  MenuItemType.Database: (BuildContext context) {
    openDatabaseView(context);
  },
  MenuItemType.Camera: (BuildContext context) {
    openCameraView(context);
  },
  MenuItemType.Initialize: (BuildContext context) {
    openInitView(context);
  },
};

class MainMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      // Create a grid with 2 columns. If you change the scrollDirection to
      // horizontal, this produces 2 rows.
      crossAxisCount: 2,
      // Generate 100 widgets that display their index in the List.
      children: List.generate(MenuItemType.values.length, (index) {
        return ElevatedButton(
            style: ButtonStyle(
              overlayColor: MaterialStateProperty.all<Color>(Colors.grey[200]),
              backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
            ),
            onPressed: () =>
                _menuItemCalls[MenuItemType.values[index]](context),
            child: Center(
              child: Text(
                '${_menuItemsText[MenuItemType.values[index]]}',
                style: Theme.of(context).textTheme.headline5,
              ),
            ));
      }),
    );
  }
}
