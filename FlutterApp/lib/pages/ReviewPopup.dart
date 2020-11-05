import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

///aemon comments zetten
class ReviewPopup extends StatefulWidget {
  int id;
  ReviewPopup({Key key, this.id}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return RealWorldState();
  }
}

///aemon comments zetten
class RealWorldState extends State<ReviewPopup> {
  bool _buttonEnabled = false;
  int _sterRating = 0;
  bool _1ster = false;
  bool _2ster = false;
  bool _3ster = false;
  bool _4ster = false;
  bool _5ster = false;
  bool foo = false;
  dynamic _onPressed;

  String opmerkingen = " ";
  String naam = " ";
  @override
  Widget build(BuildContext context) {
    if (_sterRating != 0 && (naam != null || naam != " ")) {
      _buttonEnabled = true;
    } else {
      _buttonEnabled = false;
    }
    if (_buttonEnabled == true) {
      _onPressed = () {
        print("Tap");
        setState(() {});
      };
    } else if (_buttonEnabled == false) {
      _onPressed = null;
    }
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Uw reactie'),
      ),
      body: new SingleChildScrollView(
          child: new Center(
              child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Text("Laat uw reactie achter over deze parkeerplek!",
            style: TextStyle(color: Colors.black.withOpacity(1.0), 
                       fontSize: 25.0,
                       height: 1.5,
          ),
          textAlign: TextAlign.center,
          ),
          new TextField(
            maxLength: 20,
            decoration: new InputDecoration(hintText: 'Naam:'),
            onChanged: (text) {
              naam = text;
            },
          ),
          new TextField(
            maxLength: 150,
            decoration: new InputDecoration(hintText: 'Opmerking:'),
            onChanged: (text) {
              opmerkingen = text;
            },
          ),
          new BottomAppBar(
              elevation: 0.0,
              color: Colors.white10,
              child: ButtonBar(
                alignment: MainAxisAlignment.center,
                children: <Widget>[
                  new IconButton(
                      icon: new Icon(Icons.stars),
                      iconSize: 35.0,
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.bottomRight,
                      color: _1ster ? Colors.blue : Colors.black,
                      onPressed: () {
                        print("1 ster");
                        setState(() {
                          _sterRating = 1;
                          if (_sterRating == 1 && foo == false) {
                            _1ster = true;
                            _2ster = false;
                            _3ster = false;
                            _4ster = false;
                            _5ster = false;
                            foo = true;
                          } else if (_sterRating == 1 && foo == true) {
                            _1ster = false;
                            foo = false;
                            _sterRating = 0;
                          }
                        });
                      }),
                  new IconButton(
                      icon: new Icon(Icons.stars),
                      iconSize: 35.0,
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.bottomRight,
                      color: _2ster ? Colors.blue : Colors.black,
                      onPressed: () {
                        print("2 ster");
                        setState(() {
                          _sterRating = 2;
                          if (_sterRating == 2) {
                            _1ster = true;
                            _2ster = true;
                            _3ster = false;
                            _4ster = false;
                            _5ster = false;
                            foo = false;
                          }
                        });
                      }),
                  new IconButton(
                      icon: new Icon(Icons.stars),
                      iconSize: 35.0,
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.bottomRight,
                      color: _3ster ? Colors.blue : Colors.black,
                      onPressed: () {
                        print("3 ster");
                        setState(() {
                          _sterRating = 3;
                          if (_sterRating == 3) {
                            _1ster = true;
                            _2ster = true;
                            _3ster = true;
                            _4ster = false;
                            _5ster = false;
                            foo = false;
                          }
                        });
                      }),
                  new IconButton(
                      icon: new Icon(Icons.stars),
                      iconSize: 35.0,
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.bottomRight,
                      color: _4ster ? Colors.blue : Colors.black,
                      onPressed: () {
                        print("4 ster");
                        setState(() {
                          _sterRating = 4;
                          if (_sterRating == 4) {
                            _1ster = true;
                            _2ster = true;
                            _3ster = true;
                            _4ster = true;
                            _5ster = false;
                            foo = false;
                          }
                        });
                      }),
                  new IconButton(
                      icon: new Icon(Icons.stars),
                      iconSize: 35.0,
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.bottomRight,
                      color: _5ster ? Colors.blue : Colors.black,
                      onPressed: () {
                        print("5 ster");
                        setState(() {
                          _sterRating = 5;
                          if (_sterRating == 5 && _5ster == false) {
                            _1ster = true;
                            _2ster = true;
                            _3ster = true;
                            _4ster = true;
                            _5ster = true;
                            foo = false;
                          }
                        });
                      })
                ],
              )),
          new ButtonTheme(
            height: 50.0,
            minWidth: 150.0,
            child: RaisedButton(
              onPressed: () {
                if (_sterRating <= 0) {
                  alert(context, "Geen rating", "Vul aantal sterren in");
                } else {
                  _onLoading(_sterRating, naam, opmerkingen, widget.id, context);
                }

              },
              elevation: 5.0,
              color: Colors.blue,
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Confirm',
                style: new TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ))),
    );
  }
}
void _onLoading(_sterRating, naam, opmerkingen, widget, context,) async {

    bool res = await postData(_sterRating, naam, opmerkingen, widget, context);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: new Row(
            children: [
              Container(margin: new EdgeInsets.only(left:10, right:10, top:5, bottom: 5) ,width: 30 ,height: 30 ,child: new CircularProgressIndicator()),
              new Text("Bezig met review versturen..."),
            ],
          ),
        );
      },
    );
    new Future.delayed(new Duration(seconds: 2), () {
    if(res){
      Navigator.pop(context); //pop dialog
      alert(context, "Uw feedback is ontvangen.", "Dank voor uw feedback!");
    }else{
      Navigator.pop(context); //pop dialog
      alert(context,"Er is iets fout gegaan." ," Probeer later opnieuw.");
    }  
      
    });
    
   
 }
//method for posting data
Future<bool> postData(int sterren, String user, String remark, int id, BuildContext context) async {
  if(user == ""){
      user ="Anoniem";
  }
  Map<String,String> message = 
  {
      "Name": user,
      "Comment": remark,
      "Rating": sterren.toString(),
      "Parkingspot": id.toString(),
  };

  var json = jsonEncode(message);

  String link = "http://invalideparkeren.nl/api/review/create.php";

  http.Response response = await http.post(
    Uri.encodeFull(link),
    headers: {   
      "Accept": "application/json",
    },
    body: json,
  );
  if(response.statusCode == 201){
    return true;
  }
  else{
    return false;
  }
}


void alert(BuildContext context, String title, String comment) {
  AlertDialog alertDialog = AlertDialog(
    title: Text(title),
    content: Text(comment),
  );

  showDialog(context: context, builder: (BuildContext context) => alertDialog);
}
