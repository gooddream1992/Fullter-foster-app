import 'package:flutter/material.dart';
import 'package:foster_logger/pages/add-medication.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:foster_logger/store/index.dart';
import 'dart:convert';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MedicationPage extends StatefulWidget {
  @override
  _MedicationPage createState() => new _MedicationPage();
}

class _MedicationPage extends State<MedicationPage>
    with TickerProviderStateMixin {
  AppState state;
  String error = '';
  bool status = false;
  bool status2 = false;
  bool status3 = false;
  Color color = Colors.green.withOpacity(0.6);
  List<String> headers = ['DATE', 'TYPE'];
  String note = 'vaccination';

  String nextPageV = '';
  String nextPageD = '';
  String nextPageO = '';

  TabController _controller;
  TabController _controller2;

  List vaccinations = [];
  List dewormers = [];
  List others = [];

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  RefreshController _refreshController2 =
      RefreshController(initialRefresh: false);
  RefreshController _refreshController3 =
      RefreshController(initialRefresh: false);

  void initState() {
    super.initState();
    state = Provider.of<AppState>(context, listen: false);
    getVaccinations(state.endpoint +
        "get-foster-vaccination/" +
        state.foster['id'].toString() +
        "?token=" +
        state.token);
    getDewormers(state.endpoint +
        "get-foster-dewormer/" +
        state.foster['id'].toString() +
        "?token=" +
        state.token);
    getOthers(state.endpoint +
        "get-foster-other/" +
        state.foster['id'].toString() +
        "?token=" +
        state.token);

    _controller = new TabController(length: 3, vsync: this);
    _controller2 = new TabController(length: 3, vsync: this);

    List notes = ['vaccination', 'dewormer', 'others'];
    _controller.addListener(() {
      setState(() {
        note = notes[_controller.index];
      });
      _controller2.animateTo(_controller.index);
    });
    _controller2.addListener(() {
      setState(() {
        note = notes[_controller2.index];
        _controller.animateTo(_controller2.index);
      });
    });
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
          title: new Text('MEDICATION NOTES '),
          backgroundColor: Colors.purpleAccent),
      body: new SafeArea(
          child: new SingleChildScrollView(
        child: new Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: new DefaultTabController(
              length: 3,
              child: new Container(
                child: new Column(
                  children: [
                    new Container(
                      color: Colors.grey.withOpacity(0.1),
                      child: new TabBar(
                        labelStyle: TextStyle(fontSize: 15),
                        tabs: [
                          new Tab(
                              child: new Text('Vaccinations',
                                  style:
                                      new TextStyle(color: Colors.pinkAccent))),
                          new Tab(
                              child: new Text('Dewormers',
                                  style: new TextStyle(color: Colors.green))),
                          new Tab(
                              child: new Text('Others',
                                  style: new TextStyle(color: Colors.blue))),
                        ],
                        controller: _controller2,
                        indicatorColor: Colors.purple,
                      ),
                    ),
                    new Flexible(
                        child: new TabBarView(
                      children: [
                        new Container(
                          padding: EdgeInsets.only(left: 10, right: 0, top: 10),
                          child: new SmartRefresher(
                            controller: _refreshController,
                            enablePullUp: true,
                            enablePullDown: true,
                            child: new SingleChildScrollView(
                              child: new Container(
                                child: new Table(
                                    children: makeTable(vaccinations, headers)),
                                width: MediaQuery.of(context).size.width - 20,
                                margin: EdgeInsets.only(
                                    left: 0, top: 20, right: 10, bottom: 10),
                              ),
                              scrollDirection: Axis.horizontal,
                            ),
                            footer: new CustomFooter(
                              builder: (BuildContext context, LoadStatus mode) {
                                Widget body;
                                if (mode == LoadStatus.idle &&
                                    mode != LoadStatus.noMore) {
                                  body = Text("Lift the load");
                                } else if (mode == LoadStatus.loading) {
                                  body = CupertinoActivityIndicator();
                                } else if (mode == LoadStatus.failed) {
                                  body = Text("Load Failed! Click Retry!");
                                } else if (mode == LoadStatus.canLoading) {
                                  body = Text("Release to load more");
                                }
                                if (nextPageV == null) {
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
                                vaccinations = [];
                              });
                              getVaccinations(state.endpoint +
                                  "get-foster-vaccination/" +
                                  state.foster['id'].toString() +
                                  "?token=" +
                                  state.token);
                            },
                            onLoading: () {
                              if (nextPageV == null) {
                                _refreshController.loadNoData();
                              } else {
                                getVaccinations(
                                    nextPageV + '&token=' + state.token);
                              }
                            },
                          ),
                        ),
                        new Container(
                          padding: EdgeInsets.only(left: 10, right: 0, top: 10),
                          child: new SmartRefresher(
                            controller: _refreshController2,
                            enablePullUp: true,
                            enablePullDown: true,
                            child: new SingleChildScrollView(
                              child: new Container(
                                child: new Table(
                                    children: makeTable(dewormers, headers)),
                                width: MediaQuery.of(context).size.width - 20,
                                margin: EdgeInsets.only(
                                    left: 0, top: 20, right: 10, bottom: 10),
                              ),
                              scrollDirection: Axis.horizontal,
                            ),
                            footer: new CustomFooter(
                              builder: (BuildContext context, LoadStatus mode) {
                                Widget body;
                                if (mode == LoadStatus.idle &&
                                    mode != LoadStatus.noMore) {
                                  body = Text("Lift the load");
                                } else if (mode == LoadStatus.loading) {
                                  body = CupertinoActivityIndicator();
                                } else if (mode == LoadStatus.failed) {
                                  body = Text("Load Failed! Click Retry!");
                                } else if (mode == LoadStatus.canLoading) {
                                  body = Text("Release to load more");
                                }
                                if (nextPageD == null) {
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
                                dewormers = [];
                              });
                              getDewormers(state.endpoint +
                                  "get-foster-dewormer/" +
                                  state.foster['id'].toString() +
                                  "?token=" +
                                  state.token);
                            },
                            onLoading: () {
                              if (nextPageD == null) {
                                _refreshController2.loadNoData();
                              } else {
                                getDewormers(
                                    nextPageD + '&token=' + state.token);
                              }
                            },
                          ),
                        ),
                        new Container(
                          padding: EdgeInsets.only(left: 10, right: 0, top: 10),
                          child: new SmartRefresher(
                            controller: _refreshController3,
                            enablePullUp: true,
                            enablePullDown: true,
                            child: new SingleChildScrollView(
                              child: new Container(
                                child: new Table(
                                    children: makeTable(others, headers)),
                                width: MediaQuery.of(context).size.width - 20,
                                margin: EdgeInsets.only(
                                    left: 0, top: 20, right: 10, bottom: 10),
                              ),
                              scrollDirection: Axis.horizontal,
                            ),
                            footer: new CustomFooter(
                              builder: (BuildContext context, LoadStatus mode) {
                                Widget body;
                                if (mode == LoadStatus.idle &&
                                    mode != LoadStatus.noMore) {
                                  body = Text("Lift the load");
                                } else if (mode == LoadStatus.loading) {
                                  body = CupertinoActivityIndicator();
                                } else if (mode == LoadStatus.failed) {
                                  body = Text("Load Failed! Click Retry!");
                                } else if (mode == LoadStatus.canLoading) {
                                  body = Text("Release to load more");
                                }
                                if (nextPageO == null) {
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
                                others = [];
                              });
                              getOthers(state.endpoint +
                                  "get-foster-other/" +
                                  state.foster['id'].toString() +
                                  "?token=" +
                                  state.token);
                            },
                            onLoading: () {
                              if (nextPageO == null) {
                                _refreshController3.loadNoData();
                              } else {
                                getOthers(nextPageO + '&token=' + state.token);
                              }
                            },
                          ),
                        ),
                      ],
                      controller: _controller,
                    ))
                  ],
                ),
              ),
            )),
      )),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
