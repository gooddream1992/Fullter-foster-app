import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:provider/provider.dart';
import 'package:foster_logger/store/index.dart';
import 'dart:convert';

class AddUrinationLog extends StatefulWidget {
  @override
  _AddUrinationLog createState() => new _AddUrinationLog();
}

class _AddUrinationLog extends State<AddUrinationLog> {
  AppState state;
  String error = '';
  bool status = false;

  TextEditingController date;
  TextEditingController time;
  TextEditingController response = new TextEditingController();

  void initState() {
    super.initState();
    state = Provider.of<AppState>(context, listen: false);
    date = new TextEditingController(text: state.formatDate(DateTime.now()));
    time = new TextEditingController(
        text: state
            .formatTime(new DateFormat('HH:mm:ss').format(DateTime.now())));
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
        backgroundColor: Colors.deepOrangeAccent,
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
                    'Did urination occur?',
                    style: new TextStyle(color: Colors.grey),
                  ),
                  value: null,
                  items: [
                    new DropdownMenuItem(
                        child: new Text(
                          'YES',
                          style: new TextStyle(color: Colors.grey),
                        ),
                        value: 'YES'),
                    new DropdownMenuItem(
                        child: new Text(
                          'NO',
                          style: new TextStyle(color: Colors.grey),
                        ),
                        value: 'NO'),
                  ],
                  onChanged: (v) {
                    setState(() {
                      response.text = v;
                    });
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
              new Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(top: 20),
                child: new MaterialButton(
                  onPressed: () {
                    submit();
                  },
                  padding: EdgeInsets.only(top: 15, bottom: 15),
                  color: Colors.deepOrangeAccent,
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
        context, 'create-foster-urination/' + state.foster['id'].toString(), {
      'date': date.text,
      'time': time.text,
      'response': response.text,
    }).then((data) {
      var body = jsonDecode(data.body);
      if (data.statusCode == 200 && body['status']) {
        state.notifyToastSuccess(context: context, message: body['message']);
        Navigator.pop(context);
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
