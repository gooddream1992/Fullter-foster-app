import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:foster_logger/store/index.dart';
import 'dart:convert';
import 'package:foster_logger/pages/reset-password.dart';

class EnterCode extends StatefulWidget {
  @override
  _EnterCode createState() => new _EnterCode();
}

class _EnterCode extends State<EnterCode> {
  AppState state;
  String country = '';
  String error = '';
  bool status = false;
  List countries = [];

  TextEditingController code = new TextEditingController();

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
                  'ENTER CODE',
                  style: new TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.w500,
                      color: Colors.green),
                  textAlign: TextAlign.center,
                ),
                margin: EdgeInsets.only(bottom: 10),
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
                      hintText: 'Enter Code',
                      contentPadding: EdgeInsets.only(top: 10)),
                  controller: code,
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
                      : new Text('VERIFY',
                          style: new TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }

  void submit() {
    if (code.text.length == 0) {
      state.notifyToast(
          context: context, message: "Please fill the required fields");
    }

    setState(() {
      status = true;
    });

    String email = state.sp.getString('email');

    state.post('verify-code', {'code': code.text, 'email': email}).then((data) {
      var body = jsonDecode(data.body);
      print(body);
      if (data.statusCode == 422) {
        Map<String, dynamic> response = jsonDecode(data.body);
        Map<String, dynamic> errors = response['errors'];
        state.notifyToastDanger(
            context: context, message: errors.values.toList()[0][0]);
      } else if (data.statusCode == 200 && body['status']) {
        state.notifyToastSuccess(
            context: context, message: 'Verification code has been verified');

        state.sp.setString('code', code.text);

        Navigator.push(context,
            MaterialPageRoute(builder: (context) => new ResetPassword()));
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
