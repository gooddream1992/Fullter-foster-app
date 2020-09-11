import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:provider/provider.dart';
import 'package:foster_logger/store/index.dart';
import 'package:foster_logger/pages/reminders.dart';
import 'dart:math';
import 'dart:convert';

class AddReminder extends StatefulWidget {
  @override
  _AddReminder createState() => new _AddReminder();
}

class _AddReminder extends State<AddReminder> {
  AppState state;
  String error = '';
  bool status = false;

  TextEditingController date;
  TextEditingController time;
  TextEditingController note = new TextEditingController();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void initState() {
    super.initState();
    state = Provider.of<AppState>(context, listen: false);
    date = new TextEditingController(text: state.formatDate(DateTime.now()));
    time = new TextEditingController(
        text: state
            .formatTime(new DateFormat('HH:mm:ss').format(DateTime.now())));
    initialiseNotification();
  }

  void initialiseNotification() async {
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    var initializationSettingsAndroid =
        AndroidInitializationSettings('mipmap/ic_launcher');
    var initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
  }

  Future onDidReceiveLocalNotification(a, b, c, d) {
    print(a);
    print(b);
    print(c);
    print(d);
  }

  Future selectNotification(a) {
    String data = state.sp.getString('reminders');
    List list = [];
    if (data != null) {
      list = jsonDecode(data);
    }
    list = list.where((element) => element['id'].toString() != a).toList();
    state.sp.setString('reminders', jsonEncode(list));
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
        title: new Text('REMINDER ' + state.foster['name']),
        backgroundColor: Colors.red,
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
                child: new TextFormField(
                  decoration: new InputDecoration(
                      prefixIcon: Icon(Icons.linear_scale,
                          color: Colors.grey.withOpacity(0.7)),
                      focusedBorder: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.orange)),
                      enabledBorder: new OutlineInputBorder(
                          borderSide: new BorderSide(
                              color: Colors.grey.withOpacity(0.3))),
                      hintText: 'Label',
                      contentPadding: EdgeInsets.only(top: 10)),
                  controller: note,
                ),
              ),
              new Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(top: 20),
                child: new MaterialButton(
                  onPressed: () {
                    addReminder();
                  },
                  padding: EdgeInsets.only(top: 15, bottom: 15),
                  color: Colors.red,
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

  void addReminder() {
    if (date.text.length == 0 ||
        time.text.length == 0 ||
        note.text.length == 0) {
      state.notifyToastDanger(
          context: context, message: 'All fields are required');
    }
    saveReminder();
  }

  void saveReminder() {
    String data = state.sp.getString('reminders');
    List list = [];
    if (data != null) {
      list = jsonDecode(data);
    }
    int id = Random().nextInt(1000);
    list.add({
      'id': id,
      'foster_id': state.foster['id'],
      'note': note.text,
      'date': this.date.text.toString(),
      'time': this.time.text.toString(),
    });

    state.sp.setString('reminders', jsonEncode(list));
    List date = this.date.text.toString().split('-');
    List time = this.time.text.toString().split('.')[0].split(':');

    date = date.map((e) => int.parse(e)).toList();
    time = time.map((e) => int.parse(e)).toList();

    notify(id, date, time);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => new ListReminders()));
  }

  void notify(id, date, time) async {
//  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
//      'your channel id', 'your channel name', 'your channel description',
//      importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
//  var iOSPlatformChannelSpecifics = IOSNotificationDetails();
//  var platformChannelSpecifics = NotificationDetails(
//      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
//  await flutterLocalNotificationsPlugin.show(id , 'plain title', 'plain body', platformChannelSpecifics,
//      payload: 'item x');

    var current = DateTime.now();
    var tym = DateTime(date[0], date[1], date[2], time[0], time[1]);
//    print(tym.difference(current).inMinutes);

    var scheduledNotificationDateTime = DateTime.now()
        .add(Duration(minutes: tym.difference(current).inMinutes));
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'foster', 'foster', 'fosterapp',
        importance: Importance.Max,
        priority: Priority.High,
        ticker: 'ticker',
        playSound: true,
        icon: 'ic_launcher');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();

    NotificationDetails platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
      id,
      state.foster['name'],
      note.text,
      scheduledNotificationDateTime,
      platformChannelSpecifics,
      payload: id.toString(),
    );

    state.notifyToast(
        context: context, message: 'Reminder was set successfully');
    setState(() {
      this.date.text = '';
      this.time.text = '';
      this.note.text = '';
    });
  }
}
