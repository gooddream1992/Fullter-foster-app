import 'package:flutter/material.dart';
import 'package:foster_logger/pages/landingpage.dart';
import 'package:provider/provider.dart';
import 'package:foster_logger/store/index.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(new MultiProvider(
      providers: [ChangeNotifierProvider.value(value: AppState())],
      child: new MaterialApp(
        debugShowCheckedModeBanner: false,
        home: new LandingPage(),
      )));
}
//debugPrint('notification payload: ' + payload);
