import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider_vs_riverpods/notifier/count_change_notifier.dart';

final countProvider = ChangeNotifierProvider((_) => CountChangeNotifier());
