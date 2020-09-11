import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:foster_logger/pages/add-urination.dart';
import 'package:provider/provider.dart';
import 'package:foster_logger/store/index.dart';
import 'dart:convert';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class Urination extends StatefulWidget {
  @override
  _Urination createState() => new _Urination();
}

class _Urination extends State<Urination> {
  AppState state;
  String error = '';
  bool status = false;
  Color color = Colors.green.withOpacity(0.6);
  List<String> headers = ['Date', 'Time', 'Yes/No'];
  List items = [];
  String nextPage = '';
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void initState() {
    super.initState();
    state = Provider.of<AppState>(context, listen: false);
    getItems(state.endpoint +
        "get-foster-urination/" +
        state.foster['id'].toString() +
        "?token=" +
        state.token);
  }

  @override
  Widget build(BuildContext context) {
    List<TableRow> data = makeTable();

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
          'URINATION LOG (' + state.foster['name'] + ')',
          style: new TextStyle(fontSize: 17),
        ),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: new SafeArea(
          child: new SingleChildScrollView(
        child: new Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          margin: EdgeInsets.only(top: 20),
          padding: EdgeInsets.only(bottom: 85, left: 0, right: 0),
          child: new SmartRefresher(
            controller: _refreshController,
            enablePullUp: true,
            enablePullDown: true,
            child: new SingleChildScrollView(
              child: new Container(
                child: new Table(
                  children: data,
                ),
                width: MediaQuery.of(context).size.width,
                margin:
                    EdgeInsets.only(left: 0, top: 20, right: 10, bottom: 10),
              ),
              scrollDirection: Axis.horizontal,
            ),
            footer: new CustomFooter(
              builder: (BuildContext context, LoadStatus mode) {
                Widget body;
                if (mode == LoadStatus.idle && mode != LoadStatus.noMore) {
                  body = Text("Lift the load");
                } else if (mode == LoadStatus.loading) {
                  body = CupertinoActivityIndicator();
                } else if (mode == LoadStatus.failed) {
                  body = Text("Load Failed! Click Retry!");
                } else if (mode == LoadStatus.canLoading) {
                  body = Text("Release to load more");
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
                  "get-foster-urination/" +
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
              MaterialPageRoute(builder: (context) => new AddUrinationLog()));
        },
        backgroundColor: Colors.deepOrangeAccent,
        child: new Icon(Icons.add),
      ),
    );
  }

  List makeTable() {
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
                  color: Colors.deepOrangeAccent, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ),
          decoration: new BoxDecoration(
              color: Colors.deepOrangeAccent.withOpacity(0.3),
              border: new Border.all(color: Colors.black12)),
          padding: EdgeInsets.only(top: 10, bottom: 10),
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
                  child: new Text(
                    item['date_r'],
                    style: new TextStyle(fontSize: 15, color: Colors.black54),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.clip,
                  ),
                  decoration: new BoxDecoration(
                      border:
                          new Border(left: new BorderSide(color: Colors.grey))),
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                )),
            new TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: new Container(
                  child: new Text(
                    state.formatTime(item['time']),
                    style: new TextStyle(fontSize: 15, color: Colors.black54),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.clip,
                  ),
                  decoration: new BoxDecoration(
                      border:
                          new Border(left: new BorderSide(color: Colors.grey))),
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                )),
            new TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: new Container(
                  child: new Text(
                    item['response'],
                    style: new TextStyle(fontSize: 15, color: Colors.black54),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.clip,
                  ),
                  decoration: new BoxDecoration(
                      border:
                          new Border(left: new BorderSide(color: Colors.grey))),
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                ))
          ].toList());
    }).toList());
    return data;
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
}
