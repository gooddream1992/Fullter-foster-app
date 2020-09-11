import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:foster_logger/pages/create-foster.dart';
import 'package:foster_logger/pages/edit-foster.dart';
import 'package:provider/provider.dart';
import 'package:foster_logger/store/index.dart';
import 'package:foster_logger/pages/homepage.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

enum ConfirmAction { CANCEL, ACCEPT }

class SelectingFoster extends StatefulWidget {
  @override
  _SelectingFoster createState() => new _SelectingFoster();
}

class _SelectingFoster extends State<SelectingFoster> {
  AppState state;
  String error = '';
  bool status = false;
  List items = [];
  String nextPage = '';
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void initState() {
    super.initState();
    state = Provider.of<AppState>(context, listen: false);
    getItems(state.endpoint + "get-fosters?token=" + state.token);
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
        title: new Text('Select an Existing Foster'),
        backgroundColor: Colors.orangeAccent,
      ),
      body: new SafeArea(
          child: new SingleChildScrollView(
              child: new Stack(
        children: [
          new Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.only(
                left: 10,
                right: 10,
                bottom: MediaQuery.of(context).padding.bottom * 2),
            child: status
                ? new Container(
                    width: 50,
                    height: 50,
                    child: new Center(
                      child: new CircularProgressIndicator(
                          backgroundColor: Colors.white,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.orange),
                          strokeWidth: 2),
                    ),
                  )
                : new Container(
                    padding: EdgeInsets.only(bottom: 85, left: 0, right: 0),
                    child: new SmartRefresher(
                      controller: _refreshController,
                      enablePullUp: true,
                      enablePullDown: true,
                      child: items.length == 0
                          ? new Container(
                              child:
                                  new Center(child: new Text('List is empty')),
                            )
                          : new ListView.builder(
                              itemCount: items.length,
                              itemBuilder: (context, index) {
                                var item = items[index];
                                return new InkWell(
                                  child: new Container(
                                    margin: EdgeInsets.only(top: 2),
                                    child: new Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        new Flexible(
                                            child: new Container(
                                          margin: EdgeInsets.only(
                                              top: 10, bottom: 10),
                                          child: new Row(
                                            children: [
                                              new Container(
                                                width: 60,
                                                height: 60,
                                                decoration: new BoxDecoration(
                                                    color: Colors.orangeAccent,
                                                    borderRadius:
                                                        new BorderRadius
                                                            .circular(50),
                                                    image: new DecorationImage(
                                                        image: item['filename'] !=
                                                                null
                                                            ? new NetworkImage(
                                                                item[
                                                                    'filename'])
                                                            : new AssetImage(
                                                                'assets/images/logo.png'),
                                                        fit: BoxFit.cover)),
                                                //                                  child: new Image.asset(''),
                                                margin:
                                                    EdgeInsets.only(right: 10),
                                              ),
                                              new Container(
                                                child: new Text(
                                                  item['name'],
                                                  style: new TextStyle(
                                                      fontSize: 20,
                                                      color: Colors.black54,
                                                      fontWeight:
                                                          FontWeight.w300),
                                                ),
                                              )
                                            ],
                                          ),
                                        )),
                                        new Container(
                                          child: new Text(
                                            item['created_date'],
                                            style: new TextStyle(
                                                color: Colors.grey),
                                          ),
                                        ),
                                        new IconButton(
                                            icon: new Icon(
                                              Icons.cancel,
                                              color: Colors.red,
                                            ),
                                            onPressed: () {
                                              removeFoster(item['id']);
                                            }),
                                        new IconButton(
                                            icon: new Icon(
                                              Icons.edit,
                                              color: Colors.blue,
                                            ),
                                            onPressed: () {
                                              state.foster = item;
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          new EditFosterPage()));
                                            })
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    state.foster = item;
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                new HomePage()));
                                  },
                                );
                              }),
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
                            "get-fosters?token=" +
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
        ],
      ))),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => new CreateFosterPage()));
        },
        backgroundColor: Colors.orange,
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
    state.get(url, context: context).then((value) {
      var body = jsonDecode(value.body);
      setState(() {
        items.addAll(body['data']);
        nextPage = body['nextPage_url'];
        status = false;
      });
    }).catchError((error) {
      print(error);
      setState(() {
        status = false;
      });
    });
  }

  void yesOnPressed(id) {
    state.postAuth(context, 'delete-foster/' + id.toString(), {}).then((data) {
      var body = jsonDecode(data.body);
      if (data.statusCode == 200 && body['status']) {
        state.notifyToast(context: context, message: body['message']);
        setState(() {
          items = [];
        });
        getItems(state.endpoint + "get-fosters?token=" + state.token);
      } else if (data.statusCode != 422) {
        state.notifyToastDanger(
            context: context,
            message: "Error occured while deleting selected foster");
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

  void removeFoster(id) {
    Future<ConfirmAction> asyncConfirmDialog(BuildContext context) async {
      return showDialog<ConfirmAction>(
        context: context,
        barrierDismissible: false, // user must tap button for close dialog!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Are you sure?'),
            content: const Text(
                'This will permanently delete the foster you selected.'),
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
