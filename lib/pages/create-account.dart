import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:foster_logger/store/index.dart';
import 'dart:convert';

class CreateAccountPage extends StatefulWidget {
  @override
  _CreateAccountPage createState() => new _CreateAccountPage();
}

class _CreateAccountPage extends State<CreateAccountPage> {
  TextEditingController email = new TextEditingController();
  TextEditingController username = new TextEditingController();
  TextEditingController postal = new TextEditingController();
  TextEditingController password = new TextEditingController();

  AppState state;
  String country = '';
  String error = '';
  bool status = false;
  List countries = [];

  void initState() {
    super.initState();
//    email.text='highdee.ai@gmail.com';
//    username.text='highdee';
//    postal.text='23435';
//    password.text='secret';

    state = Provider.of<AppState>(context, listen: false);

    state.loadInterestJsonFile('data/countries.json').then((value) {
      setState(() {
        countries = jsonDecode(value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
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
                child: new Text(
                  'CREATE NEW ACCOUNT',
                  style: new TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.w500,
                      color: Colors.green),
                  textAlign: TextAlign.center,
                ),
                margin: EdgeInsets.only(bottom: 10),
              ),
              new Container(
                child: new Image.asset('assets/images/logo without bg.png',
                    scale: 6),
                width: 160,
                decoration: new BoxDecoration(
                    borderRadius: new BorderRadius.circular(10)),
              ),
              new Container(
                margin: EdgeInsets.only(bottom: 20, top: 10),
                child: new Text(
                  'NEW ACCOUNT',
                  style: new TextStyle(color: Colors.black, fontSize: 18),
                ),
              ),
              new Container(
                height: 50,
                child: new TextFormField(
                  decoration: new InputDecoration(
                      prefixIcon: Icon(Icons.account_circle,
                          color: Colors.grey.withOpacity(0.7)),
                      focusedBorder: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.orange)),
                      enabledBorder: new OutlineInputBorder(
                          borderSide: new BorderSide(
                              color: Colors.grey.withOpacity(0.3))),
                      hintText: 'USERNAME',
                      contentPadding: EdgeInsets.only(top: 10)),
                  controller: username,
                ),
              ),
              new Container(
                height: 50,
                margin: EdgeInsets.only(top: 10),
                child: new TextFormField(
                  decoration: new InputDecoration(
                      prefixIcon:
                          Icon(Icons.mail, color: Colors.grey.withOpacity(0.7)),
                      focusedBorder: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.orange)),
                      enabledBorder: new OutlineInputBorder(
                          borderSide: new BorderSide(
                              color: Colors.grey.withOpacity(0.3))),
                      hintText: 'EMAIL ADDRESS',
                      contentPadding: EdgeInsets.only(top: 10)),
                  controller: email,
                ),
              ),
              new Container(
                height: 50,
                margin: EdgeInsets.only(top: 10),
                child: new DropdownButtonFormField(
                  hint: new Text('COUNTRY'),
                  value: null,
                  items: countries.map((e) {
                    return new DropdownMenuItem(
                        child: new Text(
                            e['name'].toString().substring(
                                0,
                                e['name'].toString().length > 30
                                    ? 30
                                    : e['name'].toString().length),
                            style: new TextStyle(color: Colors.grey)),
                        value: e['code']);
                  }).toList(),
                  onChanged: (v) {
                    setState(() {
                      country = v;
                    });
                  },
                  decoration: new InputDecoration(
                    contentPadding: EdgeInsets.only(left: 15),
                    prefixIcon:
                        Icon(Icons.map, color: Colors.grey.withOpacity(0.7)),
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
                height: 50,
                margin: EdgeInsets.only(top: 10),
                child: new TextFormField(
                  decoration: new InputDecoration(
                      prefixIcon: Icon(Icons.pin_drop,
                          color: Colors.grey.withOpacity(0.7)),
                      focusedBorder: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.orange)),
                      enabledBorder: new OutlineInputBorder(
                          borderSide: new BorderSide(
                              color: Colors.grey.withOpacity(0.3))),
                      hintText: 'ZIP/POSTAL CODE',
                      contentPadding: EdgeInsets.only(top: 10)),
                  controller: postal,
                ),
              ),
              new Container(
                height: 50,
                margin: EdgeInsets.only(top: 10),
                child: new TextFormField(
                  decoration: new InputDecoration(
                      prefixIcon:
                          Icon(Icons.lock, color: Colors.grey.withOpacity(0.7)),
                      focusedBorder: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.orange)),
                      enabledBorder: new OutlineInputBorder(
                          borderSide: new BorderSide(
                              color: Colors.grey.withOpacity(0.3))),
                      hintText: 'PASSWORD',
                      contentPadding: EdgeInsets.only(top: 10)),
                  controller: password,
                  obscureText: true,
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
                  color: Colors.pinkAccent,
                  shape: StadiumBorder(),
                  child: status
                      ? new CircularProgressIndicator(
                          backgroundColor: Colors.white,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.orange),
                          strokeWidth: 2)
                      : new Text('CREATE ACCOUNT',
                          style: new TextStyle(color: Colors.white)),
                ),
              ),
              new Container(
                margin: EdgeInsets.only(top: 30),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new GestureDetector(
                      child: new Row(
                        children: <Widget>[
                          new Text(
                            "Already have an account? ",
                            style: new TextStyle(
                                color: Colors.black54,
                                fontSize: 15,
                                fontWeight: FontWeight.w400),
                          ),
                          new Text(
                            "SIGN IN",
                            style: new TextStyle(
                                color: Colors.orange,
                                fontSize: 15,
                                fontWeight: FontWeight.w400),
                          )
                        ],
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }

  void submit() {
    if (email.text.length == 0 ||
        password.text.length == 0 ||
        username.text.length == 0 ||
        postal.text.length == 0 ||
        country == 0) {
      state.notifyToast(
          context: context, message: "Please fill the required fields");
    }

    setState(() {
      status = true;
    });

    state.post('create-account', {
      'email': email.text,
      'username': username.text,
      'postal': postal.text,
      'country': country,
      'password': password.text,
    }).then((data) {
      var body = jsonDecode(data.body);
      print(body);
      if (data.statusCode == 422) {
        Map<String, dynamic> response = jsonDecode(data.body);
        Map<String, dynamic> errors = response['errors'];
        state.notifyToastDanger(
            context: context, message: errors.values.toList()[0][0]);
      } else if (data.statusCode == 200 && body['status']) {
        state.notifyToastSuccess(
            context: context, message: 'Your registration was successful');
        Navigator.pop(context);
      } else {
        state.notifyToastDanger(
            context: context, message: "Error occured while creating account");
//        Navigator.push(context, MaterialPageRoute(builder: (context)=> new LoginPage()));
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
