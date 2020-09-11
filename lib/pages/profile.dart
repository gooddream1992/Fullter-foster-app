import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:foster_logger/store/index.dart';
import 'dart:convert';
import 'package:foster_logger/pages/login.dart';

class Profile extends StatefulWidget {
  @override
  _Profile createState() => new _Profile();
}

class _Profile extends State<Profile> {
  AppState state;
  String country = '';
  String error = '';
  bool status = false;
  bool loading = false;
  List countries = [];

  TextEditingController email = new TextEditingController();
  TextEditingController username = new TextEditingController();
  TextEditingController postal = new TextEditingController();
  TextEditingController password = new TextEditingController();
  TextEditingController password2 = new TextEditingController();

  void initState() {
    super.initState();
    state = Provider.of<AppState>(context, listen: false);

    email.text = state.user['email'];
    username.text = state.user['username'];
    postal.text = state.user['postal'];
    country = state.user['country'];

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
      appBar: new AppBar(
        backgroundColor: Colors.pinkAccent,
        title: new Text('MY PROFILE',
            style:
                new TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
            textAlign: TextAlign.center),
      ),
      body: new SafeArea(
          child: new Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.only(left: 20, right: 20),
        child: new SingleChildScrollView(
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
                      contentPadding: EdgeInsets.only(top: 10),
                      enabled: false),
                  controller: email,
                ),
              ),
              new Container(
                height: 50,
                margin: EdgeInsets.only(top: 10),
                child: new DropdownButtonFormField(
                  hint: new Text('COUNTRY'),
                  value: state.user['country'],
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
                    hasFloatingPlaceholder: true,
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
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(top: 30, bottom: 10),
                child: new Text(
                  'CHANGE PASSWORD',
                  style: new TextStyle(fontSize: 16),
                  textAlign: TextAlign.start,
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
                      labelText: 'CURRENT PASSWORD',
                      contentPadding: EdgeInsets.only(top: 10)),
                  controller: password,
                  obscureText: true,
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
                      labelText: 'NEW PASSWORD',
                      contentPadding: EdgeInsets.only(top: 10)),
                  controller: password2,
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
                      : new Text('UPDATE PROFILE',
                          style: new TextStyle(color: Colors.white)),
                ),
              ),
              new Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(top: 20, bottom: 30),
                child: new MaterialButton(
                  onPressed: () {
                    logout();
                  },
                  padding: EdgeInsets.only(top: 15, bottom: 15),
                  color: Colors.white,
                  shape: StadiumBorder(),
                  child: status
                      ? new CircularProgressIndicator(
                          backgroundColor: Colors.pinkAccent,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.orange),
                          strokeWidth: 2)
                      : new Text('Logout',
                          style: new TextStyle(color: Colors.pinkAccent)),
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }

  void logout() {
    state.sp.remove('user');
    state.sp.remove('token');

    state.user = null;
    state.token = null;

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => new LoginPage()));
  }

  void submit() {
    if (email.text.length == 0 ||
        username.text.length == 0 ||
        postal.text.length == 0 ||
        country == 0) {
      state.notifyToast(
          context: context, message: "Please fill the required fields");
    }

    setState(() {
      status = true;
    });

    state.post(
        'update-account/' +
            state.user['id'].toString() +
            '?token=' +
            state.token,
        {
          'email': email.text,
          'username': username.text,
          'postal': postal.text,
          'country': country,
          'password': password.text,
          'new_password': password2.text
        }).then((data) {
      var body = jsonDecode(data.body);
      print(body);
      if (data.statusCode == 422) {
        Map<String, dynamic> response = jsonDecode(data.body);
        Map<String, dynamic> errors = response['errors'];
        state.notifyToastDanger(
            context: context, message: errors.values.toList()[0][0]);
      } else if (data.statusCode == 200 && body['status']) {
        state.sp.setString('user', jsonEncode(body['data']));
        state.user = body['data'];

        if (this.password2.text.length > 0) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => new LoginPage()));
        }
        state.notifyToast(
            context: context, message: 'Your profile was updated successful');
        Navigator.pop(context);
      } else {
        state.notifyToastDanger(context: context, message: body['msg']);
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
