import 'package:flutter/material.dart' show ChangeNotifier, BuildContext;
import 'package:provider/provider.dart';

class CountProvider extends ChangeNotifier {
  int count = 0;

  void updateCount({required int by}) {
    count += by;
    notifyListeners();
  }

  static CountProvider of(BuildContext context, {bool listen = false}) {
    return Provider.of<CountProvider>(context, listen: listen);
  }
}
