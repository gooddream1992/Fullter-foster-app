import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:foster_logger/store/index.dart';
import 'package:foster_logger/pages/login.dart';
import 'package:foster_logger/pages/option.dart';
import 'dart:convert';

class LandingPage extends StatefulWidget {
  _LandingPage createState() => new _LandingPage();
}

class _LandingPage extends State<LandingPage> {
  AppState state;

  void initState() {
    super.initState();
    state = Provider.of<AppState>(context, listen: false);
//      state.sp.clear();
    Future.delayed(Duration(seconds: 1), () {
      print(state.user);
      if (state.user == null) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => new LoginPage()));
      } else {
        print('options');
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => new OptionPages()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      body: new Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: new Stack(
          children: [
            new Center(
                child: new Image.asset(
              'assets/images/logo.png',
              scale: 4,
            )),
          ],
        ),
      ),
    );
  }
}
