import 'package:flutter/material.dart';
import 'package:foster_logger/pages/defecation-image.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:foster_logger/store/index.dart';
import 'dart:convert';
import 'package:foster_logger/pages/add-defecation.dart';

class Defecation extends StatefulWidget {
  @override
  _Defecation createState() => new _Defecation();
}

class _Defecation extends State<Defecation> {
  AppState state;
  String error = '';
  bool status = false;
  Color color = Colors.green.withOpacity(0.6);
  List<String> headers = ['Date', 'Time', 'Type'];
  List items = [];
  String nextPage = '';
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void initState() {
    super.initState();
    state = Provider.of<AppState>(context, listen: false);
    getItems(state.endpoint +
        "get-foster-defecation/" +
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
        title: new Text('DEFECATION LOG'),
        backgroundColor: Colors.lightGreen,
      ),
      body: new SafeArea(
          child: new SingleChildScrollView(
        child: new Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          margin: EdgeInsets.only(top: 20),
          child: new Column(
            children: [
              new Container(
                child: new MaterialButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new DefecationImage()));
                  },
                  padding:
                      EdgeInsets.only(top: 5, bottom: 5, left: 25, right: 25),
                  color: Colors.white,
                  shape: StadiumBorder(),
                  child: new Text('Click here to see the types',
                      style: new TextStyle(color: Colors.black)),
                ),
              ),
              new Flexible(
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
                    margin: EdgeInsets.only(
                        left: 0, top: 20, right: 10, bottom: 10),
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
                      "get-foster-defecation/" +
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
              ))
            ],
          ),
        ),
      )),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => new AddDefecationLog()));
        },
        backgroundColor: Colors.lightGreen,
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
          child: new Center(
            child: new Text(
              e,
              style: new TextStyle(
                  color: Colors.lightGreen, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ),
          decoration: new BoxDecoration(
              color: Colors.lightGreen.withOpacity(0.3),
              border: new Border.all(color: Colors.black)),
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
                    item['type'],
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
