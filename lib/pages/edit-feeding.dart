import 'package:flutter/material.dart';
import 'package:foster_logger/pages/homepage.dart';
import 'package:intl/intl.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:provider/provider.dart';
import 'package:foster_logger/store/index.dart';
import 'dart:convert';

class EditFeedingLog extends StatefulWidget {
  @override
  _EditFeedingLog createState() => new _EditFeedingLog();
}

class _EditFeedingLog extends State<EditFeedingLog> {
  AppState state;
  String error = '';
  bool status = false;
  bool otherFood = false;
  bool otherUnit = false;
  String food = '';
  String um = '';
  final List<String> units = <String>["g", "oz", "others"];
  final List<String> types = <String>[
    "Wet Food",
    "Dry Food",
    "Formula",
    "Other"
  ];

  TextEditingController date;
  TextEditingController time;
  TextEditingController type = new TextEditingController();
  TextEditingController amount = new TextEditingController();
  TextEditingController unit = new TextEditingController();

  void initState() {
    super.initState();
    state = Provider.of<AppState>(context, listen: false);
    date = new TextEditingController(text: state.formatDate(DateTime.now()));
    time = new TextEditingController(
        text: state
            .formatTime(new DateFormat('HH:mm:ss').format(DateTime.now())));
    if (state.feeding['date'] != null) {
      date.text = state.feeding['date'];
    }
    if (state.feeding['time'] != null) {
      time.text = state.formatTime(state.feeding['time']);
    }
    if (state.feeding['type'] != null) {
      if (!types.contains(state.feeding['type'])) {
        otherFood = true;
        food = 'Other';
      } else {
        otherFood = false;
        food = state.feeding['type'];
      }
      type.text = state.feeding['type'];
    }
    if (state.feeding['amount'] != null) {
      amount.text = state.feeding['amount'].toString();
    }
    if (state.feeding['unit'] != null) {
      if (!units.contains(state.feeding['unit'])) {
        otherUnit = true;
        um = 'others';
      } else {
        otherUnit = false;
        um = state.feeding['unit'];
      }
      unit.text = state.feeding['unit'];
    }
  }

