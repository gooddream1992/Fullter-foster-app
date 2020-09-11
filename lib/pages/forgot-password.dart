import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:foster_logger/store/index.dart';
import 'dart:convert';
import 'package:foster_logger/pages/enter-code.dart';

class FORGOTPASSWORD extends StatefulWidget {
  @override
  _FORGOTPASSWORD createState() => new _FORGOTPASSWORD();
}

class _FORGOTPASSWORD extends State<FORGOTPASSWORD> {
  AppState state;
  String country = '';
  String error = '';
  bool status = false;
  List countries = [];

  TextEditingController email = new TextEditingController();

  void initState() {
    super.initState();
    state = Provider.of<AppState>(context, listen: false);
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
                  'FORGOT PASSWORD',
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
                  'EXISTING ACCOUNT',
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
                      hintText: 'Email Address',
                      contentPadding: EdgeInsets.only(top: 10)),
                  controller: email,
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
                      : new Text('SEND MAIL',
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
    if (email.text.length == 0) {
      state.notifyToast(
          context: context, message: "Please fill the required fields");
    }

    setState(() {
      status = true;
    });

    state.post('send-code', {
      'email': email.text,
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
            context: context,
            message: 'Verification code has been sent to your mail');
        state.sp.setString('email', email.text);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => new EnterCode()));
      } else {
        state.notifyToastDanger(context: context, message: body['message']);
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
