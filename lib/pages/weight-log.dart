import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:foster_logger/pages/add-weight.dart';
import 'package:foster_logger/pages/edit-weight.dart';
import 'package:provider/provider.dart';
import 'package:foster_logger/store/index.dart';
import 'dart:convert';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class WeightLog extends StatefulWidget {
  @override
  _WeightLog createState() => new _WeightLog();
}

class _WeightLog extends State<WeightLog> {
  AppState state;
  String error = '';
  bool status = false;
  Color color = Colors.green.withOpacity(0.6);
  List<String> headers = [
    'Date',
    'Time',
    'Pre Food',
    'Post Food',
    'u/m',
    'Del/Edit'
  ];
  List items = [];
  String nextPage = '';
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void initState() {
    super.initState();
    state = Provider.of<AppState>(context, listen: false);
    getItems(state.endpoint +
        "get-foster-weight/" +
        state.foster['id'].toString() +
        "?token=" +
        state.token);
  }

  @override
  Widget build(BuildContext context) {
    List<TableRow> data = [];
    data.add(new TableRow(
        children: headers.map((e) {
      return new TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: new Container(
          child: new Center(
            child: new Text(
              e,
              style: new TextStyle(
                  fontSize: 12,
                  color: Colors.pinkAccent,
                  fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ),
          decoration: new BoxDecoration(
              color: Colors.pinkAccent.withOpacity(0.3),
              border: new Border.all(color: Colors.black12)),
          padding: EdgeInsets.only(top: 15, bottom: 15),
        ),
      );
    }).toList()));
    data.addAll(items.map((item) {
      return new TableRow(
          decoration: new BoxDecoration(
              border: new Border(
                  bottom: new BorderSide(color: Colors.grey),
                  right: new BorderSide(color: Colors.grey))),
          children: [
            new TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: new Container(
                  child: new Center(
                    child: new Text(
                      item['date_r'],
                      style: new TextStyle(fontSize: 13, color: Colors.black54),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.clip,
                    ),
                  ),
                  decoration: new BoxDecoration(
                      border:
                          new Border(left: new BorderSide(color: Colors.grey))),
                )),
            new TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: new Container(
                  child: new Center(
                    child: new Text(
                      state.formatTime(item['time']),
                      style: new TextStyle(fontSize: 13, color: Colors.black54),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.clip,
                    ),
                  ),
                  decoration: new BoxDecoration(
                      border:
                          new Border(left: new BorderSide(color: Colors.grey))),
                  padding: EdgeInsets.only(top: 15, bottom: 15),
                )),
            new TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: new Container(
                  child: new Center(
                    child: new Text(
                      item['pre_weight'],
                      style: new TextStyle(fontSize: 13, color: Colors.black54),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.clip,
                    ),
                  ),
                  decoration: new BoxDecoration(
                      border:
                          new Border(left: new BorderSide(color: Colors.grey))),
                  padding: EdgeInsets.only(top: 15, bottom: 15),
                )),
            new TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: new Container(
                  child: new Center(
                    child: new Text(
                      item['post_weight'],
                      style: new TextStyle(fontSize: 13, color: Colors.black54),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.clip,
                    ),
                  ),
                  decoration: new BoxDecoration(
                      border:
                          new Border(left: new BorderSide(color: Colors.grey))),
                  padding: EdgeInsets.only(top: 15, bottom: 15),
                )),
            new TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: new Container(
                  child: new Center(
                    child: new Text(
                      item['u_m'],
                      style: new TextStyle(fontSize: 13, color: Colors.black54),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.clip,
                    ),
                  ),
                  decoration: new BoxDecoration(
                      border:
                          new Border(left: new BorderSide(color: Colors.grey))),
                  padding: EdgeInsets.only(top: 15, bottom: 15),
                )),
            new TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: new Container(
                  child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: new IconButton(
                              icon: new Icon(
                                Icons.cancel,
                                color: Colors.red,
                                size: 15,
                              ),
                              onPressed: () {
                                removeWeightLog(item['id']);
                              }),
                        ),
                        Expanded(
                          child: new IconButton(
                              icon: new Icon(
                                Icons.edit,
                                color: Colors.blue,
                                size: 15,
                              ),
                              onPressed: () {
                                state.weight = item;
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            new EditWeightLog()));
                              }),
                        ),
                      ]),
                  decoration: new BoxDecoration(
                      border:
                          new Border(left: new BorderSide(color: Colors.grey))),
                )),
          ].toList());
    }).toList());

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
        title: new Text(
          'WEIGHT LOG (' + state.foster['name'] + ')',
          style: new TextStyle(fontSize: 17),
        ),
        backgroundColor: Colors.pink,
      ),
      body: new SafeArea(
          child: new SingleChildScrollView(
        child: new Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          margin: EdgeInsets.only(top: 20),
          padding: EdgeInsets.only(bottom: 85),
          child: new SmartRefresher(
            controller: _refreshController,
            enablePullUp: true,
            enablePullDown: true,
            child: new SingleChildScrollView(
              child: new Container(
                child: new Table(
                  children: data,
                ),
                width: 600,
                margin: EdgeInsets.only(top: 20, bottom: 10),
              ),
            ),
            footer: new CustomFooter(
              builder: (BuildContext context, LoadStatus mode) {
                Widget body;
                if (mode == LoadStatus.idle && mode != LoadStatus.noMore) {
                  body = Text("Pull up load");
                } else if (mode == LoadStatus.loading) {
                  body = CupertinoActivityIndicator();
                } else if (mode == LoadStatus.failed) {
                  body = Text("Load Failed! Click Retry!");
                } else if (mode == LoadStatus.canLoading) {
                  body = Text("release to load more");
                }
                if (nextPage == null) {
                  body = Text("There is no more data");
                }
                return Container(
                  height: 55.0,
                  child: Center(child: body),
                );
              },
            ),
            onRefresh: () {
              setState(() {
                items = [];
              });
              getItems(state.endpoint +
                  "get-foster-weight/" +
                  state.foster['id'].toString() +
                  "?token=" +
                  state.token);
            },
            onLoading: () {
              if (nextPage == null) {
                _refreshController.loadNoData();
              } else {
                getItems(nextPage + '&token=' + state.token);
              }
            },
          ),
        ),
      )),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => new AddWeightLog()));
        },
        backgroundColor: Colors.pinkAccent,
        child: new Icon(Icons.add),
      ),
    );
  }

  void getItems(url) {
    if (items.length == 0) {
      setState(() {
        status = true;
      });
    }
    state.get(url).then((value) {
      var body = jsonDecode(value.body);
      setState(() {
        items.addAll(body['data']);
        nextPage = body['nextPage_url'];
        status = false;
      });
      _refreshController.refreshCompleted();
      _refreshController.loadComplete();
    }).catchError((error) {
      print(error);
      setState(() {
        status = false;
      });
    });
  }

  void yesOnPressed(id) {
    state.postAuth(context, 'delete-foster-weight/' + id.toString(),
        {'foster_id': state.foster['id'].toString()}).then((data) {
      var body = jsonDecode(data.body);
      if (data.statusCode == 200 && body['status']) {
        state.notifyToast(context: context, message: body['message']);
        setState(() {
          items = [];
        });
        getItems(state.endpoint +
            "get-foster-weight/" +
            state.foster['id'].toString() +
            "?token=" +
            state.token);
      } else if (data.statusCode != 422) {
        state.notifyToastDanger(
            context: context,
            message: "Error occured while deleting weight log");
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

  void removeWeightLog(id) {
    Future<ConfirmAction> asyncConfirmDialog(BuildContext context) async {
      return showDialog<ConfirmAction>(
        context: context,
        barrierDismissible: false, // user must tap button for close dialog!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Are you sure?'),
            content: const Text(
                'This will permanently delete the weight log you selected.'),
            actions: <Widget>[
              FlatButton(
                child: const Text('No'),
                onPressed: () {
                  Navigator.of(context).pop(ConfirmAction.CANCEL);
                },
              ),
              FlatButton(
                child: const Text('Yes'),
                onPressed: () {
                  yesOnPressed(id);
                  Navigator.of(context).pop(ConfirmAction.ACCEPT);
                },
              )
            ],
          );
        },
      );
    }

    asyncConfirmDialog(context);
  }
}
