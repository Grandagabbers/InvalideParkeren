import 'package:flutter/material.dart';
import './EigenLocatie.dart';
import './VindLocatie.dart';

///Homescreen van de app
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //appBar/tittle van pagina
        appBar: new AppBar(
          title: new Text("P-App"),
        ),
        backgroundColor: Colors.lightBlueAccent,
        body: new SingleChildScrollView(
            child: new Column(
          //de alignment in het midden gezet
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              children: <Widget>[
                ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      topRight: Radius.circular(8.0),
                      bottomLeft: Radius.circular(8.0),
                      bottomRight: Radius.circular(8.0),
                    ),
                    
                    child: Image.asset(
                        'assets/images/gehandicaptenparkeerplaats.jpg',
                        height: 250,
                        fit:BoxFit.fill
                    ),
                ),
                
                Text("Welkom op de P-App!",
                  style: TextStyle(color: Colors.white.withOpacity(1.0), 
                       height: 7.0,
                       fontSize: 25.0,
                )),
                Text("Voor alle invalide parkeerplekken",
                  style: TextStyle(color: Colors.white.withOpacity(1.0), 
                       fontSize: 25.0,
                )),
                Text("in Zoetermeer!",
                  style: TextStyle(color: Colors.white.withOpacity(1.0), 
                       fontSize: 25.0,
                )),
              ],
            ),

            //Image.asset('assets/images/gehandicaptenparkeerplaats.jpg'),
            ButtonTheme(
              minWidth: 200.0,
              height: 10.0,
              //knop om te navigeren naar locatie van de gebruiker
              child: RaisedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => VindLocatie()),
                  );
                },
                elevation: 5.0,
                textColor: Colors.blue,
                color: Colors.white,
                padding: const EdgeInsets.all(8.0),
                child: new Text(
                  "Zoek met uw locatie",
                ),
              ),
            ),
            ButtonTheme(
              minWidth: 200.0,
              height: 10.0,
              //knop om te navigeren naar pagina waar gebruiker zelf locatie invoert
              child: RaisedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EigenLocatie()),
                  );
                  showDialog(
                      context: context,
                      builder: (context) {
                        Future.delayed(Duration(seconds: 5), () {
                          Navigator.of(context).pop(true);
                        });
                        return AlertDialog(
                          title: Text(
                              'Deze pagina is nog onder development en kan raar gedrag vertonen'),
                        );
                      });
                },
                elevation: 5.0,
                textColor: Colors.blue,
                color: Colors.white,
                padding: const EdgeInsets.all(8.0),
                child: new Text(
                  "Zoek met opgegeven locatie",
                ),
              ),
            ),
          ],
        )));
  }
}
