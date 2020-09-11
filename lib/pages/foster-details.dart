import 'package:flutter/material.dart';
import 'package:foster_logger/pages/homepage.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:provider/provider.dart';
import 'package:foster_logger/store/index.dart';
import 'dart:convert';

class FosterDetailsPage extends StatefulWidget {
  @override
  _FosterDetailsPage createState() => new _FosterDetailsPage();
}

class _FosterDetailsPage extends State<FosterDetailsPage> {
  AppState state;
  String error = '';
  bool status = false;

  TextEditingController intakeDate;
  TextEditingController exitDate;
  TextEditingController agency = new TextEditingController();
  TextEditingController note = new TextEditingController();

  void initState() {
    super.initState();
    state = Provider.of<AppState>(context, listen: false);
    intakeDate =
        new TextEditingController(text: state.formatDate(DateTime.now()));
    exitDate =
        new TextEditingController(text: state.formatDate(DateTime.now()));
    if (state.foster['agency'] != null) {
      agency.text = state.foster['agency'];
    }
    if (state.foster['arrival_date'] != null) {
      intakeDate.text = state.foster['arrival_date'];
    }
    if (state.foster['departure_date'] != null) {
      exitDate.text = state.foster['departure_date'];
    }
    if (state.foster['note'] != null) {
      note.text = state.foster['note'];
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
        title: new Text("FOSTER DETAILS (" + state.foster['name'] + ")"),
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
                height: 50,
                margin: EdgeInsets.only(top: 10),
                child: new TextFormField(
                  decoration: new InputDecoration(
                      prefixIcon: Icon(Icons.account_circle,
                          color: Colors.grey.withOpacity(0.7)),
                      focusedBorder: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.orange)),
                      enabledBorder: new OutlineInputBorder(
                          borderSide: new BorderSide(
                              color: Colors.grey.withOpacity(0.3))),
                      labelText: "Where is " +
                          state.foster['name'].toString() +
                          " from?",
                      contentPadding: EdgeInsets.only(top: 10)),
                  controller: agency,
                ),
              ),
              new Container(
                margin: EdgeInsets.only(top: 10),
                child: new GestureDetector(
                  child: new TextFormField(
                    decoration: new InputDecoration(
                      contentPadding: EdgeInsets.all(18),
                      labelStyle: new TextStyle(color: Colors.grey),
                      labelText: 'Intake Date',
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
                    controller: intakeDate,
                    readOnly: true,
                    onTap: () {
                      showDate(1);
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
                      labelText: 'Exit Date',
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
                    controller: exitDate,
                    readOnly: true,
                    onTap: () {
                      showDate(2);
                    },
                  ),
                ),
              ),
              new Container(
                margin: EdgeInsets.only(top: 10),
                child: new TextFormField(
                  maxLines: 5,
                  decoration: new InputDecoration(
                      enabledBorder: new OutlineInputBorder(
                          borderSide: new BorderSide(
                              color: Colors.grey.withOpacity(0.4))),
                      focusedBorder: new OutlineInputBorder(
                          borderSide: new BorderSide(
                        color: Colors.grey.withOpacity(0.4),
                      )),
                      labelText: 'Add a note ',
                      labelStyle:
                          new TextStyle(color: Colors.grey, fontSize: 15),
                      alignLabelWithHint: true),
                  controller: note,
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

  void showDate(type) {
    DatePicker.showDatePicker(context,
        showTitleActions: true,
        minTime: DateTime(1900, 1, 1),
        maxTime: DateTime(new DateTime.now().year, 12, 31), onConfirm: (date) {
      if (type == 1) {
        this.intakeDate.text = date.toString().split(' ')[0];
      } else {
        this.exitDate.text = date.toString().split(' ')[0];
      }
    }, currentTime: DateTime.now(), locale: LocaleType.en);
  }

  void submit() {
    setState(() {
      status = true;
    });

    state.postAuth(context, 'foster-details/' + state.foster['id'].toString(), {
      'agency': agency.text,
      'intake': intakeDate.text,
      'exit': exitDate.text,
      'note': note.text,
    }).then((data) {
      var body = jsonDecode(data.body);
      if (data.statusCode == 200 && body['status']) {
        state.notifyToastSuccess(
            context: context, message: 'Foster was updated successful');
        state.foster = body['data'];
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
