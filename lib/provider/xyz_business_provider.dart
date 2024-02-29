import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider_vs_riverpods/notifier/xyx_business_logic_change_notifier.dart';
import 'package:provider_vs_riverpods/provider/count_provider.dart';

import '../notifier/count_change_notifier.dart';

final xyzBusinessLogicProvider = ChangeNotifierProvider(
    (ref) => XYZBusinessChangeNotifier(ref.read(countProvider)));
