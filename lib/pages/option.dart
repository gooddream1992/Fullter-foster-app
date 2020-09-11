import 'package:flutter/material.dart';
import 'package:foster_logger/pages/select-foster.dart';
import 'package:foster_logger/pages/create-foster.dart';
import 'package:provider/provider.dart';
import 'package:foster_logger/store/index.dart';
import 'package:foster_logger/pages/login.dart';
import 'dart:async';
import 'package:foster_logger/pages/landingpage.dart';
import 'dart:convert';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:foster_logger/pages/profile.dart';

class OptionPages extends StatefulWidget {
  @override
  _OptionPages createState() => new _OptionPages();
}

class _OptionPages extends State<OptionPages> {
  String error = '';
  bool status = false;
  AppState state;
  String url = '';
  int index = 0;
  WebViewController _controller;
  bool displayBack = true;

  void initState() {
    super.initState();
    state = Provider.of<AppState>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        child: new Scaffold(
          backgroundColor: Colors.white,
          body: new SafeArea(
              child: new IndexedStack(
            index: index,
            children: [
              new SingleChildScrollView(
                child: new Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      new InkWell(
                        child: new Container(
                          width: MediaQuery.of(context).size.width - 50,
                          height: 100,
                          child: new Center(
                            child: new Text(
                              'ARE YOU UPDATING AN EXISTING FOSTER?',
                              style: new TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.w500),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          decoration: new BoxDecoration(
                              color: Colors.orangeAccent,
                              borderRadius: new BorderRadius.circular(10)),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) => new SelectingFoster()));
                        },
                      ),
                      new Container(
                        margin: EdgeInsets.only(top: 25, bottom: 25),
                        child: new Text(
                          'OR',
                          style: new TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500),
                        ),
                      ),
                      new InkWell(
                        child: new Container(
                          height: 100,
                          width: MediaQuery.of(context).size.width - 50,
                          child: new Container(
                            child: new Center(
                              child: new Text(
                                'CREATE A NEW FOSTER',
                                style: new TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                    fontWeight: FontWeight.w500),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          decoration: new BoxDecoration(
                              color: Colors.orangeAccent,
                              borderRadius: new BorderRadius.circular(10)),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) =>
                                      new CreateFosterPage()));
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
        ),
        onWillPop: () async {
          if (index == 1) {
            setState(() {
              index = 0;
            });
          }
          return false;
        });
  }
}
