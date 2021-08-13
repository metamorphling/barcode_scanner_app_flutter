import 'package:flutter/material.dart';
import 'package:game_barcode_scanner/widgets/db_item_edit_screen.dart';

dbItemNotFound(BuildContext context, String barcode) {
  Widget cancelButton = TextButton(
    child: Text("Cancel"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );
  Widget continueButton = TextButton(
    child: Text("Continue"),
    onPressed: () {
      Navigator.of(context).pop();
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => DbItemEditScreen(tableName: null, row: null)));
    },
  );

  AlertDialog alert = AlertDialog(
    title: Text("Unknown Barcode"),
    content: Text("Would you like to add new item('$barcode') to database?"),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
