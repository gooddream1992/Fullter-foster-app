import 'package:flutter/material.dart';
import 'package:foster_logger/pages/create-account.dart';
import 'package:foster_logger/pages/forgot-password.dart';
import 'package:foster_logger/pages/option.dart';
import 'package:foster_logger/store/index.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

class LoginPage extends StatefulWidget {
  @override
  _LoginPage createState() => new _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  AppState state;
  String error = '';
  bool status = false;

  TextEditingController username = new TextEditingController();
  TextEditingController password = new TextEditingController();

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
                    width: 250,
                    child: new Text(
                      'WELCOME TO FOSTER LOGGER',
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
                        color: Colors.pinkAccent.withOpacity(0.2),
                        borderRadius: new BorderRadius.circular(10)),
                  ),
                  new Container(
                    margin: EdgeInsets.only(bottom: 20, top: 10),
                    child: new Text(
                      'EXISTING ACCOUNT',
                      style: new TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  ),
                  new Container(
                    child: new TextFormField(
                      decoration: new InputDecoration(
                          prefixIcon: Icon(Icons.person,
                              color: Colors.grey.withOpacity(0.7)),
                          focusedBorder: new OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.orange)),
                          enabledBorder: new OutlineInputBorder(
                              borderSide: new BorderSide(
                                  color: Colors.grey.withOpacity(0.3))),
                          hintText: 'Username'),
                      controller: username,
                    ),
                  ),
                  new Container(
                    margin: EdgeInsets.only(top: 20),
                    child: new TextFormField(
                      decoration: new InputDecoration(
                          prefixIcon: Icon(Icons.lock,
                              color: Colors.grey.withOpacity(0.7)),
                          focusedBorder: new OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.orange)),
                          enabledBorder: new OutlineInputBorder(
                              borderSide: new BorderSide(
                                  color: Colors.grey.withOpacity(0.3))),
                          hintText: 'Password'),
                      controller: password,
                      obscureText: true,
                    ),
                  ),
                  new Container(
                    margin: EdgeInsets.only(top: 10),
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        new GestureDetector(
                          child: new Text(
                            'Forgot Password?',
                            style: new TextStyle(
                                color: Colors.black54,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        new FORGOTPASSWORD()));
                          },
                        )
                      ],
                    ),
                  ),
                  new Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(top: 20),
                    child: new MaterialButton(
                      onPressed: () {
                        login();
                      },
                      padding: EdgeInsets.only(top: 15, bottom: 15),
                      shape: StadiumBorder(),
                      color: Colors.pinkAccent,
                      child: status
                          ? new CircularProgressIndicator(
                              backgroundColor: Colors.white,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.orange),
                              strokeWidth: 2)
                          : new Text('LOG IN',
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
                                "CREATE NEW ACCOUNT",
                                style: new TextStyle(
                                    color: Colors.pinkAccent,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400),
                              ),
//                              new Text("SIGN UP",style: new TextStyle(color: Colors.pinkAccent,fontSize: 15,fontWeight: FontWeight.w400),)
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        new CreateAccountPage()));
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
        ),
        onWillPop: () => Future.value(false));
  }

  void login() {
    setState(() {
      status = true;
    });

    if (username.text.length == 0 || password.text.length == 0) {
      state.notifyToast(
          context: context, message: "Please fill the required fields");
    }

    state.post('login', {
      'username': username.text,
      'password': password.text,
    }).then((data) {
      var body = jsonDecode(data.body);
      if (data.statusCode == 200 && body['status']) {
        state.sp.setString('user', jsonEncode(body['user']));
        state.sp.setString('token', jsonEncode(body['token']));
        state.user = body['user'];
        state.token = body['token'];
        setState(() {
          status = false;
        });
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => new OptionPages()));
      } else {
        setState(() {
          status = false;
        });
        if (!body['status']) {
          state.notifyToastDanger(context: context, message: body['message']);
        } else {
          state.notifyToastDanger(
              context: context, message: "Error occured while loggin in");
        }
      }
    }).catchError((error) {
      print(error);
      setState(() {
        status = false;
      });
    });
  }
}
