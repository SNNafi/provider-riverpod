import 'package:flutter/material.dart' show ChangeNotifier, BuildContext;
import 'package:provider/provider.dart';
import 'package:provider_vs_riverpods/provider/count_provider.dart';
import 'package:uuid/data.dart';
import 'package:uuid/uuid.dart';

class XYZBusinessProvider extends ChangeNotifier {
  final _uuid = const Uuid();

  // We need the count value variable from [CountProvider]. How do we get that? Provider has no support for two provider connection.
  // We can pass [CountProvider] as an argument
  String businessLogic(CountProvider countProvider) {
    return _uuid.v1(options: {
      'mSecs': 132164496138 + countProvider.count,
      'nSecs': 1000 + countProvider.count
    });
  }

  static XYZBusinessProvider of(BuildContext context, {bool listen = false}) {
    return Provider.of<XYZBusinessProvider>(context, listen: listen);
  }
}
