import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:game_barcode_scanner/widgets/db_json.dart';

enum InitType {
  ByJson,
  ByHand,
  ByDb,
}

Map<InitType, String> _menuItemsText = {
  InitType.ByJson: "JSON",
  InitType.ByHand: "Manual",
  InitType.ByDb: "Use DB",
};

Map<InitType, Function> _menuItemCalls = {
  InitType.ByJson: (BuildContext context) async {
    FilePickerResult result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ["json"]);
    if (result != null) {
      File file = File(result.files.single.path);
      file.readAsString().then((value) {
        var json = jsonDecode(value);
        var item = json[0].keys.toList();
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => DbFromJson(columns: item)));
      });
    }
  },
  InitType.ByHand: (BuildContext context) async {},
  InitType.ByDb: (BuildContext context) async {},
};

class InitializeView extends StatefulWidget {
  const InitializeView({
    Key key,
  }) : super(key: key);

  @override
  InitializeViewState createState() => InitializeViewState();
}

class InitializeViewState extends State<InitializeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Table"),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        children: List.generate(InitType.values.length, (index) {
          return ElevatedButton(
              style: ButtonStyle(
                overlayColor:
                    MaterialStateProperty.all<Color>(Colors.grey[200]),
                backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
              ),
              onPressed: () => _menuItemCalls[InitType.values[index]](context),
              child: Center(
                child: Text(
                  '${_menuItemsText[InitType.values[index]]}',
                  style: Theme.of(context).textTheme.headline5,
                ),
              ));
        }),
      ),
    );
  }
}

openInitView(BuildContext context) async {
  Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => InitializeView()));
}
