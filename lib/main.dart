import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fruitapp/models/calender_model.dart';
import 'package:fruitapp/models/day_model.dart';
import 'package:fruitapp/models/lanuguage_model.dart';
import 'package:fruitapp/screens/calender.dart';
import 'package:fruitapp/screens/day.dart';
import 'package:fruitapp/screens/information.dart';
import 'package:fruitapp/screens/timetable.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:time_machine/time_machine.dart';
import 'models/initialize_database.dart';
import 'models/fruit_model.dart';
import 'models/name_fruit_dialog_model.dart';
import 'models/sub_name_fruit_dialog_model.dart';
import 'dart:io';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Timetable package uses time_machine for handling date and time, which you first have to initialize before runApp().
  // Also see assets in pubspec.yaml for another required initialization.
  WidgetsFlutterBinding.ensureInitialized();
  await TimeMachine.initialize({'rootBundle': rootBundle});
  // Providers at the top of the widget tree for keeping the state visible
  // everywhere in the application.
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create:(_)=> LanguageModel()),
      ChangeNotifierProvider(create: (_) => CalenderModel()),
      ChangeNotifierProvider(create: (_) => DayModel()),
      ChangeNotifierProvider(create: (_) => FruitModel()),
      ChangeNotifierProvider(create: (_) => NameFruitModel()),
      ChangeNotifierProvider(create: (_) => SubNameFruitModel()),
      ChangeNotifierProvider(create: (context) => InitializeModel(context)),
    ],
    builder: (context, widget) {
      return MyApp();
    },
  ));

  // Get storage permission from user
  var status = await Permission.storage.status;
  if (status.isUndetermined) {
    // Need to get read/write permission for SQLite to work.
    Map<Permission, PermissionStatus> statuses =
        await [Permission.storage].request();
    print(statuses[
        Permission.storage]); // it should print PermissionStatus.granted
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Flutter Demo',
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('ru',''),
        Locale('en',''),
      ],
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/day',
      routes: {
        '/day': (_) => DayPage(),
        '/calender': (_) => CalenderWidget(),
        '/detail': (_) => InformationPage(),
        '/timetable': (_) => TimetablePage(),
      },
    );
  }
}