  @override
  Widget build(BuildContext context) {
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
        title: new Text(state.foster['name']),
        backgroundColor: Colors.orangeAccent,
      ),
      body: new SafeArea(
          child: new SingleChildScrollView(
        child: new Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.only(left: 20, right: 20),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Container(
                margin: EdgeInsets.only(top: 10),
                child: new GestureDetector(
                  child: new TextFormField(
                    decoration: new InputDecoration(
                      contentPadding: EdgeInsets.all(18),
                      labelStyle: new TextStyle(color: Colors.grey),
                      labelText: 'Date',
                      prefixIcon: Icon(Icons.date_range,
                          color: Colors.grey.withOpacity(0.7)),
                      enabledBorder: new OutlineInputBorder(
                        borderSide:
                            new BorderSide(color: Colors.grey.withOpacity(0.4)),
                      ),
                      focusedBorder: new OutlineInputBorder(
                        borderSide:
                            new BorderSide(color: Colors.grey.withOpacity(0.3)),
                      ),
                    ),
                    style: new TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey),
                    controller: date,
                    readOnly: true,
                    onTap: () {
                      showDate();
                    },
                  ),
                ),
              ),
              new Container(
                margin: EdgeInsets.only(top: 10),
                child: new GestureDetector(
                  child: new TextFormField(
                    decoration: new InputDecoration(
                      contentPadding: EdgeInsets.all(18),
                      labelStyle: new TextStyle(color: Colors.grey),
                      labelText: 'Time',
                      prefixIcon: Icon(Icons.date_range,
                          color: Colors.grey.withOpacity(0.7)),
                      enabledBorder: new OutlineInputBorder(
                        borderSide:
                            new BorderSide(color: Colors.grey.withOpacity(0.4)),
                      ),
                      focusedBorder: new OutlineInputBorder(
                        borderSide:
                            new BorderSide(color: Colors.grey.withOpacity(0.3)),
                      ),
                    ),
                    style: new TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey),
                    controller: time,
                    readOnly: true,
                    onTap: () {
                      showTime();
                    },
                  ),
                ),
              ),
              new Container(
                height: 50,
                margin: EdgeInsets.only(top: 10),
                child: new DropdownButtonFormField(
                  hint: new Text(
                    'Type',
                    style: new TextStyle(color: Colors.grey),
                  ),
                  value: food,
                  items: types.map(
                    (item) {
                      return DropdownMenuItem(
                        value: item,
                        child: new Text(
                          item,
                          style: new TextStyle(color: Colors.grey),
                        ),
                      );
                    },
                  ).toList(),
                  onChanged: (v) {
                    if (v != 'Other') {
                      setState(() {
                        otherFood = false;
                        type.text = v;
                      });
                    } else {
                      setState(() {
                        otherFood = true;
                        type.text = '';
                      });
                    }
                  },
                  decoration: new InputDecoration(
                    contentPadding: EdgeInsets.only(left: 15),
                    prefixIcon: Icon(Icons.category,
                        color: Colors.grey.withOpacity(0.7)),
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: new OutlineInputBorder(
                      borderSide:
                          new BorderSide(color: Colors.grey.withOpacity(0.4)),
                    ),
                    focusedBorder: new OutlineInputBorder(
                        borderSide: new BorderSide(color: Colors.black)),
                  ),
                ),
              ),
              otherFood
                  ? new Container(
                      height: 50,
                      margin: EdgeInsets.only(top: 10),
                      child: new TextFormField(
                        decoration: new InputDecoration(
                            prefixIcon: Icon(Icons.devices_other,
                                color: Colors.grey.withOpacity(0.7)),
                            focusedBorder: new OutlineInputBorder(
                                borderSide:
                                    new BorderSide(color: Colors.orange)),
                            enabledBorder: new OutlineInputBorder(
                                borderSide: new BorderSide(
                                    color: Colors.grey.withOpacity(0.3))),
                            hintText: 'Other Types',
                            contentPadding: EdgeInsets.only(top: 10)),
                        controller: type,
                      ),
                    )
                  : new Container(),
              new Container(
                height: 50,
                margin: EdgeInsets.only(top: 10),
                child: new TextFormField(
                  decoration: new InputDecoration(
                      prefixIcon: Icon(Icons.ac_unit,
                          color: Colors.grey.withOpacity(0.7)),
                      focusedBorder: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.orange)),
                      enabledBorder: new OutlineInputBorder(
                          borderSide: new BorderSide(
                              color: Colors.grey.withOpacity(0.3))),
                      hintText: 'Amount',
                      contentPadding: EdgeInsets.only(top: 10)),
                  controller: amount,
                ),
              ),
              new Container(
                height: 50,
                margin: EdgeInsets.only(top: 10),
                child: new DropdownButtonFormField(
                  hint: new Text(
                    'Unit of Measure',
                    style: new TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.grey),
                  ),
                  value: um,
                  items: units.map(
                    (item) {
                      return DropdownMenuItem(
                        value: item,
                        child: new Text(
                          item,
                          style: new TextStyle(color: Colors.grey),
                        ),
                      );
                    },
                  ).toList(),
                  onChanged: (v) {
                    if (v != 'others') {
                      setState(() {
                        otherUnit = false;
                        unit.text = v;
                      });
                    } else {
                      setState(() {
                        otherUnit = true;
                        unit.text = '';
                      });
                    }
                  },
                  decoration: new InputDecoration(
                    contentPadding: EdgeInsets.only(left: 15),
                    prefixIcon: Icon(Icons.graphic_eq,
                        color: Colors.grey.withOpacity(0.7)),
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: new OutlineInputBorder(
                      borderSide:
                          new BorderSide(color: Colors.grey.withOpacity(0.4)),
                    ),
                    focusedBorder: new OutlineInputBorder(
                        borderSide: new BorderSide(color: Colors.orange)),
                  ),
                ),
              ),
              otherUnit
                  ? new Container(
                      height: 50,
                      margin: EdgeInsets.only(top: 10),
                      child: new TextFormField(
                        decoration: new InputDecoration(
                            prefixIcon: Icon(Icons.devices_other,
                                color: Colors.grey.withOpacity(0.7)),
                            focusedBorder: new OutlineInputBorder(
                                borderSide:
                                    new BorderSide(color: Colors.orange)),
                            enabledBorder: new OutlineInputBorder(
                                borderSide: new BorderSide(
                                    color: Colors.grey.withOpacity(0.3))),
                            hintText: 'Other Units',
                            contentPadding: EdgeInsets.only(top: 10)),
                        controller: unit,
                      ),
                    )
                  : new Container(),
              new Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(top: 20),
                child: new MaterialButton(
                  onPressed: () {
                    submit();
                  },
                  padding: EdgeInsets.only(top: 15, bottom: 15),
                  color: Colors.orangeAccent,
                  shape: StadiumBorder(),
                  child: status
                      ? new CircularProgressIndicator(
                          backgroundColor: Colors.white,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.orange),
                          strokeWidth: 2)
                      : new Text('SUBMIT',
                          style: new TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }

  void showDate() {
    DatePicker.showDatePicker(context,
        showTitleActions: true,
        minTime: DateTime(1900, 1, 1),
        maxTime: DateTime(new DateTime.now().year, 12, 31), onConfirm: (date) {
      this.date.text = state.formatDate(date);
    }, currentTime: DateTime.now(), locale: LocaleType.en);
  }

  void showTime() {
    DatePicker.showTimePicker(context,
        showTitleActions: true, showSecondsColumn: false, onConfirm: (date) {
      this.time.text = state.formatTime(date.toString().split(' ')[1]);
    }, locale: LocaleType.en);
  }

  void submit() {
    setState(() {
      status = true;
    });

    state.postAuth(
        context, 'update-foster-feeding/' + state.feeding['id'].toString(), {
      'date': date.text,
      'time': time.text,
      'type': type.text,
      'amount': amount.text,
      'unit': unit.text,
    }).then((data) {
      var body = jsonDecode(data.body);
      if (data.statusCode == 200 && body['status']) {
        state.notifyToastSuccess(context: context, message: body['message']);
        state.feeding = body['data'];
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => new HomePage()));
      } else if (data.statusCode != 422) {
        state.notifyToastDanger(
            context: context, message: "Error occured while creating account");
      }
      setState(() {
        status = false;
      });
    }).catchError((error) {
      print(error);
      setState(() {
        status = false;
      });
    });
  }
}
