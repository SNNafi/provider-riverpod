import 'package:flutter/foundation.dart' show ChangeNotifier;

class CountChangeNotifier extends ChangeNotifier {
  int count = 0;

  void updateCount({required int by}) {
    count += by;
    notifyListeners();
  }
}
