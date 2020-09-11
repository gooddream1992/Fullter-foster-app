import 'package:flutter/material.dart';

class DefecationImage extends StatefulWidget {
  @override
  _DefecationImage createState() => new _DefecationImage();
}

class _DefecationImage extends State<DefecationImage> {
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.white,
        ),
        title: new Text('Bristol Scale Image'),
        backgroundColor: Colors.lightGreen,
      ),
      body: new SafeArea(
          child: new SingleChildScrollView(
        child: new Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          margin: EdgeInsets.only(top: 30),
          child: new Column(
            children: [
              new Container(
                  margin: EdgeInsets.only(top: 30),
                  width: MediaQuery.of(context).size.width,
                  child: new Image.asset(
                    'assets/images/briston.png',
                    scale: 1,
                  )),
            ],
          ),
        ),
      )),
      bottomNavigationBar: new BottomAppBar(
        child: new Container(
          width: MediaQuery.of(context).size.width,
          child: new Row(
            children: [
              new Container(
                  margin:
                      EdgeInsets.only(top: 15, bottom: 15, left: 10, right: 10),
                  width: MediaQuery.of(context).size.width,
                  child: new Text(
                    'Modified from Rome Foundation Bristol Stool Firm Scale, Copyright 2000. Used with permission.',
                    style: new TextStyle(
                        color: Colors.red,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