//          print(note);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => new AddMedication(
                        note: note,
                      )));
        },
        backgroundColor: note == 'vaccination'
            ? Colors.pinkAccent
            : note == 'dewormer' ? Colors.green : Colors.blue,
        child: new Icon(Icons.add),
      ),
    );
  }

  List makeTable(items, headers) {
    List<TableRow> data = [];

    data.add(new TableRow(
        children: headers.map<Widget>((e) {
      return new TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: new Container(
          padding: EdgeInsets.only(top: 10, bottom: 10),
          child: new Center(
            child: new Text(
              e,
              style: new TextStyle(
                  color: Colors.black, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ),
          decoration: new BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              border: new Border.all(color: Colors.grey)),
        ),
      );
    }).toList()));
    data.addAll(items.map<TableRow>((item) {
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
                    item['text'],
                    style: new TextStyle(fontSize: 15, color: Colors.black54),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.clip,
                  ),
                  decoration: new BoxDecoration(
                      border:
                          new Border(left: new BorderSide(color: Colors.grey))),
                ))
          ].toList());
    }).toList());

    return data;
  }

  void getVaccinations(url) {
    if (vaccinations.length == 0) {
      setState(() {
        status = true;
      });
    }
    state.get(url).then((value) {
      var body = jsonDecode(value.body);
      setState(() {
        vaccinations.addAll(body['data']);
        nextPageV = body['nextPage_url'];
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

  void getDewormers(url) {
    if (dewormers.length == 0) {
      setState(() {
        status2 = true;
      });
    }
    state.get(url).then((value) {
      var body = jsonDecode(value.body);
      setState(() {
        dewormers.addAll(body['data']);
        nextPageD = body['nextPage_url'];
        status2 = false;
      });
      _refreshController2.refreshCompleted();
      _refreshController2.loadComplete();
    }).catchError((error) {
      print(error);
      setState(() {
        status2 = false;
      });
    });
  }

  void getOthers(url) {
    if (others.length == 0) {
      setState(() {
        status3 = true;
      });
    }
    state.get(url).then((value) {
      var body = jsonDecode(value.body);
      setState(() {
        others.addAll(body['data']);
        nextPageO = body['nextPage_url'];
        status3 = false;
      });
      _refreshController3.refreshCompleted();
      _refreshController3.loadComplete();
    }).catchError((error) {
      print(error);
      setState(() {
        status3 = false;
      });
    });
  }
}
