import 'package:flutter/widgets.dart';

class AddItemNotification extends Notification {
  final List<String> columns;

  const AddItemNotification({this.columns});
}
