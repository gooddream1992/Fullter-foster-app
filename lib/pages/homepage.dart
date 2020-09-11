import 'package:flutter/material.dart';
import 'package:foster_logger/pages/weight-log.dart';
import 'package:foster_logger/pages/feeding-log.dart';
import 'package:foster_logger/pages/urination-log.dart';
import 'package:foster_logger/pages/defecation-log.dart';
import 'package:foster_logger/pages/generate-note.dart';
import 'package:foster_logger/pages/select-foster.dart';
import 'package:foster_logger/pages/foster-details.dart';
import 'package:foster_logger/pages/profile.dart';
import 'package:foster_logger/pages/reminders.dart';
import 'package:foster_logger/pages/pdf-email.dart';
import 'package:provider/provider.dart';
import 'package:foster_logger/store/index.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:io';
import 'dart:convert';

class HomePage extends StatefulWidget {
  @override
  _HomePage createState() => new _HomePage();
}

class _HomePage extends State<HomePage> {
  String error = '';
  bool status = false;
  Color color = Colors.green.withOpacity(0.6);
  AppState state;
  File _image;

  void initState() {
    super.initState();
    state = Provider.of<AppState>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: Colors.white,
        appBar: new AppBar(
          leading: new Container(),
          title: new AnimatedContainer(
            duration: Duration(microseconds: 1),
            child: new Text(state.foster['name']),
            transform: Matrix4.translationValues(0, 0, 0),
          ),
          backgroundColor: color,
          actions: [
            new IconButton(
                icon: Icon(Icons.account_circle),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => new Profile()));
                })
          ],
        ),
        body: new WillPopScope(
          onWillPop: () {},
          child: new SafeArea(
              child: new SingleChildScrollView(
            child: new Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new Container(
                    width: 100,
                    height: 100,
                    decoration: new BoxDecoration(
                        color: Colors.green.withOpacity(0.5),
                        borderRadius: new BorderRadius.circular(50),
                        border:
                            new Border.all(color: Colors.grey.withOpacity(0.5)),
                        image: new DecorationImage(
                            image: state.foster['filename'] != null
                                ? new NetworkImage(state.foster['filename'])
                                : _image != null
                                    ? new FileImage(_image)
                                    : new AssetImage('assets/images/logo.png'),
                            fit: BoxFit.cover)),
                    //                                  child: new Image.asset(''),
                    margin: EdgeInsets.only(top: 30),
                  ),
                  new Container(
                    margin: EdgeInsets.only(top: 20),
                    child: new MaterialButton(
                      onPressed: () {
                        // getImage(ImageSource.camera);
                        getImage(ImageSource.gallery);
                      },
                      padding: EdgeInsets.only(
                          top: 10, bottom: 10, left: 25, right: 25),
                      color: Colors.green.withOpacity(0.5),
                      shape: StadiumBorder(),
                      child: status
                          ? new Container(
                              child: new CircularProgressIndicator(
                                  backgroundColor: Colors.white,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.pinkAccent),
                                  strokeWidth: 2),
                              width: 20,
                              height: 20,
                            )
                          : new Text('Upload/Change Image',
                              style: new TextStyle(color: Colors.white)),
                    ),
                  ),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      new Container(
                        margin: EdgeInsets.only(top: 30),
                        child: new MaterialButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => new PdfEmail()));
                          },
                          padding: EdgeInsets.only(
                              top: 5, bottom: 5, left: 25, right: 25),
                          color: Colors.white,
                          shape: StadiumBorder(),
                          child: new Text('Create PDF of all data',
                              style: new TextStyle(color: Colors.black)),
                        ),
                      ),
                      new Container(
                        margin: EdgeInsets.only(top: 30),
                        child: new MaterialButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => new ListReminders()));
                          },
                          padding: EdgeInsets.only(
                              top: 5, bottom: 5, left: 25, right: 25),
                          color: Colors.white,
                          shape: StadiumBorder(),
                          child: new Row(
                            children: [
                              new Icon(
                                Icons.alarm,
                                color: Colors.red,
                              ),
                              new Text('Reminder',
                                  style: new TextStyle(color: Colors.red))
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  new Container(
                    margin: EdgeInsets.only(top: 30),
                    width: 350,
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        new GestureDetector(
                          child: new Container(
                            width: 100,
                            height: 100,
                            decoration: new BoxDecoration(
                                color: Colors.grey.withOpacity(0.3),
                                borderRadius: new BorderRadius.circular(50)),
                            child: new Center(
                              child: new Text(
                                'Weight Log',
                                style: new TextStyle(
                                    color: Colors.pink,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => new WeightLog()));
                          },
                        ),
                        new GestureDetector(
                          child: new Container(
                            width: 100,
                            height: 100,
                            decoration: new BoxDecoration(
                                color: Colors.grey.withOpacity(0.3),
                                borderRadius: new BorderRadius.circular(50)),
                            child: new Center(
                              child: new Text(
                                'Feeding Log',
                                style: new TextStyle(
                                    color: Colors.orangeAccent,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => new FeedingLog()));
                          },
                        ),
                        new GestureDetector(
                          child: new Container(
                            width: 100,
                            height: 100,
                            decoration: new BoxDecoration(
                                color: Colors.grey.withOpacity(0.3),
                                borderRadius: new BorderRadius.circular(50)),
                            child: new Center(
                              child: new Text(
                                'Urination Log',
                                style: new TextStyle(
                                    color: Colors.deepOrangeAccent,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => new Urination()));
                          },
                        ),
                      ],
                    ),
                  ),
                  new Container(
                    margin: EdgeInsets.only(top: 20),
                    width: 350,
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        new GestureDetector(
                          child: new Container(
                            width: 100,
                            height: 100,
                            decoration: new BoxDecoration(
                                color: Colors.grey.withOpacity(0.3),
                                borderRadius: new BorderRadius.circular(50)),
                            child: new Center(
                              child: new Text(
                                'Defecation Log',
                                style: new TextStyle(
                                    color: Colors.green,
                                    fontSize: 19,
                                    fontWeight: FontWeight.w500),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => new Defecation()));
                          },
                        ),
                        new GestureDetector(
                          child: new Container(
                            width: 100,
                            height: 100,
                            decoration: new BoxDecoration(
                                color: Colors.grey.withOpacity(0.3),
                                borderRadius: new BorderRadius.circular(50)),
                            child: new Center(
                              child: new Text(
                                'Foster\t Details',
                                style: new TextStyle(
                                    color: Colors.blue,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) =>
                                        new FosterDetailsPage()));
                          },
                        ),
                        new GestureDetector(
                          child: new Container(
                            width: 100,
                            height: 100,
                            decoration: new BoxDecoration(
                                color: Colors.grey.withOpacity(0.3),
                                borderRadius: new BorderRadius.circular(50)),
                            child: new Center(
                              child: new Text(
                                'Notes',
                                style: new TextStyle(
                                    color: Colors.purpleAccent,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => new GenerateNote()));
                          },
                        ),
                      ],
                    ),
                  ),
                  new Container(
                    height: 40,
                    margin: EdgeInsets.only(top: 30),
                    child: new MaterialButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => new SelectingFoster()));
                      },
                      padding: EdgeInsets.only(
                          top: 0, bottom: 0, left: 35, right: 35),
                      color: Colors.green,
                      shape: StadiumBorder(),
                      child: new Text('SWITCH FOSTER',
                          style: new TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          )),
        ));
  }

  Future getImage(source) async {
    final image = await ImagePicker().getImage(source: source);
    cropImage(image);
  }

  void cropImage(imageFile) async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: imageFile.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));
    this.setState(() {
      _image = croppedFile;
    });
    uploadImage();
  }

  uploadImage() {
    List splitted = _image.path.split('/');

    Map payload = {
      'image': base64Encode(_image.readAsBytesSync()),
      'filename': splitted[splitted.length - 1],
    };

    setState(() {
      this.status = true;
    });

    state
        .postAuth(
            context, 'add-image/' + state.foster['id'].toString(), payload)
        .then((value) {
      print(value.body);
      if (value.statusCode == 200) {
        var body = jsonDecode(value.body);
        if (body['status']) {
          state.notifyToastSuccess(
              context: context, message: 'Image uploaded successfully');
          state.foster = body['data'];
          setState(() {
            _image = null;
          });
        } else {
          state.notifyToastDanger(context: context, message: body['message']);
        }
      }
      setState(() {
        this.status = false;
      });
    }).catchError((error) {
      print(error);
      setState(() {
        this.status = false;
      });
    });
  }
}
