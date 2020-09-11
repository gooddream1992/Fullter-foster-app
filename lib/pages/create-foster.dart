import 'package:flutter/material.dart';
import 'package:foster_logger/pages/homepage.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:provider/provider.dart';
import 'package:foster_logger/store/index.dart';
import 'dart:convert';

class CreateFosterPage extends StatefulWidget {
  @override
  _CreateFosterPage createState() => new _CreateFosterPage();
}

class _CreateFosterPage extends State<CreateFosterPage> {
  AppState state;
  String error = '';
  bool status = false;
  String species = '';

  TextEditingController birthdate = new TextEditingController(text: null);
  TextEditingController name = new TextEditingController();

  void initState() {
    super.initState();
    state = Provider.of<AppState>(context, listen: false);
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
        title: new Text('CREATE A NEW FOSTER'),
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
                child: new TextFormField(
                  decoration: new InputDecoration(
                      prefixIcon: Icon(Icons.account_circle,
                          color: Colors.grey.withOpacity(0.7)),
                      focusedBorder: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.orange)),
                      enabledBorder: new OutlineInputBorder(
                          borderSide: new BorderSide(
                              color: Colors.grey.withOpacity(0.3))),
                      hintText: 'Name',
                      contentPadding: EdgeInsets.only(top: 10)),
                  controller: name,
                ),
              ),
              new Container(
                margin: EdgeInsets.only(top: 15),
                child: new GestureDetector(
                  child: new TextFormField(
                    decoration: new InputDecoration(
                      contentPadding: EdgeInsets.all(18),
                      labelStyle: new TextStyle(color: Colors.grey),
                      labelText: 'Date of Birth',
                      prefixIcon: Icon(Icons.date_range,
                          color: Colors.grey.withOpacity(0.7)),
                      enabledBorder: new OutlineInputBorder(
                        borderSide:
                            new BorderSide(color: Colors.grey.withOpacity(0.3)),
                      ),
                      focusedBorder: new OutlineInputBorder(
                        borderSide:
                            new BorderSide(color: Colors.grey.withOpacity(0.4)),
                      ),
                    ),
                    style: new TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey),
                    controller: birthdate,
                    readOnly: true,
                    onTap: () {
                      showDate();
                    },
                  ),
                ),
              ),
              new Container(
                margin: EdgeInsets.only(top: 15),
                child: new DropdownButtonFormField(
                  hint: new Text(
                    'Species',
                    style: new TextStyle(color: Colors.grey),
                  ),
                  value: null,
                  items: [
                    new DropdownMenuItem(
                        child: new Text(
                          'Cat',
                          style: new TextStyle(color: Colors.grey),
                        ),
                        value: 'Cat'),
                    new DropdownMenuItem(
                        child: new Text(
                          'Dog',
                          style: new TextStyle(color: Colors.grey),
                        ),
                        value: 'Dog'),
                    new DropdownMenuItem(
                        child: new Text(
                          'Other',
                          style: new TextStyle(color: Colors.grey),
                        ),
                        value: 'Other'),
                  ],
                  onChanged: (v) {
                    setState(() {
                      species = v;
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
                  color: Colors.orangeAccent,
                  shape: StadiumBorder(),
                  child: status
                      ? new CircularProgressIndicator(
                          backgroundColor: Colors.white,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.orange),
                          strokeWidth: 2)
                      : new Text('NEXT',
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
      setState(() {
        this.birthdate.text = state.formatDate(date);
      });
    }, currentTime: DateTime.now(), locale: LocaleType.en);
  }

  void submit() {
    if (name.text.length == 0 || species.length == 0) {
      state.notifyToast(
          context: context, message: "Please fill the required fields");
    }

    setState(() {
      status = true;
    });
    print(birthdate.text);
    state.postAuth(context, 'create-foster', {
      'name': name.text,
      'species': species,
      'dob': birthdate.text,
    }).then((data) {
      var body = jsonDecode(data.body);
      if (data.statusCode == 200 && body['status']) {
        state.notifyToast(context: context, message: body['message']);
        state.foster = body['data'];
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
