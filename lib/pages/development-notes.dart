import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:foster_logger/store/index.dart';
import 'package:foster_logger/pages/add-feeding.dart';
import 'package:foster_logger/pages/add-development.dart';
import 'dart:convert';

class DevelopmentNote extends StatefulWidget {
  @override
  _DevelopmentNote createState() => new _DevelopmentNote();
}

class _DevelopmentNote extends State<DevelopmentNote> {
  AppState state;
  String error = '';
  bool status = false;

  List<String> headers = ['DATE', 'TYPE'];
  List items = [];
  String nextPage = '';
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void initState() {
    super.initState();
    state = Provider.of<AppState>(context, listen: false);
    getItems(state.endpoint +
        "get-foster-development/" +
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
          title: new Text('DEVELOPMENT NOTES (' + state.foster['name'] + ')',
              style: new TextStyle(fontSize: 17)),
          backgroundColor: Colors.purpleAccent),
      body: new SafeArea(
        child: new SingleChildScrollView(
          child: new Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            margin: EdgeInsets.only(top: 20),
            padding: EdgeInsets.only(bottom: 85, left: 10, right: 10),
            child: new SmartRefresher(
              controller: _refreshController,
              enablePullUp: true,
              enablePullDown: true,
              child: new SingleChildScrollView(
                child: new Container(
                  child: new Table(
                    children: data,
                  ),
                  width: MediaQuery.of(context).size.width - 20,
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
                    "get-foster-development/" +
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
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => new AddDevelopment()));
        },
        backgroundColor: Colors.purpleAccent,
        child: new Icon(Icons.add),
      ),
    );
  }

  makeTable() {
    List<TableRow> data = [];
    data.add(new TableRow(
        children: headers.map((e) {
      return new TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: new Container(
          padding: EdgeInsets.only(top: 10, bottom: 10),
          child: new Center(
            child: new Text(
              e,
              style: new TextStyle(
                  color: Colors.purpleAccent, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ),
          decoration: new BoxDecoration(
              color: Colors.purpleAccent.withOpacity(0.3),
              border: new Border.all(color: Colors.grey)),
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
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: new Text(
                    item['date_r'],
                    style: new TextStyle(fontSize: 15, color: Colors.black54),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.clip,
                  ),
                  decoration: new BoxDecoration(
                      border:
                          new Border(left: new BorderSide(color: Colors.grey))),
                )),
            new TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: new Container(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: new Text(
                    item['note'],
                    style: new TextStyle(fontSize: 15, color: Colors.black54),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.clip,
                  ),
                  decoration: new BoxDecoration(
                      border:
                          new Border(left: new BorderSide(color: Colors.grey))),
                )),
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
