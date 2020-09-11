import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:foster_logger/store/index.dart';
//import 'package:speech_recognition/speech_recognition.dart';
import 'dart:convert';
import 'package:foster_logger/pages/medication-note.dart';
import 'package:foster_logger/pages/development-notes.dart';

class GenerateNote extends StatefulWidget {
  @override
  _GenerateNote createState() => new _GenerateNote();
}

class _GenerateNote extends State<GenerateNote> {
  AppState state;
  String error = '';
  bool status = false;
  String transcription = '';
  // SpeechRecognition _speech = SpeechRecognition();
  // bool _speechRecognitionAvailable = false;
  // String _currentLocale = '';
  // bool _isListening = false;

  TextEditingController note = new TextEditingController();

  void initState() {
    super.initState();
    state = Provider.of<AppState>(context, listen: false);

    if (state.foster['special_note'] != null) {
      note.text = state.foster['special_note'];
    }
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
          title: new Text('GENERAL NOTES '),
          backgroundColor: Colors.purpleAccent),
      body: new SafeArea(
          child: new SingleChildScrollView(
        child: new Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          margin: EdgeInsets.only(top: 30),
          padding: EdgeInsets.only(left: 20, right: 20),
          child: new Column(
            children: [
              new Container(
                child: new Text(
                  state.foster['name'],
                  style: new TextStyle(color: Colors.black54, fontSize: 20),
                ),
              ),
              new Container(
                margin: EdgeInsets.only(top: 20, bottom: 20),
                child: new Text(
                  'Special Requirements, Other Littermates, Personality Notes, etc',
                  style: new TextStyle(color: Colors.black54, fontSize: 14),
                ),
              ),
              new Container(
                child: new TextFormField(
                  maxLines: 5,
                  decoration: new InputDecoration(
                      enabledBorder: new OutlineInputBorder(
                          borderSide: new BorderSide(
                              color: Colors.grey.withOpacity(0.4))),
                      focusedBorder: new OutlineInputBorder(
                          borderSide: new BorderSide(
                        color: Colors.grey.withOpacity(0.4),
                      )),
                      labelText: 'Add a note ',
                      labelStyle:
                          new TextStyle(color: Colors.grey, fontSize: 15),
                      suffixIcon: new IconButton(
                          icon: new Icon(Icons.mic),
                          onPressed: () {
                            listen();
                          }),
                      alignLabelWithHint: true),
                  controller: note,
                ),
              ),
              new Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(top: 20),
                child: new MaterialButton(
                  onPressed: () {
                    this.submit();
                  },
                  padding: EdgeInsets.only(top: 15, bottom: 15),
                  shape: StadiumBorder(),
                  color: Colors.white,
                  child: status
                      ? new CircularProgressIndicator(
                          backgroundColor: Colors.purpleAccent,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.orange),
                          strokeWidth: 2)
                      : new Text('SAVE',
                          style: new TextStyle(color: Colors.purpleAccent)),
                ),
              ),
              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  new Container(
                    margin: EdgeInsets.only(top: 20),
                    child: new MaterialButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => new DevelopmentNote()));
                      },
                      padding: EdgeInsets.only(
                          top: 15, bottom: 15, left: 20, right: 20),
                      shape: StadiumBorder(),
                      color: Colors.purpleAccent,
                      child: new Text('DEVELOPMENT NOTES',
                          style: new TextStyle(color: Colors.white)),
                    ),
                  ),
                  new Container(
                    margin: EdgeInsets.only(top: 20),
                    child: new MaterialButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => new MedicationPage()));
                      },
                      padding: EdgeInsets.only(
                          top: 15, bottom: 15, left: 20, right: 20),
                      shape: StadiumBorder(),
                      color: Colors.purpleAccent,
                      child: new Text('MEDICATIONS',
                          style: new TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      )),
    );
  }

  void listen() async {
//    _speech.setAvailabilityHandler((bool result) => setState(() => _speechRecognitionAvailable = result));
//    _speech.setCurrentLocaleHandler((String locale) => setState(() => _currentLocale = locale));
//    _speech.setRecognitionStartedHandler(()=> setState(() => _isListening = true));
//
//    _speech.setRecognitionResultHandler((String text)
//    => setState(() => transcription = text));
//
//    _speech.setRecognitionCompleteHandler(()
//    => setState(() => _isListening = false));
//
//// 1st launch : speech recognition permission / initialization
//    _speech
//        .activate()
//        .then((res) => setState(() => _speechRecognitionAvailable = res));
////..
//
//    print(_speechRecognitionAvailable);
//    _speech.listen(locale: 'en_US').then((result)=> print('result : $result'));
  }

  void stopListening() {
//    _speech.cancel();
//    _speech.stop();
  }

  void submit() {
    setState(() {
      status = true;
    });

    state.postAuth(context, 'foster-details/' + state.foster['id'].toString(), {
      'special_note': note.text,
    }).then((data) {
      var body = jsonDecode(data.body);
      if (data.statusCode == 200 && body['status']) {
        state.notifyToastSuccess(
            context: context, message: 'Foster was updated successful');
        state.foster = body['data'];
      } else if (data.statusCode != 422) {
        state.notifyToastDanger(
            context: context, message: "Error occured while creating account");
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
