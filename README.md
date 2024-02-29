# Provider to RiverPod Migration [WIP]

We have been using __Provider__ for a quite long time. It has so many features __BUT__ as it is tightly bundled with Flutter i.e. __InheritedWidget__, so can't do certain things and it can't be possible to add them to the provider.

So there is __RiverPod__.

Suppose, We have an app, where we need a counter, so create a `CountProvider` that will update the count and notify changes to the _UI_. And based on the counter value we need to generate some business logic behind the scenes. So, it demands a provider of its own. So, Now we have another named `XYZBusinessProvider`.

Now we need to access the value of `CountProvider` from the `XYZBusinessProvider`. How can we do this? We need to pass the `CountProvider` as an argument to the method.Like,

```dart
String businessLogic(CountProvider countProvider) {
  return _uuid.v1(options: {
    'mSecs': 132164496138 + countProvider.count,
    'nSecs': 1000 + countProvider.count
  });
}
```
This is the cleanest way I think. So every time we need to call the `businessLogic()` we need to pass it.

Now let's migrate the same provider code to Riverpod.

First, we need to update `pubspec.yaml` from

```yaml
dependencies:
  flutter:
    sdk: flutter

  provider: ^6.1.2
  uuid: ^4.3.3

```
to

```yaml
dependencies:
  flutter:
    sdk: flutter

  flutter_riverpod: ^2.4.10
  uuid: ^4.3.3

```

Then migrate the `CountProvider`. <br>
__Provider__ <br>
__File:__ _count_provider.dart_

```dart

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
```
__Riverpod__ <br>
__File:__ _count_change_notifier.dart_

```dart
class CountChangeNotifier extends ChangeNotifier {
  int count = 0;

  void updateCount({required int by}) {
    count += by;
    notifyListeners();
  }
}
```
__File:__ _count_provider.dart_

```dart
final countProvider = ChangeNotifierProvider((_) => CountChangeNotifier());
```

For `XYZBusinessProvider`, we need a reference for `CountProvider`. We can do this riverpod version.

Then migrate the `XYZBusinessProvider`. <br>
__Provider__ <br>
__File:__ _xyz_business_provider.dart_

```dart
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
```
__Riverpod__ <br>
__File:__ _xyx_business_logic_change_notifier.dart_

```dart
class XYZBusinessChangeNotifier extends ChangeNotifier {
  CountChangeNotifier countChangeNotifier;

  XYZBusinessChangeNotifier(this.countChangeNotifier);

  final _uuid = const Uuid();

  // We need the count value variable from [CountProvider]. How do we get that?
  // Riverpod has direct support for two provider communication.
  String businessLogic() {
    return _uuid.v1(options: {
      'mSecs': 132164496138 + countChangeNotifier.count,
      'nSecs': 1000 + countChangeNotifier.count
    });
  }
}
```
__File:__ _xyz_business_provider.dart_

```dart
final xyzBusinessLogicProvider = ChangeNotifierProvider(
        (ref) => XYZBusinessChangeNotifier(ref.read(countProvider))); // Here we are passing 
```



Now for using Riverpod, we just need to wrap our root widget with `ProviderScope`.

```dart
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Riverpod Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ProviderScope(
        child: MyHomePage(title: 'Provider Demo Home Page'),
      ),
    );
  }
}
```

And instead of `StatelessWidget` & `StatefulWidget`, we will use `ConsumerWidget`, `ConsumerStatefulWidget`. <br>

For reading value, `ref.read(countProvider).count.toString()` instead of `CountProvider.of(context).count.toString()` <br>
For watching value `ref.watch(countProvider).count.toString()` instead of `CountProvider.of(context, listen: true).count.toString()`

This is how, we can migrate our exsiting provider code to riverpod.

# More Info:
https://riverpod.dev/docs/from_provider/quickstart <br>
https://riverpod.dev/docs/from_provider/provider_vs_riverpod <br>
https://riverpod.dev/docs/from_provider/motivation

