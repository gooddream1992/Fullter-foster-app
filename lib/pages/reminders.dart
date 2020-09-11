import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:foster_logger/store/index.dart';
import 'dart:convert';
import 'package:foster_logger/pages/reminder.dart';

class ListReminders extends StatefulWidget {
  @override
  _ListReminders createState() => new _ListReminders();
}

class _ListReminders extends State<ListReminders> {
  String error = '';
  bool status = false;
  AppState state;
  List reminders = [];

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void initState() {
    super.initState();
    state = Provider.of<AppState>(context, listen: false);

    String data = state.sp.getString('reminders');
    if (data != null) {
      setState(() {
        reminders = jsonDecode(data);
        reminders = new List.from(reminders.reversed);
      });
      print(reminders);
    }
  }

  void initialiseNotification() async {
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    var initializationSettingsAndroid =
        AndroidInitializationSettings('ic_launcher');
    var initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
  }

  Future onDidReceiveLocalNotification(a, b, c, d) async {}
  Future selectNotification(a) async {}

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
            child: reminders.length == 0
                ? new Container(
                    child: new Center(
                      child: new Text('No Reminder was found'),
                    ),
                  )
                : new ListView.builder(
                    itemCount: reminders.length,
                    itemBuilder: (context, i) {
                      return Container(
                        margin: EdgeInsets.only(top: 10),
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            new Row(
                              children: [
                                new Container(
                                  width: 50,
                                  height: 50,
                                  decoration: new BoxDecoration(
                                      color: Colors.red,
                                      borderRadius:
                                          new BorderRadius.circular(100)),
                                  child: new Icon(
                                    Icons.alarm,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                  margin: EdgeInsets.only(right: 10),
                                ),
                                new Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    new Container(
                                      child: new Text(reminders[i]['note'],
                                          style: new TextStyle(
                                              color: Colors.black,
                                              fontSize: 17)),
                                      margin: EdgeInsets.only(bottom: 5),
                                    ),
                                    new Text(
                                        reminders[i]['date'] +
                                            ' ' +
                                            reminders[i]['time'].split('.')[0],
                                        style: new TextStyle(
                                            color: Colors.grey, fontSize: 14))
                                  ],
                                )
                              ],
                            ),
                            new IconButton(
                                icon: new Icon(
                                  Icons.cancel,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  removeReminder(reminders[i]['id']);
                                })
                          ],
                        ),
                      );
                    })),
      )),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => new AddReminder()));
        },
        backgroundColor: Colors.red,
        child: new Icon(Icons.add),
      ),
    );
  }

  void removeReminder(id) {
    String data = state.sp.getString('reminders');
    List list = [];
    if (data != null) {
      list = jsonDecode(data);
      list = list
          .where((element) => element['id'].toString() != id.toString())
          .toList();
      setState(() {
        reminders = list;
      });

      state.sp.setString('reminders', jsonEncode(list));
      deleteNotify(id);
      state.notifyToastSuccess(
          context: context, message: 'Reminder has been removed successfully');
    }
  }

  void deleteNotify(id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }
}
