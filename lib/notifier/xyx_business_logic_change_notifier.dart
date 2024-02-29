import 'package:flutter/foundation.dart' show ChangeNotifier;
import 'package:provider_vs_riverpods/notifier/count_change_notifier.dart';
import 'package:provider_vs_riverpods/provider/count_provider.dart';
import 'package:uuid/data.dart';
import 'package:uuid/uuid.dart';

class XYZBusinessChangeNotifier extends ChangeNotifier {
  CountChangeNotifier countChangeNotifier;

  XYZBusinessChangeNotifier(this.countChangeNotifier);

  final _uuid = const Uuid();

  // We need the count value variable from [CountProvider]. How do we get that?
  // Riverpod has direct support for two provider connection.
  String businessLogic() {
    return _uuid.v1(options: {
      'mSecs': 132164496138 + countChangeNotifier.count,
      'nSecs': 1000 + countChangeNotifier.count
    });
  }
}
